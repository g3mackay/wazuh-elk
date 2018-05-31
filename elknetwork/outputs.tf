output "app_name" {
  value = "${var.app_name}"
}

output "app_env" {
  value = "${var.app_env}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}

output "aws_zones" {
  value = ["${module.vpc.aws_zones}"]
}

output "vpc_default_sg_id" {
  value = "${module.vpc.vpc_default_sg_id}"
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnet_ids}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnet_ids}"]
}

output "external_elb_name" {
  value = "${module.external_elb.elb_name}"
}

output "external_elb_dns_name" {
  value = "${module.external_elb.elb_dns_name}"
}

output "elasticsearch_elb_name" {
  value = "${module.elasticsearch_elb.elb_name}"
}

output "elasticsearch_elb_dns_name" {
  value = "${module.elasticsearch_elb.elb_dns_name}"
}
output "logstash_elb_name" {
  value = "${module.logstash_elb.elb_name}"
}

output "logstash_elb_dns_name" {
  value = "${module.logstash_elb.elb_dns_name}"
}

output "ext_elb_sg_id" {
  value = "${aws_security_group.ext-elb-inbound.id}"
}

output "public_inbound_sg_id" {
  value = "${aws_security_group.public-allow-inbound.id}"
}
