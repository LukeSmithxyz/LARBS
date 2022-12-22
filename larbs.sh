#!/usr/bin/env bash

set -euo pipefail

dotfilesrepo="https://github.com/lukesmithxyz/voidrice.git"
progsfile="https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/progs.csv"
aurhelper="yay"
repobranch="master"

installpkg() {
  local package="$1"
  pacman --noconfirm --needed -S "$package" || exit 1
}

error() {
  local message="$1"
  printf "%s\n" "$message" >&2 || exit 1
}

welcomemsg() {
  whiptail --title "Welcome!" \
    --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured Linux desktop, which I use as my main machine.\\n\\n-Luke" 10 60

  whiptail --title "Important Note!" --yes-button "All ready!" \
    --no-button "Return..." \
    --yesno "Be sure the computer you are using has current pacman updates and refreshed Arch keyrings.\\n\\nIf it does not, the installation of some programs might fail." 8 70
}

getuserandpass() {
  local name
  name=$(whiptail --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit 1
  while ! printf "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
    name=$(whiptail --nocancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
  done
  local pass1 pass2
  pass1=$(whiptail --nocancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
  pass2=$(whiptail --nocancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
  while ! [ "$pass1" = "$pass2" ]; do
    unset pass2
    pass1=$(whiptail --nocancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
    pass2=$(whiptail --nocancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
  done
}

usercheck() {
  local name
  if ! id -u "$name" >/dev/null 2>&1; then
    return
  fi
  whiptail --title "WARNING" --yes-button "CONTINUE" \
    --no-button "No wait..." \
    --yesno "The user \`$name\` already exists on this system. LARBS can install for a user already existing, but it will OVERWRITE any conflicting settings/dotfiles on the user account.\\n\\nLARBS will NOT overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that LARBS will change $name's password to the one you just gave." 14 70
}

preinstallmsg() {
  whiptail --title "Let's get this party started!" --yes-button "Let's go!" \
    --no-button "No, nevermind!" \
    --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 80 || exit 1
}

adduserandpass() {
	# Adds user `$name` with password $pass1.
	useradd -m "$name" || exit 1
	echo "$name:$pass1" | chpasswd || exit 1
	echo "Added user $name"
}

adduser() {
  # Adds user `$name` without a password.
  useradd -m "$name" || exit 1
  echo "Added user $name"
}

addaursupport() {
  # Adds support for using AUR.
  installpkg "git"
  if [ -d "/home/$name" ]; then
    cd "/home/$name" || exit 1
  else
    cd /tmp || exit 1
  fi
  su "$name" -c "git clone https://aur.archlinux.org/$aurhelper.git" || exit 1
  if [ "$aurhelper" = "yay" ]; then
    cd "$aurhelper" || exit 1
    su "$name" -c "makepkg -si --noconfirm" || exit 1
  fi
  cd /tmp || exit 1
  rm -rf "$aurhelper"
  echo "Added AUR support"
}

systemupdate() {
  # Performs a system update.
  installpkg "reflector"
  reflector --latest 200 --sort rate --save /etc/pacman.d/mirrorlist || exit 1
  pacman -Syyu --noconfirm || exit 1
  echo "System updated"
}

installpkgs() {
  # Installs all necessary packages.
  installpkg "base-devel"
  while read -r package; do
    installpkg "$package"
  done < <(curl -Ls "$progsfile" | grep -vE "^#")
  echo "Packages installed"
}

dotfilesinstall() {
  # Installs dotfiles.
  if [ -d "/home/$name" ]; then
    cd "/home/$name" || exit 1
  else
    cd /tmp || exit 1
  fi
  su "$name" -c "git clone --recursive -b "$repobranch" "$dotfilesrepo" /home/$name/dotfiles" || exit 1
  su "$name" -c "bash /home/$name/dotfiles/install.sh" || exit 1
  echo "Dotfiles installed"
}

systemwideinstall() {
  # Installs system-wide programs.
  while read -r package; do
    installpkg "$package"
  done < <(curl -Ls "$progsfile" | grep "^[^#]" | awk '{print $1}')
  echo "System-wide programs installed"
}

configuresystem() {
  # Configures system.
  installpkg "systemd-swap"
  systemd-swap -f || exit 1
  echo "System configured"
}

finalize() {
  # Clean up and finish.
  systemctl enable NetworkManager || exit 1
  echo "Finalized system"
}

welcomemsg
getuserandpass
usercheck
preinstallmsg
adduserandpass
addaursupport
systemupdate
installpkgs
dotfilesinstall
systemwideinstall
configuresystem
finalize

echo "Installation complete!"