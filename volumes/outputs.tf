output "vol_id" {
    value = "${aws_ebs_volume.es_volume.*.id}"
}
