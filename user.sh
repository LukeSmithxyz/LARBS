#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
blue Changing directory to /home/$USER...
cd /home/$USER

error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 && clear && exit ;}

blue Activating Pulseaudio if not already active...
pulseaudio --start

#curl -O http://lukesmith.xyz/larbs/aur_install.sh && bash aur_install.sh
#rm aur_install.sh
curl -O http://lukesmith.xyz/larbs/install_packages.sh
bash install_packages.sh

blue Downloading config files...
git clone https://github.com/lukesmithxyz/voidrice.git && rsync -va voidrice/ /home/$USER && rm -rf voidrice

blue Generating bash/ranger/qutebrowser shortcuts...
python ~/.config/Scripts/shortcuts.py
