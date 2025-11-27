Dear learners,
I'm sharing some insights on Learning Module 11.3.1 Capstone labs 

**STEP I - Preparing the 2 files for the attack on WinPrep**

**NOTE :** Don’t start yet the wsgidav server , that way you DON’T open the `config-Library.ms` by accident in your WinPrep machine (when you open it will change the meta in the file cause it connects to the wsgidav server) 

1. Connect to RDP on WinPrep and you will share your TMP folder with the machine (that way you copy-paste the 2 files we will create - `config.Library-ms` and `automatic_configuration.lnk`) 
```xfreerdp /u:offsec /p:lab /v:192.168.X.194 /drive:/tmp```

2. Open VS-Code and create an empty text file on the desktop and name it `config.Library-ms`, close VS-Code (wait for the file to appear, it looks like in the video a folder with a blank file behind it)

3. Right-click -> Open with ->  VS-Code. Now copy Listing 17 - Windows Library code for connecting to our WebDAV Share (change the IP with your tun0) then save the file and exit VS-Code (now in 1-2 seconds ICON should change to a blue one, meaning all went good so far!) 
**NOTE: **DON’T double click the new file, else inside it will change, like leave it like that! 

4. Now it's time to create the Shortcut: Right-Click on Desktop -> New -> Shortcut. On the type of location you copy paste FULL command from Listing 18 - PowerShell Download Cradle and PowerCat Reverse Shell Execution (make sure to change both IPs with your tun0 IP) 
**NOTE:** When you copy-paste Listing 18 it will not take full one-liner, but only first command, so make sure you insert both commands (else will stop at “;” which ends the 1st command) 

5. Copy-paste to your shared TMP: File Explorer -> This PC -> _tmp on Kali.  Now both files are transferred with integrity on your own Kali. Move them to `/home/kali/webdav` from `/tmp` (on your Kali)
```cd /home/kali/webdav```
```cp /tmp/automatic_configuration.lnk .```
```cp /tmp/config.Library-ms .```


**UPDATE**: In some cases, copy-paste to your shared TMP will work, BUT swaks will not go further even if successful with the attack! USE **impacket-smbserver **to transfer using a mounted partition! For more info regarding HOW TO , go to https://discord.com/channels/780824470113615893/1148907181480104028
