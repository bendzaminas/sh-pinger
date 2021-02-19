#!/bin/bash

FILES=./response/[^.]*/good_ips.txt

for f in $FILES
do
  cmd="sh ./porter.sh "$f
  eval $cmd & pid=$!
  PID_LIST+=" $pid";
  echo $f
done

trap "kill $PID_LIST" SIGINT

echo "Parallel processes have started"
wait $PID_LIST

echo "All processes have completed"
