
# Contents

## dotfiles
Settings for:
- bash
- fish



## packages
Inside the ```packages``` folder there are lists of packages that can be install with the ```./INSTALL``` script.

Package lists are structured package manager name inside brackets followed by package name to install with it, each on a new line.

Example:
```
[apt]
tmux
curl

[brew]
jq
```
Currently supported package managers: ```apt, brew, pip, scoop, snap, flatpak and code (Visual Studio Code)```.

Support for new package managers can easily be added by inheriting from ```PackageManager``` class inside the ```./INSTALL``` script.

## bin
Inside the ```bin``` folder there are few usefull scripts that you can add to your ```$PATH```.

## scripts
Inside the ```scripts``` folder there are some scripts that you will most likely only run once. 
Most of them just install programs that can't be installed with a package manager.

## vscode
My Visual Studio Code ```settings.json``` and snippets.

# Install script usage
```
usage: ./INSTALL [-h] [-bin] [-dotfiles] [-dev] [-essential] [-gui] [-tools] [-virtualbox_guest]
options:
  -h, --help         show this help message and exit
  -bin               Add scripts inside './bin' to your $PATH
  -dotfiles          Install dotfiles
  -dev               Install packages listed in './packages/dev.txt'
  -essential         Install packages listed in './packages/essential.txt'
  -gui               Install packages listed in './packages/gui.txt'
  -tools             Install packages listed in './packages/tools.txt'
  -virtualbox_guest  Install packages listed in './packages/virtualbox_guest.txt'
```
# License
[MIT License](https://github.com/zigai/dotfiles/blob/master/LICENSE)
