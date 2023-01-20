---
title: "Neomutt"
date: 2023-01-16T16:15:58-05:00
---

Neomutt is a fast terminal-based email client.

{{< img src="/pix/neomutt.png" class=normal >}}

## Setup with Mutt Wizard

Use [mutt-wizard](https://muttwizard.com) (`mw`) to add mail accounts. This is already installed on LARBS. Added accounts will be accessible from neomutt. To add your first account, just run the following:

```fish
mw -a your@email.com
```

Once you have installed accounts, sync them with the command `mailsync`, or by pressing <kbd>super + F8</kbd>.

## Running

Press <kbd>super + e</kbd> or type `neomutt` manually in the terminal.


## Bindings

Note also that neomutt automatically documents itself: you can press <kbd>?</kbd> at any time in the program and you will see a list of all shortcuts for the screen you are on.

### In the mail index...

- <kbd>j</kbd>, <kbd>k</kbd> -- move up and down in mail.
- <kbd>l</kbd> or <kbd>enter</kbd> -- open mail, or return to index.
- <kbd>h</kbd> or <kbd>esc</kbd> -- return from mail to index.
- <kbd>m</kbd> -- compose new mail.
- <kbd>r</kbd> -- reply to selected mail.
- <kbd>R</kbd> -- reply all to selected mail.
- <kbd>ctrl-j</kbd>/<kbd>ctrl-k</kbd> -- move up or down in the sidebar.
- <kbd>ctrl-o</kbd> -- open the box highlighted in the sidebar.
- <kbd>space</kbd> -- select mail. (See below).

mutt-wizard automatically sets automatic binds to move to or move mail to other boxes. Press one of these keys:

- <kbd>g</kbd> -- go to...
- <kbd>M</kbd> -- move selected mail to...
- <kbd>C</kbd> -- copy selected mail to...

And then follow it with one of these keys:

- <kbd>i</kbd> -- ...the inbox.
- <kbd>d</kbd> -- ...drafts.
- <kbd>s</kbd> -- ...the sent box.
- <kbd>a</kbd> -- ...the archive.
- <kbd>j</kbd> -- ...junk.

### With mail open...

Some binds above are shared.

- <kbd>j</kbd>/<kbd>k</kbd> -- scroll up and down.
- <kbd>J</kbd>/<kbd>K</kbd> -- next or previous mail.
- <kbd>v</kbd> -- view attachments. This can be used for opening annoying HTML ad emails in the browser. You can also save the selected attachment with <kbd>s</kbd>.

### On the compose screen...

- <kbd>a</kbd> -- attach a file.
- <kbd>m</kbd> -- edit highlighted attachment in text editor.
- <kbd>S</kbd> -- choose to sign or encrypt mail (usually with PGP).
- <kbd>y</kbd> -- send mail.

## Configuration

- `~/.config/mutt/muttrc` -- main configuration file
- `~/.config/mutt/accounts/` -- where mutt-wizard will put account-specific configuration files, named after your email addresses
- `~/.local/share/mail/` -- where your mail is stored.

## Extending

Neomutt is one of the most extensible programs on the planet. I am constantly surprised by what you can do with it. If you are ever bored, yet hungry for efficiency, check out the neomutt and neomuttrc manuals.

One nice little thing is how widely aliases can be used. For example, we can add a line like this to our muttrc:

```muttrc
alias besties luke@email.com, richard@email.com, linus@email.com
```

This aliases the sequence `besties` to the following text/email addresses. So we can just type `besties` as a recipient of a mail, and the other addresses will be filled in.

Note also that neomutt is configured to tab complete contact information stored with [abook](/abook) automatically.

## Documentation

`man neomutt` or `man neomuttrc`.

[Mutt/Neomutt on the ArchWiki](https://wiki.archlinux.org/title/Mutt)
