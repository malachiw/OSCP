#!/usr/bin/python3
```If using VBA, use this script to break a string into correct size```

#!/usr/bin/env python
from __future__ import print_function
import argparse
import json
import sys
import os

def chunk_string(s, n):
    for i in range(0, len(s), n):
        yield s[i:i+n]

def main():
    p = argparse.ArgumentParser(description="Split a long string into concatenation lines.")
    p.add_argument('string', nargs='?', help="String to split (or path if --file).")
    p.add_argument('-f', '--file', action='store_true',
                   help="Interpret the positional argument as a filename and read the string from that file.")
    p.add_argument('-n', type=int, default=50, help="Chunk size (default: 50).")
    p.add_argument('-v', '--varname', default='Str', help="Variable name to use in output (default: Str).")
    args = p.parse_args()

    if args.string is None:
        p.error("No string provided. Provide the string as a positional argument or use --file with a filename.")

    if args.file:
        if not os.path.exists(args.string):
            p.error("File not found: {}".format(args.string))
        with open(args.string, 'rb') as fh:
            # read raw bytes and decode safely
            raw = fh.read()
            try:
                s = raw.decode('utf-8')
            except Exception:
                # fall back to latin-1 to preserve bytes
                s = raw.decode('latin-1')
    else:
        s = args.string

    var = args.varname

    # Print initialization (optional)
    print("{0} = \"\"".format(var))

    for part in chunk_string(s, args.n):
        # json.dumps ensures proper escaping and double quotes
        quoted = json.dumps(part)
        print("{0} = {0} + {1}".format(var, quoted))

if __name__ == "__main__":
    main()
