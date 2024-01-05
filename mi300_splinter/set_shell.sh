#!/bin/bash

# User variables
export SCRIPTS_DIR="${HOME}/scripts"
export SCRIPTS_DIR_PROJ="${HOME}/scripts/mi300_splinter"
export AGT_DIR="/home/amd/tools/agt_internal"
export ORC_DIR_NAME="orc3_pamposh"
export GITHUB_USER_EMAIL="pamposh.dhar@amd.com"
export GITHUB_USER_NAME="Pamposh Dhar"

##############################################################

# Adding SSH keys here
. ${HOME}/sys_config/set_ssh_keys.sh

##############################################################

# Get the scripts folder
cd ${HOME}

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

##############################################################
# Modify bashrc file

# Creating a backup bashrc file
cp ${HOME}/.bashrc ${HOME}/.bashrc_backup

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
echo 'alias orc="cd ${HOME}/orc3_pamposh/orc3/"' >> ~/.bashrc
echo 'alias pa="cd ${HOME}/orc3_pamposh/orc3/orc_test/power_attainment/"' >> ~/.bashrc
echo 'alias presets="cd ${HOME}/orc3_pamposh/orc3/src/amdlibs/orc_ppa_fmt/orc_ppa_fmt/app_presets"' >> ~/.bashrc

# Reload the .bashrc file for the changes to take effect
source ~/.bashrc
echo 'Changes to bashrc applied.'

##############################################################

# Github config - email and name
. ${SCRIPTS_DIR_PROJ}/github_config.sh

##############################################################

# Initial setup the ubuntu system with some pre-requisites for this set shell script
. ${SCRIPTS_DIR_PROJ}/set_ubuntu.sh

##############################################################

# Get the latest agt_internal with the amd-tool-installer
. ${SCRIPTS_DIR_PROJ}/get_agt_int.sh "${AGT_DIR}"

##############################################################

# Get the powerlens repository
. ${SCRIPTS_DIR_PROJ}/get_powerlens.sh

##############################################################

# install orc3
. ${SCRIPTS_DIR_PROJ}/install_orc3.sh "${ORC_DIR_NAME}"

##############################################################

# Mounting dcval on SUT

if ! dpkg -l | grep -q "cifs-utils"; then
    sudo apt-get install -y cifs-utils
fi

##############################################################

# Vim editor settings

# Setting line numbers in vim
line_number_style="set number" #absolute line number style

# Check if the ~/.vimrc file exists
if [ -e ~/.vimrc ]; then
  # Check if the line number style is already set
  if ! grep -q "$line_number_style" ~/.vimrc; then
    # If not, append the line number configuration to the ~/.vimrc file
    echo "$line_number_style" >> ~/.vimrc
    echo "Line numbers set in Vim."
  else
    echo "Line numbers are already set in Vim."
  fi
else
  # If the ~/.vimrc file doesn't exist, create it and add the line number configuration
  echo "$line_number_style" > ~/.vimrc
  echo "Line numbers set in Vim."
fi

##############################################################

