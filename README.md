# Luke's Auto-Rice Bootstraping Scripts (LARBS)


## Installation:

On an Arch based distribution as root, run the following:

```
curl -LO lukesmith.xyz/larbs.sh
bash larbs.sh
```

That's it.

## What is LARBS?

LARBS is a script that autoinstalls and autoconfigures a fully-functioning
and minimal terminal-and-vim-based Arch Linux environment.

LARBS was originally intended to be run on a fresh install of Arch Linux, and
provides you with a fully configured diving-board for work or more
customization. But LARBS also works on already configured systems *and* other
Arch-based distros such as Manjaro, Antergos and Parabola (although Parabola,
which uses slightly different repositories might miss one or two minor
programs).

Here are some of the things LARBS sets up:

- Installs i3-gaps, a tiling window manager, with my fully featured
  configuration along with dozens of lightweight and vim-centric terminal
  applications that replace the more over-encumbering
  programs on most machines.
- Massive documentation making use even for novices seamless. A help document
  with all bindings for the window manager accessible with `Super+F1` at all
  times, as well as commands such as `getkeys` which print the default bindings
  of terminal applications. You can even stream instructional videos on topics
  with `Super+Shift+E`.
- Installs [my dotfiles](https://github.com/lukesmithxyz/voidrice) giving as
  popularized on [my YouTube channel](https://youtube.com/c/Lukesmithxyz).
- Sets up system requirements such as users, permissions, networking, audio and
  an AUR manager.
- All done behind a `dialog` based user interface.

## Changes since first release
- [CHANGES.md](CHANGES.md)

## Customization

By default, LARBS uses the programs [here in progs.csv](progs.csv) and installs
[my dotfiles repo (voidrice) here](https://github.com/lukesmithxyz/voidrice),
but you can easily change this by either modifying the default variables at the
beginning of the script or giving the script one of these options:

- `-r`: custom dotfiles repository (URL)
- `-p`: custom programs list/dependencies (local file or URL)
- `-a`: a custom AUR helper (must be able to install with `-S` unless you
  change the relevant line in the script
### Adding tap to click
For this you need to modify `/etc/X11/xorg.conf.d/<synaptics-file>` where the
snaptics file will be something like: `30-touchpad.conf` the basic contents should
look like this.
```
/etc/X11/xorg.conf.d/30-touchpad.conf
	Section "InputClass"
	Identifier "devname"
    	Driver "libinput"
    	...
EndSection
```
**Edit that file to contain the following:**
```
Option "Tapping" "on"
```

More information on this can be found on the [Arch wiki](https://wiki.archlinux.org/index.php/Libinput)

### The `progs.csv` list

LARBS will parse the given programs list and install all given programs. Note
that the programs file must be a three column `.csv`.

The first column is a "tag" that determines how the program is installed, ""
(blank) for the main repository, `A` for via the AUR or `G` if the program is a
git repository that is meant to be `make && sudo make install`ed.

The second column is the name of the program in the repository, or the link to
the git repository, and the third comment is a description (should be a verb
phrase) that describes the program. During installation, LARBS will print out
this information in a grammatical sentence. It also doubles as documentation
for people who read the csv or who want to install my dotfiles manually.

Depending on your own build, you may want to tactically order the programs in
your programs file. LARBS will install from the top to the bottom.

If you include commas in your program descriptions, be sure to include double quotes around the whole description to ensure correct parsing.

### The script itself

The script is broken up extensively into functions for easier readability and
trouble-shooting. Most everything should be self-explanatory.

The main work is done by the `installationloop` function, which iterates
through the programs file and determines based on the tag of each program,
which commands to run to install it. You can easily add new methods of
installations and tags as well.

Note that programs from the AUR can only be built by a non-root user. What
LARBS does to bypass this by default is to temporarily allow the newly created
user to use `sudo` without a password (so the user won't be prompted for a
password multiple times in installation). This is done ad-hocly, but
effectively with the `newperms` function. At the end of installation,
`newperms` removes those settings, giving the user the ability to run only
several basic sudo commands without a password (`shutdown`, `reboot`,
`pacman -Syu`).

## To-do list

- Provide documentation on how to update dotfiles from remote repository.
- Keyboard luminosity script.
- Add notification icons?
