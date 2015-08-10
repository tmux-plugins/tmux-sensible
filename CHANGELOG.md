# Changelog

### master
- remove `detach-on-destroy`
- do not set `aggressive-resize` on iTerm terminal
- disable `detach-on-destroy`

### v3.0.0, 2015-06-24
- remove 'almost sensible' feature

### v2.3.0, 2015-06-24
- update to support \*THE\* latest tmux version
- bugfix for `prefix + R` key binding
- fix for tmux 2.0 `default-terminal` option (thanks @kwbr)

### v2.2.0, 2015-02-10
- bugfix in `key_binding_not_set`: the regex is now properly detecting key
  bindings with `-r` flag.
- enable `aggressive-resize`

### v2.1.0, 2014-12-12
- check before binding `prefix + prefix` (@m1foley)
- enable `focus-events`
- deprecate 'almost sensible' feature. The reason for this is to focus the
  plugin on doing just one thing.

### v2.0.0, 2014-10-03
- bugfix: prevent exiting tmux if 'reattach-to-user-namespace' is not installed
- remove all mouse-related options
- introduce 'almost sensible' setting and options

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
