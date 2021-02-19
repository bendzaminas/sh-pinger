#!/bin/bash
# pingsweep for class C CIDR only /24 to /31
# pingsweep.sh [<network address>/CIDR]
# pingsweel.sh 10.11.1.0/24
FILE=$2
network_address=$(echo $1 | cut -d / -f 1)
cidr=$(echo $1 | cut -d / -f 2)
echo "[*] Performing ping sweep on "$network_address"/"$cidr"" >> ./log.log

# starts off at 1, because all multiples will be done of 2
host_count=1

# iterate through the number of network bits set on the CIDR
# subtract cidr from 32 to figure out number of bits used for hosts
for i in $(seq 1 $((32-$cidr))); do host_count=$(($host_count * 2)); done;

echo "[-] Total # of hosts: "$host_count"" >> ./log.log
start=1
stop=$(($host_count - 2))
echo "[-] Usable range: 1 - "$stop"" >> ./log.log
echo "[*] Pinging range now!" >> ./log.log

# grab first 3 octects of the network address
network_only=$(echo $network_address | cut -d'.' -f 1-3)

# issue ping command for range of targets
for i in $(seq $start $stop)
do
	target=$network_only"."$i
        echo "[*] Pinging "$target" now!" >> ./log.log
	result=$(ping -c 1 -W 1 $target | grep "packets" | cut -d" " -f 6)
	if [ $result == "0%" ]
	then
	    echo $target >> "./response/$FILE/good_ips.txt"
        else
            echo $target >> "./response/$FILE/bad_ips.txt"
	fi
done | parallel -k -j 100
