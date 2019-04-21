#!/bin/sh

mkdir output

for f in midifiles/kp/*.xml

do
  mscore -o "output/$(basename "$f" .xml).mid" "$f"
done
