#!/bin/bash

read -e -p "Filename: " file
filter=$(pwd | sed 's/^.*data//' | sed 's#/##g' | sed "s/$/$file/")
mkdir -p _$file

echo "[*] Sorting $filter[symbol]"
grep -ai "^$filter\w*\b" $file |  grep -avi "^$filter[a-zA-Z0-9]" | sed 's/\r//g' > ./_$file/symbols
for letter in {0..9} {a..z};
do
	echo "[*] Sorting $filter$letter"
	grep -ai "^$filter$letter\w*\b" $file | sed 's/\r//g' > ./_$file/$letter
done

rm $file
mv _$file $file
