# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    #alias dir='dir --color=always'
    #alias vdir='vdir --color=always'
    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

### some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'
alias nan='nano'

### Apt
alias update='sudo apt -y update'
alias upgrade='sudo apt-get -y update && sudo apt-get -y --allow-unauthenticated upgrade && sudo apt-get autoclean && sudo apt-get autoremove && exit 0'
alias search='sudo apt search'
alias links='links2'

### Install and Remove Packages
alias install='sudo apt-get -y install'
alias uninstall='sudo apt-get --purge autoremove '
alias search-installed='sudo dpkg --get-selections '
alias upgrade-pips='sudo pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 sudo pip install -U'

alias lsdir='ls -thord */'
alias display='eog -w'
alias emptyDir='find . -empty -type d -delete'
alias meng='cd ${HOME}/Dropbox/MEng_Stuff/MEng-Progress'
alias media='sshfs -o reconnect media@192.168.1.10:/mnt /home/"${USER}"/mnt/media_srv'
alias reboot='sudo shutdown -r now'
alias shutdown='sudo shutdown -h now'
alias paux='ps aux | grep'
alias cd.='cd ..'
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias cd..='cd ..'

# Typo cd alias
alias CD='cd'

alias diff='colordiff -y'
alias hist-grep='history | grep --color=always'
alias man='tldr'
alias youtube='youtube-dl'
alias youtube-mp3='youtube-dl -x --audio-format mp3'
alias pdf='evince'

# Add an "alert" alias for long running commands.  Use like so:
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

### Kill Switch
alias killfirefox="pkill -9 firefox"
alias killslack="pkill -9 slack"

### Git aliases
alias git=hub
alias it=hub
alias get=hub
alias gut=hub
alias got=hub
alias clone='git clone --progress'

# Log into to Server
alias camserver='ssh -X kat@10.8.67.161'
alias cmc1='ssh -X 10.103.254.1'
alias cmc2='ssh -X 10.103.254.3'
alias cmc3='ssh -X 10.103.254.6'
alias dbelab04='ssh -X dbelab04'
alias dbelab06='ssh -X dbelab06'

# Networking
alias ports='netstat -tulanp'
