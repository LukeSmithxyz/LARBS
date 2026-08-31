---
title: "Zathura"
date: 2026-08-31T09:24:45-04:00
---

Zathura is a vim-based minimalist PDF/djvu/ps/epub/comic book reader.

An annoyance about a lot of PDF readers is that they only read PDFs, but Zathura
can read a whole host of documents. This requires the necessary packages to be
installed, which can be found by running `pacman -Qi zathura` to see the
optional dependencies.

## Documentation

`man zathura`

## Bindings

- <kbd>h</kbd>, <kbd>j</kbd>, <kbd>k</kbd>, <kbd>l</kbd> -- move left/down/up/right in document.
- <kbd>d</kbd>/<kbd>u</kbd> -- down/up half a page.
- <kbd>gg</kbd>/<kbd>G</kbd> -- top/bottom of document.
- <kbd>f</kbd> -- highlight URLS to follow.
- <kbd>J</kbd>/<kbd>K</kbd> -- zoom out/in.
- <kbd>s</kbd>/<kbd>a</kbd> -- zoom to fit width/height.
- <kbd>r</kbd> -- reload document if changed.
- <kbd>R</kbd> -- rotate document.
- <kbd>D</kbd> -- toggle dual-page mode.
- <kbd>p</kbd> -- print document.
- <kbd>/</kbd> -- search document.
- <kbd>tab</kbd> -- chapter index.

## Configuration

- `~/.config/zathura/zathurarc` -- key bindings and other changes.

Zlib License
