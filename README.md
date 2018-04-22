# elastic_stack

Deploying the Elastic Stack can be difficult. This project hopes to simplify that.

### Initial Goal

Make it simple to deploy a full fledged Elastic Stack with advanced capabilities on a single physical box using Docker.

### Long Term Goal

Contain scripts for easy deployment to production systems

## Prerequisites
Must have Docker installed. An example of how to do this on an Ubuntu 16.04 system is as below:

```bash
cd /opt
sudo git clone https://github.com/HASecuritySolutions/elastic_stack.git
sudo bash /opt/elastic_stack/scripts/prereq.sh
sudo cp /opt/elastic_stack/docker-compose.yml.example /opt/elastic_stack/docker-compose.yml
docker-compose up
# Wait until Elasticsearch is running then run this:
bash elasticsearch/indexes/import.sh
```
