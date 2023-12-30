#!/bin/bash

# Get the latest agt_internal

USER="pampdhar"

# Check if the HOME_DIR variable is unset or set to an empty string
# This is done to make sure this script works with the get_shell.sh script
if [ -z "${HOME_DIR}" ]; then
    HOME_DIR="/home/${USER}"
    AGT_DIR="/home/amd/tools/agt_internal"
fi

# Ensuring the agt_internal directory exists
sudo chmod 777 -R "/home/amd"
if [ ! -d ${AGT_DIR} ]; then
    mkdir -p "${AGT_DIR}"
fi    

cd ${HOME_DIR}

# Check if directory exists
if [ ! -d amd-installer-tools ]; then
    python3 -m venv amd-installer-tools
fi

source ${HOME_DIR}/amd-installer-tools/bin/activate
python3 -m pip install amd-tool-installer --extra-index-url=http://mkmartifactory.amd.com/artifactory/api/pypi/hw-orc3pypi-prod-local/simple --trusted-host=mkmartifactory.amd.com --upgrade

# Check if an older agt-internal version already exists
if [ -f "${AGT_DIR}/agt_internal" ]; then
    echo "An older agt_internal version already exists. Getting the latest version now..."
    sudo rm ${AGT_DIR}/agt_internal
else
    echo "Installing the latest agt_internal version..."
fi
amd-tool-install agt_internal ${AGT_DIR} latest
deactivate