#!/usr/bin/env sh

function log {
	echo "$@" >> $HOME/.cache/lock_logs
}

function resolve {
	local arg="$1"
	local img="$2"

	case "$arg" in
		"capture")
			grim -t png "$img"
			log "capture into $img"
			;;
		"background")
			cp "$HOME/.config/wallpapers/gruvbox_pinguin.png" "$img"
			;;
		"print")
			echo "$img"
			;;
		"lock")
			swaylock -i "$img" &
			log "lock called"
			;;
		"clean")
			(sleep 1; rm "$img") &
			log "clean called"
			;;
		"suspend")
			systemctl suspend
			;;
		"grey")
			convert "$img" -set colorspace Gray -separate -average "$img"
			;;
		"pixel")
			convert "$img" -scale 4% -scale 2500% "$img"
			;;
		"blur")
			convert "$img" -blur 0x7 "$img"
			log "blured the image"
			;;
		"text")
			convert "$img" \
				-font '/usr/share/fonts/TTF/Iosevka Nerd Font Complete.ttf' \
				-fill '#ffffff' \
				-pointsize 128 \
				-gravity center \
				-draw 'text 0,140 ""' \
				"$img"
			;;
		"picture="*)
			convert "$img" \
				"${arg/picture=/}" \
				-gravity center \
				-geometry x770 \
				-composite -matte "$img"
			;;
	esac
	
	if [[ $? != 0 ]]; then
		log "Failed command '$arg' with img '$img'"
		exit 1
	fi
}

function main {
	local image_path="$(mktemp --suffix='.png')"
	for arg in "$@"; do
		resolve "$arg" "$image_path"
	done
}

main "$@" &>> $HOME/.cache/lock_logs
