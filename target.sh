#!/bin/zsh

# This script is meant to be sourced or wrapped in a function
# to update and export IP in .zshenv
#
# Add this to .zshenv so that you can update $IP and it is 
# immediately available.
#
# target() {
#   /usr/local/bin/target "$1" && source ~/.zshenv
# }

# Ensure one argument is passed
if [[ "$#" -ne 1 ]]; then
    echo "Usage: target <IPv4 or IPv6 address>"
    return 1
fi

IP_VALUE="$1"

# Regex patterns
ipv4_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
ipv6_regex='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

# Validate IP
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
    true
else
    echo "Invalid IP address format."
    return 1
fi

# .zshenv path and variable
ZSHENV_PATH="$HOME/.zshenv"
ENV_VAR_NAME="IP"

# Create file if it doesn't exist
touch "$ZSHENV_PATH"

# Backup .zshenv
cp "$ZSHENV_PATH" "$ZSHENV_PATH.bak" 2>/dev/null

# Remove existing export line
# Cross-platform sed compatibility (macOS/BSD)
if grep -q "^export ${ENV_VAR_NAME}=" "$ZSHENV_PATH"; then
    if [[ "$OSTYPE" == darwin* ]]; then
        sed -i '' "/^export ${ENV_VAR_NAME}=/d" "$ZSHENV_PATH"
    else
        sed -i "/^export ${ENV_VAR_NAME}=/d" "$ZSHENV_PATH"
    fi
fi

# Append new export line
echo "export ${ENV_VAR_NAME}=${IP_VALUE}" >> "$ZSHENV_PATH"

# Source it
source "$ZSHENV_PATH"

# Output
echo "IP=${IP_VALUE} has been added to $ZSHENV_PATH and sourced."
echo "Current IP: \$IP=$IP"
