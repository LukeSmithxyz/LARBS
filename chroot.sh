#Potential variables: timezone, hostname

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

echo "test" > /etc/hostname

pacman -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

pacman -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

curl -O http://lukesmith.xyz/larbs/root.sh && root.sh
