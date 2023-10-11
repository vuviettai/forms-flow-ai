#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
# Recreate config file
rm -rf ${SCRIPT_DIR}/config.js
touch ${SCRIPT_DIR}/config.js

envsubst < ${SCRIPT_DIR}/config.template.js > ${SCRIPT_DIR}/config.js;
