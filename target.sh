#!/bin/zsh

# Check if exactly one argument is passed
if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <IPv4 or IPv6 address>"
    exit 1
fi

IP="$1"

# Regex patterns for IPv4 and IPv6
ipv4_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
ipv6_regex='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

# Validate IPv4
if [[ "$IP" =~ $ipv4_regex ]]; then
    # Split IP into octets using Zsh split
    local -a octets
    IFS='.' octets=("${(@s:.:)IP}")
    
    for octet in "${octets[@]}"; do
        if (( octet < 0 || octet > 255 )); then
            echo "Invalid IPv4 address: Octet '$octet' out of range"
            exit 1
        fi
    done
    
    export IP="$IP"
    echo "Valid target. Exported IP=$IP"
    exit 0
fi

# Validate IPv6
if [[ "$IP" =~ $ipv6_regex ]]; then
    export IP="$IP"
    echo "Valid target. Exported IP=$IP"
    exit 0
fi

echo "Invalid IP address format."
exit 1
