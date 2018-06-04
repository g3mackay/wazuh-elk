# /modules/compute/cluster_es/main.tf

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
  template = "${file("${path.module}/ecs_user_data_with_mount.sh")}"
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
#  security_groups       = ["${var.vpc_default_sg_id}","${aws_security_group.elastic-sg.id}"]
  security_groups       = ["${var.sg_groups}"]
  iam_instance_profile  = "ecsELKInstanceRole"
  key_name              = "${var.key_name}"
  user_data             = "${data.template_file.user_data.rendered}"

  tags {
    "Name"              = "${var.cluster_name}-docker_ecs_host-${count.index}"
    "ElasticSearch"     = "esnode"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  count         = "${length(var.private_subnet_ids)}"
  device_name   = "/dev/xvdd"
  volume_id     = "${element(var.vol_id, count.index)}"
  instance_id   = "${element(aws_instance.ecs_host.*.id, count.index)}"
  skip_destroy  = true
}

resource "aws_ecs_cluster" "cluster" {
  name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
}
