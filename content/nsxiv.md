---
title: "nsxiv"
date: 2026-08-30T10:16:02-04:00
---

nsxiv is opened automatically when you select an image file to open from
[lf](/lf) or another program. Handles images, animated gifs, has additional
thumbnail and slideshow modes and allows you to run custom scripts and
read/write to standard input/output.

## Documentation

`man nsxiv`

## Bindings

- <kbd>h</kbd>, <kbd>l</kbd>, <kbd>j</kbd>, <kbd>k</kbd> -- pans image/moves selection.
- <kbd>-</kbd>/<kbd>+</kbd> -- zooms out/in.
- <kbd>enter</kbd> -- toggles thumbnail mode.
- <kbd>f</kbd> -- toggles fullscreen.
- <kbd>n</kbd>/<kbd>p</kbd> -- goes forward/backward an image.
- <kbd>r</kbd> -- reloads image if changed.
- <kbd>w</kbd> -- fits image to window.
- <kbd>e</kbd>/<kbd>E</kbd> -- fits image to width/height.
- <kbd>\<</kbd>/<kbd>></kbd> -- rotates image.
- <kbd>?</kbd> -- rotates image 180 degrees.
- <kbd>|</kbd>/<kbd>_</kbd> -- flips image.
- <kbd>m</kbd> - Mark/unmark image.
- <kbd>ctrl-x</kbd> -- then press one of the following to execute a command:
	- <kbd>c</kbd> -- select a bookmarked directory to copy the image to.
	- <kbd>m</kbd> -- select a bookmarked directory to move the image to.
	- <kbd>d</kbd> -- deletes the image.
	- <kbd>r</kbd>/<kbd>R</kbd> -- rotates the image and saves to file.
	- <kbd>f</kbd> -- flips the image and saves to file.
	- <kbd>y</kbd> -- copies the image name to clipboard.
	- <kbd>Y</kbd> -- copies the image path to clipboard.
	- <kbd>x</kbd> -- copies the image file to clipboard.
	- <kbd>g</kbd> -- opens the image in Gimp.
	- <kbd>w</kbd> -- set the image as the wallpaper.
	- <kbd>i</kbd> -- shows image information.
- <kbd>b</kbd> -- toggles the statusbar.

## Configuration

- `~/.config/nsxiv/exec/key-handler` -- key/script handler

GPLv2
