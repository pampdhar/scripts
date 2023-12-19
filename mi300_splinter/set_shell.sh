#!/bin/bash

# User variables
USER="pampdhar"
HOME_DIR="/home/${USER}"
SCRIPTS_DIR="${HOME_DIR}/scripts"
SCRIPTS_DIR_PROJ="${HOME_DIR}/scripts/mi300_splinter"
AGT_DIR="/home/amd/tools/agt_internal"

##############################################################

# Get the scripts folder
cd ${HOME_DIR}
# Check if the scripts directory exists
if [ -d "${SCRIPTS_DIR}" ]; then
    echo "scripts directory already exists. Pulling repo for latest changes now..."
    git pull git@github.com:pampdhar/scripts.git
else
    git clone git@github.com:pampdhar/scripts.git
fi

##############################################################

#add ssh keys --> get scripts from github.com



#ADDING SSH keys here

HOST_NAME=${hostname}


##############################################################


# Get the latest agt_internal with the amd-tool-installer

python3 -m venv amd-installer-tools
source amd-installer-tools/bin/activate
python3 -m pip install amd-tool-installer --extra-index-url=http://mkmartifactory.amd.com/artifactory/api/pypi/hw-orc3pypi-prod-local/simple --trusted-host=mkmartifactory.amd.com --upgrade
echo "Installing the latest agt_internal version..."
amd-tool-install agt_internal ${AGT_DIR} latest
deactivate

##############################################################

# Get the powerlens repository
git clone git@github.amd.com:dcgpu-validation/powerlens.git
cd powerlens
pip install -e .

##############################################################

# install orc3

# Specify the home orc3 directory path
ORC_DIR="{HOME_DIR}/orc3_pamposh"
cd ${HOME_DIR}

# Check if the directory exists
if [ -d "${ORC_DIR}" ]; then
    echo "orc3_pamposh directory already exists"
    git clone git@github.amd.com:dcgpu-validation/orc3.git
else
    # Create the directory
    mkdir -p "${ORC_DIR}"
    echo "orc3_pamposh directory created"
    git clone git@github.amd.com:dcgpu-validation/orc3.git
    cd "${ORC_DIR}/orc3"
    sudo orc_install/install_pyenv.sh
    orc_python orc_install/install.py --venv=${ORC_DIR}/orc3_py_venv dev
fi

##############################################################
# Modify bashrc file

# Creating a backup bashrc file
cp ${HOME_DIR}/.bashrc ${HOME_DIR}/.bashrc_backup

# Adding the script folder 
echo 'export PATH=$PATH:${SCRIPTS_DIR}' >> ~/.bashrc

# Setting custom aliases here
echo 'alias cdl="dmesg | grep amdgpu"' >> ~/.bashrc
echo 'alias rocminfo="sudo /opt/rocm/bin/rocminfo"' >> ~/.bashrc
echo 'alias s="cd ${SCRIPTS_DIR}"' >> ~/.bashrc
echo 'alias sp="cd ${SCRIPTS_DIR_PROJ}"' >> ~/.bashrc
echo 'alias a="cd ${SCRIPTS_DIR_PROJ}/auto/"' >> ~/.bashrc
echo 'alias agt="cd /home/amd/tools/agt_internal/"' >> ~/.bashrc
echo 'alias vb="cd /home/amd/tools/amdvbflash/"' >> ~/.bashrc
echo 'alias ifwi="cd /home/amd/tools/amdvbflash/;sudo ./amdvbflash -i"' >> ~/.bashrc
echo 'alias devices="cd /home/amd/tools/agt_internal/;sudo ./agt_internal -i"' >> ~/.bashrc
echo 'alias orc="cd ${HOME_DIR}/orc3_pamposh/orc3/"' >> ~/.bashrc
echo 'alias pa="cd ${HOME_DIR}/orc3_pamposh/orc3/orc_test/power_attainment/"' >> ~/.bashrc
echo 'alias presets="cd ${HOME_DIR}/orc3_pamposh/orc3/src/amdlibs/orc_ppa_fmt/orc_ppa_fmt/app_presets"' >> ~/.bashrc

# Reload the .bashrc file for the changes to take effect
source ~/.bashrc
echo 'Changes to bashrc applied.'

##############################################################

# Mounting dcval on SUT

if ! dpkg -l | grep -q "cifs-utils"; then
    sudo apt-get install -y cifs-utils
fi

