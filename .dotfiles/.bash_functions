# Useful Functions

sciget() {
    # sci-hub.tw
    # The first pirate website in the world to provide mass and public access to tens of millions of research papers
    curl -O $(curl -s http://sci-hub.tw/"$@" | $(which grep) location.href | $(which grep) -o "http.*pdf")
}

getbibtex() {
    # ieeexplore
    # extract bibtex by id/url
    INFO="$@"
    if [[ "${INFO}" == http* ]]; then
        ID=$(echo "${INFO}" | cut -f5 -d '/')
    else
        ID="${INFO}"
    fi
    curl -s --data "recordIds=${ID}&download-format=download-bibtex&citations-format=citation-abstract" https://ieeexplore.ieee.org/xpl/downloadCitations > "${ID}_reference".bib
    sed -i "s/<br>//g" "${ID}_reference".bib
}

# Create a new directory and enter it
mkcd() {
    mkdir -p "$@" && echo "You are in: $@" && cd "$@" || exit 1
}

PullAll() {
    CUR_DIR=$(pwd)
    find -type d -execdir test -d {}/.git \; -print -prune | while read -r DIR;
        do cd "${DIR}" >/dev/null 2&>1;
        git pull &>/dev/null &
        echo "Updating ${DIR}";
        cd - >/dev/null 2&>1;
    done
    cd "${CUR_DIR}";
}

committer() {
    # Add file(s), commit and push
    FILE=$(git status | $(which grep) "modified:" | cut -f2 -d ":" | xargs)
    for file in $FILE; do git add -f "$file"; done
    if [ "$1" == "" ]; then
        git commit -nm"Updated $FILE";
    else
        git commit -nm"$2";
    fi;
    read -t 5 -p "Hit ENTER if you want to push else wait 5 seconds"
    [ $? -eq 0 ] && bash -c "git push --no-verify -q &"
}

createpr() {
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

filefinder () {
    for FILE in $(find . -type f -name "*$1"); do
        echo ${FILE};
    done
}

ssh() {
    # Always ssh with -X
    command ssh -X "$@"
}

wrapper() {
    # Desktop notification when long running commands complete
    start=$(date +%s)
    "$@"
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Long\
running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

extract () {
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

psgrep() {
	if [ ! -z $1 ] ; then
		echo "Grepping for processes matching $1..."
		ps aux | grep $1 | grep -v grep
	else
		echo "!! Need name to grep for"
	fi
}

cd() {
    # The 'builtin' keyword allows you to redefine a Bash builtin without
    # creating a recursion. Quoting the parameter makes it work in case there are spaces in
    # directory names.
    builtin cd "$@" && ls -thor;
}

pip() {
    if [[ "$1" == "install" ]]; then
        shift 1
        command pip install --no-cache-dir -U "$@"
    else
        command pip "$@"
    fi
}

install-pkg() {
    echo "Installing package: $1";
    if command -v gdebi >/dev/null;then
        sudo gdebi $1;
    else
        sudo dpkg --install $1;
    fi
}

gpg_delete_all_keys() {
    for KEY in $(gpg --with-colons --fingerprint | grep "^fpr" | cut -d: -f10); do
        gpg --batch --delete-secret-keys "${KEY}";
    done
}

disconnect() {
    # Disconnect all mounted disks
    while IFS= read -r -d '' file;
	do fusermount -qzu $file >/dev/null;
    done < <(find "${HOME}/mnt" -maxdepth 1 -type d -print0);
}

connectSSHFS() {
    IP="192.168.4.23"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/dbelab04
    else
        fusermount -u -z ~/mnt/dbelab04 ;
    fi
}

dbelab06mount() {
    IP="192.168.6.14"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/dbelab0
    else
        fusermount -u -z ~/mnt/dbelab06 ;
    fi
}

cmc2mount() {
    IP="10.103.254.3"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/cmc2
    else
        fusermount -u -z ~/mnt/cmc2 ;
    fi
}

cmc3mount() {
    IP="10.103.254.6"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        timeout 2 sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
        "${USER}"@"${IP}":/ /home/"${USER}"/mnt/cmc3
    else
        fusermount -u -z ~/mnt/cmc3 ;
    fi
}

