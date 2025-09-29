#!/bin/zsh

# This script is meant to be sourced or wrapped in a function
# to update and export IP in .zshenv

if [[ "$#" -ne 1 ]]; then
    echo "Usage: target <IPv4 or IPv6 address>"
    return 1
fi

IP_VALUE="$1"

# Regex patterns
ipv4_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
ipv6_regex='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

# Validate IPv4
if [[ "$IP_VALUE" =~ $ipv4_regex ]]; then
    local -a octets
    IFS='.' octets=("${(@s:.:)IP_VALUE}")
    for octet in "${octets[@]}"; do
        if (( octet < 0 || octet > 255 )); then
            echo "Invalid IPv4 address: Octet '$octet' out of range"
            return 1
        fi
    done
elif [[ "$IP_VALUE" =~ $ipv6_regex ]]; then
    true  # IPv6 format looks good
else
    echo "Invalid IP address format."
    return 1
fi

# .zshenv path and variable
ZSHENV_PATH="$HOME/.zshenv"
ENV_VAR_NAME="IP"

# Backup .zshenv if it exists
cp "$ZSHENV_PATH" "$ZSHENV_PATH.bak" 2>/dev/null

# Remove existing IP export and add new one
if grep -q "^export ${ENV_VAR_NAME}=" "$ZSHENV_PATH" 2>/dev/null; then
    sed -i '' "/^export ${ENV_VAR_NAME}=/d" "$ZSHENV_PATH"
fi

ec
