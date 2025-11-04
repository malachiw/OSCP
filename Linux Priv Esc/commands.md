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
netstat -tlnp
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
sudo -l
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

check for writiable files
```shell
#!/usr/bin/env bash
# Check if files and directories in writeVB are writable

# Define the variable
writeVB="/etc/anacrontab|/etc/apt/apt.conf.d|/etc/bash.bashrc|/etc/bash_completion|/etc/bash_completion.d/|/etc/cron|/etc/environment|/etc/environment.d/|/etc/group|/etc/incron.d/|/etc/init|/etc/ld.so.conf.d/|/etc/master.passwd|/etc/passwd|/etc/profile.d/|/etc/profile|/etc/rc.d|/etc/shadow|/etc/skey/|/etc/sudoers|/etc/sudoers.d/|/etc/supervisor/conf.d/|/etc/supervisor/supervisord.conf|/etc/systemd|/etc/sys|/lib/systemd|/etc/update-motd.d/|/root/.ssh/|/run/systemd|/usr/lib/cron/tabs/|/usr/lib/systemd|/systemd/system|/var/db/yubikey/|/var/spool/anacron|/var/spool/cron/crontabs|$(echo $PATH 2>/dev/null | sed 's/:\.:/:/g' | sed 's/:\.$//g' | sed 's/^\.://g' | sed 's/:/|/g')"

# Split the variable into an array by '|'
IFS='|' read -r -a paths <<< "$writeVB"

echo "=== Writable Path Check ==="
for path in "${paths[@]}"; do
    # Skip empty entries
    [[ -z "$path" ]] && continue

    # Resolve symbolic links
    resolved_path=$(readlink -f "$path" 2>/dev/null || echo "$path")

    if [ -w "$resolved_path" ]; then
        echo "[WRITABLE] $resolved_path"
    fi
done
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
