#!/bin/bash

sed -i "s;http:\/\/elasticsearch:9200;$ELASTICSEARCH_URL;g" /usr/share/kibana/config/kibana.yml

exec $@
