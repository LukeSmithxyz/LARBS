# Luke's Auto-Rice Bootstraping Scripts (LARBS)

When you've installed Arch Linux 6 gorrillian times like me, you get pretty sick of having to reproduce your favorite configuration on fresh installs over and over. When you're a C-list YouTube celebrity, it gets even more difficult when literally thousands of people ask you how to do X or get Y.

The LARBS are a final solution to all of that. These scripts are to be run on a fresh install of Arch Linux, and they create a user, install all required programs and set up dotfiles directly from Github to give normal people a fairly sleek Linux configuration without hundreds of autsitic hours. I did the work, so why should you?

I've also documented the configuration fairly well, check out the documentation on my **voidrice** repository for that.

## What do you get?

[My dotfiles](https://github.com/lukesmithxyz/voidrice) and all their requisite programs installed without a problem.

All the core stuff we be installed without prompt, but you'll have the option to install some of the larger non-essential packages (LaTeX, LibreOffice, Blender, etc.).

## Installation

Once you've installed a fresh install of Arch Linux with an internet connection, but before making your user, just run the following in the command line as  root:

```
curl -O http://lukesmith.xyz/larbs/root.sh #Downloads the script.
bash root.sh #To run it.
```

This will prompt you to create a user and a password and install all of the basic pacakges in the Arch repos.

In the process, it will also download another script to be run as the user (this is all automated). This will install `packer`, an AUR helper, and will use it to install the last few (very important) programs from the AUR.

Finally, it will use `git` to download my [Voidrice](https://github.com/lukesmithxyz/voidrice) dotfiles and will plop them in their proper location for instant use!

Then, finally, once that all is done, you should be able to type `startx` to begin the graphical environment. Congrats!

## How to Use

Once you're in the environment, just type Super/Mod/Windows+F1 to pull up a document that will explain everything.

## Permission Details (sudoers file)

These script will give your new created user (and those others you put in the `wheel` group) sudo access (with a password), but will also allow some commands to be run without any password confirmation. Those include:

+ `shutdown`
+ `reboot`
+ `pacman -Syyu`/`pacman -Syu`
+ `packer -Syyu`/`packer -Syu`
+ `mount`
+ `umount`
+ `systemctl restart NetworkManager`

Additionally, if you've put your password in a terminal window already, you will not need to repeat putting it in in other terminal windows.

## Version

We're basically on Version 2.0 now, which is still pretty primitive. I'm adding some error handling, if the script fails, check the contents of LARBS.log in whatever directory you've run the script. Still, this script is still in the Wild West, so I recommend only running it on fresh installs.

## Bugs?

### When I type `startx` I get some kind of non-descript error!

Some computers might require some additional drivers to run a graphical environment, for example, some ThinkPads might require you to install `xf86-video-intel`. If you search your model or graphics card along with "Arch Linux" on your preferred search engine, you'll probably get the answer fast.

### I have some other problem and it didn't install correctly.

In normal circumstances, there are two main causes of misinstalls: faulty internet connections and errors with particular package upgrades or with the pacman keyring.

Check yourself if the former may be at fault, but feel free to inform me in the latter case; I may be able to provide a quick fix.

Regardless, it's generally safe to rerun the script if something temporary went wrong, although you may want to delete the user created before rerunning:

```
userdel USER
```

### >still using systemd botnet distro and/or not a 100% free-as-in-freedumb Parabola GANOO slash Linocks

I do plan on making an alternative script option for Parabola sooner or later, after all Parabola *is* the distro I actually use. If you want to use Arch OpenRC or another Arch-based non-systemd distro, I think this script still *should* work, although you may have to manually enable Network Manager or Pulseaudio. I haven't tested this though. If you have, tell me the results and I might implement it.
