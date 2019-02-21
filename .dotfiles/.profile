# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Define a few Colours
BLACK="$(tput setaf 0)"
BLACKBG="$(tput setab 0)"
DARKGREY="$(tput bold ; tput setaf 0)"
LIGHTGREY="$(tput setaf 7)"
LIGHTGREYBG="$(tput setab 7)"
WHITE="$(tput bold ; tput setaf 7)"
RED="$(tput setaf 1)"
REDBG="$(tput setab 1)"
LIGHTRED="$(tput bold ; tput setaf 1)"
GREEN="$(tput setaf 2)"
GREENBG="$(tput setab 2)"
LIGHTGREEN="$(tput bold ; tput setaf 2)"
BROWN="$(tput setaf 3)"
BROWNBG="$(tput setab 3)"
YELLOW="$(tput bold ; tput setaf 3)"
BLUE="$(tput setaf 4)"
BLUEBG="$(tput setab 4)"
LIGHTBLUE="$(tput bold ; tput setaf 4)"
PURPLE="$(tput setaf 5)"
PURPLEBG="$(tput setab 5)"
PINK="$(tput bold ; tput setaf 5)"
CYAN="$(tput setaf 6)"
CYANBG="$(tput setab 6)"
LIGHTCYAN="$(tput bold ; tput setaf 6)"
NC="$(tput sgr0)" # No Color

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

# set PATH so it includes user's private bin directories
PATH="$HOME/.venv/bin:$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

recho() {
    echo "${RED}$1${NC}"
}

gecho() {
    echo "${GREEN}$1${NC}"
}


export -f recho
export -f gecho