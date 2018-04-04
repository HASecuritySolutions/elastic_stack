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
git clone HASecuritySolutions/elastic_stack
sudo bash /opt/elastic_stack/scripts/prereq.sh
docker-compose up
```
