#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
ENV_FILE=$DIR/formsflow.env
OS=$(uname)
DOCKER_COMPOSE_BPM=${DIR}/docker-compose-bpm.yml
if [ $OS == 'Darwin' ]
then
    # Form macos
    HOST_IP=$(ipconfig getifaddr en0)
    sed -i '' "s|HOST_IP=.*|HOST_IP=$HOST_IP|g" $ENV_FILE
    ARCH=$(uname -m)
    if [ $ARCH == 'arm64' ]
    then
        DOCKER_COMPOSE_BPM=${DIR}/docker-compose-bpm-arm64.yml
    fi
elif [ $OS == 'Linux' ]
then
    HOST_IP=$(hostname -I | awk '{print $1}')
    sed -i "s|HOST_IP=.*|HOST_IP=$HOST_IP|g" $ENV_FILE
fi 
COMPOSES="-f ${DIR}/docker-compose-network.yml"
COMPOSES="${COMPOSES} -f ${DIR}/docker-compose-formio.yml"
COMPOSES="${COMPOSES} -f ${DOCKER_COMPOSE_BPM}"
COMPOSES="${COMPOSES} -f ${DIR}/docker-compose-web.yml"
#COMPOSES="-f ${DIR}/docker-compose-keycloak.yml"
#COMPOSES=" -f ${DIR}/docker-compose-arm64.yml"

build() {
    docker-compose ${COMPOSES} --env-file $ENV_FILE build
}

up() {
    docker-compose ${COMPOSES} --env-file $ENV_FILE up -d 
}

down() {
    docker-compose ${COMPOSES} down
}

$@