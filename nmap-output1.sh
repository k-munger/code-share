#!/bin/bash

#nmap diffing cron job
mkdir /opt/nmap_diff
d=$(date +%Y-%m-%d)
y=$(date -d yesterday + %Y-%m-%d)
/usr/bin/nmap -T4 -oX /opt/nmap_diff/scan_$d.xml 192.168.1.1-254 >
/dev/null 2>&1

if [[ -e /opt/nmap_diff/scan_$y.xml ]];
then
	/usr/bin/ndiff/opt/nmap_diff/scan_$y.xml
	/opt/nmap_diff/scan_$d.xml > /opt/nmap_diff.txt

# Creates the output and the results directory if they need to be created
if [ ! -d "output" ]; then
    mkdir output
    mkdir results
fi

# Run a host discovery scan to see which devices are available in the subnet
typeOfScan='nmap-sP'
nmap -sP $subnet -oA output/$location-$typeOfScan

# From the host discovery put together a list of IP Addresses that can be used in future scans
if [ -f "output/$location-$typeOfScan.nmap" ]; then
    cat output/$location-$typeOfScan.nmap | grep "Nmap scan report for" | awk '{print $5}' > $ipList
else
    echo "Unable to find the nmap host discovery list."
    exit
fi

# need to test
