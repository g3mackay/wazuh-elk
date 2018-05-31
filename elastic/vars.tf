variable "AWS_REGION" {
  default = "us-east-1"
}

variable "app_name" {
  type = "string"
  default = "elasticsearch"
}

variable "app_env" {
  type = "string"
  default = "test"
}

variable "cluster" {
  type = "string"
  default = "ecs_elk-test"
}

#variable "internal_nlb_name" {
#  type = "string"
#  default = "elk-test-internal-nlb"
#}

#######################################
variable "vpc_remote_state_bucket" {
  default = "elk-test-running-state"
}

variable "vpc_remote_state_key" {
  default = "dev/elktest/vpc/terraform.tfstate"
}

variable "cluster_remote_state_bucket" {
  default = "elk-test-running-state"
}

variable "cluster_remote_state_key" {
  default = "dev/elktest/cluster/terraform.tfstate"
}
