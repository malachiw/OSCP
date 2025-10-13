#!/bin/sh
#scan a /24 cidr range with basic sh tools. This scan searches
# for machines that have port 445 open.
for i in $(seq 1 254); do nc -zv -w 1 172.16.169.$i 445; done
