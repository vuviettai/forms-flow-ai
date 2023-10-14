#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
ENV=${2:-formsflow}
ENV_FILE=$DIR/.env.${ENV}
OS=$(uname)
DOCKER_COMPOSE_BPM=${DIR}/docker-compose-bpm.yml
SMARTFORM_CLIENT=${DIR}/../../../smartform-client
DOCKER_COMPOSE_CLIENT=${SMARTFORM_CLIENT}/docker-compose.yml

#export MICRO_FRONT_ENDS=${DIR}/../../../smartform-micro-front-ends
#DOCKER_COMPOSE_MICRO_FRONT_ENDS=${MICRO_FRONT_ENDS}/docker-compose.yml

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
#Formio backend + mongodb
COMPOSES="${COMPOSES} -f ${DIR}/docker-compose-formio.yml"
#Postgres + Bpm java backend (Camunda server)
COMPOSES="${COMPOSES} -f ${DOCKER_COMPOSE_BPM}"
#Main components from formsflow ai (Postgres 11, python backend + frontend for designer)
COMPOSES="${COMPOSES} -f ${DIR}/docker-compose-web.yml"
#Web component development
#COMPOSES="${COMPOSES} -f ${DIR}/docker-compose-dev.yml"
#Micro frontend application
#COMPOSES="${COMPOSES} -f ${DOCKER_COMPOSE_MICRO_FRONT_ENDS}"
#Separated client
#COMPOSES="${COMPOSES} -f ${DOCKER_COMPOSE_CLIENT}"
#COMPOSES="-f ${DIR}/docker-compose-keycloak.yml"

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