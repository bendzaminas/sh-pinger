#!/bin/bash

 > ./good_ips.txt
 > ./bad_ips.txt

FILES=./country-ip-blocks/ipv4/*

mkdir response

for f in $FILES
do
  mkdir "./response/{$f}"
  cmd="sh ./process.sh "$f
  eval $cmd & pid=$!
  PID_LIST+=" $pid";

done

trap "kill $PID_LIST" SIGINT

echo "Parallel processes have started"
wait $PID_LIST

echo "All processes have completed"
