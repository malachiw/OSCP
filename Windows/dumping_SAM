Launch WSL from the PowerShell console with the bash command:
```powershell
sudo apt install python3
sudo apt install python3-pip
python3 -m pip install impacket
```
  
From the impacket package, we need the secretsdump.py file. It can be found inside the Python module or downloaded from GitHub:
```bash
wget https://github.com/SecureAuthCorp/impacket/releases/download/
impacket_0_9_22/impacket-0.9.22.tar.gz
tar -xvzf impacket-0.9.22.tar.gz
cd impacket-0.9.22/examples
```
  
Extract the hashes:
```bash
python3 secretsdump.py -system /mnt/c/Temp/SYSTEM -ntds /mnt/c/Temp/ntds.dit LOCAL -outputfile /mnt/c/Temp/hashes.lst
```
  
We should immediately check the presence and content of the hashes.lst.ntds.cleartext file. These are passwords from accounts with a "Store password using reversible encryption" checkbox in the properties. It is worth checking whether this is a necessity.

There is a lot of garbage in the file. You can remove waste like this:
```bash
cat hashes.lst.ntds | cut -d":" -f 1,4 | sort > hashes_sorted.lst
```
  
You will get a list of such kind:
```bash
domain\sam_account_name:ntlm_hash
```
