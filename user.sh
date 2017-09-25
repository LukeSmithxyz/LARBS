#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
printf "${BLUE}Changing directory to /home/$USER...\n${NC}"
cd /home/$USER

printf "${BLUE}Activating Pulseaudio if not already active...\n${NC}"
pulseaudio --start


printf "${BLUE}Installing packer as an AUR manager...\n${NC}"
wget https://aur.archlinux.org/cgit/aur.git/snapshot/packer.tar.gz
tar -xvzf packer.tar.gz
cd packer
makepkg --noconfirm -si
cd ..
rm -rf packer/
rm packer.tar.gz

printf "${BLUE}Installing AUR programs...\n${NC}"
printf "${BLUE}(May take some time.)\n${NC}"
packer --noconfirm -S cli-visualizer i3-gaps vim-pathogen vim-live-latex-preview neofetch i3lock tamzen-font-git speedometer neomutt transmission-remote-cli-git ncpamixer-git unclutter-xfixes-git urxvt-resize-font-git ttf-ancient-fonts polybar-git python-pywal xfce-theme-blackbird

printf "${BLUE}Downloading config files...\n${NC}"
git clone https://github.com/lukesmithxyz/voidrice.git
rsync -va --delete-after voidrice/ /home/$USER
git clone https://github.com/lukesmithxyz/latex-templates.git
mkdir -p /home/$USER/Documents/LaTeX
rsync -va --delete-after latex-templates /home/$USER/Documents/LaTeX
sudo rm -rf voidrice
sudo rm -rf latex-templates
printf "${BLUE}Generating bash/ranger/qutebrowser shortcuts...\n${NC}"
python ~/.config/Scripts/shortcuts.py
