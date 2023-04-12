#!/usr/bin/env sh

function battery {
	upower -i /org/freedesktop/UPower/devices/battery_BAT0 |
	awk '
	$0 ~ /perc/ {
		q = $2
	}

	$0 ~ /state/ {
		state = $2
	}

	END {
		print state, q

		#if (state == "charging") {
		#	color = "'"${color_place[2]}"'"
		#} else if (q - 6 < 0) {
		#	color = "'"${color_place_bold}${color_place[1]}"'"
		#} else if (q - 11 < 0) {
		#	color = "'"${color_place[1]}"'"
		#} else {
		#	#color = "'"${color_clear_place}"'"
		#}

		#printf "%s%s\n", color, q
	}'
}

source ~/.config/sway/cpu_retrieve_functions.sh
_retrieve_cpu_init 
function cpu {
	local cpu_value="$(retrieve_cpu)"
	printf "%s%%" "$cpu_value"
}

function network {
	local network_name="$(iwgetid -r)"
	if [[ "$network_name" == "" ]]; then
		network_name="off"
	fi

	local vpn_status=""
	local vpn_connection_name="$(nmcli connection show --active |
		awk '$3 == "vpn" { print $1; }')"
	if [[ "$vpn_connection_name" != "" ]]; then
		nmcli connection show "$vpn_connection_name" |
			grep -q 'GENERAL.STATE.*activated$' &&
			vpn_status=" vpn"
	fi

	printf "%s%s" "$network_name" "$vpn_status"
	if rfkill list all | grep yes &> /dev/null; then
		printf ' airplane'
	fi
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
	printf '%s\t%s' "$__download_speed" "$__upload_speed"
	echo $__current_download_size $__current_upload_size > $tmp_helper
}

function datetime {
	date +'%d/%m/%y %H:%M:%S'
}

function volume {
	local volume="$(amixer sget Master | grep -o '[0-9]*%' | head -1)"
	local audio_device="$(pactl list sinks | sed -n 's/\t*Active Port:.*-\(\w\).*/\1/p' | head -1)"
	printf '%s %s' "$volume" "$audio_device"
}

function playing {
	local current="$(mpc current -f '%title% by %artist%' 2> /dev/null)"
	if [[ "$current" == "" ]]; then
		echo ''
	else
		echo "$current"
	fi
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
			printf "%d%%", (mem_total - mem_free + swap_total - swap_free) / mem_total * 100
		}'
}

while true; do
	printf "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" \
		"$(battery)" "$(cpu)" "$(network)" \
		"$(network_statistics)" "$(datetime)" "$(volume)" \
		"$(playing)" "$(memory)"
	sleep 1
done
