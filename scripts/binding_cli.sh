#!/usr/bin/env sh
[[ $0 =~ di.sh ]] || exec $HOME/.config/scripts/di.sh $0 $*

##export
function screen_toggle {
	if [[ "$(light)" == "0.00" ]]; then light -I; else light -O; light -S 0; fi
}

##export
function screen_capture {
	export GRIM_DEFAULT_DIR="$HOME/Downloads/"

	local action="$1"
	if [[ "$action" == 'screen' ]]; then
		grim
	elif [[ "$action" == 'region' ]]; then
		grim -g "$(swaymsg -t get_tree |
			jq -r '.. |
				select(.pid? and .visible?) |
				.rect |
				"\(.x),\(.y) \(.width)x\(.height)"' |
			slurp)"
	elif [[ "$action" == 'selection' ]]; then
		grim -g "$(slurp)"
	fi

	cat "$GRIM_DEFAULT_DIR/$(ls -t "$GRIM_DEFAULT_DIR" | head -1)" | wl-copy
}

##export
function bemenu_run {
	source $HOME/Scripts/colors_define.sh
	bemenu-run \
		-l 10 \
		--fn universal\
		--tb="$foreground_value" \
		--tf="$background_value" \
		--fb="$background_value" \
		--ff="$foreground_value" \
		--nb="$background_value" \
		--nf="$foreground_value" \
		--hb="$foreground_value" \
		--hf="$background_value"
}

##export
function bemenu_locate {
	source $HOME/Scripts/colors_define.sh
	local selected="$($HOME/Scripts/locate_wrapper.sh |
		bemenu -p start \
			-l 10 \
			--fn universal\
			--tb="$foreground_value" \
			--tf="$background_value" \
			--fb="$background_value" \
			--ff="$foreground_value" \
			--nb="$background_value" \
			--nf="$foreground_value" \
			--hb="$foreground_value" \
			--hf="$background_value")"
	exec $HOME/Scripts/locate_wrapper.sh "$selected"
}
