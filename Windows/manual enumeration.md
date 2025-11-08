## 17.1 Enumerating Windows.

Always gather the following info

```
- Username and hostname
- Group memberships of the current user
- Existing users and groups
- Operating system, version and architecture
- Network information
- Installed applications
- Running processes
```
*Listing 5 - Information we should gather to obtain situational awareness*

Write out a summary after gathering your info. This will help consolidate the info in your mind and help find gaps.

Username and hostname
```powershell
whoami
```

Group memberships of the current user
```powershell
whoami /groups
```

Existing users
```powershell
Get-LocalUser
```

```powershell
net local user
```

Group info
```powershell
Get-LocalGroup
```

```powershell
Get-LocalGroupMember adminteam #specific group of interest
Get-LocalGroupMember Administrators #run this one always!!!
``` 


Operating system, version, and architecture

```powershell
systeminfo
```

Network information
```powershell
ipconfig /all
route print
netstat -ano
```

Installed applications
Can run this as well as check the programs folders, both 32 and 64.
```powershell
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | select displayname
```

Running process
```powershell
Get-Process
```

Details for particular processes
```powershell
Get-Process particular_process | Format-List *
```
gathering scheduled tasks
```powershell
$schtasks = schtasks /query /fo LIST /v
```

filtering scheduled tasks using PowerShell
```powershell
$schtasks | Where-Object { $_ -match "TaskName|RunAsUser" } 
```
No unquoted paths
```powershell
wmic service get name,pathname | select-string -pattern "C:\\windows\\" -notmatch | select-string -pattern '"' -notmatch | select-string -pattern '\w'
```

Looking for running vulnerable services 
```powershell
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}
```

### 17.1.3 Hidden in Plain View
Searching for sensitive files

keepass databases
```powershell
Get-ChildItem -Path C:\ -Include *.kdbx -File -Recurse -ErrorAction SilentlyContinue
```

sensitive files
```powershell
Get-ChildItem -Path C:\xampp -Include *.txt,*.ini -File -Recurse -ErrorAction SilentlyContinue
```
Show user's command line history if not cleared; think bash's history 
```
Get-History 
```
Checking history again--find location of PSRreadline file
Shows where PSReadline history file is, now go read it
```powershell
(Get-PSReadlineOption).HistorySavePath 
```
