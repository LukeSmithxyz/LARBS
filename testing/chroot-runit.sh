#Potential variables: timezone, lang and local

ln -sf /usr/share/zoneinfo/$TZuser /etc/localtime

hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

mkinitcpio -P

passwd << EOF
123
123
EOF

pacman --noconfirm --needed -S networkmanager-runit grub efibootmgr && grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && grub-mkconfig -o /boot/grub/grub.cfg

ln -s /etc/runit/sv/NetworkManager /run/runit/service
sv up NetworkManager
mkdir -p /etc/runit/sv/ckb-next-daemon
echo "#!/bin/sh
exec ckb-next-daemon > /dev/null 2>&1" >> /etc/runit/sv/ckb-next-daemon/run
ln -s /etc/runit/sv/ckb-next-daemon /run/runit/service
sv up ckb-next-daemon

pacman --noconfirm --needed -S dialog git
larbs() { curl -O https://raw.githubusercontent.com/elwolf6/LARBS/master/larbs-runit.sh && bash larbs-runit.sh;}
dialog --title "Install elwolf's Rice" --yesno "This install script will easily let you access elwolf's Auto-Rice Boostrapping Scripts which automatically install a full Arch Linux nord dwm desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\elwolf"  15 60 && larbs
