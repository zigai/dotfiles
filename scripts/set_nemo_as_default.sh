#!/bin/bash
# https://askubuntu.com/questions/1066752/how-to-set-nemo-as-the-default-file-manager-in-ubuntu

xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true

# Then also install these tools so we can adjust some settings next
sudo apt install dconf-editor gnome-tweaks

# Start up the nemo desktop to allow nemo to control the desktop icons too
nemo-desktop&  # We use `&` here to run it in the background