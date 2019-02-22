# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

BLACK=; BLACKBG=; DARKGREY=; LIGHTGREY=; LIGHTGREYBG=; WHITE=; RED=; REDBG=;
LIGHTRED=; GREEN=; GREENBG=; LIGHTGREEN=; BROWN=; BROWNBG=; YELLOW=; BLUE=;
BLUEBG=; LIGHTBLUE=; PURPLE=; PURPLEBG=; PINK=; CYAN=; CYANBG=; LIGHTCYAN=;
NC=;
case ${TERM} in
    '') ;;
  *)
    # Define a few Colours
    BLACK="$(tput -T xterm setaf 0)"
    BLACKBG="$(tput -T xterm setab 0)"
    DARKGREY="$(tput -T xterm bold ; tput -T xterm setaf 0)"
    LIGHTGREY="$(tput -T xterm setaf 7)"
    LIGHTGREYBG="$(tput -T xterm setab 7)"
    WHITE="$(tput -T xterm bold ; tput -T xterm setaf 7)"
    RED="$(tput -T xterm setaf 1)"
    REDBG="$(tput -T xterm setab 1)"
    LIGHTRED="$(tput -T xterm bold ; tput -T xterm setaf 1)"
    GREEN="$(tput -T xterm setaf 2)"
    GREENBG="$(tput -T xterm setab 2)"
    LIGHTGREEN="$(tput -T xterm bold ; tput -T xterm setaf 2)"
    BROWN="$(tput -T xterm setaf 3)"
    BROWNBG="$(tput -T xterm setab 3)"
    YELLOW="$(tput -T xterm bold ; tput -T xterm setaf 3)"
    BLUE="$(tput -T xterm setaf 4)"
    BLUEBG="$(tput -T xterm setab 4)"
    LIGHTBLUE="$(tput -T xterm bold ; tput -T xterm setaf 4)"
    PURPLE="$(tput -T xterm setaf 5)"
    PURPLEBG="$(tput -T xterm setab 5)"
    PINK="$(tput -T xterm bold ; tput -T xterm setaf 5)"
    CYAN="$(tput -T xterm setaf 6)"
    CYANBG="$(tput -T xterm setab 6)"
    LIGHTCYAN="$(tput -T xterm bold ; tput -T xterm setaf 6)"
    NC="$(tput -T xterm sgr0)" # No Color
esac

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