#!/bin/bash

FILE=$1

for cmd in $(cat $FILE); do {
  filename="$(basename -- $FILE)"
  mkdir "./response/"$filename
  sh ./pinger.sh $cmd $filename
} done

