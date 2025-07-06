# standard open port scan
rustscan -a $IP -- -oN rusty

# nmap scan on open ports
nmap -p $(awk '/tcp/ {print $1}' rusty | tr '\n' ',' | sed 's/\/tcp//g' | sed 's/,$//g') -sC -sV -O -A -oN nmap $IP

