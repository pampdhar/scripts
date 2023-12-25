#!/bin/bash

# python3.10-venv : needed for creating virtual environments
if dpkg -l | grep -q "python3.10-venv"; then
  echo "python3.10-venv is already installed."
else
  echo "python3.10-venv is not installed. Installing..."
  sudo apt-get install -y python3.10-venv
fi
