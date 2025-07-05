#!/bin/bash
# SMB Enumeration Script for Kali Linux
# Run as root

TARGET=$1
if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target_ip>"
    exit 1
fi

echo "[+] Starting SMB enumeration on $TARGET"

# Check if target is alive
ping -c 1 $TARGET > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "[-] Target $TARGET is not reachable"
    exit 1
fi

# Check SMB ports
echo "[+] Checking SMB ports..."
nmap -p 139,445 $TARGET -sV

# Check SMB shares
echo "[+] Checking SMB shares..."
smbclient -L //$TARGET -U%

# Check for anonymous login
echo "[+] Testing anonymous login..."
smbclient -L //$TARGET -U%

# Check for vulnerable SMB versions
echo "[+] Checking SMB version..."
smbclient -L //$TARGET -U% -d 3

# Check for vulnerable shares
echo "[+] Checking for vulnerable shares..."
smbclient -L //$TARGET -U% | grep -i "admin\|share\|public"

echo "[+] SMB enumeration completed"
