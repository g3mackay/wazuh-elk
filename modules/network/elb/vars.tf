variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

#variable "vpc_id" {
#  type = "string"
#}

#variable "aws_zones" {
#  type = "list"
#}

variable "elb_name" {
  type = "string"
}

variable "subnets" {
  type = "list"
}

#variable "vpc_default_sg_id" {
#  type = "string"
#}

variable "internal" {
  type = "string"
}

variable "sg_groups" {
  type = "list"
}

variable "listener" {
  type = "list"
}

variable "health_check" {
  type = "list"
}
