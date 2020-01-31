#!/bin/bash
VERSION=`cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d"=" -f2`
SUDOUSER=`logname`
MODEL=`sudo dmidecode -t system | grep "Product Name" | cut -d":" -f2 | sed 's/^ *//g'`
apt update
if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "Installing git"
  apt install -y git
else
  echo "Git is already installed"
fi
if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "Installing curl"
  apt install -y curl
else
  echo "Curl is already installed"
fi
if [ $(dpkg-query -W -f='${Status}' nfs-common 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "Installing nfs-common"
  apt install -y nfs-common
else
  echo "NFS Common is already installed"
fi

if grep -q 'deb \[arch=amd64\] https://download.docker.com/linux/ubuntu' /etc/apt/sources.list
then
  echo "Docker software repository is already installed"
else
  echo "Docker software repository is not installed. Installing"
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  if grep -q 'deb \[arch=amd64\] https://download.docker.com/linux/ubuntu' /etc/apt/sources.list
  then
    echo "Docker software repository is now installed"
  fi
fi
if [ $(dpkg-query -W -f='${Status}' docker-ce 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "Installing docker"
  sudo apt-get install -y docker-ce
  sudo sed -i '/LimitCORE=infinity/ a LimitMEMLOCK=infinity' /lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl enable docker.service
else
  echo "Docker is already installed"
fi
if grep docker /etc/group | grep -q ${SUDOUSER}
then
  echo "Current user already member of docker group"
else
  echo "Adding current user to docker group"
  sudo usermod -aG docker ${SUDOUSER}
fi
if [ -f /usr/local/bin/docker-compose ];
then
  echo "Docker Compose is already installed"
else
  echo "Installing Docker Compose"
  sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
if grep -q 'vm.max_map_count' /etc/sysctl.conf
then
  echo "VM Max Map Count already configured"
else
  echo "Setting vm.max_map_count to 262144"
  sudo sysctl -w vm.max_map_count=262144
  echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
fi
if grep -q 'docker - memlock unlimited' /etc/security/limits.conf
then
  echo "Security limits already configured"
else
  echo "Setting security limits for elasticsearch, root, and docker"
  echo "elasticsearch - nofile 65535" | sudo tee -a /etc/security/limits.conf
  echo "elasticsearch - memlock unlimited" | sudo tee -a /etc/security/limits.conf
  echo "root - memlock unlimited" | sudo tee -a /etc/security/limits.conf
  echo "elasticsearch soft memlock unlimited" | sudo tee -a /etc/security/limits.conf
  echo "elasticsearch hard memlock unlimited" | sudo tee -a /etc/security/limits.conf
  echo "docker - nofile 65535" | sudo tee -a /etc/security/limits.conf
  echo "docker - memlock unlimited" | sudo tee -a /etc/security/limits.conf
  echo "docker soft memlock unlimited" | sudo tee -a /etc/security/limits.conf
  echo "docker hard memlock unlimited" | sudo tee -a /etc/security/limits.conf
fi
if grep -q 'swap' /etc/fstab
then
  echo 'Disabling swap'
  sudo sed -i '/swap/d' /etc/fstab
else
  echo 'Swap has already been disabled'
fi
