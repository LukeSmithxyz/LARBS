#!/bin/bash
blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/LARBS.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/LARBS.log) ;}

echo "LARBS started $(date)" >> /tmp/LARBS.log
chmod 777 /tmp/LARBS.log

pacman -S --noconfirm --needed dialog || (echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?" && exit)

dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\n\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\n\n-Luke" 10 60

dialog --no-cancel --inputbox "First, please enter a name for the user account." 10 60 2> /tmp/.name

dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 2> /tmp/.pass1
dialog --no-cancel --passwordbox "Retype password." 10 60 2> /tmp/.pass2

while [ $(cat /tmp/.pass1) != $(cat /tmp/.pass2) ]
do
	dialog --no-cancel --passwordbox "Passwords do not match.\n\nEnter password again." 10 60 2> /tmp/.pass1
	dialog --no-cancel --passwordbox "Retype password." 10 60 2> /tmp/.pass2
done

chmod 777 /tmp/.name
NAME=$(cat /tmp/.name)
shred -u /tmp/.name
useradd -m -g wheel -s /bin/bash $NAME

echo "$NAME:$(cat /tmp/.pass1)" | chpasswd
#I shred the password for safety's sake.
shred -u /tmp/.pass1
shred -u /tmp/.pass2

cmd=(dialog --separate-output --checklist "Select additional packages to install with <SPACE>:" 22 76 16)
options=(1 "LaTeX packages" off
         2 "Libreoffice Suite" off
         3 "GIMP" off
         4 "Blender" off
	 5 "Emacs" off
	 6 "Fonts for unicode and other languages" off
	 7 "Transmission torrent client" off
	 8 "Music visualizers and decoration" off
	 )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $choices > /tmp/.choices

dialog --title "Let's get this party started!" --msgbox "The rest of the installation will now be totally automated, so you can sit back and relax.\n\nIt will take some time, but when done, you can relax even more with your complete system.\n\nNow just press <OK> and the system will begin installation!" 13 60

clear

cat << "EOF"

 mmmmm                    #           mmm
 #   "#  mmm    mmm    mmm#  m   m   "   #
 #mmmm" #"  #  "   #  #" "#  "m m"    m#"
 #   "m #""""  m"""#  #   #   #m#     "
 #    " "#mm"  "mm"#  "#m##   "#      #
			      m"
EOF
sleep 1
cat << "EOF"

  mmmm           m      mmm
 #"   "  mmm   mm#mm   "   #
 "#mmm  #"  #    #      m#"
     "# #""""    #      "
 "mmm#" "#mm"    "mm    #
EOF
sleep 1

#Prints metal gay
cat << "EOF"

   [0;1;34;94mmmm[0m   [0;34mmmmm[0m    [0;34mm[0m
 [0;34mm"[0m   [0;34m"[0m [0;34mm"[0m  [0;34m"m[0m   [0;37m#[0m
 [0;34m#[0m   [0;34mmm[0m [0;37m#[0m    [0;37m#[0m   [0;37m#[0m
 [0;37m#[0m    [0;37m#[0m [0;37m#[0m    [0;37m#[0m   [0;1;30;90m"[0m
  [0;37m"mmm"[0m  [0;1;30;90m#mm#[0m    [0;1;30;90m#[0m

EOF
sleep .5
cat << "EOF"


                      -     =    .--._
                - - ~_=  =~_- = - `.  `-.
              ==~_ = =_  ~ -   =  .-'    `.
            --=~_ - ~  == - =   .'      _..:._
           ---=~ _~  = =-  =   `.  .--.'      `.
          --=_-=- ~= _ - =  -  _.'  `.      .--.:
            -=_~ -- = =  ~-  .'      :     :    :
             -=-_ ~=  = - _-`--.     :  .--:    D
               -=~ _=  =  -~_=  `;  .'.:   ,`---'@
             --=_= = ~-   -=   .'  .'  `._ `-.__.'
            --== ~_ - =  =-  .'  .'     _.`---'
           --=~_= = - = ~  .'--''   .   `-..__.--.
          jgs--==~ _= - ~-=  =-~_-   `-..___(  ===;
          --==~_==- =__ ~-=  - -    .'       `---'

EOF
sleep .5


blue \[1\/6\] Now installing main programs \(system basics\)...

pacman --noconfirm --needed -Sy git base-devel

cd /tmp
git clone https://github.com/lukesmithxyz/st.git
cd st
patch < patches/transparency.diff
make
make install
cd /tmp

pacman --noconfirm --needed -Sy \
	xorg-xinit \
	xorg-server \
	compton \
	arandr \
	ttf-inconsolata \
	noto-fonts \
	unzip \
	unrar \
	wget \
	atool \
	ntfs-3g \
	xf86-video-intel \
 	dosfstools \
	cups \
	transset-df \
	htop || (red Error installing system basics. Check your internet connection and pacman keyring.)


blue \[2\/6\] Now installing main programs \(productivity\)...
pacman --noconfirm --needed -Sy \
	calcurse \
	ranger \
	vim \
	tmux \
	rofi \
	poppler \
	mupdf \
	pandoc || (red Error installing productivity packages. Check your internet connection and pacman keyring.)


blue \[3\/6\] Now installing main programs \(network and internet\)...
pacman --noconfirm --needed -Sy \
	wireless_tools \
	network-manager-applet \
	networkmanager \
	w3m \
	offlineimap \
	msmtp \
	notmuch \
	notmuch-mutt \
	qutebrowser \
	rsync \
	newsboat || (red Error installing network packages. Check your internet connection and pacman keyring.)


blue \[4\/6\] Now installing main programs \(graphics\)...
pacman --noconfirm --needed -Sy \
	feh \
	imagemagick \
	scrot \
	libcaca || (red Error installing graphic packages. Check your internet connection and pacman keyring.)


blue \[5\/6\] Now installing main programs \(audio\)...
pacman --noconfirm --needed -Sy \
	ffmpeg \
	pulseaudio \
	pulseaudio-alsa \
	pamixer \
	mpd \
	mpc \
	ncmpcpp \
	youtube-dl \
	youtube-viewer \
	mediainfo \
	mpv || (red Error installing audio packages. Check your internet connection and pacman keyring.)


blue \[6\/6\] Now installing main programs \(devel\)...
pacman --noconfirm --needed -Sy \
	python-dbus \
	python-gobject \
	discount \
	r \
	highlight || (red Error installing devel packages. Check your internet connection and pacman keyring.)


pacman --noconfirm --needed -S fzf || (red Error with peripheral programs.)

cat << "EOF"
 _____________________________
< Drink whole milk every day! >
 -----------------------------
 \     ____________
  \    |__________|
      /           /\
     /           /  \
    /___________/___/|
    |          |     |
    |  ==\ /== |     |
    |   O   O  | \ \ |
    |     <    |  \ \|
   /|          |   \ \
  / |  \_____/ |   / /
 / /|          |  / /|
/||\|          | /||\/
    -------------|
        | |    | |
       <__/    \__>
EOF

for choice in $choices
do
    case $choice in
        1)
	    blue Now installing LaTeX packages...

cat << "EOF"

 [0;1;34;94mmmmmm[0m                  [0;37mm[0m           [0;37m""#[0m    [0;1;30;90m""#[0m      [0;1;30;90m"[0m                         [0;34mm[0m            [0;37mmmmmmmm[0m        [0;1;30;90mm[0m    [0;1;30;90mm[0m
   [0;34m#[0m    [0;34mm[0m [0;34mmm[0m    [0;37mmmm[0m   [0;37mmm#mm[0m   [0;37mmm[0;1;30;90mm[0m     [0;1;30;90m#[0m      [0;1;30;90m#[0m    [0;1;34;94mmmm[0m    [0;1;34;94mm[0m [0;1;34;94mmm[0m    [0;34mmmmm[0m         [0;34m#[0m       [0;37mmmm[0m     [0;37m#[0m     [0;1;30;90mmmm[0m    [0;1;30;90m#[0m  [0;1;30;90m#[0m
   [0;34m#[0m    [0;37m#"[0m  [0;37m#[0m  [0;37m#[0m   [0;37m"[0m    [0;1;30;90m#[0m    [0;1;30;90m"[0m   [0;1;30;90m#[0m    [0;1;30;90m#[0m      [0;1;34;94m#[0m      [0;1;34;94m#[0m    [0;34m#"[0m  [0;34m#[0m  [0;34m#"[0m [0;34m"#[0m         [0;37m#[0m      [0;37m"[0m   [0;1;30;90m#[0m    [0;1;30;90m#[0m    [0;1;30;90m#"[0m  [0;1;30;90m#[0m    [0;1;34;94m##[0m
   [0;37m#[0m    [0;37m#[0m   [0;37m#[0m   [0;1;30;90m"""m[0m    [0;1;30;90m#[0m    [0;1;30;90mm""[0;1;34;94m"#[0m    [0;1;34;94m#[0m      [0;1;34;94m#[0m      [0;34m#[0m    [0;34m#[0m   [0;34m#[0m  [0;37m#[0m   [0;37m#[0m         [0;37m#[0m      [0;1;30;90mm"""#[0m    [0;1;30;90m#[0m    [0;1;34;94m#""""[0m   [0;1;34;94mm""m[0m
 [0;37mmm#mm[0m  [0;1;30;90m#[0m   [0;1;30;90m#[0m  [0;1;30;90m"mmm"[0m    [0;1;34;94m"mm[0m  [0;1;34;94m"mm"#[0m    [0;1;34;94m"m[0;34mm[0m    [0;34m"mm[0m  [0;34mmm#mm[0m  [0;37m#[0m   [0;37m#[0m  [0;37m"#m"#[0m         [0;1;30;90m#mmmmm[0m [0;1;30;90m"mm[0;1;34;94m"#[0m    [0;1;34;94m#[0m    [0;1;34;94m"#mm"[0m  [0;34mm"[0m  [0;34m"m[0m   [0;34m#[0m      [0;37m#[0m      [0;37m#[0m
                                                                 [0;1;30;90mm[0m  [0;1;30;90m#[0m
                                                                  [0;1;30;90m""[0m

                          [0;37m#[0m                       [0;1;30;90m#[0m                    [0;1;34;94mm[0;34mmmmm[0m [0;34mmmmmmmm[0m [0;34mmmm[0;37mmmm[0m  [0;37mmmmm[0m    [0;37mm[0m
[0;34mm[0m     [0;34mm[0m  [0;34mmmm[0m    [0;37mm[0m [0;37mmm[0m   [0;37mmmm#[0m   [0;37mmm[0;1;30;90mm[0m   [0;1;30;90mm[0m   [0;1;30;90mm[0m   [0;1;30;90mmmm[0m   [0;1;34;94m#[0m   [0;1;34;94mm[0m   [0;1;34;94mmmm[0m          [0;34m#[0m    [0;34m#[0m   [0;37m#[0m    [0;37m#[0m      [0;37mm"[0m  [0;1;30;90m"m[0m   [0;1;30;90m#[0m
[0;34m"m[0m [0;34mm[0m [0;34mm"[0m [0;37m#"[0m [0;37m"#[0m   [0;37m#"[0m  [0;37m"[0m [0;37m#"[0m [0;1;30;90m"#[0m  [0;1;30;90m#"[0m  [0;1;30;90m"[0m  [0;1;30;90m#[0m   [0;1;34;94m#[0m  [0;1;34;94m#"[0m  [0;1;34;94m"[0m  [0;1;34;94m#[0m [0;1;34;94mm"[0m   [0;34m#[0m   [0;34m"[0m         [0;34m#[0;37mmmmm"[0m   [0;37m#[0m    [0;37m#mm[0;1;30;90mmmm[0m [0;1;30;90m#[0m    [0;1;30;90m#[0m   [0;1;30;90m#[0m
 [0;37m#m#m#[0m  [0;37m#[0m   [0;37m#[0m   [0;1;30;90m#[0m     [0;1;30;90m#[0m   [0;1;30;90m#[0m  [0;1;30;90m#[0m      [0;1;34;94m#[0m   [0;1;34;94m#[0m  [0;1;34;94m#[0m      [0;34m#"#[0m     [0;34m"""m[0m         [0;37m#[0m    [0;37m#[0m   [0;1;30;90m#[0m    [0;1;30;90m#[0m      [0;1;30;90m#[0m    [0;1;34;94m#[0m   [0;1;34;94m"[0m
  [0;37m#[0m [0;37m#[0m   [0;1;30;90m"#m#"[0m   [0;1;30;90m#[0m     [0;1;30;90m"#[0;1;34;94mm##[0m  [0;1;34;94m"#mm"[0m  [0;1;34;94m"mm"[0;34m#[0m  [0;34m"#mm"[0m  [0;34m#[0m  [0;34m"m[0m  [0;37m"mmm"[0m         [0;37m#[0;1;30;90mmmmm"[0m   [0;1;30;90m#[0m    [0;1;30;90m#[0m       [0;1;34;94m#mm#[0m    [0;1;34;94m#[0m

EOF
	    pacman --noconfirm --needed -S texlive-most texlive-lang biber
            ;;
        2)
	    blue Now installing LibreOffice Suite...
	    pacman --noconfirm --needed -S libreoffice-fresh
            ;;
        3)
	    blue Now installing GIMP...
	    pacman --noconfirm --needed -S gimp
            ;;
        4)
	    blue Now installing Blender...
	    pacman --noconfirm --needed -S blender
            ;;
	5)
	    blue Now installing Emacs...
	    pacman --noconfirm --needed -S emacs
	    ;;
	6)
	    blue Now installing extra fonts...
	    pacman --noconfirm --needed -S noto-fonts-cjk noto-fonts-emoji
	    ;;
	7)
	    blue Now installing transmission...
	    pacman --noconfirm --needed -S transmission-cli
	    ;;
	8)
		blue Now installing visualizers and decoration...
		pacman --noconfirm --needed -S projectm-pulseaudio cmatrix asciiquarium screenfetch
		;;
    esac
done

#Prints gay [autism intensifies]
cat << "EOF"


   [0;1;33;93m#[0;1;32;92m"[0m                   [0;1;31;91mm[0m      [0;1;36;96m"[0m                           [0;1;35;95m"[0m             [0;1;31;91mm[0m                           [0;1;32;92m"[0m      [0;1;31;91mm"[0;1;33;93m"[0m    [0;1;36;96m"[0m                   [0;1;33;93m"[0;1;32;92m#[0m
   [0;1;32;92m#[0m     [0;1;35;95mm[0;1;31;91mmm[0m   [0;1;32;92mm[0m   [0;1;34;94mm[0m  [0;1;31;91mmm[0;1;33;93m#m[0;1;32;92mm[0m  [0;1;36;96mm[0;1;34;94mmm[0m     [0;1;33;93mm[0;1;32;92mmm[0m   [0;1;34;94mm[0;1;35;95mmm[0;1;31;91mmm[0m         [0;1;35;95mm[0;1;31;91mmm[0m    [0;1;36;96mm[0m [0;1;34;94mmm[0m   [0;1;31;91mm[0;1;33;93mm#[0;1;32;92mmm[0m   [0;1;34;94mm[0;1;35;95mmm[0m   [0;1;33;93mm[0m [0;1;32;92mm[0;1;36;96mm[0m    [0;1;35;95mm[0;1;31;91mmm[0m   [0;1;32;92mm[0;1;36;96mmm[0m    [0;1;31;91mmm[0;1;33;93m#m[0;1;32;92mm[0m  [0;1;36;96mm[0;1;34;94mmm[0m     [0;1;33;93mm[0;1;32;92mmm[0m    [0;1;35;95mmm[0;1;31;91mm[0m     [0;1;36;96m#[0m
   [0;1;36;96m#[0m    [0;1;31;91m"[0m   [0;1;32;92m#[0m  [0;1;36;96m#[0m   [0;1;35;95m#[0m    [0;1;32;92m#[0m      [0;1;35;95m#[0m    [0;1;32;92m#[0m   [0;1;34;94m"[0m  [0;1;35;95m#[0m [0;1;31;91m#[0m [0;1;33;93m#[0m           [0;1;33;93m#[0m    [0;1;34;94m#"[0m  [0;1;31;91m#[0m    [0;1;32;92m#[0m    [0;1;35;95m#"[0m  [0;1;33;93m#[0m  [0;1;32;92m#[0;1;36;96m"[0m  [0;1;34;94m#[0m  [0;1;31;91m#[0m   [0;1;32;92m"[0m    [0;1;34;94m#[0m      [0;1;32;92m#[0m      [0;1;35;95m#[0m    [0;1;32;92m#"[0m  [0;1;34;94m#[0m  [0;1;35;95m#[0m   [0;1;33;93m"[0m    [0;1;34;94m#[0m
   [0;1;34;94m#[0m    [0;1;33;93mm"[0;1;32;92m""[0;1;36;96m#[0m  [0;1;34;94m#[0m   [0;1;31;91m#[0m    [0;1;36;96m#[0m      [0;1;31;91m#[0m     [0;1;36;96m"[0;1;34;94m""[0;1;35;95mm[0m  [0;1;31;91m#[0m [0;1;33;93m#[0m [0;1;32;92m#[0m           [0;1;32;92m#[0m    [0;1;35;95m#[0m   [0;1;33;93m#[0m    [0;1;36;96m#[0m    [0;1;31;91m#"[0;1;33;93m""[0;1;32;92m"[0m  [0;1;36;96m#[0m   [0;1;35;95m#[0m   [0;1;33;93m"[0;1;32;92m""[0;1;36;96mm[0m    [0;1;35;95m#[0m      [0;1;36;96m#[0m      [0;1;31;91m#[0m    [0;1;36;96m#"[0;1;34;94m""[0;1;35;95m"[0m   [0;1;33;93m""[0;1;32;92m"m[0m    [0;1;35;95m#[0m
   [0;1;35;95m#[0m    [0;1;32;92m"m[0;1;36;96mm"[0;1;34;94m#[0m  [0;1;35;95m"[0;1;31;91mmm[0;1;33;93m"#[0m    [0;1;34;94m"m[0;1;35;95mm[0m  [0;1;31;91mm[0;1;33;93mm#[0;1;32;92mmm[0m  [0;1;34;94m"m[0;1;35;95mmm[0;1;31;91m"[0m  [0;1;33;93m#[0m [0;1;32;92m#[0m [0;1;36;96m#[0m         [0;1;32;92mm[0;1;36;96mm#[0;1;34;94mmm[0m  [0;1;31;91m#[0m   [0;1;32;92m#[0m    [0;1;34;94m"[0;1;35;95mmm[0m  [0;1;33;93m"#[0;1;32;92mmm[0;1;36;96m"[0m  [0;1;34;94m#[0m   [0;1;31;91m#[0m  [0;1;32;92m"m[0;1;36;96mmm[0;1;34;94m"[0m  [0;1;35;95mm[0;1;31;91mm#[0;1;33;93mmm[0m    [0;1;34;94m#[0m    [0;1;31;91mm[0;1;33;93mm#[0;1;32;92mmm[0m  [0;1;34;94m"#[0;1;35;95mmm[0;1;31;91m"[0m  [0;1;33;93m"[0;1;32;92mmm[0;1;36;96mm"[0m    [0;1;31;91m#[0m
   [0;1;31;91m"[0;1;33;93m"[0m                                                                                                                                  [0;1;31;91m"[0;1;33;93m"[0m

EOF

cat << "EOF"
 ________________________
< >tfw too hot to handle >
 ------------------------
  \            .    .     .
   \      .  . .     `  ,
    \    .; .  : .' :  :  : .
     \   i..`: i` i.i.,i  i .
      \   `,--.|i |i|ii|ii|i:
           UooU\.'@@@@@@`.||'
           \__/(@@@@@@@@@@)'
                (@@@@@@@@)
                `YY~~~~YY'
                 ||    ||
EOF

curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/src/sudoers_tmp > /etc/sudoers

cd /tmp
blue Changing working directory to /tmp/...
blue Downloading next portion of the script \(larbs_user.sh\)...
curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/testing/src/larbs_user.sh > /tmp/larbs_user.sh && blue Running larbs_user.sh script as $NAME...
sudo -u $NAME bash /tmp/larbs_user.sh || red Error when running larbs_user.sh...
rm -f /tmp/larbs_user.sh

#Prints gay "ALMOST THERE!"
cat << "EOF"
   [0;1;33;93mm[0;1;32;92mm[0m   [0;1;34;94mm[0m      [0;1;33;93mm[0m    [0;1;34;94mm[0m  [0;1;35;95mm[0;1;31;91mmm[0;1;33;93mm[0m   [0;1;36;96mmm[0;1;34;94mmm[0m [0;1;35;95mm[0;1;31;91mmm[0;1;33;93mmm[0;1;32;92mmm[0m       [0;1;31;91mm[0;1;33;93mmm[0;1;32;92mmm[0;1;36;96mmm[0m [0;1;34;94mm[0m    [0;1;33;93mm[0m [0;1;32;92mmm[0;1;36;96mmm[0;1;34;94mmm[0m [0;1;35;95mm[0;1;31;91mmm[0;1;33;93mmm[0m  [0;1;36;96mmm[0;1;34;94mmm[0;1;35;95mmm[0m   [0;1;33;93mm[0m
   [0;1;32;92m#[0;1;36;96m#[0m   [0;1;35;95m#[0m      [0;1;32;92m#[0;1;36;96m#[0m  [0;1;34;94m#[0;1;35;95m#[0m [0;1;31;91mm"[0m  [0;1;32;92m"m[0m [0;1;36;96m#[0;1;34;94m"[0m   [0;1;31;91m"[0m   [0;1;32;92m#[0m             [0;1;36;96m#[0m    [0;1;35;95m#[0m    [0;1;32;92m#[0m [0;1;36;96m#[0m      [0;1;31;91m#[0m   [0;1;32;92m"[0;1;36;96m#[0m [0;1;34;94m#[0m        [0;1;32;92m#[0m
  [0;1;36;96m#[0m  [0;1;34;94m#[0m  [0;1;31;91m#[0m      [0;1;36;96m#[0m [0;1;34;94m#[0;1;35;95m#[0m [0;1;31;91m#[0m [0;1;33;93m#[0m    [0;1;36;96m#[0m [0;1;34;94m"[0;1;35;95m#m[0;1;31;91mmm[0m    [0;1;36;96m#[0m             [0;1;34;94m#[0m    [0;1;31;91m#[0;1;33;93mmm[0;1;32;92mmm[0;1;36;96m#[0m [0;1;34;94m#m[0;1;35;95mmm[0;1;31;91mmm[0m [0;1;33;93m#[0;1;32;92mmm[0;1;36;96mmm[0;1;34;94m"[0m [0;1;35;95m#m[0;1;31;91mmm[0;1;33;93mmm[0m   [0;1;36;96m#[0m
  [0;1;34;94m#m[0;1;35;95mm#[0m  [0;1;33;93m#[0m      [0;1;34;94m#[0m [0;1;35;95m"[0;1;31;91m"[0m [0;1;33;93m#[0m [0;1;32;92m#[0m    [0;1;34;94m#[0m     [0;1;33;93m"[0;1;32;92m#[0m   [0;1;34;94m#[0m             [0;1;35;95m#[0m    [0;1;33;93m#[0m    [0;1;34;94m#[0m [0;1;35;95m#[0m      [0;1;32;92m#[0m   [0;1;34;94m"[0;1;35;95mm[0m [0;1;31;91m#[0m        [0;1;34;94m"[0m
 [0;1;34;94m#[0m    [0;1;33;93m#[0m [0;1;32;92m#m[0;1;36;96mmm[0;1;34;94mmm[0m [0;1;35;95m#[0m    [0;1;32;92m#[0m  [0;1;36;96m#[0;1;34;94mmm[0;1;35;95m#[0m  [0;1;31;91m"[0;1;33;93mmm[0;1;32;92mm#[0;1;36;96m"[0m   [0;1;35;95m#[0m             [0;1;31;91m#[0m    [0;1;32;92m#[0m    [0;1;35;95m#[0m [0;1;31;91m#m[0;1;33;93mmm[0;1;32;92mmm[0m [0;1;36;96m#[0m    [0;1;31;91m"[0m [0;1;33;93m#m[0;1;32;92mmm[0;1;36;96mmm[0m   [0;1;35;95m#[0m
EOF


blue Enabling Network Manager...
systemctl enable NetworkManager
systemctl start NetworkManager

blue Getting rid of that retarded error beep sound...
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

blue Implementing temporary sudoers file...
curl https://raw.githubusercontent.com/LukeSmithxyz/larbs/master/src/sudoers > /etc/sudoers

dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\n\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment.\n\n-Luke" 12 80
clear
