# Email

The mail solution is a combination of Aerc, Notmuch, Lei, and a custom Python
script.

Lei (or whatever else) downloads mails into an old fashioned maildir at
`~/mail`. Then Notmuch indexes and tags it. Then Aerc has a mailbox view for
each of the queries defined in `query-map.conf`. Notmuch tags are used to store
state, importantly:

- `archived` means I'm finished with that mail.
- `mute-thread` is a "command tag" which means "I'm done with this mail and I
  don't wanna see any replies to it". This is implemented by
  `notmuch_propagate_mute.py` which walks down the thread from any
  `mute-thread`-tagged message applying the tag `thread-muted` to each messsage.
  Then the Aerc `query-map.conf` will filter that tag out of the Inbox view.

Run `get_mail.sh` to initialise/update the mailbox. This has a hardcoded cutoff
date in April 2025.

Setup:

```
sudo apt install aerc notmuch python3-notmuch lei
```