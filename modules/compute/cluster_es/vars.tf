variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "aws_zones" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "vol_id" {
  type = "list"
}

variable "cluster_name" {
  type = "string"
}

variable "sg_groups" {
  type = "list"
}

variable "key_name" {
  type = "string"
}

variable "instance_type" {
  type = "string"
  default = "t2.micro"
}
