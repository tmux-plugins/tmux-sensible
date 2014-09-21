# Changelog

### master
- bugfix: prevent exiting tmux if 'reattach-to-user-namespace' is not installed

### v1.1.0, 2014-08-30
- bugfix: determine the default shell from the $SHELL env var on OS X
- set `mode-mouse on` by default
- do not make any decision about the prefix, just enhance it
- update `README.md`. List options set in the plugin.
- do *not* set `mode-mouse on` by default because some users don't like it
- if a user changes default prefix but binds `C-b` to something else, do not
  unbind `C-b`

### v1.0.0, 2014-07-30
- initial work on the plugin
- add readme
