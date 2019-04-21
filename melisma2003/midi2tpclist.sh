#!/bin/sh

input="$1" # get source path from user
output="$2" # get target path from user

mkdir output
for f in midifiles/kp/*.mid
do
  mftext/mftext "$f" | meter/meter | harmony/harmony | grep TPCNote > "output/$(basename "$f" .mid).csv"
done

if [ -s "output/$f.csv" ]
then
  rm -f "output$f.csc"
fi
