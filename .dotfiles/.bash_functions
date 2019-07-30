# Useful Functions

cheatsheet() {
    # Cheatsheets https://github.com/chubin/cheat.sh
    if [ "$1" == "" ]; then
        recho "Usage $0 {filename}"
        recho "eg: ${FUNCNAME[0]} ls"
        exit 1
    fi
    curl -L "https://cheat.sh/$1"
}

create-venv() {
    if [ "$1" == "" ]; then
        recho "Usage $0 {Python version}"
        recho "eg: ${FUNCNAME[0]} 3"
    else command -v virtualenv > /dev/null;
        virtdir=".$(basename $(pwd))_Py${1}"
        virtualenv --python="python${1}" "${virtdir}" --no-site-packages
        source "${virtdir}/bin/activate"

        "${virtdir}/bin/pip" install flake8 \
                                     isort \
                                     autopep8 \
                                     future \
                                     six \
                                     future-fstrings

        if [ $(echo " $@ >= 3" | bc) -eq 1 ]; then
            "${virtdir}/bin/pip" install black ipython['all']
        else
            "${virtdir}/bin/pip" install ipython==5.8.0
        fi
    fi
}

up() {
    cd $(printf "%0.s../" $(seq 1 $1 ));
}

touch_script() {
    touch $1 && chmod a+x $1;
}

backup() {
    FILENAME=$1;
    cp -v "${FILENAME}" ./"${FILENAME}.bk";
}

killbg(){
    kill -9 $(jobs -p)
}

# Calculator
calc() {
 # $ calc 1+2 == 3
    echo "$*" | bc -l
}

search_replace() {
    # Search and replace strings recursively in a given dir
    if [ -n "$2" ]; then
        if [ -n "$3" ]; then
            local path="$3";
        else
            local path=".";
        fi
        ag -l "$1" "$path" | xargs -I {} -- sed -i "" -e "s%${1//\\/}%$2%g" {}
    else
        echo "== Usage: gsed search_string replace_string [path = .]"
    fi
}

add_alias() {
    if [ -n "$2" ]; then
        echo "alias $1=\"$2\"" >> ~/.bash_aliases
        source ~/.bashrc
    else
        echo "Usage: add_alias <alias> <command>"
    fi
}

getbib_from_ieee() {
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

getbib(){

    if [ -f "$1" ]; then
        # Try to get DOI from pdfinfo or pdftotext output.
        doi=$(pdfinfo "$1" | grep -io "doi:.*") ||
        doi=$(pdftotext "$1" 2>/dev/null - | grep -io "doi:.*" -m 1) ||
        exit 1
    else
        doi="$1"
    fi

    # Check crossref.org for the bib citation.
    curl -s "http://api.crossref.org/works/${doi}/transform/application/x-bibtex" -w "\\n"
    # Check doi2bib.org for the bib citation.
    curl -s "https://doi2bib.org/doi2bib?id=${doi}" -w "\\n"
}

sciget() {
    # sci-hub.tw
    # The first pirate website in the world to provide mass and public access to tens of millions of research papers
    curl -O $(curl -s http://sci-hub.tw/"$@" | grep location.href | grep -o "http.*pdf")
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
        awk -v r=${RED} -v y=${YELLOW} -v g=${GREEN} -v b=${BLUE} -v n=${NC} '
        /^On branch / {printf(y$3n)}
        /^Changes not staged / {printf(g"|?Changes unstaged!"n)}
        /^Changes to be committed/ {printf(b"|*Uncommitted changes!"n)}
        /^Your branch is ahead of/ {printf(r"|^Push changes!"n)}
        ')

        printf "Repo: ${DIR} | ${STATUS}\n";
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
    FILE=$(git status | grep "modified:" | cut -f2 -d ":" | xargs)
    for file in $FILE; do git add -f "$file"; done
    if [ "$1" == "" ]; then
        # SignOff by username & email, SignOff with PGP and ignore hooks
        git commit -s -S -n -m"Updated ${FILE}";
    else
        MSG=$2
        git commit -s -S -n -m "${MSG}";
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
        if echo "${BRANCH}" | grep -q "MT-"; then
            REVIEWERS="ajoubertza,sw00,tockards"
            echo "Requesting PR Reviewers: ${REVIEWERS}";
            hub pull-request -b "${REMOTE}" -h "${BRANCH}" -r "${REVIEWERS}" \
                --labels "WIP" --no-edit || true
        else
            hub pull-request -b "${REMOTE}" -h "${BRANCH}" --no-edit || true
        fi
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
             *.pdf)                 zathura $1 &               ;;
             *.md)                  pandoc $1 | lynx -stdin    ;;
             *.mp3|*.mp4|*.mkv)     vlc $1 & ;;
             *)                     xdg-open $1 >>/dev/null ;;
         esac
     else
        xdg-open $1 >>/dev/null
     fi
}

compile() {
     if [ -f $1 ] ; then
         case $1 in
            # List should be expanded.
             *.c)      gcc -Wall "$1" -o "main" -lm  ;;
             *.go)     go run "$1"                   ;;
             *.py)     pycompile -v "$1"             ;;
             *.tex)    latexmk -pdf "$1"             ;;
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
    if [ "${PWD}" == "${HOME}/GitHub_CAM" ]; then
        git-pull-all
    fi
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

cammount() {
    IP="10.8.67.160"
    if timeout 2 ping -c 1 -W 2 "${IP}" &> /dev/null; then
        sshfs -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=5 \
        kat@"${IP}":/ /home/"${USER}"/mnt/cam
    else
        fusermount -quz /home/"${USER}"/mnt/cam;
    fi
}


create_project () {
# Easily create a project x in current dir using cookiecutter templates

    PACKAGES=("pygithub" "cookiecutter" "platformio")
    PACKAGE_DIR=""
    export DESCRIPTION="description goes here!"
    PYTHON3_PIP="python3 -W ignore::DeprecationWarning -m pip -q --disable-pip-version-check"
    IDE="subl"

    for pkg in "${PACKAGES[@]}"; do
        if ${PYTHON3_PIP} freeze | grep -i "${pkg}" >/dev/null 2>&1; then
            ${PYTHON3_PIP} install -q --user -U "${pkg}" >/dev/null 2>&1;
        fi
    done

    read -p "What is the language you using for the  (or type of) project? " LANG
    if [[ "${LANG}" =~ ^([pP])$thon ]]; then
        gecho "Lets build your Python project, Please follow the prompts."
        cookiecutter https://github.com/mmphego/cookiecutter-python-package
        PACKAGE_DIR=$(ls -tr --color='never' | tail -n1)
        export DESCRIPTION=$(grep -oP '(?<=DESCRIPTION = ).*' setup.py)
        cd -- "${PACKAGE_DIR}"
    elif [[ "${LANG}" =~ ^([uU])$python ]]; then
        gecho "Lets build your Micropython project, Please follow the prompts."
        cookiecutter https://github.com/mmphego/cookiecutter-micropython
        PACKAGE_DIR=$(ls -tr --color='never' | tail -n1)
        cd -- "${PACKAGE_DIR}"
        export DESCRIPTION=$(grep -oP '(?<=DESCRIPTION = ).*' setup.py)
    elif [[ "${LANG}" =~ ^([Aa])$duino ]]; then
        gecho "Lets build your Arduino project, Please follow the prompts."
        read -p "Enter name of the project directory? " PACKAGE_DIR
        read -p "Enter type of board (nodemcu/uno)? " BOARD
        read -p "What IDE would you like to use vscode/atom/vim? " IDE
        read -p "Enter the description of the project? " DESCRIPTION
        export DESCRIPTION="${DESCRIPTION}"
        mkdir -p "${PACKAGE_DIR}"
        python2 -m platformio init -s -d ${PACKAGE_DIR} -b ${BOARD} --ide ${IDE}
        cd -- "${PACKAGE_DIR}"
    fi

############################################################

    if [[ "${PACKAGE_DIR}" == "$(basename $(pwd))" ]];then

        git init -q

        python3 -c """
from configparser import ConfigParser
from pathlib import Path
from os import getenv
from subprocess import check_output

from github import Github

try:
    token = check_output(['git', 'config', 'user.token'])
    token = token.strip().decode() if type(token) == bytes else token.strip()
except Exception:
    p = pathlib.Path('.gitconfig.private')
    config.read(p.absolute())
    token = config['user']['token']

proj_name = Path.cwd().name
g = Github(token)
user = g.get_user()
user.create_repo(
    proj_name,
    description=getenv('DESCRIPTION', 'Description goes here!'),
    has_wiki=False,
    has_issues=True,
    auto_init=False)
print('Successfully created repository %s' % proj_name)
"""

        git add .  > /dev/null 2>&1
        git commit -q -nm "Automated commit" > /dev/null 2>&1
        git remote add origin "git@github.com:$(git config user.username)/${PACKAGE_DIR}.git" > /dev/null 2>&1
        git push -q -u origin master > /dev/null 2>&1
        "${IDE}" .
    fi
}


create_blog_post () {
    if [ "$1" == "" ]; then
        recho "Usage: $0 hello world"
        recho "eg: ${FUNCNAME[0]} 'Hello world' "
        recho "This will create a file with (date)-hello-world"
        return
    fi

    BLOG_DIR=$(locate -b 'mmphego.github.io')
    if [ -d "${BLOG_DIR}" ]; then
        FILENAME=$1
        DATE=$(date +'%Y-%m-%d')
        TIME=$(date +'%H:%M:%S')

        NEW_POST="${BLOG_DIR}/_posts/${DATE}-${FILENAME// /-}.md"
        NEW_POST_IMG="/assets/${DATE}-${FILENAME// /-}.jpg"
        BG_IMG="${BLOG_DIR}/img/new_post_word_cloud.jpg"
        # Titlecase the filename
        TITLE=($FILENAME)
        TITLE="${TITLE[@]^}"

        touch "${NEW_POST}"
        tee "${NEW_POST}" <<EOF
---
layout: post
title: "${TITLE}"
date: ${DATE} ${TIME}.000000000 +02:00
tags:

---
# ${TITLE}.

{:refdef: style="text-align: center;"}
![post image]({{ "${NEW_POST_IMG}" | absolute_url }})
{: refdef}

-----------------------------------------------------------------------------------------

# The Story


# The How


# The Walkthrough


# Reference

- []()
- []()
EOF
        subl "${NEW_POST}"
        recho "Do not forget to Run:"
        set -x
        python3 generate_wordcloud.py -f "${NEW_POST}" -s "${BG_IMG}"
        cp "${BG_IMG}" "${BLOG_DIR}${NEW_POST_IMG}"
        set +x
        recho "When you are done editing."
    else
        recho "Could not find blog directory."
    fi
}

mv_file_to_dir() {
    for file in *.{avi,mp4,mkv}; do
        DIR="${file%.*}";
        mkdir -p "${DIR}";
        mv "${file}" "${DIR}";
    done
}

vid_2_gif() {
    ffmpeg -i "$1" -r 15 -vf scale=720:-1 "$1.gif"
}


rm_pyc() {
    find . -name "*.pyc" -exec rm -f {} \;
}

sync_with_cam(){
    # Download entr:
    #   http://eradman.com/entrproject/
    CAM_PATH=$(echo $(realpath $(pwd)) | cut -d'/' -f5-)
    find . | entr rsync -truv . "${HOME}/mnt/cam/home/kat/svn/${CAM_PATH}"
}