#!/bin/sh

echo '\n\e[1;36mInstalling build dependencies:\e[0m'

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

echo '\e[1;36m> Updating lists of packages...\e[0m'
apt-get update >/dev/null

echo '\e[1;36m> Installing `build-essential`...\e[0m'
apt-get install -y --no-install-recommends build-essential >/dev/null

echo '\e[1;36m> Installing `libbz2-dev`...\e[0m'
apt-get install -y --no-install-recommends libbz2-dev >/dev/null

echo '\e[1;36m> Cleaning the `apt` cache...\e[0m\n'
rm -rf /var/lib/apt/lists/*

echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections