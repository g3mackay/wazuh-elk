# jaarsv2/modules/compute/bastion_host/main.tf

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}


resource "aws_instance" "bastion_host" {
#  ami                         = "ami-467ca739"
  ami                         = "${data.aws_ami.ecs_ami.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${var.subnet}"
  security_groups             = ["${var.sg_groups}"]
  associate_public_ip_address = true
#  key_name                    = "elk-test"
  key_name                    = "${var.key_name}"

  tags {
    "Name" = "external_host"
  }
}
