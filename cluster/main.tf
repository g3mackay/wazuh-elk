# /cluster/main.tf

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

data "terraform_remote_state" "newvol" {
  backend = "s3"

  config {
    bucket = "${var.vol_remote_state_bucket}"
    key    = "${var.vol_remote_state_key}"
    region = "${var.AWS_REGION}"
  }
}

module "bastion_host" {
  source                    = "../modules/compute/bastion_host"
  subnet                    = "${element(data.terraform_remote_state.newvpc.public_subnet_ids, 0)}"
  sg_groups                 = ["${data.terraform_remote_state.newvpc.vpc_default_sg_id}","${data.terraform_remote_state.newvpc.public_inbound_sg_id}"]
  key_name                   = "${var.key_name}"
}

module "cluster_es" {
  source                    = "../modules/compute/cluster"
  instance_type             = "${var.instance_type}"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  cluster_name              = "${data.terraform_remote_state.newvpc.es_cluster_name}"
#  ami_id                    = "${data.terraform_remote_state.newvpc.ami_id}"
  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
  sg_groups                 = ["${data.terraform_remote_state.newvpc.vpc_default_sg_id}"]
  aws_zones                 = "${data.terraform_remote_state.newvpc.aws_zones}"
  private_subnet_ids        = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
  key_name                  = "${var.key_name}"
  ip_value                  = 10
  user_data_script          = "ecs_user_data_with_mount.sh"
  instance_count            = "${length(data.terraform_remote_state.newvpc.private_subnet_ids)}"
  iam_instance_profile      = "${data.terraform_remote_state.newvpc.ecs_es_instance_profile_id}"
  vol_count                 = "${length(data.terraform_remote_state.newvpc.private_subnet_ids)}"
  vol_id                    = "${data.terraform_remote_state.newvol.vol_id}"

  tags                      = {
      "Name"                = "elastic-docker_ecs_host"
      "ElasticSearch"       = "esnode"
    }
}

module "cluster_lk" {
  source                    = "../modules/compute/cluster"
  instance_type             = "${var.instance_type}"
  app_name                  = "${data.terraform_remote_state.newvpc.app_name}"
  app_env                   = "${data.terraform_remote_state.newvpc.app_env}"
  cluster_name              = "${data.terraform_remote_state.newvpc.lk_cluster_name}"
#  ami_id                    = "${data.terraform_remote_state.newvpc.ami_id}"
  vpc_id                    = "${data.terraform_remote_state.newvpc.vpc_id}"
  sg_groups                 = ["${data.terraform_remote_state.newvpc.vpc_default_sg_id}"]
  aws_zones                 = "${data.terraform_remote_state.newvpc.aws_zones}"
  private_subnet_ids        = "${data.terraform_remote_state.newvpc.private_subnet_ids}"
  key_name                  = "${var.key_name}"
  ip_value                  = 100
  user_data_script          = "ecs_user_data.sh"
  instance_count            = "${length(data.terraform_remote_state.newvpc.private_subnet_ids)}"
  #instance_count            = 2
  iam_instance_profile      = "${data.terraform_remote_state.newvpc.ecs_lk_instance_profile_id}"
  vol_count                 = 0
  vol_id                    = []

  tags                      = {
      "Name"                = "logstash-docker_ecs_host"
      "logstash"            = "lsnode"
    }
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
