#!/bin/bash

set -e pipefail

for FILE in $(find "${HOME}/.dotfiles" -maxdepth 1 -type f); do
    ACT_FILE="$(echo ${FILE} | cut -f5 -d "/")";
    echo "Creating symlink:${FILE} -> ${HOME}/${ACT_FILE}";
    ln -sf "${FILE}" "${HOME}/${ACT_FILE}";
done
