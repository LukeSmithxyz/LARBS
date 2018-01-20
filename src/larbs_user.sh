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

cat << "EOF"
   [0;1;33;93mm[0;1;32;92mm[0m   [0;1;34;94mm[0m    [0;1;31;91mm[0m [0;1;33;93mm[0;1;32;92mmm[0;1;36;96mmm[0m        [0;1;32;92mmm[0;1;36;96mmm[0;1;34;94mmm[0;1;35;95mm[0m [0;1;31;91mmm[0;1;33;93mmm[0;1;32;92mm[0m  [0;1;36;96mm[0m    [0;1;31;91mm[0m [0;1;33;93mmm[0;1;32;92mmm[0;1;36;96mmm[0m   [0;1;35;95mm[0m
   [0;1;32;92m#[0;1;36;96m#[0m   [0;1;35;95m#[0m    [0;1;33;93m#[0m [0;1;32;92m#[0m   [0;1;34;94m"[0;1;35;95m#[0m          [0;1;34;94m#[0m      [0;1;32;92m#[0m    [0;1;34;94m#[0;1;35;95m#[0m  [0;1;31;91m#[0;1;33;93m#[0m [0;1;32;92m#[0m        [0;1;31;91m#[0m
  [0;1;36;96m#[0m  [0;1;34;94m#[0m  [0;1;31;91m#[0m    [0;1;32;92m#[0m [0;1;36;96m#[0;1;34;94mmm[0;1;35;95mmm[0;1;31;91m"[0m          [0;1;35;95m#[0m      [0;1;36;96m#[0m    [0;1;35;95m#[0m [0;1;31;91m#[0;1;33;93m#[0m [0;1;32;92m#[0m [0;1;36;96m#m[0;1;34;94mmm[0;1;35;95mmm[0m   [0;1;33;93m#[0m
  [0;1;34;94m#m[0;1;35;95mm#[0m  [0;1;33;93m#[0m    [0;1;36;96m#[0m [0;1;34;94m#[0m   [0;1;31;91m"[0;1;33;93mm[0m          [0;1;31;91m#[0m      [0;1;34;94m#[0m    [0;1;31;91m#[0m [0;1;33;93m"[0;1;32;92m"[0m [0;1;36;96m#[0m [0;1;34;94m#[0m        [0;1;32;92m"[0m
 [0;1;34;94m#[0m    [0;1;33;93m#[0m [0;1;32;92m"m[0;1;36;96mmm[0;1;34;94mm"[0m [0;1;35;95m#[0m    [0;1;32;92m"[0m          [0;1;33;93m#[0m    [0;1;34;94mmm[0;1;35;95m#m[0;1;31;91mm[0m  [0;1;33;93m#[0m    [0;1;34;94m#[0m [0;1;35;95m#m[0;1;31;91mmm[0;1;33;93mmm[0m   [0;1;36;96m#[0m
EOF


gpg --recv-keys 5FAF0A6EE7371805 #Add the needed gpg key for neomutt

aurcheck packer i3-gaps siji-git vim-pathogen neomutt unclutter-xfixes-git polybar  xfce-theme-blackbird || red Error with basic AUR installations...
#Also installing i3lock, since i3-gaps was only just now installed.
sudo pacman -S --noconfirm --needed i3lock

packer --noconfirm -S ncpamixer-git

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

blue Downloading config files...
git clone -b testing https://github.com/lukesmithxyz/voidrice.git && rsync -va voidrice/ /home/$NAME && rm -rf voidrice

curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/testing/src/welcome_i3 >> /home/$NAME/.config/i3/config

blue Generating bash/ranger/qutebrowser shortcuts...
bash /home/$NAME/.config/Scripts/shortcuts.sh
