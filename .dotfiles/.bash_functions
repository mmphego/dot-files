# Useful Functions

nightlight () {
    # 1000 — Lowest value (super warm/red)
    # 4000 — Default night light on temperature
    # 5500 — Balanced night light temperature
    # 6500 — Default night light off temperature
    # 10000 — Highest value (super cool/blue)
    if [ "$1" == 'low' ]; then
        VAL=2500
    elif [ "$1" == 'bal' ]; then
        VAL=5000
    else
        VAL=$1
    fi
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
    sleep 0.2
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature $VAL
}

cheatsheet() {
    # Cheatsheets https://github.com/chubin/cheat.sh
    if [ "$1" == "" ]; then
        recho "Usage $0 {filename}"
        recho "eg: ${FUNCNAME[0]} ls"
    else
        curl -L "https://cheat.sh/$1"
    fi
}

create_venv() {
    if [ "$1" == "" ]; then
        recho "Usage $0 {Python version}"
        recho "eg: ${FUNCNAME[0]} 3"
    else command -v virtualenv > /dev/null;
        virtdir=".$(basename $(pwd))_Py${1}"
        virtualenv --python="python${1}" "${virtdir}"
        source "${virtdir}/bin/activate"

        "${virtdir}/bin/pip" install -U pip
        "${virtdir}/bin/pip" install \
                                    --use-feature=2020-resolver \
                                    flake8 \
                                    future \
                                    isort \
                                    pytest \

        if [ $(echo " $@ >= 3" | bc) -eq 1 ]; then
            "${virtdir}/bin/pip" install black flake8-black pre-commit ipython['all']
        else
            "${virtdir}/bin/pip" install ipython==5.8.0
        fi
    fi
}

up() {
    cd $(printf "%0.s../" $(seq 1 $1 ));
}

touch_script() {
    touch $1 && chmod a+x $1 && subl $1;
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

gitignore() {
    # Generate .gitignore
    curl -sL https://www.gitignore.io/api/$@ ;
}

git-revert-commit() {
    # Undo last pushed commit
    if [ "$1" == "" ]; then
        recho "Usage $0 'commit-hash'"
        recho "eg: ${FUNCNAME[0]} '6e9f0998'"
    else
        BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        git reset --hard $1
        git push --force-with-lease origin "$BRANCH"
    fi
}

git-pull-all() {
    # Pull all remote refs from repos in the current dir
    CUR_DIR=$(pwd)
    find -type d -execdir test -d {}/.git \; -print -prune | sort | while read -r DIR;
        do builtin cd $DIR &>/dev/null;
        (git fetch -pa && git pull --allow-unrelated-histories \
            origin $(git symbolic-ref --short HEAD)) &>/dev/null &disown;

        STATUS=$(git status 2>/dev/null |
        awk -v r=${RED} -v y=${YELLOW} -v g=${GREEN} -v b=${BLUE} -v n=${NC} '
        /^On branch / {printf(y$3n)}
        /^Changes not staged / {printf(g"|?Changes unstaged!"n)}
        /^Changes to be committed/ {printf(b"|*Uncommitted changes!"n)}
        /^Your branch is ahead of/ {printf(r"|^Push changes!"n)}
        ')
        LAST_UPDATE="${STATUS} | ${LIGHTCYAN}[$(git show -1 --stat | grep ^Date | cut -f4- -d' ')]${NC}"

        printf "Repo: \t${DIR} \t| ${LAST_UPDATE}\n";
        builtin cd - &>/dev/null;
    done
    builtin cd ${CUR_DIR} &>/dev/null;
}

backup_my_git_repos() {
    # Get a list of all your Git repos in the current directory
    FILENAME=~/My-Git-Repos.txt
    if [ ! -f $FILENAME ]; then touch $FILENAME; fi
    CUR_DIR=$(pwd);
    find -type d -execdir test -d {}/.git \; -print -prune | while read -r DIR; do
        builtin cd ${DIR} &> /dev/null;
        echo -e "\n[$(basename $(pwd))]" >> $FILENAME
        git config --get remote.origin.url >> $FILENAME
        builtin cd - &> /dev/null;
    done;
    builtin cd "${CUR_DIR}" &> /dev/null
}

git-rename-branch(){
    # Rename current branch with new one and push to remote
    if [ "$1" = "help" -o "$1" = "-h" -o "$1" = "--help" -o "$1" = "h" -o "$1" = "" ] ; then
        recho "Usage $0 new_name'"
        recho "This will rename the branch 'error-fixes' into 'syntax-error-fix'"
        recho "eg: ${FUNCNAME[0]} 'syntax-error-fix'"
    else
        new_name=$1
        old_name="$(git rev-parse --abbrev-ref HEAD)"
        echo "Renaming current branch from ${old_name} to ${new_name}"
        git branch -m "${new_name}"
        git push origin :"${old_name}"
        git push origin "${new_name}":"refs/heads/${new_name}"
    fi
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
    MSG=$@;
    # Add file(s), commit with generic message and push to remote
    git status | grep "modified:" | cut -f2 -d ":" | tr -s '  ' | while read line; do
        git add -f "${line}";
    done

    FILE=$(git status | grep "modified:" | cut -f2 -d ":" | tr "\n" " " | xargs)
    if [ ! -z "$MSG" ]; then
        # SignOff by username & email, SignOff with PGP and ignore hooks
        git commit -s -S -n -m "$MSG";
    else
        git commit -s -S -n -m"Updated ${FILE}";
    fi;
    read -t 5 -p "Hit ENTER if you want to push else wait 5 seconds"
    [ $? -eq 0 ] && bash -c "git push --no-verify -q -u origin $(git rev-parse --abbrev-ref HEAD) &>/dev/null &disown;"
}

createpr() {
    # Push changes and create Pull Request on GitHub
    REMOTE="devel";
    LABELS="Review Me"
    if ! git show-ref --quiet refs/heads/devel; then REMOTE="master"; fi
    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git push -u origin "${BRANCH}" || true;
    if command -v hub > /dev/null; then
        # Check if branch contains a JIRA ticket id.
        if echo "${BRANCH}" | grep -q "MT-"; then
            REVIEWERS="ajoubertza,amakhaba,bngcebetsha,lanceWilliams,tockards,mamkhari"
            echo "Requesting PR Reviewers: ${REVIEWERS}";
            hub pull-request --draft -b "${REMOTE}" -h "${BRANCH}" -r "${REVIEWERS}" \
                --labels "${LABELS}" --no-edit || hub pull-request \
                    -b "${REMOTE}" -h "${BRANCH}" -r "${REVIEWERS}" --labels "${LABELS}" --no-edit
        else
            hub pull-request --draft -b "${REMOTE}" -h "${BRANCH}" --no-edit || hub pull-request \
                 -b "${REMOTE}" -h "${BRANCH}" --no-edit
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

git-fetch-all-branches() {
    # Fetch all remote branches
    git checkout --detach
    git fetch origin '+refs/heads/*:refs/heads/*';
}

git-checkout-update-master () {
    # Forcefully checkout master and pull latest changes.
    for DIR in $(ls --color=never);
        do echo $DIR;
        pushd $DIR;
        git checkout -f master && git pull --allow-unrelated-histories -q &>/dev/null &disown;
        popd;
    done
}

find-file() {
    # Find filename
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
             *.pdf)                 evince $1 &                ;;
             *.md)                  pandoc $1 | lynx -stdin    ;;
             *.mp3|*.mp4|*.mkv)     vlc $1 &                   ;;
             *)                     xdg-open $1 >>/dev/null    ;;
         esac
     else
        xdg-open $1 >>/dev/null
     fi
}

compile() {
     if [ -f $1 ] ; then
         case $1 in
            # List should be expanded.
             *.c)      gcc -H -Wall "$1" -o "main" -lm  ;;
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
    if [ "${PWD}" == "${HOME}/CAM_Work" ]; then
        git-pull-all
    fi
}

install-pkg() {
    echo "Installing package: $@";
    if command -v gdebi >/dev/null; then
        if [[ "$@" == *"http"* ]]; then
            wget -O /tmp/package.deb "$@";
            sudo gdebi /tmp/package.deb;
        else
            sudo gdebi $@;
        fi
    else
        sudo dpkg --install $@;
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
        if bash -c "${PYTHON3_PIP} freeze | grep -i "${pkg}" &>/dev/null &disown;"; then
            bash -c "${PYTHON3_PIP} install -q --user -U "${pkg}" &>/dev/null &disown;"
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
        FILENAME=$@
        DATE=$(date +'%Y-%m-%d')
        TIME=$(date +'%H:%M:%S')

        NEW_POST="${BLOG_DIR}/_posts/${DATE}-${FILENAME// /-}.md"
        NEW_POST_IMG="/assets/${DATE}-${FILENAME// /-}.png"
        BG_IMG="${BLOG_DIR}/img/new_post_word_cloud.png"
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

<<TIME TO READ>>

-----------------------------------------------------------------------------------------

# The Story

## TL;DR

## TS;RE

# The How


# The Walk-through


# Reference

- []()
- []()
EOF
        subl "${NEW_POST}"
        recho "Do not forget to Run:"
        set -x
        generate_wordcloud.py -f "${NEW_POST}" -s "${BG_IMG}"
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

rm_pyc() {
    find . -name "*.pyc" -exec rm -f {} \;
}

sync_with_cam(){
    if [ "$1" == "" ]; then
        recho "Usage: $0 devm"
        recho "eg: ${FUNCNAME[0]} devm"
        return
    fi
    if ! command -v entr >/dev/null 2>&1; then
        recho "Entr is not installed."
        recho "Install entr: http://eradman.com/entrproject/"
        exit 1
    fi

    CONFIG_FILE="${HOME}/.secrets/config.sh"
    if [ ! -f "${CONFIG_FILE}" ]; then
        recho "Config file doesnt exist."
    else
        source "${CONFIG_FILE}"
        CWD_PATH=$(pwd | cut -d'/' -f5-)
        RSYNC_SRC="${LOCAL_DIR}/${CWD_PATH}"
        RSYNC_DEST="${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/${CWD_PATH}"
        # Download entr:
        #   https://github.com/eradman/entr
        #   http://eradman.com/entrproject/
        find . | entr rsync -truv \
                            --exclude-from="$(git worktree list | cut -d' ' -f1)/.gitignore" \
                            --exclude=".git" \
                            --progress "${RSYNC_SRC}/" "${RSYNC_DEST}"
    fi
}

install() {
    # Debian package installer fallback.
    sudo apt-get -y --install-recommends install "$@"
    ret_code=$?
    if [ "$ret_code" == 100 ]; then
        echo -e "\nAPT doesn't have the package that you are trying to install, "
        echo -e "I will install it using 'snap'\n\n"
        sudo snap install "$@"
    fi
}

mp3_split_on_silence() {
    sox $@ file.mp3 silence 1 1.0 0.2% 1 0.8 0.5% : newfile : restart
}

vid_2_gif() {
    if [ "$1" == "" ]; then
        recho "Usage $0 filename.mp4"
    else
        ffmpeg -i "$1" -r 15 -vf scale=720:-1 "$1.gif"
    fi
}

gif_2_vid() {
    if [ "$1" == "" ]; then
        recho "Usage $0 filename.gif"
    else
        ffmpeg -i "$1" -movflags faststart -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${1}.mp4"
    fi
}

extract_audio_from_video() {
    ffmpeg -i $1 -vn -b:a 320k output-audio.mp3
}

pdf_merge(){
    pdftk "$1" "$2" cat output mergedfile.pdf
}
