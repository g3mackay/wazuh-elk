output "bastion_ip" {
    value = "${module.bastion_host.ip}"
}

output "es_cluster" {
    value = "${module.cluster_es.ecs_cluster}"
}

output "lk_cluster" {
    value = "${module.cluster_lk.ecs_cluster}"
}

output "elasticsearch_ecs_host_ips" {
  value = "${module.cluster_es.internal_ips}"
}

output "logstash_ecs_host_ips" {
  value = "${module.cluster_lk.internal_ips}"
}

######
#output "internal_nlb_name" {
#  value = "${module.internal_nlb.internal_nlb_name}"
#}

#output "internal_nlb_dns_name" {
#  value = "${module.internal_nlb.internal_nlb_dns_name}"
#}

#output "external_nlb_name" {
#  value = "${module.external_nlb.external_nlb_name}"
#}

#output "external_nlb_dns_name" {
#  value = "${module.external_nlb.external_nlb_dns_name}"
#}

######
#output "internal_elb_name" {
#  value = "${module.internal_elb.internal_elb_name}"
#}

#output "internal_elb_dns_name" {
#  value = "${module.internal_elb.internal_elb_dns_name}"
#}

#output "logstash_internal_elb_name" {
#  value = "${module.internal_elb.logstash_internal_elb_name}"
#}

#output "logstash_internal_elb_dns_name" {
#  value = "${module.internal_elb.logstash_internal_elb_dns_name}"
#}

#output "external_elb_name" {
#  value = "${module.external_elb.external_elb_name}"
#}

#output "external_elb_dns_name" {
#  value = "${module.external_elb.external_elb_dns_name}"
#}
