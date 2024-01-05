#!/bin/bash

# This script checks and sets the github config email and name needed to do commits

# User changes here
default_user_email="pamposh.dhar@amd.com"
default_user_name="Pamposh Dhar"

###################################################

# Check if the GITHUB_USER_EMAIL and GITHUB_USER_NAME environment variables are unset or set to an empty string
# This is done to make sure this script works with the set_shell.sh script
local_user_email="${1:-$default_user_email}"
local_user_name="${2:-$default_user_name}"

# Check and set user.email
current_email=$(git config --global user.email)
current_name=$(git config --global user.name)

# Check and set user.email if not matching the desired value
if [ "$current_email" != "$local_user_email" ]; then
  git config --global user.email "$local_user_email"
  echo "Global user.email has been set to $local_user_email"
else
  echo "Global user.email is already set to $current_email"
fi

# Check and set user.name if not matching the desired value
if [ "$current_name" != "$local_user_name" ]; then
  git config --global user.name "$local_user_name"
  echo "Global user.name has been set to $local_user_name"
else
  echo "Global user.name is already set to $current_name"
fi
