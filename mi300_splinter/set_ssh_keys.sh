#!/bin/bash

# This script helps setup ssh keys for following accounts:
# Enterprise AMD internal account - github.amd.com account with email: <firstname>.<lastname>@amd.com
# Public account with AMD email - github.com account with email: <firstname>.<lastname>@amd.com

AMD_PUBLIC_KEYNAME="id_ed25519_public"
AMD_ENTERPRISE_KEYNAME="id_ed25519_enterprise"
HOSTNAME=`hostname`
PUB_SSH_KEY_PATH=~/.ssh/${AMD_PUBLIC_KEYNAME}
ENT_SSH_KEY_PATH=~/.ssh/${AMD_ENTERPRISE_KEYNAME}

# Function to add keychain
add_keychain(){
    # Install keychain
    sudo apt-get update
    sudo apt-get upgrade -y  
    sudo apt-get install -y keychain

    # Define the keychain command in a variable
    keychain_command="eval 'keychain --eval --agents ssh id_ed25519_public id_ed25519_enterprise'"

    # Check if keychain is already configured in the bashrc file - if not append to bashrc file
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
}


# Function to add SSH key to GitHub - Uses the GITHUB API
add_ssh_key_to_github() {
    local title=$1
    local token=$2
    local keyfile=$3
    curl -X POST -H "Authorization: token $token" -d "{\"title\":\"$title\",\"key\":\"$(cat $keyfile.pub)\"}" $API_URL
}

# Function to generate a new ssh key
generate_new_ssh_key(){
    # Generate SSH key
    ssh-keygen -t ed25519 -f ~/.ssh/$1 -N ''
    # Giving user the rwx access to the key
    sudo chmod u+rwx ~/.ssh/$1.pub
}

source_ssh_config(){
    # Sourcing the ssh_config.sh file to store the PATs as environment variables
    if [ -f ~/.secrets/ssh_config.sh ]; then
        source ~/.secrets/ssh_config.sh
    else
        echo "Could not find the ssh_config.sh file in the secrets folder!"
        exit 1
    fi
}

# Check if SSH keys exists on the system
if [ -e "${PUB_SSH_KEY_PATH}" ] && [ -e "${ENT_SSH_KEY_PATH}" ]; then
    echo "SSH keys already exist on this system. Skipping creation of new keys and addition to git accounts"
else
    echo "Could not find any existing keys. Creating new SSH keys and adding to the github accounts..."
    generate_new_ssh_key ${AMD_PUBLIC_KEYNAME}
    generate_new_ssh_key ${AMD_ENTERPRISE_KEYNAME}

    # Sourcing the ssh_config file to get the PATs needed for the github API calls
    source_ssh_config

    # Add keys to GitHub
    API_URL="https://api.github.com/user/keys"
    add_ssh_key_to_github "SSH Key for ${HOSTNAME}" "$AMD_GITHUB_PUBLIC_TOKEN" ~/.ssh/${AMD_PUBLIC_KEYNAME}

    API_URL="https://github.amd.com/api/v3/user/keys"
    add_ssh_key_to_github "SSH Key for ${HOSTNAME}" "$AMD_GITHUB_ENTERPRISE_TOKEN" ~/.ssh/${AMD_ENTERPRISE_KEYNAME}
fi

# Finally Run the keychain function to install and run the keychain
add_keychain




