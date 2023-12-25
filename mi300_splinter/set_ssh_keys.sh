#!/bin/bash

# This script helps setup ssh keys for following accounts:
# github.amd.com account with email: pamposh.dhar@amd.com
# github.com account with email: pamposh.dhar@amd.com

AMD_PUBLIC_KEYNAME="id_ed25519_public"
AMD_ENTERPRISE_KEYNAME="id_ed25519_enterprise"
HOSTNAME=`hostname`

# Function to add SSH key to GitHub
add_ssh_key() {
    local title=$1
    local token=$2
    local keyfile=$3
    curl -X POST -H "Authorization: token $token" -d "{\"title\":\"$title\",\"key\":\"$(cat $keyfile.pub)\"}" $API_URL
}

# Source the config file to get the environment variables storing the personal access tokens
source ssh_config.sh

# Generate SSH keys
ssh-keygen -t ed25519 -f ~/.ssh/${AMD_PUBLIC_KEYNAME} -N ''
ssh-keygen -t ed25519 -f ~/.ssh/${AMD_ENTERPRISE_KEYNAME} -N ''

# Giving user the rwx access to the keys
sudo chmod u+rwx ~/.ssh/${AMD_PUBLIC_KEYNAME}.pub
sudo chmod u+rwx ~/.ssh/${AMD_ENTERPRISE_KEYNAME}.pub

# Add keys to GitHub
API_URL="https://api.github.com/user/keys"
add_ssh_key "SSH Key for ${HOSTNAME}" "$AMD_GITHUB_PUBLIC_TOKEN" ~/.ssh/${AMD_PUBLIC_KEYNAME}

API_URL="https://github.amd.com/api/v3/user/keys"
add_ssh_key "SSH Key for ${HOSTNAME}" "$AMD_GITHUB_ENTERPRISE_TOKEN" ~/.ssh/${AMD_ENTERPRISE_KEYNAME}