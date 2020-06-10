#!/usr/bin/bash

printf "nameserver 192.168.1.19" > /etc/resolv.conf

printf "\192.168.1.2 nodea\n" >> /etc/hosts
printf "\n192.168.1.15 nodeb\n" >> /etc/hosts
