---
title: "Ncmpcpp"
date: 2023-01-16T22:24:03-05:00
---

ncmpcpp is the main music player that interacts with the [music player daemon](/mpd).

ncmpcpp stands for *NCurses Music Player Client ++*.
Yes. I'm sorry it's unpronounceable, but it's the best at what it does...

{{< img src="/pix/ncmpcpp-02.png" class=normal >}}

## Running

Press <kbd>super + m</kbd>, or type `ncmpcpp` in the terminal.

For ncmpcpp to run, you should have [mpd](/mpd) set up and have audio files in your mpd directory.

## Bindings

Firstly, ncmpcpp has many different screens accessible through the number keys <kbd>1</kbd> to <kbd>8</kbd>. The most important of these have also been mapped to mneumonic letter keys:

- <kbd>m</kbd> -- main music library (press key again to alternate album/album artist views).
- <kbd>v</kbd> -- visualizer.
- <kbd>f</kbd> -- library by directory structure.
- <kbd>t</kbd> -- tagger.
- <kbd>s</kbd> -- detailed search.
- <kbd>1</kbd> -- current playlist.

{{< img src="/pix/ncmpcpp-03.png" class=normal >}}

- <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> -- navigate the music library view or select directories and songs.
- <kbd>enter</kbd> -- add selected to playlist and play now.
- <kbd>space</kbd> -- add to end of playlist.


- <kbd>.</kbd> -- show/download lyrics.

## Configuration

- `~/.config/ncmpcpp/config` -- main file controlling formatting and colors and other details.
- `~/.config/ncmpcpp/bindings` -- file customizing key bindings.
