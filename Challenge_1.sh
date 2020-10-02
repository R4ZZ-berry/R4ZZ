#!/bin/bash

#Erasmo Hernandez

#Challenge 1: check IP of devices connected in a network
#Select a currently active network interface. Identify the IP range of the network. Ping all IPs in the range and print only IPs that respond.

#How to get desired results of challenge.
#Scan all interfaces and identify which are active and omit any sudo NICs. Once the interface has been identified, obtain the network IP and CIDR (subnet). Next, scan the network with the appropriate CIDR utilizing Nmap and filter out the network and broadcast IPs. Print the filtered out IPs into Text file. Use the text file to ping against all the listed IPs and display only IPs responding.


# Identify all active physical interfaces and iterate through them. (E.g. the system may be connected to an ethernet and wireless interface with IPs on each.)
for i in $(ip addr | awk '/state UP/ {print $2}' | awk -F: '$0 !~ "lo|vmnet"{print $1}' | sed 's/.$//')
    do
    interface=$i

    #Get network IP and CIDR
    network=`ip addr show | grep $interface | grep -i inet | awk 'NR==1{print $2}'`

    #Create list of all available IPs
    IPrange=`nmap -sL $network | awk '/Nmap scan report/{print $NF}' | awk '{gsub(/\(|\)/,"")}1' | sed '1d;$d' > iplist.txt`

    #Let user know what the results are
    echo "List of IPs responding on interface ${interface}"

    for j in $(cat iplist.txt)
        do
        ping -c 1 -W 0.1 $j | grep "bytes from" |cut -f4 -d" " | sed 's/.$//'
    done

