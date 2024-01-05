#!/bin/bash

# Get the powerlens repo - assuming ssh keys are configured

POWERLENS_DIR="${HOME}/powerlens"

# Check if the powerlens already exists
if [ -d "${POWERLENS_DIR}" ]; then
    echo "Powerlens directory already exists, pulling latest changes..."
    sudo chmod 777 -R ${POWERLENS_DIR}
    cd "${POWERLENS_DIR}"
    git pull git@github.amd.com:dcgpu-validation/powerlens.git
else
    cd "${HOME}"
    git clone git@github.amd.com:dcgpu-validation/powerlens.git
    cd "${POWERLENS_DIR}"
    pip install -e .
fi