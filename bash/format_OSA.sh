#!/bin/bash
#
# Author: Letheed <letheed@outlook.com>
#
# Script to extract data points from optical spectrum analysers data files.
# Models: ANDO AQ-6315A and YOKOGAWA smthg
#
###########################################################################

count1=0
count2=0

if [[ -z $(ls ./*.TXT 2> /dev/null) ]]; then
	message1="no .TXT file was found in this directory"
else
	files="./*.TXT"

	mkdir -p Data

	for i in $files; do
		j=$(echo "$i" | sed 's/\.TXT//')
		sed -e '1,3d;$d;/^\"/d;s/^ //g;s/, */\t/g' "$i" > "Data/$j"
		count1=$(($count1+1))
	done


	if [[ 1 == $count1 ]]; then
		message1=" .TXT file was processed"
	else
		message1=" .TXT files were processed"
	fi
fi

if [[ -z $(ls ./*.CSV 2> /dev/null) ]]; then
	message2="no .CSV file was found in this directory"
else
	files="./*.CSV"

	mkdir -p Data
	for i in $files; do
		j=$(echo "$i" | sed 's/\.CSV//')
		sed -e '1,29d;s/, */\t/g' "$i" > "Data/$j"
		count2=$(($count2+1))
	done

	if [[ 1 == $count2 ]]; then
		message2=" .CSV file was processed"
	else
		message2=" .CSV files were processed"
	fi
fi

if [[ 0 == $count1 && 0 == $count2 ]]; then
	zenity --info --title="OSA data extraction" --text="$message1\n$message2"
elif [[ 0 == $count1 ]]; then
	zenity --info --title="OSA data extraction" --text="$message1\n$count2$message2"
elif [[ 0 == $count2 ]]; then
	zenity --info --title="OSA data extraction" --text="$count1$message1\n$message2"
else
	zenity --info --title="OSA data extraction" --text="$count1$message1\n$count2$message2"
fi

exit 0
