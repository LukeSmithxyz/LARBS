#!/bin/bash

# You can provide a custom repository with -r or a custom programs csv with -p.
# Otherwise, the script will use my defaults.

while getopts ":r:p:h" o; do
	case "${o}" in
	h)
		echo -e "Optional arguments for custom use:\n-r: Dotfiles repository\n-p: Dependencies and programs csv" && exit ;;
	r)
		dotfilesrepo=${OPTARG} ;;
	p)
		progsfile=${OPTARG} ;;
	*)
		echo "-$OPTARG is not a valid option." && exit ;;
	esac
done

[ -z ${dotfilesrepo+x} ] && dotfilesrepo="https://github.com/lukesmithxyz/voidrice.git"
[ -z ${progsfile+x} ] && progsfile="https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/progs.csv"

pacman -S --noconfirm --needed dialog || { echo "Error at script start: Are you sure you're running this as the root user? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection?"; exit; }
dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\n\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\n\n-Luke" 10 60

name=$(dialog --no-cancel --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1)

re="^[a-z_][a-z0-9_-]*$"
while ! [[ "${name}" =~ ${re} ]]; do
	name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - and _." 10 60 3>&1 1>&2 2>&3 3>&1)
done

pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)

while [ $pass1 != $pass2 ]
do
	pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\n\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	unset pass2
done

dialog --infobox "Adding user \"$name\"..." 4 50
useradd -m -g wheel -s /bin/bash $name
echo "$name:$pass1" | chpasswd

dialog --title "Let's get this party started!" --msgbox "The rest of the installation will now be totally automated, so you can sit back and relax.\n\nIt will take some time, but when done, you can relax even more with your complete system.\n\nNow just press <OK> and the system will begin installation!" 13 60 || { clear; exit; }

dialog --infobox "Refreshing Arch Keyring..." 4 40
pacman --noconfirm -Sy archlinux-keyring &>/dev/null

# Give packerwrapper a list of programs. Finds only those needing installation
# then, it sorts them into $mainqueue and $aurqueue for progs installable from
# main repo or AUR.
posprogs=$(pacman -Sl | awk '{print $2}')
packerwrapper() { \
	for arg in "$@"
	do
		pacman -Q "$arg" &>/dev/null && continue
		pacman -Qg "$arg" &>/dev/null && continue
		grep "^$arg$" <<< $posprogs &>/dev/null  && mainqueue="$mainqueue $arg" && continue
		aurqueue="$aurqueue $arg"
	done ;}

dialog --infobox "Getting program list..." 4 40
packerwrapper $(curl -sL $progsfile | grep ^, | cut -d ',' -f2)

count=$(echo "$mainqueue" | wc -w)

for x in $mainqueue
do
	n=$((n+1))
	dialog --title "LARBS Installation" --infobox "Downloading and installing program $n out of $count: $x...\n\nThe first programs will take more time due to dependencies." 8 70
	pacman --noconfirm --needed -S "$x" &>/dev/null
done

sed -e "/#LARBS/d" /etc/sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL #LARBS" >> /etc/sudoers

[[ -f /usr/bin/packer ]] || (
	dialog --infobox "Installing \"packer\", an AUR helper..." 10 60
	cd /tmp
	rm -rf /tmp/packer*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/packer.tar.gz &&
	sudo -u $name tar -xvf packer.tar.gz &>/dev/null &&
	cd packer &&
	sudo -u $name makepkg --noconfirm -si &>/dev/null
	cd /tmp)

count=$(echo "$aurqueue" | wc -w)

n=0
for prog in $aurqueue
do
	n=$((n+1))
	dialog --infobox "Downloading and installing program $n out of $count: $prog..." 10 60
	sudo -u $name packer -S --noconfirm "$prog" &>/dev/null
done

# Downloading and installing dotfiles
dialog --infobox "Downloading and installing config files..." 4 60
rm -rf /tmp/dotfiles/
sudo -u $name git clone --depth 1 $dotfilesrepo /tmp/dotfiles &>/dev/null &&
	sudo -u $name rsync -rl /tmp/dotfiles/ /home/$name

sudo -u $name curl -s https://raw.githubusercontent.com/LukeSmithxyz/shortcut-sync/master/shortcuts.sh > /home/$name/.scripts/shortcuts.sh && chown $name:wheel /home/$name/.scripts/shortcuts.sh && chmod +x /home/$name/.scripts/shortcuts.sh

dialog --infobox "Preparing welcome message..." 4 50
echo "exec_always --no-startup-id notify-send -i ~/.scripts/larbs.png '<b>Welcome to LARBS:</b> Press Super+F1 for the manual.' -t 10000"  >> /home/$name/.config/i3/config

dialog --infobox "Reseting Pulseaudio..." 4 50
killall pulseaudio
sudo -u $name pulseaudio --start

# For installing programs via git. Give full url as argument
gitinstall() { \
	dir=$(mktemp -d)
	dialog --infobox "Installing \"$(basename $1)\" from source..." 4 40
	git clone --depth 1 "$1" $dir
	cd $dir
	make
	make install
	}

gitinstall https://github.com/lukesmithxyz/st.git &>/dev/null

gitinstall https://github.com/lukesmithxyz/dmenu.git &>/dev/null

dialog --infobox "Enabling Network Manager..." 4 40
systemctl enable NetworkManager
systemctl start NetworkManager

dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

dialog --infobox "Updating sudoers file..." 4 40
sed -e "/#LARBS/d" /etc/sudoers
echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart, /usr/bin/pacman -Syyu --noconfirm #LARBS" >> /etc/sudoers

dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 12 80
clear
