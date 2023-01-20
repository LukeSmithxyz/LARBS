---
title: "Newsboat"
date: 2023-01-19T11:37:10-05:00
---

Newsboat is an RSS-reader.

A normal person asks: "What is an RSS reader?"

It's a way to follow sites and social media updates without needing social media.

## Documentation

`man newsboat`

## Running

Press <kbd>super + shift + n</kbd> or run `newsboat` in the terminal.

## Bindings

- <kbd>j</kbd>/<kbd>k</kbd> -- move up and down.
- <kbd>enter</kbd> -- enter feed or article.
- <kbd>q</kbd> -- return to previous screen or quit.
- <kbd>h</kbd>/<kbd>l</kbd> -- open feed or return (same as <kbd>q</kbd> and <kbd>enter</kbd>).
- <kbd>a</kbd> -- mark as read.
- <kbd>n</kbd> -- go to next unread.
- <kbd>A</kbd> -- mark all as read.
- <kbd>,,</kbd> -- open the main link of an article. (Usually opens in a browser, or if a video, will play the video in [mpv](mpv).)
- <kbd>u</kbd>/<kbd>d</kbd> -- page up and down.
- <kbd>g</kbd>/<kbd>G</kbd> -- go to top or bottom of screen.

To follow a visible link, use the [st](st) binding <kbd>alt + l</kbd>, or to just copy it, <kbd>alt + k</kbd>.


## Files

- `~/.config/newsboat/urls` -- the file holding your RSS feeds. Add URLs here to make them appear in newsboat. Open itquickly by typing `cfu` in the terminal.
- `~/.config/newsboat/config` -- the general newsboat config. Type `cfn` in the terminal. You can set granulated coloring and effects here, as well as change key bindings.
- `~/.local/bin/linkhandler` -- the opener file used by newsboat for dealing with URLs with the <kbd>,,</kbd> binding. This can be modified as needed. By default, it opens normal URLs in a browser, opens videos with [mpv](mpv), downloads audio/podcast files and downloads and opens images with [sxiv](sxiv), etc.

## Links

- [newsboat website](https://newsboat.org/)
- MIT License
