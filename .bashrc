# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=9999999999999000000
HISTFILESIZE=900000000999999999
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1="\u@\h:\w\\$ \[$(tput sgr0)\]"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'
# Network Start, Stop, and Restart
alias light='xbacklight -set'
# Update and Upgrade Packages
alias update='sudo apt -y update'
alias upgrade='sudo apt -y update && sudo apt autoremove && sudo apt -y --allow-unauthenticated upgrade && sudo apt -y --allow-unauthenticated dist-upgrade && exit 0'
alias search='sudo apt search'
alias links='links2'
# Install and Remove Packages
alias install='sudo apt-get -y install'
alias uninstall='sudo apt-get --purge autoremove '
alias search-installed='sudo dpkg --get-selections '
alias upgrade-pips='sudo pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 sudo pip install -U
'
#alias cleanPC='sudo apt-get -y autoclean && sudo apt-get -y clean && sudo apt-get -y autoremove'

alias dbelab04='ssh -X dbelab04'
alias dbelab06='ssh -X dbelab06'
alias cmc3='ssh -X 10.103.254.6'
alias cmc2='ssh -X 10.103.254.3'
alias camserver='ssh -X kat@10.8.67.161'
alias cmc1='ssh -X 10.103.254.1'
alias lsdir='ls -ld */'
alias display='eog -w'
alias emptyDir='find . -empty -type d -delete'
alias connectSSHFS='if timeout 2 ping -c 1 -W 2 192.168.4.23 &> /dev/null; then timeout 2 sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 192.168.4.23:/ /home/mmphego/mnt/dbelab04 &>/dev/null ; else fusermount -u -z ~/mnt/dbelab04 ; fi'
alias dbelab06mount='if timeout 2 ping -c 1 -W 2 192.168.4.14 &> /dev/null; then timeout 2 sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 192.168.4.14:/ /home/mmphego/mnt/dbelab06 &>/dev/null ; else fusermount -u -z ~/mnt/dbelab06 ; fi'
alias cmc2mount='if timeout 2 ping -c 1 -W 2 10.103.254.3 &> /dev/null; then timeout 2 sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 mmphego@10.103.254.3:/ /home/mmphego/mnt/cmc2 &>/dev/null ; else fusermount -u -z ~/mnt/cmc2 ; fi'
alias cmc3mount='if timeout 2 ping -c 1 -W 2 10.103.254.6 &> /dev/null; then timeout 2 sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 mmphego@10.103.254.6:/ /home/mmphego/mnt/cmc3 &>/dev/null ; else fusermount -u -z ~/mnt/cmc3 ; fi'
alias meng='cd /home/mmphego/Dropbox/MEng_Stuff/MEng-Progress'
alias media='sshfs -o reconnect media@192.168.1.10:/mnt /home/mmphego/mnt/media_srv'
alias reboot='sudo shutdown -r now'
alias shutdown='sudo shutdown -h now'
#alias rm='rm -r'
#alias rm=trash
alias paux='ps aux | grep'
alias cd.='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias cd..='cd ..'
alias disconnect='fusermount -u -z ~/mnt/dbelab06; fusermount -zu ~/mnt/dbelab04;fusermount -zu ~/mnt/cmc2;fusermount -zu ~/mnt/cmc1;fusermount -zu ~/mnt/pi;fusermount -zu ~/mnt/media_srv;fusermount -zu ~/mnt/cmc3'
alias youtube="youtube-dl"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi


# log every command typed and when
#if [ -n "${BASH_VERSION}" ]; then
#    trap "caller >/dev/null || \
#printf '%s\\n' \"\$(date '+%Y-%m-%dT%H:%M:%S%z')\
#  \${BASH_COMMAND}\" 2>/dev/null >>~/.command_log" DEBUG
#fi
export PATH=$PATH:$HOME/bin
#export PS1='\[\033[0;32m\]\[\033[0m\033[0;38m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h:\w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;31m\] [\D{%F %T}] \$\[\033[0m\033[0;32m\] >>>\[\033[0m\] '

#source $HOME/.opt/Xilinx/Vivado/2017.2/settings64.sh
#source $HOME/.opt/Vivado/2018.1/settings64.sh

#export YOCTODIR=$HOME/Documents/Xilinx/EmbeddedLinux/Yocto/poky
#export PETADIR=$HOME/Documents/Xilinx/EmbeddedLinux/Petalinux
function cd {
    # The 'builtin' keyword allows you to redefine a Bash builtin without
    # creating a recursion. Quoting the parameter makes it work in case there are spaces in
    # directory names.
    builtin cd "$@"
    if [ "$PWD" == "$YOCTODIR" ] ;
        then
            bash $YOCTODIR/.source_yocto
    elif [ "$PWD" == "$PETADIR" ] ;
        then
            bash $PETADIR/.source_petalinux
    else
        ls -thor ;
    fi
}


hash -r

export PATH=/home/mmphego/bin:/home/mmphego/.opt/SDK/2018.1/bin:/home/mmphego/.opt/SDK/2018.1/gnu/microblaze/lin/bin:/home/mmphego/.opt/SDK/2018.1/gnu/arm/lin/bin:/home/mmphego/.opt/SDK/2018.1/gnu/microblaze/linux_toolchain/lin64_le/bin:/home/mmphego/.opt/SDK/2018.1/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/home/mmphego/.opt/SDK/2018.1/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/home/mmphego/.opt/SDK/2018.1/gnu/aarch64/lin/aarch64-linux/bin:/home/mmphego/.opt/SDK/2018.1/gnu/aarch64/lin/aarch64-none/bin:/home/mmphego/.opt/SDK/2018.1/gnu/armr5/lin/gcc-arm-none-eabi/bin:/home/mmphego/.opt/SDK/2018.1/tps/lnx64/cmake-3.3.2/bin:/home/mmphego/.opt/Vivado/2018.1/bin:/home/mmphego/.opt/DocNav:/home/mmphego/bin:/home/mmphego/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/home/mmphego/bin:/home/mmphego/.platformio/penv/bin:~/.platformio/penv/bin

source /etc/bash_completion.d/git-prompt

git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }

git_last_update () {
    git log 2> /dev/null | head -n 3 | grep ^Date | cut -f4- -d' ';
    }

export PS1="\[\033[0;32m\]\[\033[0m\033[0;38m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h:\w\[\033[0;32m\] \$(git_branch) \$(git_last_update)\n\[\033[0;32m\]└─\[\033[0m\033[0;31m\] [\D{%F %T}] \$\[\033[0m\033[0;32m\] >>>\[\033[0m\] "

alias CD='cd'

function pip() {
  if [[ "$1" == "install" ]]; then
    shift 1
    command pip install --no-cache-dir -U "$@"
  else
    command pip "$@"
  fi
}

#function sudo() {
#  if [[ "$1" == "su" ]]; then
#     shift 1
#     printf "$(tput smso)$(tput setaf 1) [*** With great power comes great responsibility ***] $(tput sgr0)\n\n\n"
#     command sudo bash -l
#  else
#     command sudo "$@"
#  fi
#}

function ssh() {
    command ssh -X "$@"
}

function rsync(){
    command rsync --progress "$@"
}

if [ -f /var/run/reboot-required ] ;
    then
        printf "$(tput smso)$(tput setaf 1)[*** Hello $USER, you must reboot your machine ***]$(tput sgr0)\n";
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


# pip command completion
eval "`pip completion --bash`"
alias killfirefox="pkill -9 firefox"
alias killslack="pkill -9 slack"
