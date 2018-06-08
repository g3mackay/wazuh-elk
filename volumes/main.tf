# elk/volumes/main.tf

provider "aws" {
    region = "${var.AWS_REGION}"
}

data "terraform_remote_state" "newvpc" {
  backend = "s3"

  config {
    bucket = "${var.vpc_remote_state_bucket}"
    key    = "${var.vpc_remote_state_key}"
    region = "us-east-1"
  }
}


resource "aws_ebs_volume" "es_volume" {
    count = "${length(data.terraform_remote_state.newvpc.aws_zones)}"
    availability_zone = "${element(data.terraform_remote_state.newvpc.aws_zones, count.index)}"
    size = 2
    type = "${var.volume_type}"
    tags {
        Name = "Elasticsearch_vol_${count.index}"
    }
}

terraform {
  backend "s3" {
    bucket = "elk-test-running-state"
    key = "dev/elktest/vol/terraform.tfstate"
    region = "us-east-1"
  }
}
