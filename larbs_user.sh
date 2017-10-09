#!/bin/bash

blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/LARBS.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/LARBS.log) ;}

NAME=$(whoami)

blue Activating Pulseaudio if not already active...
pulseaudio --start && blue Pulseaudio enabled...

#Install an AUR package manually.
aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. && rm -rf $1 $1.tar.gz ;}

#aurcheck runs on each of its arguments, if the argument is not already installed, it either uses packer to install it, or installs it manually.
aurcheck() {
qm=$(pacman -Qm | awk '{print $1}')
for arg in "$@"
do
if [[ $qm = *"$arg"* ]]; then
	echo $arg is already installed.
else 
	echo $arg not installed
	blue Now installing $arg...
	if [[ -e /usr/bin/packer ]]
	then
		(packer --noconfirm -S $arg && blue $arg now installed) || red Error installing $arg.
	else
		(aurinstall $arg && blue $arg now installed) || red Error installing $arg.
	fi

fi
done
}


blue Installing AUR programs...
blue \(This may take some time.\)

cowsay -f bud-frogs "Now installing AUR programs."

gpg --recv-keys 5FAF0A6EE7371805 #Add the needed gpg key for neomutt

aurcheck packer i3-gaps vim-pathogen tamzen-font-git neomutt unclutter-xfixes-git urxvt-resize-font-git polybar-git python-pywal xfce-theme-blackbird || red Error with basic AUR installations...
#Also installing i3lock, since i3-gaps was only just now installed.
sudo pacman -S --noconfirm --needed i3lock

#packer --noconfirm -S ncpamixer-git speedometer cli-visualizer

choices=$(cat /tmp/.choices)
for choice in $choices
do
    case $choice in
        1)
		aurcheck vim-live-latex-preview
		git clone https://github.com/lukesmithxyz/latex-templates.git && mkdir -p /home/$NAME/Documents/LaTeX && rsync -va latex-templates /home/$NAME/Documents/LaTeX && rm -rf latex-templates
        	;;
	6)
		aurcheck ttf-ancient-fonts
		;;
	7)
		aurcheck transmission-remote-cli-git
		;;
	8)
		aurcheck bash-pipes cli-visualizer speedometer neofetch
		;;
    esac
done
cat << "EOF"

         ▄              ▄
        ▌▒█           ▄▀▒▌
        ▌▒▒▀▄       ▄▀▒▒▒▐
       ▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
     ▄▄▀▒▒▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
   ▄▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀██▀▒▌
  ▐▒▒▒▄▄▄▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄▒▒▌
  ▌▒▒▐▄█▀▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
 ▐▒▒▒▒▒▒▒▒▒▒▒▌██▀▒▒▒▒▒▒▒▒▀▄▌
 ▌▒▀▄██▄▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▌
 ▌▀▐▄█▄█▌▄▒▀▒▒▒▒▒▒░░░░░░▒▒▒▐
▐▒▀▐▀▐▀▒▒▄▄▒▄▒▒▒▒▒░░░░░░▒▒▒▒▌
▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒░░░░░░▒▒▒▐
 ▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒▒▒░░░░▒▒▒▒▌
 ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐
  ▀▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▒▒▌
    ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
   ▐▀▒▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
  ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▀

EOF



browsers=$(cat /tmp/.browch)
for choice in $browsers
do
	case $choice in
		3)
			gpg --recv-keys 865E6C87C65285EC #Key required for Palemoon install.
			aurcheck palemoon-bin
			;;
		4)
			aurcheck waterfox-bin
			;;
	esac
done

blue Downloading config files...
git clone https://github.com/lukesmithxyz/voidrice.git && rsync -va voidrice/ /home/$NAME && rm -rf voidrice

blue Generating bash/ranger/qutebrowser shortcuts...
cd /home/$NAME/
python /home/$NAME/.config/Scripts/shortcuts.py
