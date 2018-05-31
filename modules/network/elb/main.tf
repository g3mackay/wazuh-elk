# jaarsv2/modules/network/elb/main.tf

resource "aws_elb" "elb" {
  name                = "${var.app_name}-${var.app_env}-${var.elb_name}"
  subnets             = ["${var.subnets}"]
  security_groups     = ["${var.sg_groups}"]
  internal            = "${var.internal}"

  listener            = ["${var.listener}"]
  health_check        = "${var.health_check}"
}
