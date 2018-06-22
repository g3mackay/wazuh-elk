# /modules/compute/cluster/main.tf

data "template_file" "user_data" {
  template = "${file("${path.module}/${var.user_data_script}")}"
  vars {
  cluster_name = "${var.cluster_name}"
  }
}

resource "aws_instance" "ecs_host" {
#  count                 = "${length(var.private_subnet_ids)}"
  count                 = "${var.instance_count}"
#  ami                   = "ami-71ef560b"
#  ami                   = "ami-a7a242da"
  ami                   = "${var.ami_id}"
#  ami                   = "ami-aff65ad2"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${element(var.private_subnet_ids, count.index)}"
  security_groups       = ["${var.sg_groups}"]
  private_ip            = "10.0.${(count.index + 1) * 11}.${count.index + 1 + var.ip_value}"
  iam_instance_profile  = "${var.iam_instance_profile}"
  key_name              = "${var.key_name}"
  user_data             = "${data.template_file.user_data.rendered}"

  tags                  = "${var.tags}"

}

resource "aws_volume_attachment" "ebs_attach" {
#  count         = "${length(var.private_subnet_ids)}"
  count         = "${var.vol_count}"
  device_name   = "/dev/xvdd"
  volume_id     = "${element(var.vol_id, count.index)}"
  instance_id   = "${element(aws_instance.ecs_host.*.id, count.index)}"
  skip_destroy  = true
}

#resource "aws_ecs_cluster" "cluster" {
#  name = "ecs_${var.app_name}-${var.app_env}-${var.cluster_name}"
#}
