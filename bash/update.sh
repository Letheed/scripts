#!/bin/bash
#
# Author: Letheed <letheed@outlook.com>
#
# Update the system
#
#################################

# Check if we have admin priviledges
if (( $EUID != 0 )); then
	echo "To be able to update this computer, you must run this script as root."
	exit 0
fi

function askFor() {
	local question=$1 defaultStatusString="(Y/n)" answer="invalid"
	local -i defaultStatus=1

	# Loop asking for correct answer
	while [[ true ]]; do
		case $answer in
			"") echo -ne "\033[1A\r\033[0K"; return $defaultStatus ;;
			y|Y) echo -ne "\r\033[0K"; return 1 ;;
			n|N) echo -ne "\r\033[0K"; return 0 ;;
			*) echo -ne "\r\033[0K$question ${defaultStatusString}?"; read -n 1 answer ;;
		esac
	done
}

askFor "Update and upgrade the system"
if (( $? )); then
	apt-get update
	apt-get dist-upgrade
fi

askFor "Update RKHunter file properties database"
if (( $? )); then
	rkhunter --propupd
fi

exit 0
