# jaarsv2/wazuh/main.tf

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

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config {
    bucket = "${var.cluster_remote_state_bucket}"
    key    = "${var.cluster_remote_state_key}"
    region = "${var.AWS_REGION}"
  }
}

data "template_file" "task_def" {
  template = "${file("${path.module}/task_def_wazuhmgr.json")}"
  vars {
  logstash_node  = "${data.terraform_remote_state.newvpc.logstash_elb_dns_name}"
  }
}

module "wazuhmgr" {
  source                    = "../modules/services/wazuhmgr"
  app_name                  = "${var.app_name}"
  app_env                   = "${var.app_env}"
  app_svc                   = "${var.app_svc}"
  cluster                   = "${data.terraform_remote_state.cluster.lk_cluster}"
#  target_group_arn          = "${data.terraform_remote_state.loadbalancers.wazuh_mgr_target_group_arn}"
  external_elb_name         = "${data.terraform_remote_state.newvpc.external_elb_name}"
  container_def_json        = "${data.template_file.task_def.rendered}"
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/wazuhmgr/terraform.tfstate"
    region = "us-east-1"
  }
}
