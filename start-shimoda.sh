#!/bin/bash

# Dependencies
command -v ii >/dev/null 2>&1 || { echo "This script requires ii, but it is not installed.  Aborting." >&2; exit 1; }
command -v pidof >/dev/null 2>&1 || { echo "This script requires pidof, but it is not installed.  Aborting." >&2; exit 1; }

# Globals
BOTPATH=""
TARGETPATH=""
NETWORK="chat.freenode.net"
CHANNEL="#GreatestGen"
BOTNAME="ShimodaBot"
# Get target path path
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -b|--bot-path)
	BOTPATH="$2"
	shift
	;;
    --bot-name)
	BOTNAME="$2"
	shift
	;;
    -c|--channel)
	CHANNEL="$2"
	shift
	;;
    -p|--path)
	TARGETPATH="$2"
	shift
	;;
    -n|--network)
	NETWORK="$2"
	shift
	;;
    --default)
    DEFAULT=YES
    ;;
    *)
    # unknown option
    ;;
esac
shift # past argument or value
done
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi
# Remove trailing slash from target path path
TARGETPATH=$(echo ${TARGETPATH} | sed -e 's/\/$//g')

# Main loop
if [[ -d ${TARGETPATH} ]]; then
	echo "Starting: ${TARGETPATH}"
	ii -s ${NETWORK} -n ${BOTNAME} &
	IIPID=$(pidof ii)
	echo "Connected to irc: ${IIPID}"
	if [[ -d ${TARGETPATH}/${NETWORK} ]]; then
		# Log into channel
		echo "/j ${CHANNEL}" > ${TARGETPATH}/${NETWORK}/in
		sleep 2
		tail -n9 ${TARGETPATH}/${NETWORK}/out
		# echo "${TARGETPATH}/${NETWORK}/${CHANNEL,,}/in" # DEBUG
		echo "${BOTNAME} reporting for duty!" > ${TARGETPATH}/${NETWORK}/${CHANNEL,,}/in
		echo "Run ${BOTNAME}"

		if [ -e "$BOTPATH" ]; then
			echo "Bot: ${BOTPATH}"
			echo "${BOTPATH} -d ${TARGETPATH}/${NETWORK}/${CHANNEL,,}"
		else 
			echo "Must specify bot location... Guessing:"
			echo "./ShimodaBot.sh -d ${TARGETPATH}/${NETWORK}/${CHANNEL,,}"
		fi
	fi

else 
	echo "Must specify ii path..."
fi

