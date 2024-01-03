#!/bin/bash

# This script checks and sets the github config email and name needed to do commits

#GITHUB_USER_EMAIL="pamposh.dhar@amd.com"
#GITHUB_USER_NAME="Pamposh Dhar"

# Check and set user.email
current_email=$(git config --global user.email)
current_name=$(git config --global user.name)

# Check and set user.email if not matching the desired value
if [ "$current_email" != "$GITHUB_USER_EMAIL" ]; then
  git config --global user.email "$GITHUB_USER_EMAIL"
  echo "Global user.email has been set to $GITHUB_USER_EMAIL"
else
  echo "Global user.email is already set to $current_email"
fi

# Check and set user.name if not matching the desired value
if [ "$current_name" != "$GITHUB_USER_NAME" ]; then
  git config --global user.name "$GITHUB_USER_NAME"
  echo "Global user.name has been set to $GITHUB_USER_NAME"
else
  echo "Global user.name is already set to $current_name"
fi
