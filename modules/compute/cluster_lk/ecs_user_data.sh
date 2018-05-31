#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

# install awscli for remainder of script to run
yum install -y aws-cli

mkdir -p /wazuh/master/etc
mkdir -p /wazuh/slave/etc

aws s3 cp s3://elk-test-running-state/dev/elktest/config/master/ossec.conf /wazuh/master/etc
aws s3 cp s3://elk-test-running-state/dev/elktest/config/slave/ossec.conf /wazuh/slave/etc

IPS=$(aws ec2 describe-instances --region us-east-1 --filter "Name=instance-state-name,Values=running" "Name=tag:Name,Values=logstash-docker_ecs_host-*" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text)

IP1=$(echo $IPS|awk '{print $1}')
IP2=$(echo $IPS|awk '{print $2}')

echo $IP1
echo $IP2

sed -i "s;NODE1;$IP1;g" /wazuh/master/etc/ossec.conf
sed -i "s;NODE1;$IP1;g" /wazuh/slave/etc/ossec.conf
sed -i "s;NODE2;$IP2;g" /wazuh/master/etc/ossec.conf
sed -i "s;NODE2;$IP2;g" /wazuh/slave/etc/ossec.conf
