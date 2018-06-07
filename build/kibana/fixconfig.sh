#!/bin/bash

sed -i "s;http:\/\/elasticsearch:9200;$ELASTICSEARCH_URL;g" /usr/share/kibana/config/kibana.yml

# hack to find what ecs node the wazuh master container is running and update /etc/hosts
#IPS=$(echo $CLUSTER_IPLIST|sed "s;\,;;g"|sed "s;[][];;g")
IPS="$CLUSTER_IP1 $CLUSTER_IP2"

for ip in $IPS
do
  curl -u foo:bar -k https://$ip:55000
  if [ $? -eq 0 ]
  then
    echo "$ip    wazuh" >> /etc/hosts
  fi
done

exec $@
