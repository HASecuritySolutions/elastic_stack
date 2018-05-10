#!/bin/bash
cp -f /opt/elastic_stack/docker-compose.yml.example /opt/elastic_stack/docker-compose.yml
cp -f /opt/elastic_stack/curator/example/* /opt/elastic_stack/curator/
cp -f /opt/elastic_stack/cron/custom-cron.example /opt/elastic_stack/cron/custom-cron
cp -f /opt/elastic_stack/elastalert/config.yaml.example /opt/elastic_stack/elastalert/config.yaml
if [ ! -d /opt/elastic_stack/elastalert/rules ];
then
  mkdir /opt/elastic_stack/elastalert/rules
fi
mkdir /opt/elastic_stack/elastalert/rules
cp -f /opt/elastic_stack/elastalert/example_rules/* /opt/elastic_stack/elastalert/rules/
cp -f /opt/elastic_stack/logstash/pipelines.yml.example /opt/elastic_stack/logstash/pipelines.yml
cd /opt/elastic_stack
docker-compose up --no-start
