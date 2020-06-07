#!/usr/bin/bash

printf "\192.168.1.2 nodea\n" >> /etc/hosts
printf "\n192.168.1.15 nodeb\n" >> /etc/hosts

ssh -i /ssh/id_rsa thetasinner@nodea exit
ssh -i /ssh/id_rsa thetasinner@nodeb exit
