# Luke's Auto-Rice Bootstraping Scripts (LARBS)

[Official Website: larbs.xyz](http://larbs.xyz)

This is a set of scripts either can either (1) install Arch Linux automatically
with a typical Arch ISOed USB, and perhaps more prominently (2) automatically
install and configure all of the prerequisites for an advanced Linux desktop
environment, using my configs [here](https://github.com/LukeSmithxyz/voidrice)
as a base.


## About

Really, the goal of this script is to start a kind of Linux meta-distribution
which makes the more nuanced aspects of an advanced Linux setup available to
even Linux newbies. Of course, it's also a great tool for advanced users who
want to get into tiling window managers and just generally cool-looking and
efficient worksetups.

All the core stuff we be installed without prompt, but you'll have the option
to install some of the larger non-essential packages (LaTeX, LibreOffice,
emacs, etc.).

## Requirements

An already installed Arch Linux or derivative system (works on Manjaro and Antergos as well). Works on Parabola too, but due to repository differences, some minor programs might not install. Check the program list.

If you have a non-systemd system, you might also have to manually set up Pulseaudio and Network Manager after running the script.

## Installation

### On an already existing Arch install

This is just as easy. Log in as the root user and run the following.

```sh
curl -LO lukesmith.xyz/larbs.sh #Downloads the script.
bash larbs.sh #Runs it.
```

After prompting you for some settings and some package choices, the system will
install my full i3-gaps tiling window manager Desktop Environment. If you don't
know what that means, don't worry, because I've gone to great lengths to write
readable instructions about how to go PRO super quick with this system.

Finally, it will use `git` to download my
[Voidrice](https://github.com/lukesmithxyz/voidrice)
dotfiles and will plop them in their proper location for instant use!

Then, finally, once that all is done, you should be able to log out, then log in
as your newly created user and type `startx` to begin the graphical environment.
Congrats!

### Installing Arch automatically

I also have a script here for installing Arch automatically. I *only* wrote this
script so I could quickly install then test the other scripts on new computers,
but theoretically you could use it as well. *BUT* this is a lazy, pre-alpha
script which does not give you many options (it automatically chooses the New
York time zone, US English, GRUB, Network Manager, etc). Even more important, it
automatically partitions /dev/sda without asking, so unless, you have no
non-backed up data on your machine, I don't advise running it unless you don't
mind a full wipe. That said, you can run it like this after booting into an Arch
live environment:

```sh
curl -LO lukesmith.xyz/arch.sh #Downloads the script.
bash arch.sh #Runs it.
```

After the system installs, you'll have the option of bootstrapping automatically
into installing my configs as well.

Don't be worried if the installation of the first programs seems to take a while. As general dependencies are installed, things will move very quickly. Still, since this is a total online install, it might take a little longer than just installing a distro from an ISO.

## How to Use

Once you're in the environment, just type `Super` / `Mod` / `Windows` + `F1` to
pull up a document that will explain everything.


## Permission Details (sudoers file)

These script will give your new created user (and those others you put in the
`wheel` group) sudo access (with a password), but will also allow some commands
to be run without any password confirmation. Those include:

+ `shutdown`
+ `reboot`
+ `pacman -Syyu`/`pacman -Syu`
+ `packer -Syyu`/`packer -Syu`
+ `mount`
+ `umount`
+ `systemctl restart NetworkManager`

Additionally, if you've put your password in a terminal window already, you will
not need to repeat putting it in in other terminal windows.


## Version

We're close to what can be called LARBS 2.0, and here are some of the major changes since the original version.


- Deployment of my new mutt-wizard for secure offline email configuration instead of config files for the user to manually edit.
- System is more minimalist/suckless.
- Luke's build of st is now the default terminal, instead of urxvt.
- Polybar replaced by i3blocks (with many custom modules), which is lighter on resources and requires fewer dependencies. The polybar build also often failed to build on some machines.
- Switch from mocp to mpd/ncmpcpp for music.
- dmenu is used instead of rofi for simplicity's sake.
- Firefox instead of qutebrowser for default browser (qutebrowser configs remain)
- Extensive implementation of dmenu, including for mounting/unmounting drives, display selection, confirmation for shutdown and other crucial commands, link handling and screen/audio recording.
- Updates to config files can be pulled with git now.
- i3 window resize now intuitive directions
- Removal of a lot of brainlethood in the original design, where I relocated configs for alleged extensibility's sake. That's all been fixed now.
- Configs for the new versions of qutebrowser, newsboat/newsbeuter, neomutt, etc.
- Link handling scripts for mutt, newsboat and vim
- vi mode is now default in bash (with retention of emacs-mode ctrl-l)
- Caps lock functions both as a super key and escape key with xcape.
- Use of the much better, newer version of my shortcut-sync.
- Use of Luke's `mutt-wizard`.
- And the repository is *significantly* smaller than it was before, meaning a faster download.
- A million and one other tweaks and bug fixes.


## Why I made this

When you've installed Arch Linux 6 gorrillian times like me, you get pretty sick
of having to reproduce your favorite configuration on fresh installs over and
over. When you're a C-list YouTube celebrity, it gets even more difficult when
literally thousands of people ask you how to do X or get Y.

The LARBS are a final solution to all of that. These scripts are to be run on a
fresh install of Arch Linux, and they create a user, install all required
programs and set up dotfiles directly from Github to give normal people a fairly
sleek Linux configuration without hundreds of autsitic hours. I did the work, so
why should you?

I've also documented the configuration fairly well, check out the documentation
on my **voidrice** repository for that.

## Customization

You can clone and edit the scripts to meet your own requirements, it's simple enough to use your own dotfiles by changing the relevant lines in `larbs_user.sh` and the desired programs in `progs.csv`. Be sure make sure to refer to your offline versions of these files in the scripts if you do so.

In the future, I'm planning even more customization, including the automatic generation of the programs menu, so that should make specialized deployments even easier.

