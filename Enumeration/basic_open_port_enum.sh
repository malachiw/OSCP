echo -e "\033[32m \[+\]\033[0m Starting rustscan with default options for $IP"

# standard open port scan
rustscan -a $IP -- -oN rusty

echo -e "\033[32m \[+\]\0330m Starting nmap to probe versions, and OS and assuming $IP is online."
# start nmap scan on open ports
nmap -vv -p $(awk '/tcp/ {print $1}' rusty | tr '\n' ',' | sed 's/\/tcp//g' | sed 's/,$//g') -sV -Pn -O -oN nmap $IP

