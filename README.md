# ShimodaBot

ShimodaBot is an irc bot that was written by a couple of guys who are little embarrased to have an irc bot about the "Greatest Generation" podcast; a podcast by a couple of guys who are embarrased to have a Star Trek podcast. 

## Dependencies
 - ii
 - pidof
 - inotify-tools (inotifywait)

## Usage
	./start-shimoda.sh -p ~/irc -b ./ShimodaBot.sh

## Parameters
	-b --bot-path
		Location of ShimodaBot.sh
	--bot-name
		DEFAULT: ShimodaBot
	-c --channel
		DEFAULT: chat.freenode.net
	-p --path
		Location of where ii saves files. Default is ~/irc
	-n --network
		DEFAULT: #GreatestGen