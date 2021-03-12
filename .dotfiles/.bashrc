# Bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

####################################################################################################
############################################# Fancy Prompt #########################################
####################################################################################################
__git_status_info() {
    STATUS=$(git status 2>/dev/null |
    awk -v r=${RED} -v y=${YELLOW} -v g=${GREEN} -v b=${BLUE} -v n=${NC} '
    /^On branch / {printf(y$3n)}
    /^Changes not staged / {printf(g"|?Changes unstaged!"n)}
    /^Changes to be committed/ {printf(b"|*Uncommitted changes!"n)}
    /^Your branch is ahead of/ {printf(r"|^Push changes!"n)}
    ')
    if [ -n "${STATUS}" ]; then
        echo -ne " ${STATUS} ${LIGHTCYAN}[Last updated: $(git show -1 --stat | grep ^Date | cut -f4- -d' ')]${NC}"
    fi
}

__disk_space=$(/bin/df --output=pcent /home | tail -1)
_ip_add=$(ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}')
__ps1_startline="\[\033[0;32m\]\[\033[0m\033[0;38m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h on ${_ip_add}:\w\[\033[0;32m\] \[\033[0;34m\] [disk:${__disk_space}] \[\033[0;32m\]"
__ps1_endline="\[\033[0;32m\]└─\[\033[0m\033[0;31m\] [\D{%F %T}] \$\[\033[0m\033[0;32m\] >>>\[\033[0m\] "
export PS1="${__ps1_startline}\$(__git_status_info)\n${__ps1_endline}"

####################################################################################################
#################################### Alias Definitions #############################################
####################################################################################################

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# `Docker` Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.docker_aliases, instead of adding them here directly.

if [ -f ~/.docker_aliases ]; then
    source ~/.docker_aliases
fi

# `Docker` Function definitions.
# You may want to put all your additions into a separate file like
# ~/.docker_functions, instead of adding them here directly.

if [ -f ~/.docker_functions ]; then
    source ~/.docker_functions
fi

# functions definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.

if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

# argcomplete - Bash tab completion for argparse
# See: https://github.com/kislyuk/argcomplete
if [ -f ~/.python-argcomplete.sh ]; then
    source ~/.python-argcomplete.sh
fi

if [ -f ~/.aws_secrets ]; then
    source ~/.aws_secrets
fi

# Bash tab completion for kubectl
if command -v kubectl > /dev/null; then
    source <(kubectl completion bash)
fi

# if [ -f ~/GitHub/Random_Projects/bash-wakatime/bash-wakatime.sh ] && [ -f ~/.wakatime.cfg ]; then
#     source ~/GitHub/Random_Projects/bash-wakatime/bash-wakatime.sh || true
# fi
####################################################################################################
#################################### Exports Definitions ###########################################
####################################################################################################

# Avoid issues with `gpg` as installed via apt.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

if command -v subl > /dev/null; then
    export EDITOR="subl -w";
else
    export EDITOR="nano -lm";
fi

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';
# Infinite history.
export HISTSIZE=999999
export HISTFILESIZE=999999
# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL='ignoreboth';
## history -a causes the last command to be written to the
## history file automatically and history -r imports the history
export PROMPT_COMMAND='history -a;history -r'

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Wait longer before timing out when running pip
export PIP_DEFAULT_TIMEOUT=100

if [ -d ~/.npm-packages ]; then
    NPM_PACKAGES="${HOME}/.npm-packages"

    export PATH="$PATH:$NPM_PACKAGES/bin"

    # Preserve MANPATH if you already defined it somewhere in your config.
    # Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
    export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
fi
####################################################################################################
#################################### Input edits and Key-bindings ###################################
####################################################################################################

if [[ $- == *i* ]]; then
    # Disable ctrl-s and ctrl-q
    stty -ixon

    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\e[1;5C": forward-word'
    bind '"\e[1;5D": backward-word'
    bind '"\e[5C": forward-word'
    bind '"\e[5D": backward-word'
    bind '"\e\e[C": forward-word'
    bind '"\e\e[D": backward-word'
    # Flip through autocompletion matches with Shift-Tab.
    bind '"\e[Z": menu-complete'

    # List all matches in case multiple possible completions are possible
    bind 'set show-all-if-ambiguous on'
    # Make Tab autocomplete regardless of filename case
    bind 'set completion-ignore-case on'
    # Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
    bind 'set input-meta on'
    bind 'set output-meta on'
    bind 'set convert-meta off'
    # Be more intelligent when auto-completing by also looking at the text after
    # the cursor.
    bind 'set skip-completed-text on'
    # Immediately add a trailing slash when autocompleting symlinks to directories
    bind 'set mark-symlinked-directories on'
    # Show all autocomplete results at once
    bind 'set page-completions off'
    # If there are more than 200 possible completions for a word, ask to show them all
    bind 'set completion-query-items 200'
fi

####################################################################################################
################################### SHell Options ##################################################
####################################################################################################


# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Save all lines of a multiple-line command in the same history entry.
shopt -s cmdhist
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Allows me to cd into a dir by just typing the dir name
shopt -s autocd
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
# Includes file names beginning with a '.' in the results of path name globbing.
shopt -s dotglob

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f "/usr/share/bash-completion/bash_completion" ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f "/etc/bash_completion" ]; then
        source /etc/bash_completion
    fi
fi

if [ -f "/etc/bash_completion.d/git-prompt" ]; then
    source /etc/bash_completion.d/git-prompt
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.bash.inc" ]; then
    source "${HOME}/google-cloud-sdk/path.bash.inc";
fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.bash.inc" ]; then
    source "${HOME}/google-cloud-sdk/completion.bash.inc";
fi

# Enabling travis shell
if [ -f "${HOME}/.travis/travis.sh" ]; then
    source "${HOME}/.travis/travis.sh"
fi

# The OpenVINO environment variables setup.
if [ -d "/opt/intel/openvino/bin/setupvars.sh" ]; then
    source /opt/intel/openvino/bin/setupvars.sh
fi

if [ -f $(which vagrant) ]; then
    VERSION=$(vagrant --version | cut -f 2 -d ' ')
    # >>>> Vagrant command completion (start)
    source "/opt/vagrant/embedded/gems/${VERSION}/gems/vagrant-${VERSION}/contrib/bash/completion.sh"
    # <<<<  Vagrant command completion (end)
fi

# The Azure-CLI environment variables setup.
if [ -f "${HOME}/.lib/azure-cli/az.completion" ]; then
    source "${HOME}/.lib/azure-cli/az.completion"
fi

####################################################################################################
############################################ Welcome Message #######################################
####################################################################################################
if [ -f /var/run/reboot-required ]; then
    echo -e "${REDBG}[*** Hello ${USER}, you must reboot your machine ***]${NC}\n";
fi

IP_ADD=$(ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}')
printf "${LIGHTGREEN}Hello, ${USER}@${IP_ADD}\n"
printf "Today is, $(date)\n";
printf "\nSysinfo: $(uptime)\n"
# if [ -f ~/.weather.log ]; then
#     while IFS='' read -r line || [[ -n "$line" ]]; do
#         printf "${LIGHTBLUE}%s\n${NC}" "${line}"
#     done < ~/.weather.log
# fi
printf "\n${YELLOW}Get a list of available functions: 'declare -F'\n"
#printf "${LIGHTCYAN}\n$(fortune | cowsay)${NC}\n"

# tabtab source for packages
# uninstall by removing these lines
# [ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true
