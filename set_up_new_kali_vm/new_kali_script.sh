#!/bin/zsh

sudo apt -y install pipx git feroxbuster ncat chisel neo4j bloodhound crackmapexec shellter wine veil
sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install wine32
/var/share/veil/config/setup.sh --silent --force
pipx install name-that-hash dirsearch
pip3 install wsgidav --break-system-packages
pipx ensurepath
pipx install git+https://github.com/Pennyw0rth/NetExec
sudo msfdb init
sudo systemctl enable postgresql
