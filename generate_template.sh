#!/bin/bash
USER=YOURUSERHERE
PASSWORD=YOURPASSWORDHERE
SERVER=SERVERGOESHERE
PORT=PASSWORDGOESHERE
SHARDPERXGB=50
REPLICAENABLED=1
CACERT=/opt/elastic_stack/ca/ca.crt
INDICES=/opt/elastic_stack/curator/current_indices
EXCEPTIONS=( kibana elastalert readonlyrest accounting nessus apm )
HEADERFILE=/opt/elastic_stack/elasticsearch/templates/header.template.json
FOOTERFILE=/opt/elastic_stack/elasticsearch/templates/footer.template.json
PURGEOLDTEMPLATE=1
ceil() {
  echo "define ceil (x) {if (x<0) {return x/1} \
        else {if (scale(x)==0) {return x} \
        else {return x/1 + 1 }}} ; ceil($1)" | bc
}
echo "Enter a specific name for an index to pull properties from - Example: logstash-zeek-2019.11.22"
read INDEXNAME
echo "Enter the index pattern name. logstash-zeek-2019.11.22 would have a pattern name of logstash-zeek"
read INDEXPATTERNNAME
curl -s --cacert ${CACERT} -u ${USER}:${PASSWORD} https://${SERVER}:$PORT/${INDEXNAME}/_mappings?pretty | jq .[]."mappings"."properties" > properties.json
INDEXPRIMARIESSIZE=$(curl -s --cacert ${CACERT} -u ${USER}:${PASSWORD} https://${SERVER}:$PORT/${INDEXNAME}/_stats/store | jq ."_all"."primaries"."store"."size_in_bytes" | awk '{ byte =$1 /1024/1024/1024; print byte }')
SHARDS=1
if [[ $PURGEOLDTEMPLATE -eq 1 ]]
then
  rm -f ${INDEXPATTERNNAME}.template.json
fi

cat $HEADERFILE > ${INDEXPATTERNNAME}.template.json
cat properties.json >> ${INDEXPATTERNNAME}.template.json
cat $FOOTERFILE >> ${INDEXPATTERNNAME}.template.json
sed -i "s/INDEXNAME/${INDEXPATTERNNAME}/" ${INDEXPATTERNNAME}.template.json
rm -f properties.json
sed -i "s/NUMBERSHARDS/${SHARDS}/" ${INDEXPATTERNNAME}.template.json

if [[ $REPLICAENABLED -eq 1 ]]
then
  sed -i "s/NUMBERREPLICAS/1/" ${INDEXPATTERNNAME}.template.json
else
  sed -i "s/NUMBERREPLICAS/0/" ${INDEXPATTERNNAME}.template.json
fi
echo "New Template created at ${INDEXPATTERNNAME}.template.json"

echo "Would you like to import the index template? Enter 1 for yes or 2 for no"
read ASKTOIMPORT

if [[ $ASKTOIMPORT -eq 1 ]]
then
  curl -s --cacert ${CACERT} -u ${USER}:${PASSWORD} -X PUT "https://${SERVER}:$PORT/_template/${INDEXPATTERNNAME}?pretty" -H 'Content-Type: application/json' -d @${INDEXPATTERNNAME}.template.json
fi
