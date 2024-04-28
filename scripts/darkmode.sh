#!/usr/bin/env sh

function get_state {
	gsettings get org.gnome.desktop.interface color-scheme | sed "s/prefer-//; s/'//g"
}

function set_dark {
	notify-send -h string:x-dunst-stack-tag:darkmode -t 500 "dark mode"
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark
	makoctl set-mode dark

	swaymsg -q output \* bg '~/.config/wallpapers/catppuccin_macchiato_grid.png' fill

	swaymsg -q set \$rosewater \#f4dbd6
	swaymsg -q set \$flamingo \#f0c6c6
	swaymsg -q set \$pink \#f5bde6
	swaymsg -q set \$mauve \#c6a0f6
	swaymsg -q set \$red \#ed8796
	swaymsg -q set \$maroon \#ee99a0
	swaymsg -q set \$peach \#f5a97f
	swaymsg -q set \$yellow \#eed49f
	swaymsg -q set \$green \#a6da95
	swaymsg -q set \$teal \#8bd5ca
	swaymsg -q set \$sky \#91d7e3
	swaymsg -q set \$sapphire \#7dc4e4
	swaymsg -q set \$blue \#8aadf4
	swaymsg -q set \$lavender \#b7bdf8
	swaymsg -q set \$text \#cad3f5
	swaymsg -q set \$subtext1 \#b8c0e0
	swaymsg -q set \$subtext0 \#a5adcb
	swaymsg -q set \$overlay2 \#939ab7
	swaymsg -q set \$overlay1 \#8087a2
	swaymsg -q set \$overlay0 \#6e738d
	swaymsg -q set \$surface2 \#5b6078
	swaymsg -q set \$surface1 \#494d64
	swaymsg -q set \$surface0 \#363a4f
	swaymsg -q set \$base \#24273a
	swaymsg -q set \$mantle \#1e2030
	swaymsg -q set \$crust \#181926
}

function set_light {
	notify-send -h string:x-dunst-stack-tag:darkmode -t 500 "light mode"
	gsettings set org.gnome.desktop.interface color-scheme prefer-light
	makoctl set-mode light

	swaymsg -q output \* bg '~/.config/wallpapers/catppuccin_latte_grid.png' fill

	swaymsg -q set \$rosewater \#dc8a78
	swaymsg -q set \$flamingo \#dd7878
	swaymsg -q set \$pink \#ea76cb
	swaymsg -q set \$mauve \#8839ef
	swaymsg -q set \$red \#d20f39
	swaymsg -q set \$maroon \#e64553
	swaymsg -q set \$peach \#fe640b
	swaymsg -q set \$yellow \#df8e1d
	swaymsg -q set \$green \#40a02b
	swaymsg -q set \$teal \#179299
	swaymsg -q set \$sky \#04a5e5
	swaymsg -q set \$sapphire \#209fb5
	swaymsg -q set \$blue \#1e66f5
	swaymsg -q set \$lavender \#7287fd
	swaymsg -q set \$text \#4c4f69
	swaymsg -q set \$subtext1 \#5c5f77
	swaymsg -q set \$subtext0 \#6c6f85
	swaymsg -q set \$overlay2 \#7c7f93
	swaymsg -q set \$overlay1 \#8c8fa1
	swaymsg -q set \$overlay0 \#9ca0b0
	swaymsg -q set \$surface2 \#acb0be
	swaymsg -q set \$surface1 \#bcc0cc
	swaymsg -q set \$surface0 \#ccd0da
	swaymsg -q set \$base \#eff1f5
	swaymsg -q set \$mantle \#e6e9ef
	swaymsg -q set \$crust \#dce0e8
}

function refresh_color {
	swaymsg -q client.focused           \$lavender \$base \$text  \$rosewater \$lavender
	swaymsg -q client.focused_inactive  \$overlay0 \$base \$text  \$rosewater \$overlay0
	swaymsg -q client.unfocused         \$overlay0 \$base \$text  \$rosewater \$overlay0
	swaymsg -q client.urgent            \$peach    \$base \$peach \$overlay0  \$peach
	swaymsg -q client.placeholder       \$overlay0 \$base \$text  \$overlay0  \$overlay0
	swaymsg -q client.background        \$base
}

notify-send -h string:x-dunst-stack-tag:darkmode -t 5000 "$@"
case "$1" in
dark)
	set_dark
	;;
light)
	set_light
	;;
toggle)
	[[ $(get_state) == "dark" ]] && set_light || set_dark
	;;
self)
	[[ $(get_state) == "dark" ]] && set_dark || set_light
	;;
*)
	echo INVALID COMMAND
	;;
esac
refresh_color
