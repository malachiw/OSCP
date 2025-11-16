# Add a share to /etc/samba/smb.conf
```shell
┌──(kali㉿kali)-[~]
└─$ sudo vi /etc/samba/smb.con
```

# set up a smb user and password
```shell
┌──(kali㉿kali)-[~]
└─$ sudo smbpasswd -a kali     
New SMB password:
Retype new SMB password:
Added user kali.
```
