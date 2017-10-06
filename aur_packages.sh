#!/bin/bash

blue() { printf "\033[0;34m $* \033[0m\n" && (echo $* >> LARBS.log) ;}
red() { printf "\033[0;31m $* \033[0m\n" && (echo ERROR: $* >> LARBS.log) ;}

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
		(packer --noconfirm -S $arg && printf "${BLUE}\n$arg now installed.\n${NC}") || red Error installing $arg.
	else
		(aurinstall $arg && printf "${BLUE}\n$arg now installed.\n${NC}") || red Error installing $arg.
	fi

fi
done
}

blue Changing directory to /home/$USER...
cd /home/$USER || red Could not cd to /home/$USER. Does user and home directory exist?

blue Installing AUR programs...

blue \(This may take some time.\)

#Add the needed gpg key for neomutt
gpg --recv-keys 5FAF0A6EE7371805

aurcheck packer i3-gaps vim-pathogen neofetch tamzen-font-git neomutt unclutter-xfixes-git urxvt-resize-font-git polybar-git python-pywal xfce-theme-blackbird 
#Also installing i3lock, since i3-gaps was only just now installed.
sudo pacman -S i3lock

#packer --noconfirm -S ncpamixer-git speedometer cli-visualizer

choices=$(cat .choices)
for choice in $choices
do
    case $choice in
        1)
		printf "\n${BLUE}Now installing LaTeX packages...\n${NC}"
		aurcheck vim-live-latex-preview
		git clone https://github.com/lukesmithxyz/latex-templates.git && mkdir -p /home/$USER/Documents/LaTeX && rsync -va latex-templates /home/$USER/Documents/LaTeX && rm -rf latex-templates
        	;;
	6)
		printf "\n${BLUE}Now installing extra fonts...\n${NC}"
		aurcheck ttf-ancient-fonts
		;;
	7)
	    printf "\n${BLUE}Now installing transmission-remote-cli...\n${NC}"
		aurcheck transmission-remote-cli-git
		;;
    esac
done
browsers=$(cat .browch)
for choice in $browsers
do
	case $choice in
		3)
			printf "\n${BLUE}Now installing Palemoon...\n${NC}"
			$ gpg --recv-keys 865E6C87C65285EC
			aurcheck palemoon-bin
			;;
		4)
			printf "\n${BLUE}Now installing Waterfox...\n${NC}"
			aurcheck waterfox-bin
			;;
	esac
done
