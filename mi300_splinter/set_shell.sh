#!/bin/bash

# User variables
USER="pampdhar"
HOME_DIR="/home/${USER}"
SCRIPTS_DIR="${HOME_DIR}/scripts"
SCRIPTS_DIR_PROJ="${HOME_DIR}/scripts/mi300_splinter"
AGT_DIR="/home/amd/tools/agt_internal"

##############################################################

# Adding SSH keys here
./set_ssh_keys.sh

##############################################################

# Get the scripts folder
./get_scripts.sh

##############################################################

# Get the latest agt_internal with the amd-tool-installer
./get_agt_int.sh

##############################################################

# Get the powerlens repository
./get_powerlens.sh

##############################################################

# install orc3
./install_orc3.sh

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

