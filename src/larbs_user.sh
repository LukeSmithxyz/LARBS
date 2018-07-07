#!/bin/bash

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
	echo $arg not installed.
	packer --noconfirm -S $arg >/dev/null || aurinstall $arg
fi
done
}

dialog --infobox "Installing \"packer\", an AUR helper..." 10 60
aurcheck packer >/dev/null

count=$(cat /tmp/aur_queue | wc -l)
n=0

for prog in $(cat /tmp/aur_queue)
do
	n=$((n+1))
	dialog --infobox "Downloading and installing program $n out of $count: $prog..." 10 60
	aurcheck $prog >/dev/null
done

dialog --infobox "Downloading and installing config files..." 4 60
git clone --depth 1 https://github.com/lukesmithxyz/voidrice.git >/dev/null &&
	rsync -va voidrice/ /home/$(whoami) >/dev/null &&
	rm -rf voidrice >/dev/null

dialog --infobox "Readying mutt-wizard..." 4 60
git clone --depth 1 https://github.com/lukesmithxyz/mutt-wizard.git /home/$(whoami)/.config/mutt >/dev/null

dialog --infobox "Generating bash/ranger/qutebrowser shortcuts..." 4 60
git clone --depth 1 https://github.com/LukeSmithxyz/shortcut-sync.git >/dev/null &&
	rsync shortcut-sync/shortcuts.sh ~/.scripts/ >/dev/null &&
	rsync shortcut-sync/folders ~/.scripts/ >/dev/null &&
	rsync shortcut-sync/configs ~/.scripts/ >/dev/null &&
	bash /home/$(whoami)/.scripts/shortcuts.sh >/dev/null &&
	rm -rf shortcut-sync/ >/dev/null

dialog --infobox "Creating LARBS Firefox profile..." 4 60
git clone --depth 1 https://github.com/LukeSmithxyz/mozilla-larbs.git >/dev/null &&
	rsync -r mozilla-larbs/firefox/larbs.default ~/.mozilla/firefox/ &&
	rsync mozilla-larbs/firefox/profiles.ini ~/.mozilla/firefox/

dialog --infobox "Preparing welcome message..." 4 50

echo "exec_always --no-startup-id notify-send -i ~/.scripts/larbs.png '<b>Welcome to LARBS:</b> Press Super+F1 for the manual.' -t 10000"  >> /home/$(whoami)/.config/i3/config

dialog --infobox "Reseting Pulseaudio..." 4 50
killall pulseaudio >/dev/null
pulseaudio --start >/dev/null
