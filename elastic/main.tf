# jaarsv2/elastic/main.tf

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

module "elastic" {
  source                    = "../modules/services/elastic"
  app_name                  = "${var.app_name}"
  app_env                   = "${var.app_env}"
  cluster                   = "${data.terraform_remote_state.cluster.es_cluster}"
  internal_elb_name         = "${data.terraform_remote_state.newvpc.elasticsearch_elb_name}"
#  target_group_arn          = "${data.terraform_remote_state.loadbalancers.target_group_arn}"
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/es_app/terraform.tfstate"
    region = "us-east-1"
  }
}
