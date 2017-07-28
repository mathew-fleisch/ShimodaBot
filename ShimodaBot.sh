#!/bin/bash

# Dependencies
command -v inotifywait >/dev/null 2>&1 || { echo "This script requires inotify-tools, but it is not installed.  Aborting." >&2; exit 1; }

# Globals
DESTINATION=""

# Includes
source ./lib/phrases.sh
source ./lib/commands.sh

# Get target destination path
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -d|--destination)
	DESTINATION="$2"
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
# Remove trailing slash from target destination path
DESTINATION=$(echo ${DESTINATION} | sed -e 's/\/$//g')

# Main loop
if [[ -d ${DESTINATION} ]]; then
	# echo $DESTINATION; # DEBUG
	while inotifywait -e modify ${DESTINATION}/out; do
		NEWMSG=$(tail -n1 ${DESTINATION}/out | sed -e 's/.*>\ //g')
		echo "NEWMSG: ${NEWMSG}" # DEBUG
		for user_message in "${!PHRASES[@]}"; do 
			# echo "$user_message - ${PHRASES[$user_message]}"
			if echo "${NEWMSG}" | grep "^${user_message}"; then
				echo "${PHRASES[$user_message]}" > ${DESTINATION}/in
				break 1
			fi
		done

		if echo "${NEWMSG}" | grep "^!"; then
			# echo "COMMAND: ${NEWMSG}" # DEBUG
			for user_message in "${!COMMANDS[@]}"; do 
				# echo "$user_message - ${COMMANDS[$user_message]}"
				if echo "${NEWMSG}" | grep "^${user_message}"; then
					# echo "${COMMANDS[$user_message]}" > ${DESTINATION}/in
					case "${COMMANDS[$user_message]}" in 
						attack)
						echo "Pew! Pew!" > ${DESTINATION}/in
						shift
						;; 
						loadavg)
						echo $(uptime | sed -e 's/^.*load/load/g') > ${DESTINATION}/in
						shift
						;;
						8ball)
						echo $(shuf -n 1 ./lib/8ball.txt) > ${DESTINATION}/in
						shift
						;;
						default)
						;;
						*)
						;;
					esac
					shift
					break 1
				fi
			done
		fi
	done
else
	echo "Directory not found: ${DESTINATION}"
fi

