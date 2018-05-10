#!/bin/bash
VERSION=`cat /etc/lsb-release | grep RELEASE | cut -d"=" -f2`
if [ $VERSION = "18.04" ]; then
  DOCKER="docker.io"
else
  DOCKER="docker-ce"
fi
apt update
if dpkg -s git | grep -q "not installed"
then
  echo "Installing git"
  apt install -y git
else
  echo "Git is already installed"
fi
if dpkg -s curl | grep -q "not installed"
then
  echo "Installing curl"
  apt install -y curl
else
  echo "Curl is already installed"
fi

if [ -f /opt/elastic_stack ];
then
  cd /opt
  git clone https://github.com/HASecuritySolutions/elastic_stack.git
  chown -R ${USER} /opt/elastic_stack
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
if dpkg -s docker | grep -q "not installed"
then
  echo "Installing docker"
  sudo apt-get install -y $DOCKER
else
  echo "Docker is already installed"
fi
if grep docker /etc/group | grep -q ${USER}
then
  echo "Current user already member of docker group"
else
  echo "Adding current user to docker group"
  sudo usermod -aG docker ${USER}
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
