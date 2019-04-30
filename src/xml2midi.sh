##!/bin/bash

# only split lines at new lines #
IFS=$'
'

# set display variable (for WSL) #
export DISPLAY=:0

# i/o #
input="$1"
output="$2"

# parsing files #
for file in $(find "$input" -type f -name "*.xml" -o -name "*.mxl" -o -name "*.musicxml");

do

    # remove first directory of file path #
    fpath="${file#"$input"}"

    # decompose path #
    fname=$(basename "$fpath" .xml)
    dname=$(dirname  "$fpath")

    # check if file already exists in output directory #
    if [ -f "$2/$dname/$fname.mid" ]; then

        # display message #
        echo "already processed: $fname"

    else
        echo "processing: $fname"

        # create needed directories #
        mkdir -p "$2/$dname"

        # process file #
        mscore -o "$2/$dname/$fname.mid" "$input/$dname/$fname.xml"

    fi

    # check if output file is empty # remove file
    [ -s "$2/$dname/$fname.mid" ] || rm -f "$2/$dname/$fname.mid"

done
