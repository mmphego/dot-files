# Useful Functions

# Create a new directory and enter it
function mkcd() {
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
    read -t 5 -p "Hit ENTER if you want to push else wait 5 seconds"
    [ $? -eq 0 ] && bash -c "git push --no-verify -q &"
}

function create-pr() {
    REMOTE="devel";
    if ! git show-ref --quiet refs/heads/devel; then REMOTE="master"; fi
    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git push -u origin "${BRANCH}" || true;
    if [ -f /usr/local/bin/hub ]; then
        /usr/local/bin/hub pull-request -b "${REMOTE}" -h "${BRANCH}" --no-edit || true
    else
        >&2 echo "Failed to create PR, create it Manually"
        >&2 echo "If you would like to continue install hub: https://github.com/github/hub/"
    fi
}

function filefinder () {
    for FILE in $(find . -type f -name "*$1"); do
        echo ${FILE};
    done
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
             *.tar.xz)    tar -xJf $1   ;;
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
    builtin cd "$@" && ls -thor;
}

function pip() {
    if [[ "$1" == "install" ]]; then
        shift 1
        command pip install --no-cache-dir -U "$@"
    else
        command pip "$@"
    fi
}

function install-pkg() {
    echo "Installing package: $1";
    if command -v gdebi >/dev/null;then
        sudo gdebi $1;
    else
        sudo dpkg --install $1;
    fi
}

function __git_status() {
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
export PS1="${__ps1_startline}\$(__git_status)\n${__ps1_endline}"

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

