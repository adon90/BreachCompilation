#!/bin/bash
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ "$1" != "" ]; then
	letter1=$(echo ${1,,}|cut -b1)
	if [[ $letter1 == [a-zA-Z0-9] ]]; then
		if [ -f "$dir/data/$letter1" ]; then
			grep -ai "^$1" "$dir/data/$letter1"
		else
			letter2=$(echo ${1,,}|cut -b2)
			if [[ $letter2 == [a-zA-Z0-9] ]]; then
				if [ -f "$dir/data/$letter1/$letter2" ]; then
					grep -ai "^$1" "$dir/data/$letter1/$letter2"
				else
					letter3=$(echo ${1,,}|cut -b3)
					if [[ $letter3 == [a-zA-Z0-9] ]]; then
						if [ -f "$dir/data/$letter1/$letter2/$letter3" ]; then
							grep -ai "^$1" "$dir/data/$letter1/$letter2/$letter3"
						fi
					else
						if [ -f "$dir/data/$letter1/$letter2/symbols" ]; then
							grep -ai "^$1" "$dir/data/$letter1/$letter2/symbols"
						fi
					fi
				fi
			else
				if [ -f "$dir/data/$letter1/symbols" ]; then
					grep -ai "^$1" "$dir/data/$letter1/symbols"
				fi
			fi
		fi
	else
		if [ -f "$dir/data/symbols" ]; then
			grep -ai "^$1" "$dir/data/symbols"
		fi
	fi
else
	echo "[*] Example: ./query name@domain.com"
fi
