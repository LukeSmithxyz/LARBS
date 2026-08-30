---
title: "nsxiv"
date: 2026-08-30T10:16:02-04:00
---

## Documentation

`man nsxiv`

## Running

nsxiv is opened automatically when you select an image file to open from
[lf](/lf) or another program. Handles images, animated gifs, has additional
thumbnail and slideshow modes and allows you to run custom scripts and
read/write to standard input/output.

## Bindings

- <kbd>f</kbd> -- toggles fullscreen.
- <kbd>b</kbd> -- toggles the statusbar.
- <kbd>ctrl-x</kbd> -- then press one of the following to execute a command:
	- <kbd>c</kbd> -- select a bookmarked directory to copy the image to.
	- <kbd>m</kbd> -- select a bookmarked directory to move the image to.
	- <kbd>d</kbd> -- deletes the image.
	- <kbd>r</kbd>/<kbd>R</kbd> -- rotates the image.
	- <kbd>f</kbd> -- flips the image.
	- <kbd>y</kbd> -- copies the image name to clipboard.
	- <kbd>Y</kbd> -- copies the image path to clipboard.
	- <kbd>x</kbd> -- copies the image file to clipboard.
	- <kbd>g</kbd> -- opens the image in Gimp.
	- <kbd>w</kbd> -- set the image as the wallpaper.
	- <kbd>i</kbd> -- shows image information.

## Configuration

- `~/.config/nsxiv/exec/key-handler` -- key/script handler

GPLv2
