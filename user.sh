#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
printf "${BLUE}Changing directory to /home/$USER...\n${NC}"
cd /home/$USER

error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 && clear && exit ;}

printf "${BLUE}Activating Pulseaudio if not already active...\n${NC}"
pulseaudio --start

curl -O http://lukesmith.xyz/larbs/aur_install.sh && bash aur_install.sh
rm aur_install.sh

printf "${BLUE}Downloading config files...\n${NC}"
git clone https://github.com/lukesmithxyz/voidrice.git && rsync -va voidrice/ /home/$USER && rm -rf voidrice

printf "${BLUE}Generating bash/ranger/qutebrowser shortcuts...\n${NC}"
python ~/.config/Scripts/shortcuts.py
