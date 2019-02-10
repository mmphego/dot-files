# Bashrc
stty -ixon # Disable ctrl-s and ctrl-q

############################################# Fancy PS1 ############################################
__git_status_info() {
    STATUS=$(git status 2>/dev/null |
    awk '
    /^On branch / {printf($3)}
    /^Changes not staged / {printf("|?Changes unstaged!")}
    /^Changes to be committed/ {printf("|*Uncommitted changes!")}
    /^Your branch is ahead of/ {printf("|^Push changes!")}
    ')
    if [ -n "${STATUS}" ]; then
        echo -ne " (${STATUS}) [Last updated: $(git show -1 --stat | grep ^Date | cut -f4- -d' ')]"
    fi
}

__disk_space=$(df --output=pcent /home | tail -1)
_ip_add=$(ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}')
__ps1_startline="\[\033[0;32m\]\[\033[0m\033[0;38m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h on ${_ip_add}:\w\[\033[0;32m\] \[\033[0;34m\] [disk:${__disk_space}] \[\033[0;32m\]"
__ps1_endline="\[\033[0;32m\]└─\[\033[0m\033[0;31m\] [\D{%F %T}] \$\[\033[0m\033[0;32m\] >>>\[\033[0m\] "
export PS1="${__ps1_startline}\$(__git_status_info)\n${__ps1_endline}"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTSIZE= HISTFILESIZE= # Infinite history.

####################################################################################################
#################################### Alias Definitions #############################################
####################################################################################################

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# `Docker` Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.docker_aliases, instead of adding them here directly.

if [ -f ~/.docker_aliases ]; then
    source ~/.docker_aliases
fi

# functions definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.

if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi


if [[ $- == *i* ]]; then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\e[1;5C": forward-word'
    bind '"\e[1;5D": backward-word'
    bind '"\e[5C": forward-word'
    bind '"\e[5D": backward-word'
    bind '"\e\e[C": forward-word'
    bind '"\e\e[D": backward-word'
    bind 'set show-all-if-ambiguous on'
    bind 'set completion-ignore-case on'
fi

####################################################################################################
################################### SHell Options ##################################################
####################################################################################################

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Save all lines of a multiple-line command in the same history entry.
shopt -s cmdhist
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Allows me to cd into a dir by just typing the dir name
shopt -s autocd
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
# Includes file names beginning with a '.' in the results of path name globbing.
shopt -s dotglob

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f "/usr/share/bash-completion/bash_completion" ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f "/etc/bash_completion" ]; then
        source /etc/bash_completion
    fi
fi

if [ -f "/etc/bash_completion.d/git-prompt" ]; then
    source /etc/bash_completion.d/git-prompt
fi

if [ -f /var/run/reboot-required ]; then
    printf "$(tput smso)$(tput setaf 1)[*** Hello ${USER}, you must reboot your machine ***]$(tput sgr0)\n";
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.bash.inc" ]; then
    source "${HOME}/google-cloud-sdk/path.bash.inc";
fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.bash.inc" ]; then
    source "${HOME}/google-cloud-sdk/completion.bash.inc";
fi

# Enabling travis shell
if [ -f "${HOME}/.travis/travis.sh" ]; then
    source "${HOME}/.travis/travis.sh"
fi

########### Welcome Message ###########
IP_ADD=`ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}'`
printf "${LIGHTGREEN}Hello, $USER@${IP_ADD}\n"
printf "Today is, $(date)\n";
printf "Sysinfo: $(uptime)\n"
printf "\n$(fortune | cowsay)${NC}\n"


# Activate virtualenv
if [ -f "${HOME}/.venv/bin/activate" ]; then
    source "${HOME}/.venv/bin/activate";
fi
