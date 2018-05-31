#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

# install awscli for remainder of script to run
yum install -y aws-cli
useradd -u 1000 -d /home/elasticsearch -m elasticsearch

#
# See: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
#
# Make sure both volumes have been created AND attached to this instance !
#
# We do not need a loop counter in the "until" statements below because
# there is a 5 minute limit on the CreationPolicy for this EC2 instance already.

EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F \" '{print $4}')

######################################################################
# Volume /dev/sdd (which will get created as /dev/xvdd on Amazon Linux)

DATA_STATE="unknown"
until [ $DATA_STATE == "attached" ]; do
  DATA_STATE=$(aws ec2 describe-volumes \
    --region $${EC2_REGION} \
    --filters \
        Name=attachment.instance-id,Values=$${EC2_INSTANCE_ID} \
        Name=attachment.device,Values=/dev/xvdd \
    --query Volumes[].Attachments[].State \
    --output text)

  sleep 5
done

# Format /dev/xvdd if it does not contain a partition yet
if [ "$(file -b -s /dev/xvdd)" == "data" ]; then
  mkfs -t ext4 /dev/xvdd
fi

mkdir -p /data
mount /dev/xvdd /data
chown elasticsearch:root /data
chmod 0755 /data

# Persist the volume in /etc/fstab so it gets mounted again
echo '/dev/xvdd /data ext4 defaults,nofail 0 2' >> /etc/fstab
