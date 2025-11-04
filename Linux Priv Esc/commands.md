## Manually enumerating

```bash
id
```

```
cat /etc/passwd
```

```
grep -v nologin /etc/passwd
```

```
hostname
```

```
cat /etc/issue
```

```
cat /etc/os-release
```

```
uname -a
```

```
ps aux
```

```
ip a
```

```
routel
```

```
route
```

```
ss -anp
```

```
cat /etc/iptables/rules.v4
```

```
ls -lah /etc/cron*
```

```
crontab -l
```

```
sudo crontab -l
```

```
dpkg -l
```

```
find / -writable -type d 2>/dev/null
```

```
mount
```

```
cat /etc/fstab
```

```
lsblk
```

```
lsmod
```

 if you find something interesting using `lsmod` the use `modinfo` to get more details.
```
/sbin/modinfo libata
```

```
find / -perm -u=s -type f 2>/dev/null
```



## Automatic enumeration
ssh joe@$IP
# Upload unix-privesc-check
sh unix-privesc-check > output.txt
less output.txt
