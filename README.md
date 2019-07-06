# My Dotfiles

[![Build Status](https://travis-ci.com/mmphego/dot-files.svg?branch=master)](https://travis-ci.com/mmphego/dot-files)
[![LICENCE](https://img.shields.io/github/license/mmphego/dot-files.svg?style=flat)](https://github.com/mmphego/new-computer/blob/master/LICENSE)

Your dotfiles are how you personalize your system. These are mine.
I was a little tired of having long alias files and everything strewn about(which is extremely common on other dotfiles projects, too).
That led to this project being much more topic-centric. I realized I could split a lot of things up into the main areas I used, so I structured the project accordingly.

## Installation

**Warning: If you want to give these dotfiles a try, you should first fork this repository,
review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails.**

**Use at your own risk!**

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

The command (`bash .dotfiles/.dotfiles_setup.sh install`) will create symlinks for config files in your home directory.

After installation is complete, test if everything was installed successfully.

```shell
bash .dotfiles/.dotfiles_setup.sh test
```

To uninstall run;

```shell
bash .dotfiles/.dotfiles_setup.sh uninstall
```

## What's in the dotfiles

## Configurations

[IPython](ipython.org) configuration:

* Adds [IPython startup file](.ipython/profile_default/startup)

[git](http://git-scm.com/) configuration:

* Adds git typos
* Adds a `ci` alias that checks the continuous integration status.
* Adds a `pushd` alias to push upstream and an option of creating a pull-request.
* Adds a `create-pr` alias to push to remote and create a pull request.
* Adds a `commit-amend` alias amend to previous commit with HEAD commit message.
* Adds a `commit-amend-push` alias amend to previous commit with HEAD commit message and push to remote.

[VSCode](https://code.visualstudio.com) configuration:

* Added [plugins](.config/Code/User/code-plugins-extensions)
* Added few [keybindings](.config/Code/User/keybindings.json)
* Updated [settings](.config/Code/User/settings.json)

[Sublime Text](https://www.sublimetext.com) configuration:

* Added IPython.embed() snippet
* Added few [plugins](.config/sublime-text-3/Packages)
* Few settings

[XFCE4 Desktop Environment](https://xfce.org)

* Added static [wallpaper](Pictures/glasses-and-computer-screen.jpg)
* Moved the panel to the bottom of the screen, increased pixels to 48
* Few extras

## Shell aliases and scripts

* [`.bash_aliases`](.dotfiles/.bash_aliases) which contains most of my aliases.
* [`.bash_functions`](.dotfiles/.bash_functions) which contains function, examples:

    * `sciget`: Download research papers easily with [sci-hub.tw](sci-hub.tw)
    * `getbibtex`: Easily download BibTex from IEEEExplore.
    * `cd`: Redefined a cd `builtin` command and added `ls -thor`
    * etc

* [`.bashrc`](.dotfiles/.bashrc) which contains ShellOptions, source's, and some configurations.
* [`.docker_aliases`](.dotfiles/.docker_aliases) which contains my runnable Docker containers such as:

    * `bat`: supports syntax highlighting for a large number of programming and markup languages
    * `tldr`: A collection of simplified and community-driven man pages.
    * `mardownlinter`: docker based markdown linter

* And few extras

### Feedback

Feel free to fork it or send me PR to improve it.
