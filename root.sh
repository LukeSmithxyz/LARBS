#!/bin/bash
pacman -S --noconfirm dialog
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
#printf "This should have ${BLUE}Blue\n${NC} and ${RED}Red${NC} text."
#printf "\n${BLUE}Now installing main programs...\n${NC}\n"
dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\n\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\n\n-Luke" 10 60

dialog --no-cancel --inputbox "First, please enter a name for the user account." 10 60 2> name
clear 
dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 2> pass1
dialog --no-cancel --passwordbox "Reype password." 10 60 2> pass2

while [ $(cat pass1) != $(cat pass2) ]
do
	dialog --no-cancel --passwordbox "Passwords do not match.\n\nEnter password again." 10 60 2> pass1
	dialog --no-cancel --passwordbox "Reype password." 10 60 2> pass2
done

USER=$(cat name)
rm name
useradd -m -g wheel -s /bin/bash $USER

echo "$USER:$(cat pass1)" | chpasswd
#I shred the password for safety's sake.
shred -u pass1
shred -u pass2
printf "${BLUE}Now installing main programs.\n${NC}"
pacman --noconfirm --needed -S base-devel xorg-xinit xorg-server rxvt-unicode feh ffmpeg pulseaudio pulseaudio-alsa arandr pavucontrol pamixer mpv wget rofi vim w3m ranger mediainfo poppler highlight tmux calcurse htop newsbeuter mpd mpc ncmpcpp network-manager-applet networkmanager qutebrowser imagemagick transmission-cli atool libcaca compton transset-df blender gimp texlive-most texlive-lang markdown mupdf evince rsync git youtube-dl youtube-viewer noto-fonts-cjk noto-fonts-emoji cups screenfetch scrot unzip unrar biber ntfs-3g offlineimap msmtp notmuch notmuch-mutt dosfstools fzf r

printf "${BLUE}Enabling Network Manager...\n${NC}"
systemctl enable NetworkManager
systemctl start NetworkManager

printf "${BLUE}Downloading next portion of script...\n${NC}"
curl http://lukesmith.xyz/larbs/user.sh > /home/$USER/user.sh

printf "${BLUE}Running script as new user $USER...\n${NC}"
cp /etc/sudoers /etc/sudoers.prelarbs
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo -u $USER bash /home/$USER/user.sh
curl http://lukesmith.xyz/larbs/sudoers > /etc/sudoers
dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 10 60
