#!/bin/bash

# Install keychain
sudo apt-get update
sudo apt-get upgrade -y  
sudo apt-get install -y keychain

# Define the keychain command in a variable
keychain_command="eval 'keychain --eval --agents ssh id_ed25519_public id_ed25519_enterprise'"

# Check if keychain is already configured in the bashrc file
if ! grep -q "$keychain_command" ~/.bashrc; then
    # Add keychain configuration to the bashrc file
    echo -e "\n# Start keychain and set up SSH agent\n$keychain_command" >> ~/.bashrc
    echo 'export PATH="/usr/bin/keychain:$PATH"' >> ~/.bashrc

fi

# Kill any existing agents and flush the keys/identities from memory
keychain -k all

# Start keychain and set up SSH agent (suppress output)
$keychain_command > /dev/null 2>&1

# Display information and instructions
echo "Keychain has been installed, configured, and the SSH agent has been started."
echo "To add your SSH keys automatically in future terminals, no additional action is needed."
