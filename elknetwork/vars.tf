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

variable "aws_zones" {
  type = "list"
  default = ["us-east-1b","us-east-1d"]
}

variable "sg_groups" {
  type = "list"
  default = ["",""]
}

variable "external_elb" {
  type = "string"
  default = "external-elb"
}
variable "elasticsearch_elb" {
  type = "string"
  default = "elasticsearch"
}

variable "logstash_elb" {
  type = "string"
  default = "logstash"
}
