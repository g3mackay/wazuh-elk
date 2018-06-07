#!/bin/bash
LOGFILE=/root/test.log

sed -i "s;logstash:5000;$LOGSTASH_NODE:5000;g" /etc/filebeat/filebeat.yml

MYIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "$MYIP    master" >> /etc/hosts


exec /entrypoint.sh $@
