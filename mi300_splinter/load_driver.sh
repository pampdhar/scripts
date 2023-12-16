#!/bin/bash

# # Function to change/cd into a directory
# change_directory() {
#     # Get the directory path from the argument
#     directory="$1"
#     cd "$directory"
# }

# # Specify Gaurav's directory path
USER="pampdhar"
# DIR="/home/$USER/tools/scripts/ppa-bb"

# # Check if the directory exists
# if [ ! -d "$DIR" ]; then
#     # Clone the directory
#     #mkdir -p "$directory"
#     #echo "ppa-bb directory created"
#     git clone git@github.amd.com:dcgpu-validation/ppa-bb.git
# fi

#sudo pip install -i http://mkmartifactory.amd.com/artifactory/api/pypi/fw-papi2pyapi-prod-virtual/simple papi2 --trusted-host mkmartifactory.amd.com --upgrade

#sudo python3 /home/$USER/scripts/pre_driver.py

#Load the driver
sudo modprobe pci-stub && echo "1002 164e" | sudo tee /sys/bus/pci/drivers/pci-stub/new_id
sudo modprobe pci-stub
echo "1002 164e"  |sudo tee /sys/bus/pci/drivers/pci-stub/new_id
echo "0000:05:00.0" > /sys/bus/pci/devices/0000:05:00.0/driver/unbind
echo -n "0000:05:00.0" > /sys/bus/pci/drivers/pci-stub/bind

sudo modprobe -r ast
sudo modprobe amdgpu






#sudo modprobe amdgpu smu_memory_pool_size=0x4l
#runpm=0 is to bypass the driver related to the HBM >100degC issue
#sudo modprobe amdgpu runpm=0 smu_memory_pool_size=0x4

#sudo python3 /home/$USER/scripts/post_driver.py

# Program the Vin PCC limit=94A
#change_directory "/home/amd/tools/agt_internal"
#sudo ./agt_internal -i=0 -i2cw:4,90,07,D7

# Program the Vddcr_vdd0/1/2/3 OCL lim=370A and Vdd_soc OCL lim=640A
#sudo python3 /home/$USER/scripts/PCC_Limit_Modification_372_640.py

change_directory "/home/$USER"

rocminfo

dmesg | grep amdgpu
