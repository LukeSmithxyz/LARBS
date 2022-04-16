#!/bin/bash
#Potential variables: timezone, lang and local

passwd

ln -sf /usr/share/zoneinfo/$tz /etc/localtime

hwclock --systohc

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

pacman --noconfirm --needed -S networkmanager
systemctl enable --now NetworkManager

pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/$sdX && grub-mkconfig -o /boot/grub/grub.cfg

pacman --noconfirm --needed -S dialog
larbs() { curl -O https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/larbs.sh && bash larbs.sh ;}
dialog --title "Install Luke's Rice" --yesno "This install script will easily let you access Luke's Auto-Rice Boostrapping Scripts (LARBS) which automatically install a full Arch Linux dwm environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\nLuke"  15 60 && larbs
