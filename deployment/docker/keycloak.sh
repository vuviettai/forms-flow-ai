#!/bin/sh
DIR="$( cd "$( dirname "$0" )" && pwd )"
ENV_FILE=$DIR/formsflow.env
OS=$(uname)
if [ $OS == 'Darwin' ]
then
    # Form macos
    HOST_IP=$(ipconfig getifaddr en0)
    sed -i '' "s|HOST_IP=.*|HOST_IP=$HOST_IP|g" $ENV_FILE
elif [ $OS == 'Linux' ]
then
    HOST_IP=$(hostname -I | awk '{print $1}')
    sed -i "s|HOST_IP=.*|HOST_IP=$HOST_IP|g" $ENV_FILE
fi 
COMPOSES="-f ${DIR}/docker-compose-keycloak.yml"
build() {
    docker-compose ${COMPOSES} \
        --env-file $ENV_FILE \
        build
}

up() {
    docker-compose ${COMPOSES} \
        --env-file $ENV_FILE \
        up -d 
}

down() {
    docker-compose ${COMPOSES} down
}

$@
