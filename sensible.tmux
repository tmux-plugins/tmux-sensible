#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Try to find the executable path of the currently running 
# tmux server, fallback to just "tmux" if not found or no 
# procfs aviliable (non-linux).
export TMUX_CMD_PATH=$(realpath "/proc/$(tmux display -p '#{pid}')/exe" 2> /dev/null || echo "tmux" | sed -z '$ s/\n$//')
echo "tmux executable used: $TMUX_CMD_PATH"

# used to match output from `tmux list-keys`
KEY_BINDING_REGEX="bind-key[[:space:]]\+\(-r[[:space:]]\+\)\?\(-T prefix[[:space:]]\+\)\?"

is_osx() {
	local platform=$(uname)
	[ "$platform" == "Darwin" ]
}

iterm_terminal() {
	[[ "$TERM_PROGRAM" =~ ^iTerm ]]
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

# returns prefix key, e.g. 'C-a'
prefix() {
	$TMUX_CMD_PATH show-option -gv prefix
}

# if prefix is 'C-a', this function returns 'a'
prefix_without_ctrl() {
	local prefix="$(prefix)"
	echo "$prefix" | cut -d '-' -f2
}

option_value_not_changed() {
	local option="$1"
	local default_value="$2"
	local option_value=$($TMUX_CMD_PATH show-option -gv "$option")
	[ "$option_value" == "$default_value" ]
}

server_option_value_not_changed() {
	local option="$1"
	local default_value="$2"
	local option_value=$($TMUX_CMD_PATH show-option -sv "$option")
	[ "$option_value" == "$default_value" ]
}

key_binding_not_set() {
	local key="$1"
	if $($TMUX_CMD_PATH list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]"); then
		return 1
	else
		return 0
	fi
}

key_binding_not_changed() {
	local key="$1"
	local default_value="$2"
	if $($TMUX_CMD_PATH list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]\+${default_value}"); then
		# key still has the default binding
		return 0
	else
		return 1
	fi
}

main() {
	# OPTIONS

	# enable utf8 (option removed in tmux 2.2)
	$TMUX_CMD_PATH set-option -g utf8 on 2>/dev/null

	# enable utf8 in tmux status-left and status-right (option removed in tmux 2.2)
	$TMUX_CMD_PATH set-option -g status-utf8 on 2>/dev/null

	# address vim mode switching delay (http://superuser.com/a/252717/65504)
	if server_option_value_not_changed "escape-time" "500"; then
		$TMUX_CMD_PATH set-option -s escape-time 0
	fi

	# increase scrollback buffer size
	if option_value_not_changed "history-limit" "2000"; then
		$TMUX_CMD_PATH set-option -g history-limit 50000
	fi

	# tmux messages are displayed for 4 seconds
	if option_value_not_changed "display-time" "750"; then
		$TMUX_CMD_PATH set-option -g display-time 4000
	fi

	# refresh 'status-left' and 'status-right' more often
	if option_value_not_changed "status-interval" "15"; then
		$TMUX_CMD_PATH set-option -g status-interval 5
	fi

	# required (only) on OS X
	if is_osx && command_exists "reattach-to-user-namespace" && option_value_not_changed "default-command" ""; then
		$TMUX_CMD_PATH set-option -g default-command "reattach-to-user-namespace -l $SHELL"
	fi

	# upgrade $TERM, tmux 1.9
	if option_value_not_changed "default-terminal" "screen"; then
		$TMUX_CMD_PATH set-option -g default-terminal "screen-256color"
	fi
	# upgrade $TERM, tmux 2.0+
	if server_option_value_not_changed "default-terminal" "screen"; then
		$TMUX_CMD_PATH set-option -s default-terminal "screen-256color"
	fi

	# emacs key bindings in tmux command prompt (prefix + :) are better than
	# vi keys, even for vim users
	$TMUX_CMD_PATH set-option -g status-keys emacs

	# focus events enabled for terminals that support them
	$TMUX_CMD_PATH set-option -g focus-events on

	# super useful when using "grouped sessions" and multi-monitor setup
	if ! iterm_terminal; then
		$TMUX_CMD_PATH set-window-option -g aggressive-resize on
	fi

	# DEFAULT KEY BINDINGS

	local prefix="$(prefix)"
	local prefix_without_ctrl="$(prefix_without_ctrl)"

	# if C-b is not prefix
	if [ $prefix != "C-b" ]; then
		# unbind obsolete default binding
		if key_binding_not_changed "C-b" "send-prefix"; then
			$TMUX_CMD_PATH unbind-key C-b
		fi

		# pressing `prefix + prefix` sends <prefix> to the shell
		if key_binding_not_set "$prefix"; then
			$TMUX_CMD_PATH bind-key "$prefix" send-prefix
		fi
	fi

	# If Ctrl-a is prefix then `Ctrl-a + a` switches between alternate windows.
	# Works for any prefix character.
	if key_binding_not_set "$prefix_without_ctrl"; then
		$TMUX_CMD_PATH bind-key "$prefix_without_ctrl" last-window
	fi

	# easier switching between next/prev window
	if key_binding_not_set "C-p"; then
		$TMUX_CMD_PATH bind-key C-p previous-window
	fi
	if key_binding_not_set "C-n"; then
		$TMUX_CMD_PATH bind-key C-n next-window
	fi

	# source `.tmux.conf` file - as suggested in `man tmux`
	if key_binding_not_set "R"; then
		$TMUX_CMD_PATH bind-key R run-shell ' \
			$TMUX_CMD_PATH source-file ~/.tmux.conf > /dev/null; \
			$TMUX_CMD_PATH display-message "Sourced .tmux.conf!"'
	fi
}
main
