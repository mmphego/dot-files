# dot-files

[![Build Status](https://travis-ci.com/mmphego/dot-files.svg?branch=master)](https://travis-ci.com/mmphego/dot-files)

Backup of my dotfiles.

# Setup

There are various ways you can install the dotfiles either fork or clone or download repo.

* Option #1
```shell
cd $HOME
git init
git remote add -f git@github.com:[USERNAME/REPO_NAME].git
git pull -f
git checkout -f master
bash .dotfiles/.dotfiles_setup.sh install
```
* Option #2
```shell
wget https://github.com/mmphego/dot-files/archive/master.zip
unzip master.zip
rsync -uar --delete-after dot-files-master/{.,}* $HOME
cd $HOME
bash .dotfiles/.dotfiles_setup.sh install
```

* Option #3
```shell
cd $HOME
git clone --depth 1 https://github.com/mmphego/dot-files
rsync -uar --delete-after dot-files/{.,}* $HOME
bash .dotfiles/.dotfiles_setup.sh install
```
