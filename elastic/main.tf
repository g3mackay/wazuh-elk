# /elastic/main.tf

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

module "elastic" {
  source                    = "../modules/services/with-elb-and-volume"
  app_name                  = "${var.app_name}"
  app_env                   = "${var.app_env}"
#  cluster                   = "${data.terraform_remote_state.cluster.es_cluster}"
  cluster                   = "${data.terraform_remote_state.newvpc.es_cluster_id}"
  elb_name                  = "${data.terraform_remote_state.newvpc.elasticsearch_elb_name}"
  container_def_json        = "${file("${path.module}/elasticsearch.json")}"
  task_role_arn             = "${data.terraform_remote_state.newvpc.ecsTaskRole_arn}"
  desired_count             = "${var.desired_count}"
  volume_name               = "${var.volume_name}"
  volume_host_path          = "${var.volume_host_path}"
  container_name            = "${var.container_name}"
  container_port            = "${var.container_port}"
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/es_app/terraform.tfstate"
    region = "us-east-1"
  }
}
