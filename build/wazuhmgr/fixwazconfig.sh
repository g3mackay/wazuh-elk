#!/bin/bash

sed -i "s;logstash:5000;$LOGSTASH_NODE:5000;g" /etc/filebeat/filebeat.yml

exec /entrypoint.sh $@
