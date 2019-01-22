# Changes since first release

- More documentation in the `getkeys` program and `mod+shift-e`.
- Luke's build of st is now the default terminal, instead of urxvt. This
  includes:
  	- Full unicode compatibility
	- vim-like bindings
	- Scrollback with keys and mouse, clipboard use and other add ons to
	  the default st build
	- Xresources colors, allowing the use of wal/pywal
- i3status is the status bar instead of Polybar, which was bloated and failed
  to build on many machines. The new i3status includes the modules below, all
  of which are constructed to be as minimal and light on system resources as
  possible:
  	- Weather forecasts using `wttr.in`, with highs, lows and rain chance.
	- Current song information from `mpd`
	- Unread mail from Luke's `mutt-wizard`
	- Possible pacman updates
	- Status of torrents in transmission-daemon
	- Expected date, time, battery, internet and volume modules
- Switch from mocp to mpd/ncmpcpp for music.
- System is more minimalist/suckless.
- dmenu is used instead of rofi for simplicity's sake.
- Deployment of my new mutt-wizard for secure offline email configuration
  instead of config files for the user to manually edit.
- Firefox instead of qutebrowser for default browser (qutebrowser configs
  remain for qutebrowser afeccionados)
- A default profile of Firefox including some privacy features, an ad-blocker
  and VimVixen, for vim-based keyboard shortcuts.
- Extensive implementation of dmenu, including for mounting/unmounting drives,
  display selection, confirmation for shutdown and other crucial commands, link
  handling and screen/audio recording.
- Updates to config files can be pulled with git now.
- i3 window resize now intuitive directions
- Removal of a lot of brainlethood in the original design, where I relocated
  configs for alleged extensibility's sake. That's all been fixed now.
- Configs for the new versions of qutebrowser, newsboat/newsbeuter, neomutt,
  etc.
- Link handling scripts for mutt, newsboat and vim
- vi mode is now default in bash (with retention of emacs-mode ctrl-l)
- Caps lock functions both as a super key and escape key with xcape.
- Use of the much better, newer version of my shortcut-sync.
- And the repository is *significantly* smaller than it was before, meaning a
  faster download.
- A million and one other tweaks and bug fixes.
