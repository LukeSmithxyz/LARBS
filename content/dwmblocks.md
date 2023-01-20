---
title: "dwmblocks"
date: 2023-01-19T09:15:59-05:00
---

dwmblocks is the statusbar command which hosts many customizable and extensible modules.

{{< img src="/pix/dwmblocks.png" class=normal link="/pix/dwmblocks.png" caption="dwmblocks and its weather forecast, doppler radar and Bitcoin price monitors open." >}}

## Using

dwmblocks runs automatically when dwm starts, appearing as many modules in the top right, and will update as needed.

Right click on the active modules for an informational message about them.

Left and middle clicking, and sometime scrolling, often have some functional reaction, like bringing up a relevant program.

## Modules

There are modules for time and date, laptop battery, internet and volume that should be self-explanatory.

There are also modules a three-day weather forecast from [wttr.in](https://wttr.in) and the module with a 🌅 even allows you to view a Doppler RADAR of your chosen location.

There are other user-submitted modules, for IP locations, keyboard selection, memory and CPU monitoring and more.

## Files

- `~/.local/src/dwmblocks/` -- the source code.
- `~/.local/src/dwmblocks/config.h` -- where modules can be added. You can open this file automatically by shift right clicking on the status bar.
- `~/.local/bin/statusbar/` -- the scripts made for the statusbar. Note that not all are activated by default and you can add new ones as desired. You can also open an individual module's script by shift left clicking on the module.


## Signals and updating

In the `config.h` file, you will notice that each statusbar module should have a unique "Update Signal."
For modules that need to update at set events, you

For example, the `sb-volume` module has the update signal `10` by default. If we manually run the command:

```fish
wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+
```

This happens to increase the volume, but the module *does not* update with the new volume by default.
We also want to signal to dwmblocks to update this module by sending it signal `10`:

```fish
pkill -RTMIN+10 dwmblocks
```

This will now update the module.
Although, `pkill` is slightly slower than the command `kill`, which can make a big difference if we are making semi-frequent changes in a script. To signal with `kill`, we must send the value **plus 34**.
Just remember 34.

So `10 + 34 = 44`, so we use this command:

```fish
kill -44 $(pidof dwmblocks)
```

(Note also we send the signal to the process ID of dwmblocks as well.)


## Source code

- [The build for LARBS](https://github.com/lukesmithxyz/dwmblocks)
- [the original dwmblocks](https://github.com/torrinfail/dwmblocks)
- ISC License.
