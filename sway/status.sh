#!/usr/bin/env sh

function battery {
	upower -i /org/freedesktop/UPower/devices/battery_BAT0 |
	awk '
	$0 ~ /perc/ {
		gsub(/%$/, "", $2)
		q = $2 + 0
	}

	$0 ~ /state/ {
		state = $2
	}

	END {
		color = "#ffffff"
		if (state == "charging") {
			icon = "󰂄"
			color = "#dddd00"
		} else if (q < 10) {
			icon = "󰁺"
			color = "#ff0000"
		} else if (q < 20) {
			icon = "󰁻"
			color = "#ff0000"
		} else if (q < 30) {
			icon = "󰁼"
			color = "#ff3300"
		} else if (q < 40) {
			icon = "󰁽"
		} else if (q < 50) {
			icon = "󰁾"
		} else if (q < 60) {
			icon = "󰁿"
		} else if (q < 70) {
			icon = "󰂀"
		} else if (q < 80) {
			icon = "󰂁"
		} else if (q < 90) {
			icon = "󰂂"
		} else if (q == 100) {
			icon = "󰁹"
			color = "#00ff00"
		} else {
			icon = "󰁹"
		}

		printf "{ \"full_text\": \"%s\", \"color\": \"%s\", \"separator\": false }, { \"full_text\": \"%s%%\", \"min_width\": 50 }", icon, color, q
	}'
}

source ~/.config/sway/cpu_retrieve_functions.sh
_retrieve_cpu_init 
function cpu {
	local cpu_value="$(retrieve_cpu)"
	printf '{ "full_text": "", "separator": false }, { "full_text": "%s%%", "min_width": 50 }' "$cpu_value"
}

function network {
	local logo=''
	local network_name="$(iwgetid -r)"
	if [[ "$network_name" == "" ]]; then
		logo='󰖪'
	fi

	local vpn_logo=''
	local vpn_connection_name="$(nmcli connection show --active |
		awk '$3 == "vpn" { print $1; }')"
	if [[ "$vpn_connection_name" != "" ]]; then
		nmcli connection show "$vpn_connection_name" |
			grep -q 'GENERAL.STATE.*activated$' &&
			vpn_logo=''
	fi

	if rfkill list all | grep yes &> /dev/null; then
		logo='󰀝'
	fi

	printf '{ "full_text": "%s %s", "separator": false }, { "full_text": "%s", "min_width": 50 }' "$logo" "$vpn_logo" "$network_name"
}

function network_statistics {
	local tmp_helper='/tmp/status_network_statistics_state.txt'
	IFS=' '
	read __last_download_size __last_upload_size < $tmp_helper

	local __proc_net_data=($(cat /proc/net/dev | awk '$1 ~ /wlp3s0/ {print $2, $10;}'))
	local __current_download_size="${__proc_net_data[0]}"
	local __current_upload_size="${__proc_net_data[1]}"

	local __download_speed="$(numfmt --to=iec --suffix=B $(( __current_download_size - __last_download_size )))"
	local __upload_speed="$(numfmt --to=iec --suffix=B $(( __current_upload_size - __last_upload_size )))"
	printf '{ "full_text": "󰇚", "separator": false }, { "full_text": "%s", "min_width": 50 }, { "full_text": "󰕒", "separator": false }, { "full_text": "%s", "min_width": 50 }' "$__download_speed" "$__upload_speed"
	echo $__current_download_size $__current_upload_size > $tmp_helper
}

function datetime {
	printf '{ "full_text": "", "color": "ffff00", "separator": false }, { "full_text": "%s" }' "$(date +'%d/%m/%y %H:%M:%S')"
}

function volume {
	local logo="$(pactl list sinks | awk '
		$1 == "device.icon_name" {
			gsub(/"/, "", $3)
			device_icon = "$3"
		}

		$1 == "Active" {
			port = $3
		}

		END {
			if (port == "analog-output-speaker") {
				printf "%s", "󰓃"
			} else if (port == "analog-output-headphones") {
				printf "%s", "󰋋"
			} else if (device_icon == "audio-headset-bluetooth") {
				printf "%s", "󰂰"
			} else {
				printf "%s", ""
			}
		}')"

	local score="$(amixer sget Master | awk '
		$1 == "Front" {
			printf "%s", $5
			exit
		}' |
			sed 's/\[\|\]//g')"
	printf '{ "full_text": "%s", "separator": false }, { "full_text": "%s", "min_width": 50 }' $logo $score
}

function playing {
	local current="$(mpc current -f '%title% by %artist%' 2> /dev/null)"
	local logo=''
	if [[ "$current" == '' ]]; then
		logo='󰝛'
	fi

	printf '{ "full_text": "%s", "separator": false }, { "full_text": "%s", "min_width": 50 }' "$logo" "$current"
}

function memory {
	cat /proc/meminfo | awk '
		$1 == "MemTotal:" {
			mem_total = $2
		}

		$1 == "MemAvailable:" {
			mem_free = $2
		}

		$1 == "SwapTotal:" {
			swap_total = $2
		}

		$1 == "SwapFree:" {
			swap_free = $2
		}

		END {
			printf "{ \"full_text\": \"󰍛\", \"separator\": false }, { \"full_text\": \"%d%%\", \"min_width\": 50 }", (mem_total - mem_free + swap_total - swap_free) / mem_total * 100
		}'
}

function logo {
	printf '{ "full_text": " ", "color": "#1790cd" }'
}

function protocol_start {
	printf '{ "version": 1, "click_events": true, "cont_signal": 18, "stop_signal": 19 }
['
}

protocol_start
while true; do
	printf '[ %s, %s, %s, %s, %s, %s, %s, %s, %s ],' \
		"$(battery)" "$(cpu)" "$(memory)" "$(network)" \
		"$(network_statistics)" "$(playing)" \
		"$(volume)" "$(datetime)" "$(logo)"
	sleep 1
done
