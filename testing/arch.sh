#!/bin/bash

#This is a lazy script I have for auto-installing Arch.
#It's not officially part of LARBS, but I use it for testing.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting /dev/sda WITHOUT confirmation,
#which means RIP in peace qq your data unless you've already backed up all of your drive.

pacman -Sy --noconfirm dialog || { echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?"; exit; }

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire /dev/sda drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\nt. Luke"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELET your entire /dev/sda and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

dialog --defaultno --title "Time Zone select" --yesno "Do you want use the default time zone(America/New_York)?.\n\nPress no for select your own time zone"  10 60 && echo "America/New_York" > tz.tmp || tzselect > tz.tmp

dialog --no-cancel --inputbox "Enter partitionsize in gb, separated by space (swap & root)." 10 60 2>psize

IFS=' ' read -ra SIZE <<< $(cat psize)

re='^[0-9]+$'
if ! [ ${#SIZE[@]} -eq 2 ] || ! [[ ${SIZE[0]} =~ $re ]] || ! [[ ${SIZE[1]} =~ $re ]] ; then
    SIZE=(12 25);
fi

timedatectl set-ntp true

cat <<EOF | fdisk /dev/sda
o
n
p


+200M
n
p


+${SIZE[0]}G
n
p


+${SIZE[1]}G
n
p


w
EOF
partprobe

yes | mkfs.ext4 /dev/sda4
yes | mkfs.ext4 /dev/sda3
yes | mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home


pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab
cat tz.tmp > /mnt/tzfinal.tmp
rm tz.tmp
mv comp /mnt/etc/hostname
curl https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/testing/chroot.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh


dialog --defaultno --title "Final Qs" --yesno "Reboot computer?"  5 30 && reboot
dialog --defaultno --title "Final Qs" --yesno "Return to chroot environment?"  6 30 && arch-chroot /mnt
clear
