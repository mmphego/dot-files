# Useful Functions

# Create a new directory and enter it
function mk() {
    mkdir -p "$@" && echo "You are in: $@" && cd "$@" || exit 1
}

function committer() {
    # Add file, commit and push
    git add -f "$1";
    if [ "$2" == "" ]; then
        git commit -nm"Updated $1";
    else
        git commit -nm"$2";
    fi;
    bash -c "git push --no-verify -q &"
    }

function create-pr() {
    git push -u origin "$(git rev-parse --abbrev-ref HEAD)" || true;
    if [ -f /usr/local/bin/hub ]; then
        /usr/local/bin/hub pull-request -b master -h $(git rev-parse --abbrev-ref HEAD) --no-edit || true
    else
        >&2 echo "Failed to create PR, create it Manually"
        exit 1
    fi
}

function clone() {
    git clone --progress "$@"
}

function ssh() {
    # Always ssh with -X
    command ssh -X "$@"
}

function rsync(){
    command rsync --progress "$@"
}

function wrapper(){
    # Desktop notification when long running commands complete
    start=$(date +%s)
    "$@"
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Long\
running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

function extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1    ;;
             *.tar.gz)    tar xzf $1    ;;
             *.bz2)       bunzip2 $1    ;;
             *.rar)       rar x $1      ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1     ;;
             *.tbz2)      tar xjf $1    ;;
             *.tgz)       tar xzf $1    ;;
             *.zip)       unzip $1      ;;
             *.Z)         uncompress $1 ;;
             *.7z)        7z x $1       ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function psgrep() {
	if [ ! -z $1 ] ; then
		echo "Grepping for processes matching $1..."
		ps aux | grep $1 | grep -v grep
	else
		echo "!! Need name to grep for"
	fi
}

function cd {
    # The 'builtin' keyword allows you to redefine a Bash builtin without
    # creating a recursion. Quoting the parameter makes it work in case there are spaces in
    # directory names.
    builtin cd "$@"

    if [ -d ".git" ]; then
        git status -s >> /dev/null 2>&1
        SPANOPEN="<span color='red' font='18px'><i><b>"
        SPANCLOSE="</b></i></span>"
        [ $? -eq 0 ] && /usr/bin/notify-send -t 10000 --icon=error \
                                "Notification" \
                                "${SPANOPEN}You have uncommited changes on: $(git worktree list)${SPANCLOSE}" >/dev/null 2>&1
    fi

    ls -thor ;
}

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
        _ip_add=$(ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}')
__git_status() {
    STATUS=$(git status 2>/dev/null |
    awk '
    /^On branch / {printf($3)}
    /^Changes not staged / {printf("|?Changes unstaged!")}
    /^Changes to be committed/ {printf("|*Uncommitted changes!")}
    /^Your branch is ahead of/ {printf("|^Push changes!")}
    ')
    if [ -n "$STATUS" ]; then
        echo -ne " ($STATUS) [Last updated: $(git log 2> /dev/null | head -n 3 | grep ^Date | cut -f4- -d' ')]"
    fi
}
__ps1_startline="\[\033[0;32m\]\[\033[0m\033[0;38m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h on ${_ip_add}:\w\[\033[0;32m\]"
__ps1_endline="\[\033[0;32m\]└─\[\033[0m\033[0;31m\] [\D{%F %T}] \$\[\033[0m\033[0;32m\] >>>\[\033[0m\] "
export PS1="${__ps1_startline} \$(__git_status)\n ${__ps1_endline}"

function disconnect() {
    # Disconnect all mounted disks
    for DIR in $(ls "${HOME}/mnt"); do
	/bin/fusermount -qzu "${HOME}/mnt/${DIR}";
    done
    }

function connectSSHFS(){
    IP="192.168.4.23"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/dbelab04
    else
        fusermount -u -z ~/mnt/dbelab04 ;
    fi
}

function dbelab06mount(){
    IP="192.168.6.14"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/dbelab0
    else
        fusermount -u -z ~/mnt/dbelab06 ;
    fi
}

function cmc2mount(){
    IP="10.103.254.3"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/cmc2
    else
        fusermount -u -z ~/mnt/cmc2 ;
    fi
}

function cmc3mount(){
    IP="10.103.254.6"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/cmc3
    else
        fusermount -u -z ~/mnt/cmc3 ;
    fi
}

