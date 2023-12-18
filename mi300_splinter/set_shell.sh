#!/bin/bash

# User variables
USER="pampdhar"
HOME_DIR="/home/${USER}"
SCRIPTS_DIR="${HOME_DIR}/scripts"
SCRIPTS_DIR_PROJ="${HOME_DIR}/scripts/mi300_splinter"


##############################################################

# Get the scripts folder

# Check if the scripts directory exists
if [ -d "${SCRIPTS_DIR}" ]; then
    echo "scripts directory already exists. Pulling repo for latest changes now..."
    git pull git@github.com:pampdhar/scripts.git
else
    cd ${HOME_DIR}
    git clone git@github.com:pampdhar/scripts.git
fi

##############################################################

#add ssh keys --> get scripts from github.com



#ADDING SSH keys here

HOST_NAME=${hostname}


##############################################################


#Get the latest agt_internal version

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