#!/bin/zsh

sudo apt install pipx git feroxbuster ncat chisel neo4j bloodhound crackmapexec shellter wine -y
sudo dpkg --add-architecture i386 && apt-get update && apt-get install wine32
pipx install name-that-hash dirsearch
pip3 install wsgidav --break-system-packages
pipx ensurepath
pipx install git+https://github.com/Pennyw0rth/NetExec
sudo msfdb init
sudo systemctl enable postgresql
