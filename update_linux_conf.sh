#!/bin/bash

LINUXCONF="$HOME/.linuxconf"

if  [ "$LINUXCONF/confs/.profile" ]; then
	cd $LINUXCONF/confs
	for i in .??*; do
		rm $HOME/$i
		ln -s $LINUXCONF/confs/$i $HOME/$i
	done
fi

