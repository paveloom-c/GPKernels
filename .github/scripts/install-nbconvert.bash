#!/bin/bash

# A script to install `nbconvert`

# Set auxiliary variables
# for ANSI escape codes
cyan="\e[1;36m" # Bold cyan
reset="\e[0m"   # Reset colors

echo -e "\n${cyan}Installing `python3`...${reset}\n"
sudo apt-get install -y --no-install-recommends python3-dev

echo -e "\n${cyan}Installing `pip3`...${reset}\n"
sudo apt-get install -y --no-install-recommends python3-pip

echo -e "\n${cyan}Upgrading `pip3`...${reset}\n"
pip3 install --upgrade pip

echo -e "\n${cyan}Installing `nbconvert`...${reset}\n"
pip3 install --no-cache-dir nbconvert