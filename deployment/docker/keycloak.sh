#!/bin/sh
DIR="$( cd "$( dirname "$0" )" && pwd )"
ENV_FILE=$DIR/formsflow.env
# For linux
HOST_IP=$(hostname -I | awk '{print $1}')
sed -i "s|HOST_IP=.*|HOST_IP=$HOST_IP|g" $ENV_FILE
# Form macos
# HOST_IP=$(ipconfig getifaddr en0)
# echo 'Start forms flow with ip ${HOST_IP}'
# sed -i '' "s|HOST_IP=.*|HOST_IP=$HOST_IP|g" $ENV_FILE
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