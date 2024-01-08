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
        echo 'export SSH_AUTH_SOCK="$SSH_AUTH_SOCK"' >> ~/.bashrc
        echo 'export SSH_AGENT_PID="$SSH_AGENT_PID"' >> ~/.bashrc
        echo 'export PATH="/usr/bin/keychain:$PATH"' >> ~/.bashrc

    fi

    # Kill any existing agents and flush the keys/identities from memory
    keychain -k all

    # Start keychain and set up SSH agent (suppress output)
    $keychain_command > /dev/null 2>&1
    export SSH_AUTH_SOCK SSH_AGENT_PID

    # Display information and instructions
    echo "Keychain has been installed, configured, and the SSH agent has been started."
    echo "To add your SSH keys automatically in future terminals, no additional action is needed."
}

# Function to add ssh-key with inbuilt commands - no keychain application
add_key_default(){
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519_public
    ssh-add ~/.ssh/id_ed25519_enterprise
    ssh-add -l

    # Add SSH agent and ssh-add commands to ~/.bashrc
    if ! grep -q "ssh-agent" ~/.bashrc; then
        echo "Adding SSH Agent to ~/.bashrc"
        # Append commands to the ~/.bashrc file
        {
        echo -e "\n# Initialize SSH Agent"
        echo "eval \"\$(ssh-agent -s)\" > /dev/null 2>&1"
        echo "ssh-add /home/pampdhar/.ssh/id_ed25519_public > /dev/null 2>&1"
        echo "ssh-add /home/pampdhar/.ssh/id_ed25519_enterprise > /dev/null 2>&1"
        } >> ~/.bashrc
        source ~/.bashrc
    fi
}

# Function to add SSH key to GitHub - Uses the GITHUB API
add_ssh_key_to_github() {
    local title=$1
    local token=$2
    local keyfile=$3

    response=$(curl -s -w "\n%{http_code}\n" -X POST -H "Authorization: token $token" -d "{\"title\":\"$title\",\"key\":\"$(cat $keyfile.pub)\"}" $API_URL)

    # Split response and status code
    response_body=$(echo "$response" | head -n -1)
    http_status=$(echo "$response" | tail -n1)

    # Check if the HTTP status code is 201 (Created)
    if [ "$http_status" -eq 201 ]; then
        echo "SSH key successfully added to GitHub."
    else
        echo "Failed to add SSH key to GitHub. HTTP status: $http_status"
        echo "Response body: $response_body"
    fi
}

# Function to generate a new ssh key
generate_new_ssh_key(){
    # Generate SSH key
    ssh-keygen -t ed25519 -f ~/.ssh/$1 -N ''
    # Readable by everyone, writable only by the user access to the public key
    sudo chmod 644 ~/.ssh/$1.pub
    # Giving only the user the read and write access to the private key
    sudo chmod 600 ~/.ssh/$1
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
#add_keychain

# Add key to agent with default method
add_key_default



