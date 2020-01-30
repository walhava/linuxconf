#!/bin/bash

LINUXCONF="$HOME/.linuxconf"


# check if directory exists
if [ ! -d "$LINUXCONF" ]; then
	sudo apt update
	sudo apt install --yes \
		vim \
		git \
		build-essential \
		tmux \
		zsh

	sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	chsh -s $(which zsh)
	
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	git clone git://github.com/gradle/gradle-completion
	git clone https://github.com/esc/conda-zsh-completion ~/.zsh/conda-zsh-completion

	mkdir -p ~/.vim/colors
	wget https://raw.githubusercontent.com/blueshirts/darcula/master/colors/darcula.vim -O ~/.vim/colors/darcula.vim


	echo cloning github.com/walhava/linuxconf to $LINUXCONF
	git clone git@github.com:walhava/linuxconf.git  $LINUXCONF
	cd $LINUXCONF
else
	echo updating linux conf
	cd $LINUXCONF
	git pull
fi

cd $LINUXCONF

./update_linux_conf.sh

	
	
