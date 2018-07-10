# Luke's Auto-Rice Bootstraping Scripts (LARBS)

[Official Website: larbs.xyz](http://larbs.xyz)

LARBS is a quick series of scripts deployable on a fresh installation of Arch
Linux. They automatically install and setup a fully-featured, but still
lightweight tiling window manager "suite", meant to be minimal and
keyboard-based.

LARBS is also intensely well-documented. Users can press `super+F1` at any time
to view a full guide and explanation of the keyboard shortcuts. The only
advised foreknowledge for potential users is a general familiarity with vim.

Now there are also small scripts like `getkeys` which display the default
bindings for the different terminal programs used by the system. Users can also
press `super+shift+e` at any time to watch a growing list of tutorial videos on
the same programs and other basic concepts from [my YouTube channel](https://youtube.com/c/lukesmithxyz).

You can also easily fork these scripts for your own purposes to deploy your own
configs if you like. All the actual scripts do is install a `.csv` list of
programs of your choice and set up system basics.

## Requirements

An already installed Arch Linux or derivative system (works on Manjaro and
Antergos as well). Works on Parabola too, but due to repository differences,
some minor programs might not install. Check the program list.

If you have a non-systemd system, you might also have to manually set up
Pulseaudio and Network Manager after running the script.

## Installation

### On an already existing Arch install

Boot up a fresh Arch install and run the following as the root user.

```sh
curl -LO lukesmith.xyz/larbs.sh #Downloads the script.
bash larbs.sh #Runs it.
```

Once that all is done, you should be able to log out, then log in as your newly
created user and type `startx` to begin the graphical environment.  Congrats!
Note that if the graphical environment doesn't start correctly, you might want
to see what kind of drivers your computer needs to run Arch and install them
via `pacman` manually.

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

Don't be worried if the installation of the first programs seems to take a
while. As general dependencies are installed, things will move very quickly.
Still, since this is a total online install, it might take a little longer than
just installing a distro from an ISO.

## Details

In addition to installing all the needed dependencies, LARBS also:

- Enables `wheel` users to run basic commands without passwords including
  shuttting down, rebooting and updating packages.
- Installs and enables NetworkManager and Pulseaudio.
- Disables the beep.

## Version

We're close to what can be called LARBS 2.0, and here are some of the major
changes since the original version.

- More documentation in the `getkeys` program and `mod+shift-e`.
- Luke's build of st is now the default terminal, instead of urxvt. This
  includes:
  	- Full unicode compatibility
	- vim-like bindings
	- Scrollback with keys and mouse, clipboard use and other add ons to
	  the default st build
	- Xresources colors, allowing the use of wal/pywal
- i3status is the status bar instead of Polybar, which was bloated and failed
  to build on many machines. The new i3status includes the modules below, all
  of which are constructed to be as minimal and light on system resources as
  possible:
  	- Weather forecasts using `wttr.in`, with highs, lows and rain chance.
	- Current song information from `mpd`
	- Unread mail from Luke's `mutt-wizard`
	- Possible pacman updates
	- Status of torrents in transmission-daemon
	- Expected date, time, battery, internet and volume modules
- Switch from mocp to mpd/ncmpcpp for music.
- System is more minimalist/suckless.
- dmenu is used instead of rofi for simplicity's sake.
- Deployment of my new mutt-wizard for secure offline email configuration
  instead of config files for the user to manually edit.
- Firefox instead of qutebrowser for default browser (qutebrowser configs
  remain for qutebrowser afeccionados)
- A default profile of Firefox including some privacy features, an ad-blocker
  and VimVixen, for vim-based keyboard shortcuts.
- Extensive implementation of dmenu, including for mounting/unmounting drives,
  display selection, confirmation for shutdown and other crucial commands, link
  handling and screen/audio recording.
- Updates to config files can be pulled with git now.
- i3 window resize now intuitive directions
- Removal of a lot of brainlethood in the original design, where I relocated
  configs for alleged extensibility's sake. That's all been fixed now.
- Configs for the new versions of qutebrowser, newsboat/newsbeuter, neomutt,
  etc.
- Link handling scripts for mutt, newsboat and vim
- vi mode is now default in bash (with retention of emacs-mode ctrl-l)
- Caps lock functions both as a super key and escape key with xcape.
- Use of the much better, newer version of my shortcut-sync.
- And the repository is *significantly* smaller than it was before, meaning a
  faster download.
- A million and one other tweaks and bug fixes.

### Soon to be added features

*At this point, all the planned features are there, and it's now just an issue
of fine-tuning them.*
