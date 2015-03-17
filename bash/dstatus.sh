#!/bin/bash
#
# Author: Letheed <code@daweb.se>
#
# Gather status information on a list of services and display it nicely.
#
########################################################################


# List of services to test
dList="ntp smbd nmbd transmission-daemon chtorrent plexmediaserver btsync nginx php5-fpm memcached mysql fail2ban saslauthd postfix dovecot ttrssd sagemath syncthing discosrv"

# Check if we have admin priviledges
if (( $EUID != 0 )); then
	echo "This script is intended to be run as root."
	echo "Some daemons will not provide relevant information otherwise."
	exit 0
fi

function askForPrint() {
	local defaultExitTo=$1 sorp=$2 object=$3 status defaultStatusString answer="invalid"
	local -i defaultStatus

	# Define default exit status
	if [[ $defaultExitTo == "y" ]]; then
		defaultStatus=1
		defaultStatusString="(Y/n)"
	elif [[ $defaultExitTo == "n" ]]; then
		defaultStatus=0
		defaultStatusString="(y/N)"
	else
		echo "error: defaultExitTo value not valid"
		exit 0
	fi

	# Make status singular or plural
	if [[ $sorp == "s" ]]; then
		status="status"
	elif [[ $sorp == "p" ]]; then
		status="statuses"
	else
		echo "error: sorp value not valid"
		exit 0
	fi

	# Loop asking for correct answer
	while [[ true ]]; do
		case $answer in
			"") echo -ne "\033[1A\r\033[0K"; return $defaultStatus ;;
			y|Y) echo -ne "\r\033[0K"; return 1 ;;
			n|N) echo -ne "\r\033[0K"; return 0 ;;
			*) echo -ne "\r\033[0KPrint $object $status ${defaultStatusString}? "; read -n 1 answer ;;
		esac
	done
}

function printResults() {
	local action=$1 printDefault=$2 normal bold color
	local -i dCounted=$3 count exitStatus=0
	eval "local -a dRef="${4#*=}

	# Prepare text formating
	normal=$(tput sgr0)
	if [[ $action == "running" ]]; then
		bold=$(tput bold; tput setaf 2)
		color=$(tput setaf 2)
	elif [[ $action == "stopped" ]]; then
		bold=$(tput bold; tput setaf 1)
		color=$(tput setaf 1)
	elif [[ $action == "missing" ]]; then
		bold=$(tput bold; tput setaf 4)
                color=$(tput setaf 4)
	else
		bold=$(tput bold; tput setaf 3)
		color=$(tput setaf 3)
	fi

	# Test quantity of services and print statuses if asked to do so
	if (( dCounted == 0 )); then
		return 0
	elif (( dCounted == 1 )); then
		# Only one service is concerned
		echo -e "\n${bold}${dName[${dRef[1]}]} is $action${normal}"
		askForPrint $printDefault "s" "${dName[${dRef[1]}]}'s"
		if (( $? )); then
			echo "${color}${dName[${dRef[1]}]}:${normal} ${dStatus[${dRef[1]}]}"
		fi
	else
		# Several are concerned
		echo -e "\n${bold}$dCounted services are $action${normal}"
		askForPrint $printDefault "p" "their"
		if (( $? )); then
			for count in $(seq $dCounted); do
				echo "${color}${dName[${dRef[$count]}]}:${normal} ${dStatus[${dRef[$count]}]}"
			done
		fi
	fi
	
	return 0
}

function dstatus() {
	local daemon
	local -a dName dStatus dStatusError dRunning dStopped dUnknown dNotInstalled
	local -i dCount=0 dCountRunning=0 dCountStopped=0 dCountNotInstalled=0 dCountUnknown=0

	# Perform tests
	for daemon in $@; do
		# Get status
		dCount+=1
		dName[$dCount]=$daemon
		dStatus[$dCount]="$(service $daemon status 2>&1)"
		
		# See if we can recognize statuses and sort them
		if [[ ${dStatus[$dCount]} == *"start/running"* || ${dStatus[$dCount]} == *"started"* || ${dStatus[$dCount]} == *"is running"* || ${dStatus[$dCount]} == *"enabled"* || ${dStatus[$dCount]} == *"Uptime"* || ${dStatus[$dCount]} == *"uptime"* ]]; then
			dCountRunning+=1
			dRunning[$dCountRunning]=$dCount
		elif [[ ${dStatus[$dCount]} == *"stopped"* || ${dStatus[$dCount]} == *"stop/waiting"* || ${dStatus[$dCount]} == *"not running"* || ${dStatus[$dCount]} == *"disabled"* || ${dStatus[$dCount]} == *"fail"* ]]; then
			dCountStopped+=1
			dStopped[$dCountStopped]=$dCount
		elif [[ ${dStatus[$dCount]} == "$daemon: unrecognized service" ]]; then
			dCountNotInstalled+=1
			dNotInstalled[$dCountNotInstalled]=$dCount
		else
			dCountUnknown+=1
			dUnknown[$dCountUnknown]=$dCount
		fi
	done
	
	# Print small summary
	echo "$dCount services tested"
	
	# Interprete results
	if (( dCount && dCountRunning == dCount )); then
		# All is good
		if (( dCount == 1 )); then
			echo "$daemon is up and running !"
		elif (( dCount == 2 )); then
			echo "Both services are up and running !"
		else
			echo "All $dCount services are up and running !"
		fi
		return 0
	else
		# Print details
		if (( dCountRunning )); then printResults "running" "n" $dCountRunning "$(declare -p dRunning)"; fi;
		if (( dCountStopped )); then printResults "stopped" "y" $dCountStopped "$(declare -p dStopped)"; fi;
		if (( dCountUnknown )); then printResults "in an unknown state" "y" $dCountUnknown "$(declare -p dUnknown)"; fi;
		if (( dCountNotInstalled )); then printResults "missing" "y" $dCountNotInstalled "$(declare -p dNotInstalled)"; fi;
	fi
	
	return 0
}

dstatus $dList $@

exit 0
