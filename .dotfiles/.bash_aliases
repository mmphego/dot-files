
# function checks if the application is installed,
# then replaces it with the one given.
# Credit: https://github.com/slomkowski
__add_command_replace_alias() {
    if [ -x "$(command -v $2 2>&1)" ]; then
        alias "$1"="$2"
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

__add_command_replace_alias df 'pydf'
__add_command_replace_alias display 'eog'
__add_command_replace_alias git 'hub'
__add_command_replace_alias man 'tldr'
#__add_command_replace_alias ls 'exa'

### some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'
alias lsdir='ls -thord */'
alias lss='ls -thor'

### Apt
alias update='sudo apt update --fix-missing'
alias upgrade='sudo apt-get upgrade -y --allow-unauthenticated && sudo apt-get -y dist-upgrade && sudo apt autoclean && sudo apt autoremove'
alias search-pkg='apt search'
alias search-version='apt-cache policy'

### Install and Remove Packages
alias uninstall='sudo apt-get --purge autoremove '
alias installed='sudo dpkg -l '
alias show-installed="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
# Find empty directories
alias emptyDir='find . -empty -type d -delete'

# Shortcuts directory access
alias meng='cd ${HOME}/MEGA/MEng_Stuff/MEng-Progress/Main_Latex'

# System shortcuts
alias reboot='sudo shutdown -r now'
alias shutdown='sudo shutdown -h now'
alias paux='ps aux | grep'

# rm always ask for confirmation
alias rm='rm -i'

# cd aliases
alias cd.='cd ..'
alias cd-='cd -'
alias cd..='cd ..'

# Shortcuts
alias cwd="basename \"$(pwd)\""
alias diff='colordiff -y'
alias gitprojects='cd -- /home/mmphego/GitHub'
alias hist-grep='history | grep --color=always'
alias hist='history --color=always'
alias less='less -N'
alias rsync='rsync --progress'
alias y="$(command -v youtube-dl)"
alias youtube-mp3="$(command -v youtube-dl) -x --audio-format mp3"
alias youtube="$(command -v youtube-dl)"

# Add an "alert" alias for long running commands.  Use like so:
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Kill Switch
alias killfirefox="pkill -9 firefox"
alias killslack="pkill -9 slack"
alias killcode="pkill -9 code"

# Typo fixes
alias CD='cd'
alias cdd='cd'
alias get="$(which hub)"
alias giot="$(which hub)"
alias git="$(which hub)"
alias github="$(which hub)"
alias got="$(which hub)"
alias gt="$(which hub)"
alias gti="$(which hub)"
alias gut="$(which hub)"
alias it="$(which hub)"
alias nan='nano'


alias git-ignore-file="git update-index --assume-unchanged"

# Git Shortcuts
alias clone='git clone --progress --depth=1'
alias checkout='git checkout -- .'
alias push='git push --no-verify -q &>/dev/null &disown'
alias pull='git pull --allow-unrelated-histories --all &>/dev/null &disown'

# Networking
alias ports='netstat -tulanp'

# Log into to Server
alias camserver='autossh -A kat@10.8.67.160'
alias log-me-out='skill -KILL -u ${USER}'
alias pipinstall='pip install '

# Misc
alias aliases="subl ~/.dotfiles"
alias mic-toggle='amixer set Capture toggle'
alias openvino='source /opt/intel/openvino/bin/setupvars.sh --pyenv py3.6'
alias soundon="pacmd set-card-profile bluez_card.B0_18_6F_0A_1F_AA a2dp_sink"
alias please="sudo"
alias mdkir="mkdir -p"
alias get_makefile="curl -fsSL https://git.io/get-makefile > ./Makefile"
alias venv="source .venv/bin/activate"
alias kube="kubectl"
