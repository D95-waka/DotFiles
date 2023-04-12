#!/usr/bin/bash

function battery {
	case "$1" in
		"charging")
			notify-send -h string:x-dunst-stack-tag:battery -t 5000 "󰂄	"
			;;
		"discharging")
			notify-send -h string:x-dunst-stack-tag:battery -t 5000 "󰂄	"
			;;
		"critical_low")
			notify-send -h string:x-dunst-stack-tag:battery -u critical -t 0 "	Empty"
			;;
		"low")
			notify-send -h string:x-dunst-stack-tag:battery -u critical -t 16000 '	Low'
			;;
		"full")
			notify-send -h string:x-dunst-stack-tag:battery -t 16000 '	Full'
			;;
	esac
}

function mpc_status {
	IFS="
"
	s_arr=($(mpc -f "%title% \n%artist% \n%file%"))
	s_state=$(sed 's/\[\([a-zA-Z]*\)\].*/\1/g' <<< "${s_arr[3]}")
	local image_path="$("$HOME/Scripts/cover_image.sh" -size 128)"
	notify-send -i "$image_path" -t 8000 "$s_state" "${s_arr[0]}\n ${s_arr[1]}"
}

case "$1" in
"battery")
	battery "$2" "$3"
	;;
"mpc")
	mpc_status
	;;
"device")
	notify-send -h string:x-dunst-stack-tag:device -t 8000 '	Insert'
	;;
"network")
	logo=''
	case "$2" in
		'wireless')
			logo=''
			;;
		'vpn')
			logo=''
			;;
	esac
	notify-send -t 5000 "$logo	$3"
	;;
"brightness")
	notify-send -h string:x-dunst-stack-tag:bind -t 500 "󰃟	$(light -G | sed 's/\..*//')%"
	;;
esac
