#!/bin/bash

sed -i "s;logstash:5000;$LOGSTASH_NODE:5000;g" /etc/filebeat/filebeat.yml

#/usr/local/bin/aws s3 cp s3://elk-test-running-state/dev/elktest/config/ossec.conf /var/ossec/data/etc/ossec.conf

exec /entrypoint.sh $@
