#!/bin/bash -vx

# User changes here
USER="pampdhar"
ORC_DIR_NAME="orc3_pamposh"

###################################################

HOME_DIR="/home/${USER}"
# The home orc3 directory path
ORC_DIR="${HOME_DIR}/${ORC_DIR_NAME}"

# Check if the orc3 directory already exists
if [ -d "${ORC_DIR}" ]; then
    echo "${ORC_DIR_NAME} directory already exists, pulling latest changes..."
    cd "${ORC_DIR}"
    git clone git@github.amd.com:dcgpu-validation/orc3.git
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