#!/bin/bash

declare -A COMMANDS=( 
	["!attack"]="Pew! Pew!" 
	["!loadavg"]=$(uptime | sed -e 's/^.*load/load/g')
)