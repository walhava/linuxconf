# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH=$HOME/.local/bin:$PATH 
export ANDROID_HOME=$HOME/Android/Sdk                                                                                                                                                
export PATH=${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:$PATH
export PATH=$HOME/flutter_sdk/flutter/bin:$PATH
#export PATH=/snap/android-studio/current/android-studio/jre/bin:$PATH
#export LD_LIBRARY_PATH=/snap/android-studio/current/android-studio/jre/lib:$LD_LIBRARY_PATH
#. "$HOME/.cargo/env"
