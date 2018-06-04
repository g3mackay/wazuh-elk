# ELK network
Module sets up the network infrastructure for ELK stack.

## What does it do?
  - Creates VPC
  - Creates public and private subnets based on number of availability zones given
  - Creates Internet Gateway for public and NAT gateway for private subnets
  - Creates ECS clusters
  - Creates one external Classic ELB and two internal Classic ELB's
  - Creates security groups for ELB and bastion host
  - Creates IAM role for ecsInstance with required policies for additional scripts

## Required Inputs
  - `app_name`- Name of application
  - `app_env` - Name of environment
  - `aws_zones` - List of availability zones
  - `sg_groups` - List of security groups
  - `external_elb` - Name of external ELB
  - `elasticsearch_elb` - Name of ELB for ElasticSearch
  - `logstash_elb` - Name of Logstash ELB
  - `es_cluster_name` - Name of ElasticSearch ECS cluster
  - `lk_cluster_name` - Name of Logstash ECS cluster
