variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "app_svc" {
  type = "string"
}

variable "cluster" {
  type = "string"
}

variable "external_elb_name" {
  type = "string"
}

#variable "target_group_arn" {
#  type = "string"
#}

variable "container_def_json" {
  type = "string"
}
