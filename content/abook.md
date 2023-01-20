---
title: "Abook"
date: 2023-01-17T11:54:20-05:00
---

The address book.

Why let Google or Apple keep your contacts? Keep an archive on your computer and export them when you need them.
Abook is a minimal and local store of your contacts, including emails, phone numbers, addressess and whatever you might need.
Abook integrates with neomutt's autofill as well and you can script more functionality into it.

## Documentation

`man abook`

## Running

Press <kbd>super + shift + e</kbd> or run `abook` in the terminal.

## Bindings

Thankfully, abook is self-documenting: press <kbd>?</kbd> at any time to see its binds. Here are some of the most common:

- <kbd>a</kbd> -- add a contact.
- <kbd>j</kbd>/<kbd>k</kbd> -- move up and down.
- <kbd>enter</kbd> -- enter a contact.
- <kbd>h</kbd>/<kbd>l</kbd> -- (on a contact page) move from tab to tab.
- <kbd>0-9</kbd> -- (on a contact page) edit/change contact information in a field.
- <kbd>d</kbd> -- delete a contact.
- <kbd>D</kbd> -- duplicate a contact.
- <kbd>S</kbd> -- sort existing contacts.

## Extending

Using with email
: abook works out of the box with [neomutt](/neomutt). In neomutt, when you compose a new message, if you press tab, neomutt will automatically tab-complete from your abook contacts.

Using telephone numbers
: There are some services that offer computer-based calling. Since abook can export a list of contacts with data, you can use programs like dmenu to select one you want:
```fish
abook --convert --infile ~/.abook/addressbook --outformatstr="\!{name} {mobile}" --outformat=custom  | dmenu -i -l 30
```
This can easily be integrated into a script.


## Links

- [website](https://abook.sourceforge.io/)
- GPLv2
