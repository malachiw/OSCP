#!/bin/zsh

# Ensure two arguments are passed
if [[ "$#" -ne 2 ]]; then
    echo "Usage: add_creds <username:password> <path>"
    exit 1
fi

# Ensure the first argument contains a colon
if [[ "$1" != *:* ]]; then
    echo "Error: First argument must be in the format username:password"
    echo "Usage: add_creds <username:password> <path>"
    exit 1
fi

# Ensure the destination file exists or can be created
if ! touch "$2" 2>/dev/null; then
    echo "Error: Cannot write to $2"
    exit 1
fi

# Append creds to cred file
echo "$1" >> "$2"
echo "Credentials added to $2"
