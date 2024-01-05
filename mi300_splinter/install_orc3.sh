#!/bin/bash

# User changes here
default_orc3_dir="orc3_pamposh"

###################################################

# Use the environment variable from the outer script if present; otherwise, use the default value specified by the user above
local_orc3_dir="${1:-$default_orc3_dir}"

# The home orc3 directory path
ORC_DIR="${HOME}/${local_orc3_dir}"

# Check if the orc3 directory already exists
if [ -d "${ORC_DIR}/orc3" ]; then
    echo "${local_orc3_dir} directory already exists, pulling latest changes..."
    cd "${ORC_DIR}/orc3"
    git pull git@github.amd.com:dcgpu-validation/orc3.git
else
    # Create the directory
    mkdir -p "${ORC_DIR}"
    echo "${local_orc3_dir} directory created"
    cd "${ORC_DIR}"
    git clone git@github.amd.com:dcgpu-validation/orc3.git
    cd "${ORC_DIR}/orc3"
    sudo orc_install/install_pyenv.sh
    orc_python orc_install/install.py --venv=${ORC_DIR}/orc3_py_venv dev
fi