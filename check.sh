#!/bin/bash

(
    echo domain curl curl.exe dig
    for i in inet-ip.info ifconfig.me ifconfig.io; do
        printf %s' ' $i
        printf %s' ' $(curl     -4sS $i)
        printf %s' ' $(curl.exe -4sS $i)
        printf %s' ' $(dig +short $i | tr '\n' ',' | sed 's/,$//')
        echo
    done
) |
column -t

echo
cat<<'EOF'
wsshuttle -r server -x $(dig +short inet-ip.info) $(dig +short ipconfig.me) 0/0
ifconfig.me == ifconfig.io

wsshuttle -r server -x $(dig +short inet-ip.info) $(dig +short ipconfig.me)
inet-ip.info == ifconfig.io
EOF
