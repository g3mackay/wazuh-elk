output "internal_ips" {
    value = "${aws_instance.ecs_host.*.private_ip}"
}

output "ecs_cluster" {
  value = "${aws_ecs_cluster.cluster.id}"
}
