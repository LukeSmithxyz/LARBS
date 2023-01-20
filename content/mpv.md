---
title: "mpv"
date: 2023-01-17T11:39:29-05:00
---

mpv is a video-player so simple, it really just shows the video.
It is controlled by the keyboard and only shows even the progress bar and other interfaces when needed.

It is also used in LARBS to play single audio files if [mpd](/mpd) is not used.


## Documentation

`man mpv`

## Running

mpv is opened automatically when you select a video or audio file to open from [lf](/lf) or another program.
Obviously you can run it from the command line by running `mpv filename.mp4`, etc.

## Bindings

These are custom bindings for ease:

- <kbd>h</kbd>/<kbd>l</kbd> -- jump back/foward 10 seconds.
- <kbd>j</kbd>/<kbd>k</kbd> -- jump back/foward 60 seconds.
- <kbd>space</kbd> -- toggle pause.
- <kbd>S</kbd> -- toggle subtitles.
- <kbd>o</kbd> --  briefly view progress bar and time.
- <kbd>O</kbd> -- toggle time visibility.
- <kbd>i</kbd> -- show file and video information.

## Configuration

- `~/.config/mpv/input.conf` -- key bindings.
- `~/.config/mpv/` -- many other plugins can be added to mpv.

## Other

- If you download films, I recommend installing the program `subdl`, which you can run on a movie file and it will automatically check online for subtitle files. Give it the `-i` option to choose from the closest matches if the first result is slightly off.
- The LARBS binding <kbd>super + shift + P</kbd> will not only pause you music played in `mpd`, but also all audio/video instances of `mpv`.
- Press <kbd>super + F11</kbd> to see your webcam. This uses an instance of `mpv` as well.

GPLv2
