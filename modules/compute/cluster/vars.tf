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

variable "user_data_script" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "instance_count" {
  type = "string"
}

variable "vol_count" {
  type = "string"
}

variable "iam_instance_profile" {
  type = "string"
}

#variable "ami_id" {
#  type = "string"
#}

variable "ip_value" {
  type = "string"
}
