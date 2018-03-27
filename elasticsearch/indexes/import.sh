#!/bin/bash
cd /opt/elastic_stack/elasticsearch/indexes
for filename in *.json; do
  name=${filename:0:-5};
  echo "localhost:9200/_template/$name";
  curl -XPUT "localhost:9200/_template/$name" -H 'Content-Type: application/json' --data "@/opt/elastic_stack/elasticsearch/indexes/$filename";
done