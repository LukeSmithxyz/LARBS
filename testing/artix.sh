#!/bin/bash

#This is a lazy script I have for auto-installing Arch.
#It's not officially part of LARBS, but I use it for testing.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting /dev/sda WITHOUT confirmation,
#which means RIP in peace qq your data unless you've already backed up all of your drive.

pacman -Sy --noconfirm dialog gdisk parted || { echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?"; exit; }

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire /dev/sda drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\nt. elwolf"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELET your entire /dev/sda and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

dialog --defaultno --title "Time Zone select" --yesno "Do you want use the default time zone(America/New_York)?.\n\nPress no for select your own time zone"  10 60 && echo "America/New_York" > tz.tmp || tzselect > tz.tmp

cat <<EOF | gdisk /dev/sda
o
y
n


512M
ef00
n


4G
8200
n




w
y
EOF
partprobe

yes | mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
yes | mkfs.ext4 /dev/sda3

mount /dev/sda3 /mnt
swapon /dev/sda2
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

pacman -Sy --noconfirm archlinux-keyring

basestrap /mnt base base-devel runit elogind-runit linux linux-firmware

fstabgen -U /mnt >> /mnt/etc/fstab
cat tz.tmp > /mnt/tzfinal.tmp
rm tz.tmp
mv comp /mnt/etc/hostname
curl https://raw.githubusercontent.com/elwolf6/LARBS/master/testing/chroot-runit.sh > /mnt/chroot-runit.sh && artix-chroot /mnt bash chroot-runit.sh && rm /mnt/chroot-runit.sh


dialog --defaultno --title "Final Qs" --yesno "Reboot computer?"  5 30 && reboot
dialog --defaultno --title "Final Qs" --yesno "Return to chroot environment?"  6 30 && artix-chroot /mnt
clear
