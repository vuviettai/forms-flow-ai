#!/bin/bash
#For ubuntu 20.04
VERSION_DOCKER_COMPOSE=v2.21.0
#Setup docker
sudo apt update;
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}
#sudo su - ${USER}
#Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/${VERSION_DOCKER_COMPOSE}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
#Nginx
sudo apt install nginx -y