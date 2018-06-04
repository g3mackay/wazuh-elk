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

variable "es_cluster_name" {
  type = "string"
  default = "elasticsearch"
}

variable "lk_cluster_name" {
  type = "string"
  default = "logstash"
}

variable "ecsInstanceRoleAssumeRolePolicy" {
  type = "string"

  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

variable "ecsInstancerolePolicy" {
  type = "string"

  default = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ecs:CreateCluster",
                  "ecs:DeregisterContainerInstance",
                  "ecs:DiscoverPollEndpoint",
                  "ecs:Poll",
                  "ecs:RegisterContainerInstance",
                  "ecs:StartTelemetrySession",
                  "ecs:UpdateContainerInstancesState",
                  "ecs:Submit*",
                  "ecr:GetAuthorizationToken",
                  "ecr:BatchCheckLayerAvailability",
                  "ecr:GetDownloadUrlForLayer",
                  "ecr:BatchGetImage",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": "ec2:DescribeVolumes",
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": "ec2:DescribeInstances",
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "s3:Get*",
                  "s3:List*"
              ],
              "Resource": "*"
          }
      ]
}
EOF
}
