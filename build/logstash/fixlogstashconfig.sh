#!/bin/bash

#sed -i "s;http:\/\/elasticsearch:9200;$ELASTICSEARCH_URL;g" /usr/share/logstash/config/logstash.yml

#sed -i "s;elasticsearch:9200;$ELASTICSEARCH_NODE:9200;g" /etc/logstash/conf.d/logstash.conf
# above conf file was removed in 3.2.3
sed -i "s;elasticsearch:9200;$ELASTICSEARCH_NODE:9200;g" /usr/share/logstash/pipeline/01-wazuh.conf


#exec $@
exec /usr/local/bin/docker-entrypoint $@
