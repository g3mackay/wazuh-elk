variable "AWS_REGION" {
  default = "us-east-1"
}

variable "vpc_remote_state_bucket" {
  default = "elk-test-running-state"
}

variable "vpc_remote_state_key" {
  default = "dev/elktest/vpc/terraform.tfstate"
}

variable "volume_type" {
  default = "standard"
}
