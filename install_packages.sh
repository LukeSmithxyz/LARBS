#!/bin/bash
pacman -S --noconfirm dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 && clear && exit ;}

cmd=(dialog --separate-output --checklist "Select additional packages to install with <SPACE>:" 22 76 16)
options=(1 "LaTeX packages" off
         2 "Libreoffice Suite" off
         3 "GIMP" off
         4 "Blender" off
	 5 "Emacs" off
	 6 "Fonts for unicode and other languages" off
	 7 "transmission torrent client" off
	 )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $choices > /home/$USER/choices
clear

brow=(dialog --separate-output --checklist "Select a browser (none or multiple possible):" 22 76 16)
options=(1 "qutebrowser" off    # any option can be set to default to "on"
         2 "Firefox" off
         3 "Palemoon" off
         4 "Waterfox" off
	 )
browch=$("${brow[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $browch > /home/$USER/browch
clear

#If this is the first run, install all core programs.
if [[ -e .firstrun ]]
then
	dialog --title "Let's get this party started!" --msgbox "The rest of the installation will now be totally automated, so you can sit back and relax.\n\nIt will take some time, but when done, you'll can relax even more with your complete system.\n\nNow just press <OK> and the system will begin installation!" 13 60
	printf "\n${BLUE}Now installing main programs.\n${NC}"
	pacman --noconfirm --needed -S base-devel xorg-xinit xorg-server rxvt-unicode feh ffmpeg pulseaudio pulseaudio-alsa arandr pavucontrol pamixer mpv wget rofi vim w3m ranger mediainfo poppler highlight tmux calcurse htop newsbeuter mpd mpc ncmpcpp network-manager-applet networkmanager imagemagick atool libcaca compton transset-df markdown mupdf evince rsync git youtube-dl youtube-viewer cups screenfetch scrot unzip unrar ntfs-3g offlineimap msmtp notmuch notmuch-mutt dosfstools fzf r pandoc || (echo "Error installing basic packages. Check your internet connection and pacman keyring." >> LARBS.log && error)
fi

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
	7)
	    printf "\n${BLUE}Now installing transmission...\n${NC}"
	    pacman --noconfirm --needed -S transmission-cli
    esac
done

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

if [[ -e .firstrun ]]
then
	printf "${BLUE}Downloading next portion of script...\n${NC}"
	curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/user.sh > /home/$USER/user.sh 
	printf "${BLUE}Running script as new user $USER...\n${NC}"
	sudo -u $USER bash /home/$USER/user.sh || (echo "Error in the user install script. This might be because of a problem in your internet connection or pacman keyring or in an AUR package." >> LARBS.log && error)
	cat /home$USER/LARBS.log >> LARBS.log && rm /home/$USER/LARBS.log
	rm /home/$USER/user.sh
else
	printf "${BLUE}Downloading next portion of script...\n${NC}"
	curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/aur_packages.sh > /home/$USER/aur_packages.sh 
	printf "${BLUE}Running script as new user $USER...\n${NC}"
	sudo -u $USER bash /home/$USER/aur_packages.sh || (echo "Error in the user install script. This might be because of a problem in your internet connection or pacman keyring or in an AUR package." >> LARBS.log && error)
	cat /home$USER/LARBS.log >> LARBS.log && rm /home/$USER/LARBS.log
	rm /home/$USER/aur_packages.sh
fi

clear
