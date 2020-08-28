#!/bin/sh

echo '\n\e[1;36mInstalling Python packages:\e[0m'

echo '\e[1;36m> Creating a hidden folder for the user...\e[0m'
sudo mkdir -p /usr/other/$USER && sudo chgrp -R $USER /usr/other/$USER && sudo chmod -R g+w /usr/other/$USER

echo '\e[1;36m> Installing `sympy`...\e[0m'
pip3 install sympy >/dev/null 2>&1

echo '\e[1;36m> Installing `kplr`...\e[0m'
OTHER_PATH=/usr/other/$USER
wget https://github.com/dfm/kplr/archive/main.zip -P $OTHER_PATH >/dev/null 2>&1
unzip $OTHER_PATH/main.zip -d $OTHER_PATH >/dev/null
rm $OTHER_PATH/main.zip
mv $OTHER_PATH/kplr-main $OTHER_PATH/kplr
cd $OTHER_PATH/kplr
sudo python3 $OTHER_PATH/kplr/setup.py install >/dev/null 2>&1
cd - >/dev/null

echo '\e[1;36m> Deleting the hidden folder...\e[0m\n'
sudo rm -rf /usr/other/$USER