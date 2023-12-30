#!/bin/bash

# This script helps setup ssh keys for following accounts:
# github.amd.com account with email: pamposh.dhar@amd.com
# github.com account with email: pamposh.dhar@amd.com

AMD_PUBLIC_KEYNAME="id_ed25519_public"
AMD_ENTERPRISE_KEYNAME="id_ed25519_enterprise"
HOSTNAME=`hostname`
PUB_SSH_KEY_PATH=~/.ssh/${AMD_PUBLIC_KEYNAME}
ENT_SSH_KEY_PATH=~/.ssh/${AMD_ENTERPRISE_KEYNAME}

# Function that checks and starts the ssh-agent
function start_ssh_agent() {
    # Check if an SSH agent is already running
    if [ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        # Start a new SSH agent and set environment variables
        eval "$(ssh-agent -s)"
    fi
}

# Function to add SSH key to GitHub
add_ssh_key_to_github() {
    local title=$1
    local token=$2
    local keyfile=$3
    curl -X POST -H "Authorization: token $token" -d "{\"title\":\"$title\",\"key\":\"$(cat $keyfile.pub)\"}" $API_URL
}

# Function to generate a new ssh key
generate_new_ssh_key(){
# Source the config file to get the environment variables storing the personal access tokens
    source ssh_config.sh
    # Generate SSH key
    ssh-keygen -t ed25519 -f ~/.ssh/$1 -N ''
    # Giving user the rwx access to the key
    sudo chmod u+rwx ~/.ssh/$1.pub
}

function add_ssh_key_to_agent() {
    local key_file="$1"
    local key_name="$2"

    # Giving user the rwx access to the key
    sudo chmod u+rwx $key_file
    ssh-add "$key_file"
}

# Start the SSH agent
eval "$(ssh-agent -s)"

# Check if SSH keys exists on the system
if [ -e "${PUB_SSH_KEY_PATH}" ] && [ -e "${ENT_SSH_KEY_PATH}" ]; then
    echo "SSH keys already exist on this system. Skipping creation of new keys and addition to git accounts"
    # Check if the SSH identities are loaded to the ssh agent
    add_ssh_key_to_agent "$PUB_SSH_KEY_PATH" "$AMD_PUBLIC_KEYNAME"
    add_ssh_key_to_agent "$ENT_SSH_KEY_PATH" "$AMD_ENTERPRISE_KEYNAME"

else
    echo "Could not find any existing keys. Creating new SSH keys and adding to the github accounts..."
    generate_new_ssh_key ${AMD_PUBLIC_KEYNAME}
    generate_new_ssh_key ${AMD_ENTERPRISE_KEYNAME}

    # Add keys to GitHub
    API_URL="https://api.github.com/user/keys"
    add_ssh_key_to_github "SSH Key for ${HOSTNAME}" "$AMD_GITHUB_PUBLIC_TOKEN" ~/.ssh/${AMD_PUBLIC_KEYNAME}

    API_URL="https://github.amd.com/api/v3/user/keys"
    add_ssh_key_to_github "SSH Key for ${HOSTNAME}" "$AMD_GITHUB_ENTERPRISE_TOKEN" ~/.ssh/${AMD_ENTERPRISE_KEYNAME}

    # Add the newly created ssh keys to the agent
    add_ssh_key_to_agent "$PUB_SSH_KEY_PATH" "$AMD_PUBLIC_KEYNAME"
    add_ssh_key_to_agent "$ENT_SSH_KEY_PATH" "$AMD_ENTERPRISE_KEYNAME"
fi




