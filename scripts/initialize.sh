#!/bin/bash
cp -f /opt/elastic_stack/docker-compose.yml.example /opt/elastic_stack/docker-compose.yml
find /opt/elastic_stack/curator -maxdepth 1 -name "*.example" -exec sh -c 'cp "$0" "${0%.example}.yaml"' {} \;
cp -f /opt/elastic_stack/cron/custom-cron.example /opt/elastic_stack/cron/custom-cron
cp -f /opt/elastic_stack/elastalert/config.yaml.example /opt/elastic_stack/elastalert/config.yaml
cp -f /opt/elastic_stack/logstash/pipelines.yml.example /opt/elastic_stack/logstash/pipelines.yml
