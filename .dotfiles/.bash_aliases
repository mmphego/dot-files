
# function checks if the application is installed,
# then replaces it with the one given.
# Credit: https://github.com/slomkowski
__add_command_replace_alias() {
    if [ -x "$(command -v $2 2>&1)" ]; then
        alias $1=$2
    fi
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always --group-directories-first'
    #alias dir='dir --color=always'
    #alias vdir='vdir --color=always'
    #alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

### some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'
alias lsdir='ls -thord */'
alias lsf='ls -lisAhF'

### Apt
alias update='sudo apt-get -y update'
alias upgrade='sudo apt-get -y --allow-unauthenticated upgrade && sudo apt-get autoclean && sudo apt-get autoremove'
alias search='apt search'
alias search-version='apt-cache policy'

### Install and Remove Packages
alias install='sudo apt-get -y install'
alias uninstall='sudo apt-get --purge autoremove '
alias search-installed='sudo dpkg --get-selections '

# Find empty directories
alias emptyDir='find . -empty -type d -delete'

# Shortcuts directory access
#alias meng='cd ${HOME}/MEGA/MEng_Stuff'
#alias media="sshfs -o reconnect media@192.168.1.10:/mnt /home/${USER}/mnt/media_srv"

# System shortcuts
alias reboot='sudo shutdown -r now'
alias shutdown='sudo shutdown -h now'
alias paux='ps aux | grep'

# rm always ask for confirmation
alias rm='rm -i'

# cd aliases
alias cd.='cd ..'
alias cd-='cd -'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias cd..='cd ..'

# Shortcuts
alias hist='history --color=always'
alias hist-grep='history | grep --color=always'
alias youtube="$(command -v youtube-dl)"
alias youtube-mp3="$(command -v youtube-dl) -x --audio-format mp3"
alias rsync='rsync --progress'
alias less='less -N'
alias diff='colordiff -y'

__add_command_replace_alias df 'pydf'
__add_command_replace_alias display 'eog'
__add_command_replace_alias git 'hub'
__add_command_replace_alias man 'tldr'

# Add an "alert" alias for long running commands.  Use like so:
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Kill Switch
alias killfirefox="pkill -9 firefox"
alias killslack="pkill -9 slack"
alias killcode="pkill -9 code"

# Typo fixes
alias nan='nano'
alias CD='cd'
alias cdd='cd'
alias git='hub'
alias it='hub'
alias gti='hub'
alias get='hub'
alias gut='hub'
alias got='hub'
alias giot='hub'

# Git Shortcuts
alias clone='git clone --progress'

# Networking
alias ports='netstat -tulanp'

# Log into to Server
#alias camserver='ssh -X kat@10.8.67.161'
#alias cmc1='ssh -X 10.103.254.1'
#alias cmc2='ssh -X 10.103.254.3'
#alias cmc3='ssh -X 10.103.254.6'
#alias dbelab04='ssh -X dbelab04'
#alias dbelab06='ssh -X dbelab06'
