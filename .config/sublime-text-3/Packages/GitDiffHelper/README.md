GitDiffHelper
=============

Sublime text plugin that open files modified since a commit.

Sometimes you want to upload only modified files because a full sync of your project is to heavy, this plugin will help you. Just enter the commit ID from which you want to upload files, then all modified files are opened. You just have to use "Upload Open Files" functionality of [SFTP plugin](http://wbond.net/sublime_packages/sftp).
Modified files are also displayed as a list in a panel so you can do anything you want with this list.

Installation
============

- If you have Package Control installed in Sublime just press `ctrl + shift + p` (Windows, Linux) or `⌘ + shift + p` (OS X) to open the Command Pallete. Start typing 'install' to select `Package Control: Install Package`, then search for `GitDiffHelper` and select it.
- Otherwise clone source code to Sublime Text packages folder.

Usage
=====

Use one of the following:
- Bring up the command palette (it's `⌘ + shift + p`  in OS X and `ctrl + shift + p` in Windows or Linux) and type `gitdiffhelper` and select `GitDiffHelper: Launch it` command.
- Use `ctrl + alt + g`

If plugin can't find your git repository at the root of your main folder you'll be asked to enter path of your git repository:
![](https://lh6.googleusercontent.com/-9LhNHscWaXE/U8eMWIROUOI/AAAAAAAACAM/_JK-g8M1cuo/w686-h45-no/gdh_readme_1.png)

Otherwise you'll be asked to enter a commit id:
![](https://lh6.googleusercontent.com/-ZiL65VpPOBo/U8eNoTUp3YI/AAAAAAAACAg/4UEwa8wOwUE/w394-h30-no/gdh_readme_2.png)

- If you leave it blank only files of the last commit of your current branch will be opened/displayed otherwise, all files modified from commit ID entered to your last commit will be opened/displayed.
- Files of the git commit ID entered are included.
- If more than 10 files are modified, you'll be asked to confirm files opening.

Credits
=======

* [Scopart](http://www.scopart.fr)
* https://github.com/gitpython-developers/GitPython