#!/bin/bash

ls ./inputbreach |sort| sed 's/^/.\/inputbreach\//' | while read inputfile;
do
echo "[*] Checking breach $inputfile checksum..." | tee -a debug
shasum="$(sha256sum "$inputfile" | cut -d' ' -f1)"
	if [ "$(cat imported.log | grep "$shasum" | wc -l)" == "0" ]; then
		cat imported.log | grep "$shasum" | tee -a debug

		# importing to data folder
		find data | sort | while read path;
		do
			if [ -f $path ]; then
				filter=$(echo "$path" | sed 's/^.*data//' | sed 's#/##g' | sed 's/symbols$//g' )
				if [ "$(echo "$path" | grep "symbols$")" == "" ]; then
					echo "Filter: $filter	Path: $path" | tee -a debug
					grep -ai "^$filter\w*\b" $inputfile | sed 's/\r//g' | grep -a @ >> $path | tee -a debug
				else
					echo "Filter: $filter[symbol]	Path: $path" | tee -a debug
					grep -ai "^$filter\w*\b" $inputfile | grep -aiv "^$filter[a-zA-Z0-9]\w*\b" | sed 's/\r//g' | grep -a @ >> $path | tee -a debug
				fi
			fi
		done



		echo "[*] Logging sha256sum into imported.log..." | tee -a debug
		echo "$(date --rfc-3339=date): $(sha256sum "$inputfile")	$(du -h "$inputfile"|cut -d'	' -f1)" | tee -a imported.log | tee -a debug
		echo "------------------------------------------" | tee -a debug

		echo "[*] Removing breach file $inputfile..." | tee -a debug
		rm "$inputfile" | tee -a debug
	else
		echo "[*] This breach is already imported." | tee -a debug
		cat imported.log | grep "$shasum" | tee -a debug
		echo "------------------------------------" | tee -a debug
	fi
done

# data folder sorting
echo "[*] Sorting breaches..." | tee -a debug
find data | sort | while read path;
do
	if [ -f $path ]; then
		echo "[*] Sorting $path" >> debug
		sort $path -u -o $path\_
		mv $path\_ $path
	fi
done
