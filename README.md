
# Contents

## dotfiles
Settings for:
- bash
- fish
- Visual Studio Code


## packages
In the ```packages``` folder, you'll find lists of packages that can be installed using the ```./INSTALL``` script. 
The lists are organized with the package manager name in brackets followed by the package name, each on a separate line.


Example:
```
[apt]
tmux
curl

[brew]
jq
```
Currently supported package managers: ```apt, brew, pip, scoop, snap, flatpak, cargo and code (Visual Studio Code)```.

Support for new package managers can easily be added by inheriting from ```PackageManager``` class that is inside the ```./INSTALL``` script.

## bin
Inside the ```bin``` folder, there are a few useful scripts that you can add to your ```$PATH```.

## scripts
The ```scripts``` folder contains scripts that are probably intended to be executed only once, mostly to install programs that cannot be installed using a package manager.


# Install script usage
```
usage: ./INSTALL [-h] [-bin] [-dotfiles] [-dev] [-essential] [-gui] [-tools] [-virtualbox_guest]

options:
  -h, --help         show this help message and exit
  -bin               add scripts inside './bin' to your $PATH
  -dotfiles          install dotfiles
  -dev               install packages listed in './packages/dev.txt'
  -essential         install packages listed in './packages/essential.txt'
  -gui               install packages listed in './packages/gui.txt'
  -tools             install packages listed in './packages/tools.txt'
  -virtualbox_guest  install packages listed in './packages/virtualbox_guest.txt'
```
# License
[MIT License](https://github.com/zigai/dotfiles/blob/master/LICENSE)
