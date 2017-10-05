#!/bin/bash

#This is a lazy script I have for auto-installing Arch.
#It's not officially part of LARBS, but I use it for testing.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting /dev/sda WITHOUT confirmation,
#which means RIP in peace qq your data unless you've already backed up all of your drive.

pacman -S --noconfirm dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

#error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 && clear && exit ;}

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire /dev/sda drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\nt. Luke"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELET your entire /dev/sda and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

timedatectl set-ntp true

cat <<EOF | fdisk /dev/sda
o
n
p


+200M
n
p


+12G
n
p


+25G
n
p


w
EOF
partprobe

mkfs.ext4 /dev/sda4
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/sda4 /mnt/home

cat comp > /mnt/etc/hostname && rm comp

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

curl http://lukesmith.xyz/larbs/chroot.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh

grubinst() { pacman -S grub && grub-install --target=i386-pc /dev/sda ;}

echo "Install and configure GRUB bootloader? [y/N]"
read yn
case $yn in
	[Yy]* ) grubinst ;;
	[yes]* ) grubinst ;;
	[Yes]* ) grubinst ;;
esac

echo "Eject CD/ROM? [y/N]"
read yn
case $yn in
	[Yy]* ) eject ;;
	[yes]* ) eject ;;
	[Yes]* ) eject ;;
esac

echo "Reboot now? [y/N]"
read yn
case $yn in
	[Yy]* ) reboot ;;
	[yes]* ) reboot ;;
	[Yes]* ) reboot ;;
esac

echo "Return to chroot environment? [y/N]"
read yn
case $yn in
	[Yy]* ) arch-chroot /mnt ;;
	[yes]* ) arch-chroot /mnt ;;
	[Yes]* ) arch-chroot /mnt ;;
esac
