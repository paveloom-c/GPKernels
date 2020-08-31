#!/bin/sh

echo '\n\e[1;36mInstalling Python packages:\e[0m'

echo '\e[1;36m> Installing `kplr`...\e[0m\n'
OTHER_PATH=/usr/other/$USER
wget https://github.com/dfm/kplr/archive/main.zip -P $OTHER_PATH >/dev/null 2>&1
unzip $OTHER_PATH/main.zip -d $OTHER_PATH >/dev/null
rm $OTHER_PATH/main.zip
cd $OTHER_PATH/kplr-main
sudo python3 setup.py install >/dev/null 2>&1
cd - >/dev/null
sudo rm -rf $OTHER_PATH/kplr-main