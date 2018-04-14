#!/bin/bash
if grep -xq 'deb \[arch=amd64\] https://download.docker.com/linux/ubuntu xenial stable' /etc/apt/sources.list
then
  echo "Docker software repository is already installed"
else
  apt-get update
  apt install -y curl
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  if dpkg -l | grep docker-ce
  then
    echo "Docker is already installed"
  else
    sudo apt-get install -y docker-ce
  fi
  sudo usermod -aG docker ${USER}
  if ls -a /usr/local/bin/docker-compose
  then
    echo "Docker Compose is already installed"
  else
    sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
  
  max_map_count=`grep 'vm.max_map_count' /etc/sysctl.conf`
  map_value=${max_map_count:17}
  if [ $map_value -ge 262144 ]
  then
    echo "Max Map Count already set - This needs to be 262144 or higher"
  else
    sudo sysctl -w vm.max_map_count=262144
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
  fi
fi
