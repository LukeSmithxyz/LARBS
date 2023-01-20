---
title: "lf"
date: 2022-12-21T17:07:04-05:00
---

lf is the file manager used in LARBS.
It was original inspired by the program ranger, but unlike ranger, lf is written in Go instead of Python, so is significantly snappier and adds better features for interaction between different lf instances.

{{< img src="/pix/lf.png" class=normal caption="Note that lf uses ueberzug to produce previews of images, or here, a .pdf." >}}

## Running

Run lf by pressing <kbd>super + r</kbd>, or type `lf` manually in the termianl.

## Bindings

- <kbd>h</kbd>, <kbd>j</kbd>, <kbd>k</kbd> <kbd>l</kbd> (vim keys) to move around and enter directories and open files.
- <kbd>g</kbd>, <kbd>G</kbd>, <kbd>ctrl-d</kbd>,  <kbd>ctrl-u</kbd> -- movement like in vim.
- <kbd>w</kbd> -- drop into a terminal in the current directory. If you `exit` or press <kbd>ctrl-d</kbd> in the termianl, you will return to `lf`.
- <kbd>ctrl-n</kbd> -- new directory.
- <kbd>V</kbd> -- new file with `nvim`.
- <kbd>space</kbd> -- select files:
	- <kbd>d</kbd> -- cut files to lf's clipboard.
	- <kbd>y</kbd> -- yank files to lf's clipboard.
	- <kbd>p</kbd> -- paste/move copied/cut files.
	- <kbd>C</kbd> -- copy selected files to a bookmarked directory.
	- <kbd>M</kbd> -- move selected files to a bookmarked directory.
	- <kbd>Y</kbd> -- copy text names of selected files to the system clipboard.
- Renaming files:
	- <kbd>c</kbd> -- rename the selected file.
	- <kbd>A</kbd> -- rename the selected file, starting at end.
	- <kbd>a</kbd> -- rename the selected file, starting after the extension.
	- <kbd>I</kbd> -- rename the selected file, starting at beginning.
	- <kbd>i</kbd> -- rename the selected file, starting before extension.
	- <kbd>B</kbd> -- **bulk rename**: use vidir to mass edit all files in the directory.
- <kbd>s</kbd> -- sort files by a different metric.
- <kbd>z</kbd> -- show extra data or hidden files.

This list is not necessarily exhaustive. See `man lf` and the lf configuration file for more.

## lf's configuration files

- `~/.confif/lf/lfrc` -- The main lf configuration.
- `~/.config/lf/scope` -- The file that determines which commands generates previews for files.

The other files in the `~/.config/lf/` directory are run automatically when needed.

---

## Notes

Notice that `alias lf` will tell you that technically you are running the
wrapper script `lfub` when you run `lf`. This has to do with `ueberzug`, the
program that generates image previews.
