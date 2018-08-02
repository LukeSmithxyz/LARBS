#!/bin/bash

# You can provide a custom repository with -r or a custom programs csv with -p.
# Otherwise, the script will use my defaults.

### DEPENDENCIES: git, make and rsync. Make sure these are either in the progs.csv file or installed beforehand.

###
### OPTIONS AND VARIABLES ###
###

while getopts ":a:r:p:h" o; do
	case "${o}" in
	h)
		echo -e "Optional arguments for custom use:\n-r: Dotfiles repository\n-p: Dependencies and programs csv (url)\n-a: AUR helper (must have pacman-like syntax)\n-h show this message" && exit ;;
	r)
		dotfilesrepo=${OPTARG} ;;
	p)
		progsfile=${OPTARG} ;;
	a)
		aurhelper=${OPTARG} ;;
	*)
		echo "-$OPTARG is not a valid option." && exit ;;
	esac
done

# DEFAULTS:

[ -z ${dotfilesrepo+x} ] && dotfilesrepo="https://github.com/lukesmithxyz/voidrice.git"
[ -z ${progsfile+x} ] && progsfile="https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/progs.csv"
[ -z ${aurhelper+x} ] && aurhelper="packer"

###
### FUNCTIONS ###
###

initialcheck() { pacman -S --noconfirm --needed dialog || { echo "Error at script start: Are you sure you're running this as the root user? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection?"; exit; } ;}

preinstallmsg() { \
	dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\n\nIt will take some time, but when done, you can relax even more with your complete system.\n\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
	}

welcomemsg() { \
	dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\n\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\n\n-Luke" 10 60
	}

refreshkeys() { \
	dialog --infobox "Refreshing Arch Keyring..." 4 40
	pacman --noconfirm -Sy archlinux-keyring &>/dev/null
	}

getuserandpass() { \
	# Prompts user for new username an password.
	# Checks if username is valid and confirms passwd.
	name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit
	namere="^[a-z_][a-z0-9_-]*$"
	while ! [[ "${name}" =~ ${namere} ]]; do
		name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
	pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [[ ${pass1} == ${pass2} ]]; do
		unset pass2
		pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\n\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done ;}

usercheck() { \
	! (id -u $name &>/dev/null) ||
	dialog --colors --title "WARNING!" --yes-label "CONTINUE" --no-label "No wait..." --yesno "The user \`$name\` already exists on this system. LARBS can install for a user already existing, but it will \Zboverwrite\Zn any conflicting settings/dotfiles on the user account.\n\nLARBS will \Zbnot\Zn overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\n\nNote also that LARBS will change $name's password to the one you just gave." 14 70
	}

adduserandpass() { \
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/bash $name ||
	usermod -a -G wheel $name
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2 ;}

packerwrapper() { \
	# INPUT: a list of programs
	# OUTPUT: put uninstalled progs in $mainqueue or $aurqueue depending on
	# if they're in the main repos or the AUR.
	posprogs=$(pacman -Sl | awk '{print $2}')
	for arg in "$@"; do
	pacman -Q "$arg" &>/dev/null && continue
	pacman -Qg "$arg" &>/dev/null && continue
	grep "^$arg$" <<< $posprogs &>/dev/null  && mainqueue="$mainqueue $arg" && continue
	aurqueue="$aurqueue $arg"
	done ;}

programinventory() { \
	dialog --infobox "Getting program list..." 4 40
	packerwrapper $(curl -sL $progsfile | grep ^, | cut -d ',' -f2)
	}

gitinstall() { for gitrepo in $@; do
	dir=$(mktemp -d)
	dialog --infobox "Installing \"$(basename $gitrepo)\" from source..." 4 40
	git clone --depth 1 "$gitrepo" $dir
	cd $dir
	make
	make install
	done ;}

serviceinit() { for service in $@; do
	dialog --infobox "Enabling \"$service\"..." 4 40
	systemctl enable "$service"
	systemctl start "$service"
	done ;}

newperms() { # Set special sudoers settings for install (or after).
	sed -e "/#LARBS/d" /etc/sudoers
	echo "$@ #LARBS" >> /etc/sudoers ;}

systembeepoff() { dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
	rmmod pcspkr
	echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf ;}

installdotfiles() { # Download $dotfilesrepo and install them in user's home.
	# Downloading and installing dotfiles
	dialog --infobox "Downloading and installing config files..." 4 60
	rm -rf /tmp/dotfiles/
	sudo -u $name git clone --depth 1 $dotfilesrepo /tmp/dotfiles &>/dev/null &&
	sudo -u $name rsync -rl /tmp/dotfiles/ /home/$name
	}

resetpulse() { dialog --infobox "Reseting Pulseaudio..." 4 50
	killall pulseaudio &&
	sudo -n $name pulseaudio --start ;}

manualinstall() { # Installs $1 manually if not installed. Used only for AUR helper here.
	[[ -f /usr/bin/$1 ]] || (
	dialog --infobox "Installing \"$1\", an AUR helper..." 10 60
	cd /tmp
	rm -rf /tmp/$1*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz &&
	sudo -u $name tar -xvf $1.tar.gz &>/dev/null &&
	cd $1 &&
	sudo -u $name makepkg --noconfirm -si &>/dev/null
	cd /tmp)
	}

installmainprograms() { # Installs all needed programs from main repo.
	count=$(echo "$mainqueue" | wc -w)
	for x in $mainqueue; do
		n=$((n+1))
		dialog --title "LARBS Installation" --infobox "Downloading and installing program $n out of $count: $x...\n\nThe first programs will take more time due to dependencies." 7 70
		pacman --noconfirm --needed -S "$x" &>/dev/null
	done ;}

installaurprograms() { \
	count=$(echo "$aurqueue" | wc -w)
	n=0
	for prog in $aurqueue; do
		n=$((n+1))
		dialog --infobox "Downloading and installing program $n out of $count: $prog..." 10 60
		sudo -u $name $aurhelper -S --noconfirm "$prog" &>/dev/null
	done ;}

finalize(){ \
	dialog --infobox "Preparing welcome message..." 4 50
	echo "exec_always --no-startup-id notify-send -i ~/.scripts/larbs.png '<b>Welcome to LARBS:</b> Press Super+F1 for the manual.' -t 10000"  >> /home/$name/.config/i3/config
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 12 80
	}

###
### THE ACTUAL SCRIPT ###
###
### This is how everything happens in an intuitive format and order.
###

# NOTE: If you're deploying a system that doesn't require AUR packages, you
# don't need to include `installaurprograms` `manualinstall $aurhelper`
# (obviously), but also `getpermissions`.

# Check if user is root on Arch distro. Install dialog.
initialcheck

# Welcome user.
welcomemsg || { clear; exit; }

# Get and verify username and password.
getuserandpass

# Give warning if user already exists.
usercheck || { clear; exit; }

# Last chance for user to back out before install.
preinstallmsg || { clear; exit; }

### The rest of the script requires no user input.

adduserandpass

# Refresh Arch keyrings.
refreshkeys

# Checks progs and current programs to see what's needed.
programinventory

# Must be run sometime after `programinventory`.
# This will usually be the longest command by a large margin.
installmainprograms

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# Install AUR helper. Needs sudo w/o passwd.
manualinstall $aurhelper

# $aurhelper must be installed to run this. Needs sudo w/o passwd.
installaurprograms

installdotfiles

# Pulseaudio, if/when initially installed, often needs a restart to work immediately.
[[ -f /usr/bin/pulseaudio ]] && resetpulse

# Must be run sometime after `userandpassword`.
# git and rsync must be installed.
gitinstall https://github.com/lukesmithxyz/st.git https://github.com/lukesmithxyz/dmenu.git

# Enable services here.
serviceinit NetworkManager cronie

# Most important command! Get rid of the beep!
systembeepoff

# Should only be run after `installaurprograms`. Not strictly necessary if you
# want the more permissive sudo settings set above.
# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
newperms "%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart, /usr/bin/pacman -Syyu --noconfirm"

# Last message! Install complete!
finalize

clear
