#!/bin/bash

# Get the scripts folder from github.com account

# User changes here
default_user="pampdhar"

###################################################

# Use the environment variable from the outer script if present; otherwise, use the default value specified by the user above
local_user="${1:-$default_user}"

# Check if the HOME_DIR variable is unset or set to an empty string
if [ -z "${HOME_DIR}" ]; then
    HOME_DIR="/home/${local_user}"
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