#!/bin/bash

# Get the scripts folder from github.com account

# Check if the HOME_DIR variable is unset or set to an empty string
if [ -z "${HOME_DIR}" ]; then
    HOME_DIR="/home/${USER}"
    SCRIPTS_DIR="${HOME_DIR}/scripts"
    SCRIPTS_DIR_PROJ="${HOME_DIR}/scripts/mi300_splinter"
fi

cd ${HOME_DIR}

# Check if the scripts directory exists
if [ -d "${SCRIPTS_DIR}" ]; then
    echo "scripts directory already exists. Pulling repo for latest changes now..."
    sudo chmod 777 -R ${SCRIPTS_DIR}
    cd ${SCRIPTS_DIR}
    git pull git@github.com:pampdhar/scripts.git
else
    git clone git@github.com:pampdhar/scripts.git
    sudo chmod 777 -R ${SCRIPTS_DIR}
fi