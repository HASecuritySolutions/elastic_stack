#!/bin/bash
USER=YOURUSERHERE
PASSWORD=YOURPASSWORDHERE
SERVER=SERVERGOESHERE
PORT=PASSWORDGOESHERE
SHARDPERXGB=50
REPLICAENABLED=1
CACERT=/opt/elastic_stack/ca/ca.crt
HEADERFILE=/cloud/cloud_configs/global/header.template.json
FOOTERFILE=/cloud/cloud_configs/global/footer.template.json
PURGEOLDTEMPLATE=1
echo "Enter the filename of the template to import"
read TEMPLATENAME
echo "What is the index pattern name"
read INDEXPATTERNNAME
curl -s --cacert ${CACERT} -u ${USER}:${PASSWORD} -X PUT "https://${SERVER}:$PORT/_template/${INDEXPATTERNNAME}?pretty" -H 'Content-Type: application/json' -d @${TEMPLATENAME}
