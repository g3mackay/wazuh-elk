output "ip" {
    value = "${aws_instance.bastion_host.public_ip}"
}
