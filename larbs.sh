#!/bin/bash
pacman -S --noconfirm --needed dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)

blue() { printf "\033[0;34m $* \033[0m\n" && (chmod 777 LARBS.log && echo $* >> LARBS.log) ;}
red() { printf "\033[0;31m $* \033[0m\n" && (chmod 777 LARBS.log && echo ERROR: $* >> LARBS.log) ;}

dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\n\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\n\n-Luke" 10 60

dialog --no-cancel --inputbox "First, please enter a name for the user account." 10 60 2> .name

dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 2> .pass1
dialog --no-cancel --passwordbox "Reype password." 10 60 2> .pass2

while [ $(cat .pass1) != $(cat .pass2) ]
do
	dialog --no-cancel --passwordbox "Passwords do not match.\n\nEnter password again." 10 60 2> .pass1
	dialog --no-cancel --passwordbox "Reype password." 10 60 2> .pass2
done

NAME=$(cat .name)
chmod 777 .name
useradd -m -g wheel -s /bin/bash $NAME

echo "$NAME:$(cat .pass1)" | chpasswd
#I shred the password for safety's sake.
shred -u .pass1
shred -u .pass2

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
#rm -f /home/$NAME/.choices #Needed if write protected from root script.
echo $choices > /home/$NAME/.choices && chmod 777 /home/$NAME/.choices

brow=(dialog --separate-output --checklist "Select a browser (none or multiple possible):" 22 76 16)
options=(1 "qutebrowser" off    # any option can be set to default to "on"
         2 "Firefox" off
         3 "Palemoon" off
         4 "Waterfox" off
	 )
browch=$("${brow[@]}" "${options[@]}" 2>&1 >/dev/tty)
#rm -f /home/$NAME/.browch #Needed if write protected from root script.
echo $browch > /home/$NAME/.browch &&chmod 777 /home/$NAME/.browch

#If this is the first run, install all core programs.
dialog --title "Let's get this party started!" --msgbox "The rest of the installation will now be totally automated, so you can sit back and relax.\n\nIt will take some time, but when done, you'll can relax even more with your complete system.\n\nNow just press <OK> and the system will begin installation!" 13 60

blue Now installing main programs...

sudo pacman --noconfirm --needed -S base-devel xorg-xinit xorg-server rxvt-unicode feh ffmpeg pulseaudio pulseaudio-alsa arandr pavucontrol pamixer mpv wget rofi vim w3m ranger mediainfo poppler highlight tmux calcurse htop newsbeuter mpd mpc ncmpcpp network-manager-applet networkmanager imagemagick atool libcaca compton transset-df markdown mupdf evince rsync git youtube-dl youtube-viewer cups screenfetch scrot unzip unrar ntfs-3g offlineimap msmtp notmuch notmuch-mutt dosfstools fzf r pandoc || (red Error installing basic packages. Check your internet connection and pacman keyring.)

for choice in $choices
do
    case $choice in
        1)
	    blue Now installing LaTeX packages...
	    sudo pacman --noconfirm --needed -S texlive-most texlive-lang biber
            ;;
        2)
	    blue Now installing LibreOffice Suite...
	    sudo pacman --noconfirm --needed -S libreoffice-fresh
            ;;
        3)
	    blue Now installing GIMP...
	    sudo pacman --noconfirm --needed -S gimp
            ;;
        4)
	    blue Now installing Blender...
	    sudo pacman --noconfirm --needed -S blender
            ;;
	5)
	    blue Now installing Emacs...
	    sudo pacman --noconfirm --needed -S emacs
	    ;;
	6)
	    blue Now installing extra fonts...
	    sudo pacman --noconfirm --needed -S noto-fonts-cjk noto-fonts-emoji
	    ;;
	7)
	    blue Now installing transmission...
	    sudo pacman --noconfirm --needed -S transmission-cli
    esac
done

for choice in $browch
do
    case $choice in
        1)
		blue Now installing qutebrowser...
	    sudo pacman --noconfirm --needed -S qutebrowser gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
            ;;
        2)
		blue Now installing Firefox...
	    sudo pacman --noconfirm --needed -S firefox
            ;;
    esac
done

#Packages I may later add:
#pacman --noconfirm --needed -S projectm-pulseaudio

blue Downloading next portion of the script \(larbs_user.sh\)...
chmod 777 /
curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/larbs_user.sh > /home/$NAME/larbs_user.sh && blue Running larbs_user.sh script as $NAME...
sudo -u $NAME bash /home/$NAME/larbs_user.sh || red Error when running larbs_user.sh...
rm -f /home/$NAME/larbs_user.sh

printf "${BLUE}Enabling Network Manager...\n${NC}"
systemctl enable NetworkManager
systemctl start NetworkManager


curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/sudoers > /etc/sudoers 

dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 12 80
clear
