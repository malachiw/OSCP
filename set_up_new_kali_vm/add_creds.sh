#!/bin/zsh

# Ensure two arguments are passed
if [[ "$#" -ne 2 ]]; then
    echo "Usage: add_creds <username:password> <path> "
    return 1
fi

if [[ $1 == *":"* ]]; then
    echo "Usage: add_creds <username:password> <path> "
    return 1
fi

# append creds to cred file
echo $1 >> $2
