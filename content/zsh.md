---
title: "Zsh"
date: 2023-01-19T10:24:07-05:00
---

zsh is the shell used by LARBS.

## Files

- `~/.config/zsh/.zshrc` -- the main zshrc file. Run `cfz` in the terminal for quick access.
- `~/.config/shell/aliasrc` -- a separate file called by the zshrc for loading aliases that might be shared in common with bash or other shells. This is kept separate merely for organizational purposes. You can add aliases to this file or the zsh file. Run `cfa` for quick access. By default, it mostly sets aliases that will yield more colorful output and verbosity in interactive shells.
- `~/.zprofile` -- the profile file, where environmental variables are set. This is only run on login. Do not put your custom settings here unless you know what you are doing.
- `~/.config/shell/inputrc` -- This file shouldn't be edited, but contains special settings for the vi-mode in zsh that allow you to clear the screen with <kbd>ctrl + l</kbd> and also to have a different cursor for each mode: a thick bar for normal mode and a thin line for insert.

## Little features

- Press <kbd>ctrl + o</kbd> to open a special instance of [lf](/lf). It works like normal lf, but if you press <kbd>q</kbd> to quit, zsh will automatically change directory to the directory you ended up in. Useful to quickly navigate directories without typing.
- <kbd>ctrl + f</kbd> -- use `fzf` to search for a file deep in this directory structure. Selecting it will change the directory to where it is.
- <kbd>ctrl + a</kbd> -- open an instance of `bc` to do some arithmetic if needed. Press <kbd>ctrl + d</kbd> to exit.

## Source code

- [website](https://zsh.sourceforge.io/)
- Permissive license with copyleft components
