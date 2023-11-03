#!/bin/bash
USER=$1
HOST=$2
AUTH=$USER@$HOST

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
ENV=${2:-smartformclient}
rootconfig() {
    docker build --file ${SCRIPT_DIR}/frontend.Dockerfile \
				--build-arg ROOT_PATH=/root \
				--no-cache --output "type=local,dest=../dist" ${SCRIPT_DIR}/../..
	echo "Finished build in $(date)"
	# scp ${SCRIPT_DIR}/../dist/root-config.tar.gz ${AUTH}:/tmp/root-config.tar.gz
    # DEST=/usr/share/nginx/html/root-config
  	# ssh -t ${AUTH} "sudo rm -rf $DEST"
  	# ssh -t ${AUTH} "sudo mkdir -p $DEST"
  	# ssh -t ${AUTH} "sudo tar -xvf /tmp/root-config.tar.gz -C $DEST"
  	# echo "Finished deployment in $(date)"
}

client-spa() {
    docker build --file ${SCRIPT_DIR}/client-spa.Dockerfile \
				--build-arg ENV=${ENV} \
				--no-cache --output "type=local,dest=../dist" ${SCRIPT_DIR}
	echo "Finished build in $(date)"
}


client() {
    docker build --file ${SCRIPT_DIR}/client.Dockerfile \
				--build-arg ENV=${ENV} \
				--no-cache --output "type=local,dest=../dist" ${SCRIPT_DIR}/../..
	echo "Finished build in $(date)"
	# scp ${SCRIPT_DIR}/../dist/smartform-client.tar.gz ${AUTH}:/tmp/client.tar.gz
    # DEST=/usr/share/nginx/html/client
  	# ssh -t ${AUTH} "sudo rm -rf $DEST"
  	# ssh -t ${AUTH} "sudo mkdir -p $DEST"
  	# ssh -t ${AUTH} "sudo tar -xvf /tmp/smartform-client.tar.gz -C $DEST"
  	# echo "Finished deployment in $(date)"
}

$@