#!/bin/bash

FILE=$1
filename="$(basename -- $FILE)"

for cmd in $(cat $FILE); do {
  nmap -n -sS -p- --min-rate 5000 $cmd | awk '/^Nmap scan report/{cHost=$5;}
       /open/ { split($1,a,"/"); result[cHost][a[1]]=""}
       END {
       for (i in result) {
         printf i;
         for (j in result[i])
           printf ",%s", j ;
         print ""} }' |
  sed -e 's/,/\t/' >> ./opened_ports.txt 
} done
# | parallel -k -j 10
