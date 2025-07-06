# standard open port scan
rustscan -a $IP -- -oN rusty

# show the rustscan output
less -R rusty

# start nmap scan on open ports
nmap -vv -p $(awk '/tcp/ {print $1}' rusty | tr '\n' ',' | sed 's/\/tcp//g' | sed 's/,$//g') -sV -Pn -A -oN nmap $IP

