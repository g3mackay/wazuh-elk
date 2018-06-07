variable "AWS_REGION" {
  default = "us-east-1"
}

variable "app_name" {
  type = "string"
  default = "kibana"
}

variable "app_env" {
  type = "string"
  default = "test"
}

variable "cluster" {
  type = "string"
  default = "ecs_elk-test"
}

variable "external_elb_name" {
  type = "string"
  default = "elk-test-external-elb"
}
variable "desired_count" {
  type = "string"
  default = "2"
}

variable "container_name" {
  type = "string"
  default = "kibana"
}

variable "container_port" {
  type = "string"
  default = "5601"
}

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

variable "lb_remote_state_bucket" {
  default = "elk-test-running-state"
}

variable "lb_remote_state_key" {
  default = "dev/elktest/loadbalancers/terraform.tfstate"
}
