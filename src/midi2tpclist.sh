#!/bin/sh

input="$1" # get source path from user
output="$2" # get target path from user

mkdir "$2"

for f in $(find $input -name "*.mid")

do

if [ -f "$2/$(basename "$f" ".mid").csv" ]
then
  echo "$2/$(basename "$f" ".mid").csv already processed"
else
  echo $f
  echo "==========================="
  ./melisma2003/mftext/mftext "$f" | ./melisma2003/meter/meter | ./melisma2003/harmony/harmony |  grep TPCNote > "$output/$(basename "$f" .mid).csv"
fi
done
# remove empty files (in case something went wrong)
if [ -s "output/$f.csv" ]
then
  rm -f "output$f.csv"
fi
