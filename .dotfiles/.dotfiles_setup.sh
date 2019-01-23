#!/usr/bin/env bash
# My dotfiles setup script
# Author: Mpho Mphego <mmphego@ska.ac.za>

set -eo pipefail

if [ "$1" == '' ]; then
    echo "Available functions: install or delete or test";
    echo "Usage: $0 install or $0 delete or $0 test"
    exit 1;
elif [ "$1" == "install" ]; then
    while IFS= read -r -d '' FILE; do
        while IFS= read -r -d '' FILES; do
            ACT_FILE="$(echo ${FILES} | cut -f5 -d "/")";
            echo "Creating symlink:${FILES} -> ${HOME}/${ACT_FILE}";
            mv "${HOME}/${ACT_FILE}" "${HOME}/${ACT_FILE}.bk" >/dev/null 2>&1 || true;
            ln -sf "${FILES}" "${HOME}/${ACT_FILE}";
        done < <(find "${HOME}/.dotfiles" -maxdepth 1 -type f -print0)
    done < <(find "${HOME}" -mindepth 1 -maxdepth 1 -type d -iname ".dotfiles" -print0)

elif [ "$1" == "delete" ]; then

    while IFS= read -r -d '' FILE; do
        while IFS= read -r -d '' FILES; do
            ACT_FILE="$(echo ${FILES} | cut -f5 -d "/")";
            echo "Deleting symlink: ${HOME}/${ACT_FILE}";
            mv "${HOME}/${ACT_FILE}" /tmp
            if [ -L "${HOME}/${ACT_FILE}" ]; then
                echo "Failed to remove symlink";
                exit 1;
            fi
        done < <(find "${HOME}/.dotfiles" -maxdepth 1 -type f -print0)
    done < <(find "${HOME}" -mindepth 1 -maxdepth 1 -type d -iname ".dotfiles" -print0)

elif [ "$1" == "test" ]; then
    while IFS= read -r -d '' FILE; do
        while IFS= read -r -d '' FILES; do
            ACT_FILE="$(echo ${FILES} | cut -f5 -d "/")";
            echo "Checking if symlink exists: ${HOME}/${ACT_FILE}";
            if [ ! -L "${HOME}/${ACT_FILE}" ]; then
                echo "${HOME}/${ACT_FILE}: Symlink doesn't exist";
                exit 1;
            fi
            rsync -vuar --delete-after "${HOME}/${ACT_FILE}.bk" "${HOME}/${ACT_FILE}";
        done < <(find "${HOME}/.dotfiles" -maxdepth 1 -type f -print0)
        echo "Created symlinks...";
    done < <(find "${HOME}" -mindepth 1 -maxdepth 1 -type d -iname ".dotfiles" -print0)
    ls -thora "${HOME}" | grep " -> ";
else
    echo "'$1' is not a known function name" >&2
    exit 1;
fi
