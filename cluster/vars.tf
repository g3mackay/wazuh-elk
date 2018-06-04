variable "AWS_REGION" {
  default = "us-east-1"
}

variable "app_name" {
  type = "string"
  default = "elk"
}

variable "app_env" {
  type = "string"
  default = "test"
}

variable "instance_type" {
  default = "t2.medium"
}

#variable "es_cluster_name" {
#  default = "elastic"
#}

#variable "lk_cluster_name" {
#  default = "logstash"
#}

variable "sg_groups" {
  type = "list"
  default = ["",""]
}

variable "key_name" {
  type = "string"
  default = "elk-test"
}

#######################################
variable "vpc_remote_state_bucket" {
  default = "elk-test-running-state"
}

variable "vpc_remote_state_key" {
  default = "dev/elktest/vpc/terraform.tfstate"
}

variable "vol_remote_state_bucket" {
  default = "elk-test-running-state"
}

variable "vol_remote_state_key" {
  default = "dev/elktest/vol/terraform.tfstate"
}
#######################################
