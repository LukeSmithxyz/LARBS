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

cmd=(dialog --separate-output --checklist "Select additional packages to install with <SPACE>:" 22 76 16)
options=(1 "LaTeX packages" off
         2 "Libreoffice Suite" off
         3 "GIMP" off
         4 "Blender" off
	 5 "Emacs" off
	 6 "Fonts for Asian languages and emojis" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
printf "\n${BLUE}Now installing main programs.\n${NC}"
pacman --noconfirm --needed -S base-devel xorg-xinit xorg-server rxvt-unicode feh ffmpeg pulseaudio pulseaudio-alsa arandr pavucontrol pamixer mpv wget rofi vim w3m ranger mediainfo poppler highlight tmux calcurse htop newsbeuter mpd mpc ncmpcpp network-manager-applet networkmanager imagemagick transmission-cli atool libcaca compton transset-df markdown mupdf evince rsync git youtube-dl youtube-viewer cups screenfetch scrot unzip unrar ntfs-3g offlineimap msmtp notmuch notmuch-mutt dosfstools fzf r pandoc
for choice in $choices
do
    case $choice in
        1)
	    printf "\n${BLUE}Now installing LaTeX packages...\n${NC}"
	    pacman --noconfirm --needed -S texlive-most texlive-lang biber
            ;;
        2)
	    printf "\n${BLUE}Now installing Libreoffice suite...\n${NC}"
	    pacman --noconfirm --needed -S libreoffice-fresh
            ;;
        3)
	    printf "\n${BLUE}Now installing GIMP...\n${NC}"
	    pacman --noconfirm --needed -S gimp
            ;;
        4)
	    printf "\n${BLUE}Now installing Blender...\n${NC}"
	    pacman --noconfirm --needed -S blender
            ;;
    5)
	    printf "\n${BLUE}Now installing Emacs...\n${NC}"
	    pacman --noconfirm --needed -S emacs
	    ;;
    6)
	    printf "\n${BLUE}Now installing extra fonts...\n${NC}"
	    pacman --noconfirm --needed -S noto-fonts-cjk noto-fonts-emoji
	    ;;
    esac
done

brow=(dialog --separate-output --checklist "Select a browser (none or multiple possible):" 22 76 16)
options=(1 "qutebrowser" off    # any option can be set to default to "on"
         2 "Firefox" off
         #3 "Palemoon" off
         #4 "Firefox" off
	 )
browch=$("${brow[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $browch
do
    case $choice in
        1)
	    printf "\n${BLUE}Now installing qutebrowser...\n${NC}"
	    pacman --noconfirm --needed -S qutebrowser gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
            ;;
        2)
	    printf "\n${BLUE}Now installing Firefox...\n${NC}"
	    pacman --noconfirm --needed -S firefox
            ;;
        3)
	    printf "\n${BLUE}Now installing Palemoon...\n${NC}"
	    pacman --noconfirm --needed -S palemoon-bin
            ;;
        4)
	    printf "\n${BLUE}Now installing Waterfox...\n${NC}"
	    pacman --noconfirm --needed -S waterfox-bin
            ;;
    esac
done

#pacman --noconfirm --needed -S projectm-pulseaudio

printf "${BLUE}Enabling Network Manager...\n${NC}"
systemctl enable NetworkManager
systemctl start NetworkManager

printf "${BLUE}Downloading next portion of script...\n${NC}"
curl http://lukesmith.xyz/larbs/user.sh > /home/$USER/user.sh

printf "${BLUE}Running script as new user $USER...\n${NC}"
cp /etc/sudoers /etc/sudoers.prelarbs
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo -u $USER bash /home/$USER/user.sh

echo -e "root ALL=(ALL) ALL\n%wheel ALL=(ALL) ALL\n%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager\nDefaults !tty_tickets" > /etc/sudoers

dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 12 80
clear
