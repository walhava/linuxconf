#!/bin/bash

LINUXCONF="$HOME/.linuxconf"


# check if directory exists
if [ ! -d "$LINUXCONF" ]; then
	echo cloning github.com/walhava/linuxconf to $LINUXCONF
	git clone git@github.com:walhava/linuxconf.git  $LINUXCONF
	cd $LINUXCONF
else
	echo updating linux conf
	cd $LINUXCONF
	git pull
fi


	
	
	
