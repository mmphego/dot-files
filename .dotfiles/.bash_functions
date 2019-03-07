# Useful Functions

cheatsheet() {
    # Cheatsheets https://github.com/chubin/cheat.sh
    curl -L "https://cheat.sh/$1"
}

getbibtex() {
    # Download BibTex from IEEEExplore by ID or URL
    INFO="$@"
    if [[ "${INFO}" == http* ]]; then
        ID=$(echo "${INFO}" | cut -f5 -d '/')
    else
        ID="${INFO}"
    fi
    curl -s --data "recordIds=${ID}&download-format=download-bibtex&citations-format=citation-abstract" https://ieeexplore.ieee.org/xpl/downloadCitations > "${ID}_reference".bib
    sed -i "s/<br>//g" "${ID}_reference".bib
}

sciget() {
    # sci-hub.tw
    # The first pirate website in the world to provide mass and public access to tens of millions of research papers
    curl -O $(curl -s http://sci-hub.tw/"$@" | $(command -v grep) location.href | $(command -v grep) -o "http.*pdf")
    if [[ "$@" == "https://ieeexplore.ieee.org/"* ]]; then getbibtex "$@"; fi
}

mkcd() {
    # Create a new directory and enter it
    mkdir -p "$@" && echo "You are in: $@" && builtin cd "$@" || exit 1
}

rename-to-lowercase() {
    # Renames all items in a directory to lower case.
    for i in *; do
        echo "Renaming $i to ${i,,}"
        mv "$i" "${i,,}";
    done
}

git-pull-all() {
    CUR_DIR=$(pwd)
    find -type d -execdir test -d {}/.git \; -print -prune | while read -r DIR;
        do builtin cd $DIR &>/dev/null;
        git pull &>/dev/null &
        STATUS=$(git status 2>/dev/null |
            awk '
            /^On branch / {printf($3)}
            /^Changes not staged / {printf(" | ?Changes unstaged!")}
            /^Changes to be committed/ {printf(" | *Uncommitted changes!")}
            /^Your branch is ahead of/ {printf(" | ^Push changes!")}
            ')

        printf "Repo: ${DIR} | ${GREEN}${STATUS}${NC}\n";
        builtin cd - &>/dev/null;
    done
    builtin cd $CUR_DIR &>/dev/null;
}

get-git-repos() {
    # Get a list of all your Git repos in the current directory
    CUR_DIR=$(pwd);
    find -type d -execdir test -d {}/.git \; -print -prune | while read -r DIR; do
        builtin cd $DIR &> /dev/null;
        git config --get remote.origin.url >> ~/My-Git-Repos.txt
        builtin cd - &> /dev/null;
    done;
    builtin cd "${CUR_DIR}" &> /dev/null
}

clone-my-repos() {
    # Clone all my repos from file
    CLONEDIR=~/GitHub
    if [ "$1" == "" ]; then
        recho "Usage $0 {filename}"
        recho "eg: ${FUNCNAME[0]} My-Git-Repos.txt"
    else
        while IFS='' read -r repo || [[ -n "$repo" ]]; do
            [ ! -d "${CLONEDIR}" ] && mkdir -p "${CLONEDIR}"
            echo "Cloning Repo: $repo"
            git -C "${CLONEDIR}" clone --depth 5 "$repo"
        done < "$1"
    fi
}

committer() {
    # Add file(s), commit and push
    FILE=$(git status | $(command -v grep) "modified:" | cut -f2 -d ":" | xargs)
    for file in $FILE; do git add -f "$file"; done
    if [ "$1" == "" ]; then
        # SignOff by username & email, SignOff with PGP and ignore hooks
        git commit -s -S -n -m"Updated $FILE";
    else
        git commit -s -S -n -m"$2";
    fi;
    read -t 5 -p "Hit ENTER if you want to push else wait 5 seconds"
    [ $? -eq 0 ] && bash -c "git push --no-verify -q &"
}

createpr() {
    # Push changes and create Pull Request on GitHub
    REMOTE="devel";
    if ! git show-ref --quiet refs/heads/devel; then REMOTE="master"; fi
    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git push -u origin "${BRANCH}" || true;
    if command -v hub > /dev/null; then
        hub pull-request -b "${REMOTE}" -h "${BRANCH}" --no-edit || true
    else
        recho "Failed to create PR, create it Manually"
        recho "If you would like to continue install hub: https://github.com/github/hub/"
    fi
}

git-url-shortener(){
    # GitHub URL shortener
    if [ "$1" == "" ]; then
        recho "Usage $0 {Custom URL Name} {URL}"
        recho "eg: ${FUNCNAME[0]} runme https://raw.githubusercontent.com/blablabla "
    else
        curl https://git.io/ -i -F "url=${2}" -F "code=${1}"
    fi
}

filefinder() {
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
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" \
        "Long running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

extract() {
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
             *)           echo "'$1' cannot be extracted via ${FUNCNAME[0]}" ;;
         esac
     else
         recho "'$1' is not a valid file"
     fi
}

open() {
     if [ -f $1 ] ; then
         case $1 in
            # List should be expanded.
             *.pdf)                 zathura $1                 ;;
             *.md)                  pandoc $1 | lynx -stdin    ;;
             *.mp3|*.mp4|*.mkv)     vlc $1 & ;;
             *)        recho "'$1' cannot opened via ${FUNCNAME[0]}" ;;
         esac
     else
         recho "'$1' is not a valid file"
     fi
}

compile() {
     if [ -f $1 ] ; then
         case $1 in
             *.tex)    latexmk -pdf $1               ;;
             *.c)      gcc -Wall "$1" -o "main" -lm  ;;
            # List should be expanded.
             *)        recho "'$1' cannot opened via ${FUNCNAME[0]}" ;;
         esac
     else
         recho "'$1' is not a valid file"
     fi
}

psgrep() {
	if [ ! -z $1 ] ; then
		echo "Grepping for processes matching $1..."
		ps aux | grep $1 | grep -v grep
	else
		recho "!! Need name to grep for"
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
        fusermount -quz ~/mnt/cmc3 ;
    fi
}

