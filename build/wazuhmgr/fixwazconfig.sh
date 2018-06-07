#!/bin/bash
LOGFILE=/root/test.log

sed -i "s;logstash:5000;$LOGSTASH_NODE:5000;g" /etc/filebeat/filebeat.yml

# hack to find what ecs node the wazuh master container is running and update /var/ossec/data/etc/ossec.conf
IPS="$CLUSTER_IP1 $CLUSTER_IP2"

for ip in $IPS
do
  curl -u foo:bar -k https://$ip:55000
  if [ $? -eq 0 ]
  then
    echo "$ip    master" >> /etc/hosts
#    sed -i "s;NODE_IP;$ip;g" /var/ossec/data/etc/ossec.conf |tee -a $LOGFILE
  fi
done

exec /entrypoint.sh $@
