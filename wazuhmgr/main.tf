# /wazuh/main.tf

provider "aws" {
    region = "${var.AWS_REGION}"
}

data "terraform_remote_state" "newvpc" {
  backend = "s3"

  config {
    bucket = "${var.vpc_remote_state_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "${var.AWS_REGION}"
  }
}

#data "terraform_remote_state" "cluster" {
#  backend = "s3"
#
#  config {
#    bucket = "${var.cluster_remote_state_bucket}"
#    key    = "${var.cluster_remote_state_key}"
#    region = "${var.AWS_REGION}"
#  }
#}

data "template_file" "task_def" {
  template = "${file("${path.module}/task_def_wazuhmgr.json")}"
  vars {
  logstash_node  = "${data.terraform_remote_state.newvpc.logstash_elb_dns_name}"
  }
}

module "wazuhmgr" {
  source                    = "../modules/services/with-elb-and-volume"
  app_name                  = "${var.app_name}"
  app_env                   = "${var.app_env}"
#  cluster                   = "${data.terraform_remote_state.cluster.lk_cluster}"
  cluster                   = "${data.terraform_remote_state.newvpc.lk_cluster_id}"
#  target_group_arn          = "${data.terraform_remote_state.loadbalancers.wazuh_mgr_target_group_arn}"
  elb_name         = "${data.terraform_remote_state.newvpc.external_elb_name}"
  container_def_json        = "${data.template_file.task_def.rendered}"
  desired_count             = "${var.desired_count}"
  volume_name               = "${var.volume_name}"
  volume_host_path          = "${var.volume_host_path}"
  container_name            = "${var.container_name}"
  container_port            = "${var.container_port}"
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/wazuhmgr/terraform.tfstate"
    region = "us-east-1"
  }
}
