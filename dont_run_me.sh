#!/bin/bash

#This is a lazy script I have for auto-installing Arch.
#It's not officially part of LARBS, but I use it for testing.
#DO NOT RUN THIS YOURSELF because Step 1 is it reformatting /dev/sda WITHOUT confirmation,
#which means RIP in peace qq your data unless you've already backed up all of your drive.

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



pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

curl http://lukesmith.xyz/larbs/root.sh > /mnt/root.sh && arch-chroot /mnt bash root.sh && rm /mnt/root.sh

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

echo "Return to chroot environment?"
read yn
case $yn in
	[Yy]* ) arch-chroot /mnt ;;
	[yes]* ) arch-chroot /mnt ;;
	[Yes]* ) arch-chroot /mnt ;;
esac
