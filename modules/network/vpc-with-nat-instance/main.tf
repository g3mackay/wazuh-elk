/*
 * Create VPC using app name and env to name it
 */
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = {
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
    Name     = "vpc-${var.app_name}-${var.app_env}"
  }
}

/*
 * Get default security group for reference later
 */
data "aws_security_group" "vpc_default_sg" {
  name   = "default"
  vpc_id = "${aws_vpc.vpc.id}"
}

/*
 * Create public and private subnets for each availability zone
 */
resource "aws_subnet" "public_subnet" {
  count             = "${length(var.aws_zones)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.aws_zones, count.index)}"
  cidr_block        = "10.0.${(count.index + 1) * 10}.0/24"

  tags {
    Name = "public-${element(var.aws_zones, count.index)}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = "${length(var.aws_zones)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.aws_zones, count.index)}"
  cidr_block        = "10.0.${(count.index + 1) * 11}.0/24"

  tags {
    Name = "private-${element(var.aws_zones, count.index)}"
  }
}

/*
 * Create internet gateway for VPC
 */
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

/*
 * Create NAT gateway and allocate Elastic IP for it
 */
#resource "aws_eip" "gateway_eip" {}
#
#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id = "${aws_eip.gateway_eip.id}"
#  subnet_id     = "${aws_subnet.public_subnet.0.id}"
#  depends_on    = ["aws_internet_gateway.internet_gateway"]
#}

/**** nat instance details ****/
data "aws_ami" "nat_ami" {
  most_recent = true
  owners    = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
}

resource "aws_instance" "nat_instance" {
  ami                         = "${data.aws_ami.nat_ami.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.public_subnet.0.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${data.aws_security_group.vpc_default_sg.id}","${aws_security_group.allow-ssh.id}"]
  key_name                    = "${var.key_name}"
  source_dest_check           = false

  tags {
    "Name" = "nat-instance-host"
  }
}

resource "aws_security_group" "allow-ssh" {
  vpc_id = "${aws_vpc.vpc.id}"
  name = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["76.177.144.62/32"]
  }
tags {
    Name = "allow-ssh"
  }
}

/**** end of nat instance details ****/

/*
 * Routes for private subnets to use NAT gateway
 */
resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "nat_route" {
  route_table_id         = "${aws_route_table.nat_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${aws_instance.nat_instance.id}"
}

resource "aws_route_table_association" "private_route" {
  count          = "${length(var.aws_zones)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}

/*
 * Routes for public subnets to use internet gateway
 */
resource "aws_route_table" "igw_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "igw_route" {
  route_table_id         = "${aws_route_table.igw_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table_association" "public_route" {
  count          = "${length(var.aws_zones)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.igw_route_table.id}"
}

/*
 * Create DB Subnet Group for private subnets
 */
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-${var.app_name}-${var.app_env}"
  subnet_ids = ["${aws_subnet.private_subnet.*.id}"]

  tags {
    Name     = "db-subnet-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

###################################################3
/*
 * Test creating a new task role.  Will move this later.
 */

 resource "random_id" "code" {
   byte_length = 4
 }

resource "aws_iam_role" "ecsTaskRole" {
   name               = "ecsTaskRole-${random_id.code.hex}"
   assume_role_policy = "${var.ecsTaskRoleAssumeRolePolicy}"
 }

 resource "aws_iam_role_policy" "ecsTaskRolePolicy" {
   name   = "ecsTaskRolePolicy-${random_id.code.hex}"
   role   = "${aws_iam_role.ecsTaskRole.id}"
   policy = "${var.ecsTaskRolePolicy}"
 }
