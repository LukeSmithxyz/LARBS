#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
printf "${BLUE}Changing directory to /home/$USER...\n${NC}"
cd /home/$USER

printf "${BLUE}Activating Pulseaudio if not already active...\n${NC}"
pulseaudio --start


printf "${BLUE}Installing packer as an AUR manager...\n${NC}"

aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. && rm -rf $1 $1.tar.gz ;}

aurinstall packer || echo "Error installing packer." && exit

printf "${BLUE}Installing AUR programs...\n${NC}"
printf "${BLUE}(May take some time.)\n${NC}"
packer --noconfirm -S i3-gaps vim-pathogen vim-live-latex-preview neofetch i3lock tamzen-font-git neomutt transmission-remote-cli-git unclutter-xfixes-git urxvt-resize-font-git ttf-ancient-fonts polybar-git python-pywal xfce-theme-blackbird || echo "Error installing AUR packages. Check your internet connections and pacman keys." && exit
#packer --noconfirm -S ncpamixer-git speedometer cli-visualizer

printf "${BLUE}Downloading config files...\n${NC}"
git clone https://github.com/lukesmithxyz/voidrice.git && rsync -va voidrice/ /home/$USER && rm -rf voidrice
git clone https://github.com/lukesmithxyz/latex-templates.git && mkdir -p /home/$USER/Documents/LaTeX && rsync -va latex-templates /home/$USER/Documents/LaTeX && rm -rf latex-templates

printf "${BLUE}Generating bash/ranger/qutebrowser shortcuts...\n${NC}"
python ~/.config/Scripts/shortcuts.py
