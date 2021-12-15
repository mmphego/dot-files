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
    BLUE="$(tput -T xterm setaf 4)"
    BLUEBG="$(tput -T xterm setab 4)"
    BROWN="$(tput -T xterm setaf 3)"
    BROWNBG="$(tput -T xterm setab 3)"
    CYAN="$(tput -T xterm setaf 6)"
    CYANBG="$(tput -T xterm setab 6)"
    DARKGREY="$(tput -T xterm bold ; tput -T xterm setaf 0)"
    GREEN="$(tput -T xterm setaf 2)"
    GREENBG="$(tput -T xterm setab 2)"
    LIGHTBLUE="$(tput -T xterm bold ; tput -T xterm setaf 4)"
    LIGHTCYAN="$(tput -T xterm bold ; tput -T xterm setaf 6)"
    LIGHTGREEN="$(tput -T xterm bold ; tput -T xterm setaf 2)"
    LIGHTGREY="$(tput -T xterm setaf 7)"
    LIGHTGREYBG="$(tput -T xterm setab 7)"
    LIGHTRED="$(tput -T xterm bold ; tput -T xterm setaf 1)"
    PINK="$(tput -T xterm bold ; tput -T xterm setaf 5)"
    PURPLE="$(tput -T xterm setaf 5)"
    PURPLEBG="$(tput -T xterm setab 5)"
    RED="$(tput -T xterm setaf 1)"
    REDBG="$(tput -T xterm setab 1)"
    WHITE="$(tput -T xterm bold ; tput -T xterm setaf 7)"
    YELLOW="$(tput -T xterm bold ; tput -T xterm setaf 3)"
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
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.poetry/bin" ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi

if [ -d "$HOME/go" ]; then
    export PATH="$HOME/go/bin:$PATH"
    export GOPATH="$HOME/go"
fi

if [ -d "${HOME}/.venvs" ]; then
    export WORKON_HOME="${HOME}/.venvs"
    export VIRTUALENVWRAPPER_PYTHON="$(command -v python2)"
    export VIRTUALENVWRAPPER_VIRTUALENV="$(command -v virtualenv)"
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS="--no-site-packages"
    # shellcheck source=/dev/null
    source "$(command -v virtualenvwrapper.sh)"
fi

if [ -d "/var/lib/flatpak/exports/share" ]; then
    export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

recho() {
    echo "${RED}$1${NC}"
}

gecho() {
    echo "${GREEN}$1${NC}"
}

export -f recho
export -f gecho

# pip bash completion start
_pip_completion() {
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# Ensure that night light is enabled always.
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# show line numbers and colors in the “less” command line
export LESS="-NR";

chmod go-r ~/.kube/config
