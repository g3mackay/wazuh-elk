#!/bin/bash
LOGFILE=/root/test.log

sed -i "s;logstash:5000;$LOGSTASH_NODE:5000;g" /etc/filebeat/filebeat.yml

# hack to find what ecs node the wazuh master container is running and update /var/ossec/data/etc/ossec.conf
#IPS=$CLUSTER_IPS
#IPS="10.0.11.101 10.0.22.102 10.0.33.103"
export AWS_REGION="us-east-1"
IPS=$(/awsops ecs listInstanceIPs -c logstash-elk-test)

COUNT=18
MASTER=0

findmaster()
{
  if [ $MASTER -eq 0 ];then
    sleep 10
    for ip in $IPS
    do
      curl -u foo:bar -i -k https://$ip:55000
      if [ $? -eq 0 ]
      then
        echo "$ip    master" >> /etc/hosts
        let MASTER=1
        break
      fi
    done
  fi
}

until [ $COUNT -eq 0 ]
do
  findmaster
  let COUNT=$COUNT-1
  echo count is $COUNT
done

exec /entrypoint.sh $@
