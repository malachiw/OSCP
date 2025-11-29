simple port scanner
```shell
for i in $(seq 1 254); do nc -zv -w 1 172.16.169.$i 445; done
```

using wpscan
```shell
wpscan --url http://<domain> --plugins-detection aggressive -o wpscan --api-token <api-token>
```
powershell
```powershell
echo 21 22 23 25 53 80 110 111 135 139 143 443 445 993 995 1723 3306 3389 5900 8080 | ForEach-Object {if (Test-NetConnection <HOST> -Port $_ -InformationLevle "Quiet" -warningaction silentlycontinue) {echo "tcp connect to port: $_"}}
```

powershell 2
```powershell
1..20 | % {"192.168.1.$($_): $(Test-Connection -count 1 -comp 192.168.1.$($_) -quiet)"}
```
