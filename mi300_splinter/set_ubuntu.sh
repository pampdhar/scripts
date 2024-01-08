#!/bin/bash

# Update and upgrade the ubuntu system
sudo apt update && sudo apt upgrade -y

# # python3.10-venv : needed for creating virtual environments
sudo apt-get install -y python3.10-venv

# # python3-pip : needed for installing packages with pip
sudo apt-get install -y python3-pip

sudo apt install -y vim git curl htop nano tree
