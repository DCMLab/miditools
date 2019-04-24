#!/bin/sh

input="$1" # get source path from user
output="$2" # get target path from user

echo "$1"
echo "$2"

mkdir "$2"

for f in $input/*.mid #./melisma2003/midifiles/kp/*.mid
do
  ./melisma2003/mftext/mftext "$f" | ./melisma2003/meter/meter | ./melisma2003/harmony/harmony | grep TPCNote > "$output/$(basename "$f" .mid).csv"
done

if [ -s "output/$f.csv" ]
then
  rm -f "output$f.csc"
fi
