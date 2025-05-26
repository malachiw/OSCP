# Let's upgrade that shell
python3 -c 'import pty;pty.spawn("/bin/bash")'

# background the shell
# C^z
# for zsh (kali) enter twice after `fg`
stty raw -echo; fg
stty row XX columns YYY
export TERM="xterm-256color"

# there now isn't that better.
