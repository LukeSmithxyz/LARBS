#!/bin/bash

blue() { printf "\033[0;34m $* \033[0m\n" && (sudo echo $* >> LARBS.log) ;}
red() { printf "\033[0;31m $* \033[0m\n" && (sudo echo ERROR: $* >> LARBS.log) ;}

USER=$(cat .firstrun)
blue Changing directory to /home/$USER...

cd /home/$USER

blue Activating Pulseaudio if not already active...
pulseaudio --start && blue Pulseaudio enabled...

sudo sh -c "curl -O http://lukesmith.xyz/larbs/aur_install.sh && bash aur_install.sh"
rm aur_install.sh

blue Downloading config files...
git clone https://github.com/lukesmithxyz/voidrice.git && rsync -va voidrice/ /home/$USER && rm -rf voidrice

blue Generating bash/ranger/qutebrowser shortcuts...
python ~/.config/Scripts/shortcuts.py
