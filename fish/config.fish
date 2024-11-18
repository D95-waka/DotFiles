#!/usr/bin/env fish

fish_vi_key_bindings

# environment variables
export TERMINAL=wezterm
export MPD_HOST="master@$HOME/.mpd/socket"
export EDITOR=vim
export MANPAGER='nvim +Man!'
export BEMENU_OPTS='-l 10 --fn universal'
export QT_QPA_PLATFORMTHEME=qt6ct
set -a PATH ~/.local/bin

# aliases
alias ':q'=exit
alias la="ls -A"
alias cal="cal -s"		# sunday as first day of week
alias free="free -h"
alias df="df -h"
alias syu="sudo pacman -Syu"

# startup
if test "$WAYLAND_DISPLAY" = "" -a "$XDG_VTNR" -eq 1
	cd
	exec sway
end

# Functions
function fish_command_not_found
	echo "Command not found: '$argv[1]'"
end
