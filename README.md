# Tmux sensible

A set of tmux options that should be acceptable for everyone.

Inspired by [vim-sensible](https://github.com/tpope/vim-sensible).

### Principles

- `tmux-sensible` options should be acceptable to **every** tmux user!<br/>
  If any option bothers you, please open an issue and it will probably be
  updated (or removed).
- if you think a new option should be added, feel free to open a pull request.
- **no overriding** of user defined settings.<br/>
  Your existing `.tmux.conf` settings are respected and they won't be changed.
  That way you can use `tmux-sensible` if you have a few specific options.
  See [feature section](#example-feature) for an example.
- [source code](https://github.com/tmux-plugins/tmux-sensible/blob/master/sensible.tmux)
  is the authoritative documentation.<br/>
  It's really not that scary and you should have a look, even if you're a
  tmux beginner.

### Goals

- group standard tmux community options in one place
- remove clutter from your `.tmux.conf`
- educate new tmux users about basic options

### Example feature

Sets tmux prefix to `Ctrl-a`.

    # set prefix to `Ctrl-a`
    tmux set-option -g prefix C-a
    tmux unbind-key C-b

Since user defined `.tmux.conf` settings are respected, if prefix is set to
`Ctrl-z` - it won't be overriden!

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins "             \
      tmux-plugins/tpm                \
      tmux-plugins/tmux-sensible      \
    "

Hit `prefix + I` to fetch the plugin and source it. That's it!

You might also want to restart your tmux server, just in case.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-sensible ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/sensible.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You might also want to restart your tmux server, just in case.

### Other goodies

You might also find these useful:

- [copycat](https://github.com/tmux-plugins/tmux-copycat)
  improve tmux search and reduce mouse usage
- [pain control](https://github.com/tmux-plugins/tmux-pain-control)
  useful standard bindings for controlling panes

### License

[MIT](LICENSE.md)
