#!/bin/bash

#Find active interface
interface=`ip addr | awk '/state UP/ {print $2}' | awk -F: '$0 !~ "lo|vmnet"{print $1}' | sed 's/.$//'`

#Get network IP and CIDR
network=`ip addr show | grep $interface | grep -i inet | awk 'NR==1{print $2}'`

#Create list of all available IPs
IPrange=`nmap -sL $network | awk '/Nmap scan report/{print $NF}' | awk '{gsub(/\(|\)/,"")}1' | sed '1d;$d' > iplist.txt`

#Let user know what the results are
echo "List of IPs responding on interface ${interface}"

for i in $(cat iplist.txt)
do
ping -c 1 -W 0.1 $i | grep "bytes from" |cut -f4 -d" " | sed 's/.$//'
done

