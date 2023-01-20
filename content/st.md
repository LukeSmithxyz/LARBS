---
title: "st"
date: 2023-01-19T10:02:07-05:00
---

st (the simple terminal) is a simple terminal.

{{< img src=/pix/st.png link=/pix/st.png caption="Doesn't get simpler than this." class=normal >}}

## Running

Press <kbd>super + enter</kbd> for a basic terminal window.

## Documentation

`man st`

## Bindings

- <kbd>alt + j/k</kbd>/<kbd>alt + Up/Down</kbd>/<kbd>alt + mouse wheel</kbd> -- scroll up or down in the terminal history.
- <kbd>alt + u/d</kbd>/<kbd>alt + pageup/pagedown</kbd> -- faster scroll.
- <kbd>alt + shift + j/k</kbd> -- decrease or increase font size.
- <kbd>alt + c</kbd> -- copy selected text to clipboard.
- <kbd>shift + insert</kbd> -- paste clipboard contents.
- <kbd>alt + l</kbd> -- **open a link/URL**: pulls all URLs from terminal and allows you to pick one to open via dmenu.
- <kbd>alt + y</kbd> -- copy a link/URL: same as above, but copies the URL.
- <kbd>alt + o</kbd> -- **copy the output from a recent command.**
- <kbd>alt + a/s</kbd> -- decrease/increase transparency.

## Readline

Note that readline will use vim bindings by default.
Technically this is not part of `st`, but people get it confused.
If you don't like it, remove the `bindkey -v` line from the [zsh](/zsh) configuration.

## Source Code

- [st for LARBS](https://github.com/lukesmithxyz/st)
- [original st at suckless's website](https://st.suckless.org)
- MIT License
