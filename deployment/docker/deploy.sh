#!/bin/bash
USER=$1
HOST=$2
AUTH="${USER}@$HOST"
WORKING_DIR=smartform
DIR="$( cd "$( dirname "$0" )" && pwd )"

setup() {
    ssh ${AUTH} 'mkdir -p ~/${WORKING_DIR}'
    scp ${DIR}/setup.sh \
        ${AUTH}:~/${WORKING_DIR}
    ssh -t ${AUTH} "sudo /bin/sh -c /home/${USER}/${WORKING_DIR}/setup.sh"
}
docker() {
    scp ${DIR}/compose.sh \
        ${DIR}/formio.Dockerfile \
        ${DIR}/docker-compose-bpm.yml \
        ${DIR}/docker-compose-formio.yml \
        ${DIR}/docker-compose-web-backend.yml \
        ${DIR}/formsflow.env 
        ${AUTH}:~/${WORKING_DIR}
}

frontend() {

}

$@