# jaarsv2/modules/compute/cluster_lk/main.tf

#data "aws_ami" "ecs_ami" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["amzn-ami-*-amazon-ecs-optimized"]
#  }
#}

data "template_file" "user_data" {
  template = "${file("${path.module}/ecs_user_data.sh")}"
  vars {
  cluster_name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
  }
}

resource "aws_instance" "ecs_host" {
  count                 = "${length(var.private_subnet_ids)}"
#  ami                   = "${data.aws_ami.ecs_ami.id}"
#  ami                   = "ami-71ef560b"
#  ami                   = "ami-a7a242da"
  ami                   = "ami-aff65ad2"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${element(var.private_subnet_ids, count.index)}"
#  security_groups       = ["${var.vpc_default_sg_id}","${aws_security_group.logstash-inbound.id}"]
  security_groups       = ["${var.sg_groups}"]
  iam_instance_profile  = "ecsELKInstanceRole"
  key_name              = "${var.key_name}"
  user_data             = "${data.template_file.user_data.rendered}"

  tags {
    "Name"              = "${var.cluster_name}-docker_ecs_host-${count.index}"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
}
