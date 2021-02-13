# Luke's Auto-Rice Bootstrapping Scripts (LARBS)


## Installation:

On an Arch-based distribution as root, run the following:

```
curl -LO larbs.xyz/larbs.sh
sh larbs.sh
```

That's it.

## What is LARBS?

LARBS is a script that auto-installs and autoconfigures a fully-functioning
and minimal terminal-and-vim-based Arch Linux environment.

LARBS can be run on a fresh install of Arch or Artix Linux and provides you
with a fully configured diving-board for work or more customization.

## Customization

By default, LARBS uses the programs [here in progs.csv](progs.csv) and installs
[my dotfiles repo (voidrice) here](https://github.com/lukesmithxyz/voidrice),
but you can easily change this by either modifying the default variables at the
beginning of the script or giving the script one of these options:

- `-r`: custom dotfiles repository (URL)
- `-p`: custom programs list/dependencies (local file or URL)
- `-a`: a custom AUR helper (must be able to install with `-S` unless you
  change the relevant line in the script

### The `progs.csv` list

LARBS will parse the given programs list and install all given programs. Note
that the programs file must be a three column `.csv`.

The first column is a "tag" that determines how the program is installed, ""
(blank) for the main repository, `A` for via the AUR or `G` if the program is a
git repository meant to be `make && sudo make install`ed. `V`if it's for
the Void Linux distribution's `xbps` package manager.

The second column is the program's name in the repository or the link to
the git repository, and the third column is a description (should be a verb
phrase) describing the program. During installation, LARBS will print out
this information in a grammatical sentence. It also doubles as documentation
for people who read the CSV or install my dotfiles manually.

Depending on your build, you may want to order the programs in
your programs file tactically. LARBS will install from top to bottom.

If you include commas in your program descriptions, be sure to have double
quotes around the whole description to ensure correct parsing.

### The script itself

The script is extensively divided into functions for easier readability and
trouble-shooting. Almost everything should be self-explanatory.

The main work is done by the `installationloop` function, which iterates
through the programs file and determines, based on each program's tag,
which commands to run to install it. You can easily add new methods of
installations and tags as well.

Note that programs from the AUR can only be built by a non-root user. What
LARBS does to bypass this by default is to temporarily allow the newly created
user to use `sudo` without a password (so the user won't be prompted for a
password multiple times in installation). This is done ad-hoc, but
effectively with the `newperms` function. At the end of the installation,
`newperms` will remove those settings, giving the user the ability to run only
several basic sudo commands without a password (`shutdown`, `reboot`,
`pacman -Syu`).
