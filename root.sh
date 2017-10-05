#!/bin/bash
pacman -S --noconfirm dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 && clear && exit ;}

dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\n\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\n\n-Luke" 10 60

dialog --no-cancel --inputbox "First, please enter a name for the user account." 10 60 2> name
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

touch .firstime
curl -O http://lukesmith.xyz/larbs/install_packages.sh && bash install_packages.sh
rm .firstime

printf "${BLUE}Enabling Network Manager...\n${NC}"
systemctl enable NetworkManager
systemctl start NetworkManager


curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/sudoers > /etc/sudoers 

dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 12 80
clear
