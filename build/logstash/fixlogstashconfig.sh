#!/bin/bash

sed -i "s;http:\/\/elasticsearch:9200;$ELASTICSEARCH_URL;g" /usr/share/logstash/config/logstash.yml

sed -i "s;elasticsearch:9200;$ELASTICSEARCH_NODE:9200;g" /etc/logstash/conf.d/logstash.conf


#exec $@
exec /usr/local/bin/docker-entrypoint $@
