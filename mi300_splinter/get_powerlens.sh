#!/bin/bash

# Get the powerlens repo - assuming ssh keys are configured

# User changes here
USER="pampdhar"

# Check if the HOME_DIR variable is unset or set to an empty string
# This is done to make sure this script works with the get_shell.sh script
if [ -z "${HOME_DIR}" ]; then
    HOME_DIR="/home/${USER}"
fi

POWERLENS_DIR="${HOME_DIR}/powerlens"

# Check if the powerlens already exists
if [ -d "${POWERLENS_DIR}" ]; then
    echo "Powerlens directory already exists, pulling latest changes..."
    sudo chmod 777 -R ${POWERLENS_DIR}
    cd "${POWERLENS_DIR}"
    git pull git@github.amd.com:dcgpu-validation/powerlens.git
else
    cd "${HOME_DIR}"
    git clone git@github.amd.com:dcgpu-validation/powerlens.git
    cd "${POWERLENS_DIR}"
    pip install -e .
fi