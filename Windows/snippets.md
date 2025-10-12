#Great Snippets for Windows
## use linux to base64 enc for use in Windows
```shell
cat pscommand.txt | iconv -f UTF-8 -t UTF-16LE | base64 -w 0
```

## Determine if in cmd or PowerShell context
```shell
(dir 2>&1 *`|echo CMD);&<# rem #>echo PowerShell
```
## Determine if in cmd or PowerShell context (URL Encoded)
```url encoded
%28dir%202%3E%261%20%2A%60%7Cecho%20CMD%29%3B%26%3C%23%20rem%20%23%3Eecho%20PowerShell
```

## Powershell version of less
```powershell
Get-Content yourfile.txt | Out-Host -Paging
``` 
