#!/bin/bash
domain=chiradeepbanik
token=51ab9c2d-2948-4066-b42a-6d345576ef5c
ipv6addr=$(curl -s https://api6.ipify.org)
echo "https://www.duckdns.org/update?domains=$domain&token=$token&ip=&ipv6=$ipv6addr"
curl -s "https://www.duckdns.org/update?domains=$domain&token=$token&ip=&ipv6=$ipv6addr" -o ~/duckdns/duckdns.log
