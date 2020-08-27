#!/bin/sh

echo '\n\e[1;36mInstalling Python packages:\e[0m'

echo '\e[1;36m> Installing `sympy`...\e[0m'
pip3 install sympy >/dev/null 2>&1

echo '\e[1;36m> Installing `kplr`...\e[0m\n'
OTHER_PATH=/usr/other/$USER

# Workaround until `binder-base` gets `zip`/`unzip`
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo apt-get update >/dev/null
sudo apt-get install -y --no-install-recommends unzip >/dev/null
echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
sudo rm -rf /var/lib/apt/lists/*

# Workaround until `binder-julia-plots` fixes
# the lack of user rights to `/usr/other/$USER`
sudo chgrp -R $USER $OTHER_PATH
sudo chmod -R g+w $OTHER_PATH

wget https://github.com/dfm/kplr/archive/main.zip -P $OTHER_PATH >/dev/null 2>&1
unzip $OTHER_PATH/main.zip -d $OTHER_PATH >/dev/null
rm $OTHER_PATH/main.zip
mv $OTHER_PATH/kplr-main $OTHER_PATH/kplr
cd $OTHER_PATH/kplr
sudo python3 $OTHER_PATH/kplr/setup.py install >/dev/null 2>&1
cd - >/dev/null