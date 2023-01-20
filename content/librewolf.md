---
title: "Librewolf"
date: 2023-01-19T08:51:04-05:00
---

Librewolf is a version of Firefox with Mozilla's odious spyware removed.

## Running

Press <kbd>super + w</kbd> or run `librewolf` in dmenu.

## Improvements to Librewolf in LARBS

### Arkenfox's user.js

With LARBS, [Arkenfox's user.js](https://github.com/arkenfox/user.js) is installed by default.
This is a set of default settings that set settings that increase user privacy and decrease the possibility of fingerprinting.

### Other tweaks

Other annoying Firefox features have been disabled, such as push notifications and the pocket.

With any of these settings or the Arkenfox ones, they can be changed in `about:config`.

### Add-ons

Several add-ons come installed by default.
Note that they can be immediately enabled by the user in the top right corner, but might not come enabled.

- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) -- ad-blocker.
- [Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/) -- third-party tracking protection.
- [I still don't care about cookies](https://addons.mozilla.org/en-US/firefox/addon/istilldontcareaboutcookies/) -- removes those stupid cookie notifications that the EU forced on us.
- [Vim Vixen](https://addons.mozilla.org/en-US/firefox/addon/vim-vixen/) -- vim key-bindings.
