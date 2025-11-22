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
22..445 | ForEach-Object {if ((Test-NetConnection <HOST> -Port $_).TcpTestSucceeded) {$_}}
```
