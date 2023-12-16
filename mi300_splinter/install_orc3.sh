#!/bin/bash

# Function to change/cd into a directory
change_directory() {
    # Get the directory path from the argument
    directory="$1"
    cd "$directory"
}


# Specify the home orc3 directory path
directory=/home/pampdhar/orc3_pamposh

# Check if the directory exists
if [ -d "$directory" ]; then
    echo "orc3_pamposh directory already exists"
else
    # Create the directory
    mkdir -p "$directory"
    echo "orc3_pamposh directory created"
fi

# Call the function and pass the directory path as an argument
change_directory $directory
git clone git@github.amd.com:dcgpu-validation/orc3.git
change_directory "$directory/orc3"
sudo orc_install/install_pyenv.sh
orc_python orc_install/install.py --venv=/home/pampdhar/orc3_pamposh/orc3_py_venv dev
source /home/pampdhar/orc3_pamposh/orc3_py_venv/bin/activate
