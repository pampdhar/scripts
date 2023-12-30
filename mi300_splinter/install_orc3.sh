#!/bin/bash

# User changes here
USER="pampdhar"

###################################################

# Check if the HOME_DIR variable is unset or set to an empty string
# This is done to make sure this script works with the get_shell.sh script
if [ -z "${HOME_DIR}" ]; then
    HOME_DIR="/home/${USER}"
fi

if [ -z "${ORC_DIR_NAME}" ]; then
    ORC_DIR_NAME="orc3_pamposh"
fi

# The home orc3 directory path
ORC_DIR="${HOME_DIR}/${ORC_DIR_NAME}"

# Check if the orc3 directory already exists
if [ -d "${ORC_DIR}/orc3" ]; then
    echo "${ORC_DIR_NAME} directory already exists, pulling latest changes..."
    cd "${ORC_DIR}/orc3"
    git pull git@github.amd.com:dcgpu-validation/orc3.git
else
    # Create the directory
    mkdir -p "${ORC_DIR}"
    echo "${ORC_DIR_NAME} directory created"
    cd "${ORC_DIR}"
    git clone git@github.amd.com:dcgpu-validation/orc3.git
    cd "${ORC_DIR}/orc3"
    sudo orc_install/install_pyenv.sh
    orc_python orc_install/install.py --venv=${ORC_DIR}/orc3_py_venv dev
fi