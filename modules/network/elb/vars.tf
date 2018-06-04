variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "elb_name" {
  type = "string"
}

variable "subnets" {
  type = "list"
}

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
