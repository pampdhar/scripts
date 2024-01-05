#!/bin/bash

# Get the latest agt_internal

# User changes here
default_agt_dir="/home/amd/tools/agt_internal"

###################################################

# Check if the AGT_DIR environment variable is unset or set to an empty string
# This is done to make sure this script works with the set_shell.sh script
local_agt_dir="${1:-$default_agt_dir}"

# Ensuring the agt_internal directory exists

if [ ! -d ${local_agt_dir} ]; then
    sudo mkdir -p "${local_agt_dir}"
fi
sudo chmod 777 -R "/home/amd"    

cd ${HOME}

# Check if directory exists
if [ ! -d amd-installer-tools ]; then
    python3 -m venv amd-installer-tools
fi

source ${HOME}/amd-installer-tools/bin/activate
python3 -m pip install amd-tool-installer --extra-index-url=http://mkmartifactory.amd.com/artifactory/api/pypi/hw-orc3pypi-prod-local/simple --trusted-host=mkmartifactory.amd.com --upgrade

# Check if an older agt-internal version already exists
if [ -f "${local_agt_dir}/agt_internal" ]; then
    echo "An older agt_internal version already exists. Getting the latest version now..."
    sudo rm ${local_agt_dir}/agt_internal
else
    echo "Installing the latest agt_internal version..."
fi
amd-tool-install agt_internal ${local_agt_dir} latest
deactivate