#!/bin/bash
# SMTP Enumeration Script for Kali Linux
# Run as root

TARGET=$1
if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target_ip>"
    exit 1
fi

echo "[+] Starting SMTP enumeration on $TARGET"

# Check if target is alive
ping -c 1 $TARGET > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "[-] Target $TARGET is not reachable"
    exit 1
fi

# Check SMTP service
echo "[+] Checking SMTP service..."
nmap -p 25,465,587 $TARGET -sV

# Check SMTP banner
echo "[+] Checking SMTP banner..."
echo "EHLO example.com" | nc $TARGET 25

# Check for open relay
echo "[+] Testing for open relay..."
echo "MAIL FROM:<test@example.com>" | nc $TARGET 25
echo "RCPT TO:<test@example.com>" | nc $TARGET 25
echo "DATA" | nc $TARGET 25
echo "Subject: Test Email" | nc $TARGET 25
echo "This is a test email." | nc $TARGET 25
echo "." | nc $TARGET 25

# Check for vulnerable SMTP servers
echo "[+] Checking for vulnerable SMTP servers..."
smtputfuzz -d $TARGET

echo "[+] SMTP enumeration completed"
