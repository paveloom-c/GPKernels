#!/bin/bash

# A script to install `nbconvert`

# Set auxiliary variables
# for ANSI escape codes
cyan="\e[1;36m" # Bold cyan
reset="\e[0m"   # Reset colors

echo -e "\n${cyan}Installing `nbconvert`...${reset}\n"
pip3 install --no-cache-dir nbconvert