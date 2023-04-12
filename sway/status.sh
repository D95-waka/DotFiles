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
		#print state, q

		if (state == "charging") {
			icon = "󰂄"
		} else if (q < 10) {
			icon = "󰁺"
		} else if (q < 20) {
			icon = "󰁻"
		} else if (q < 30) {
			icon = "󰁼"
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
		} else {
			icon = "󰁹"
		}

		printf "%s %s%%", icon, q
	}'
}

source ~/.config/sway/cpu_retrieve_functions.sh
_retrieve_cpu_init 
function cpu {
	local cpu_value="$(retrieve_cpu)"
	printf " %s%%" "$cpu_value"
}

function network {
	local network_name="  $(iwgetid -r)"
	if [[ "$network_name" == "" ]]; then
		network_name="󰖪 "
	fi

	local vpn_status=""
	local vpn_connection_name="$(nmcli connection show --active |
		awk '$3 == "vpn" { print $1; }')"
	if [[ "$vpn_connection_name" != "" ]]; then
		nmcli connection show "$vpn_connection_name" |
			grep -q 'GENERAL.STATE.*activated$' &&
			vpn_status=" vpn"
	fi

	if rfkill list all | grep yes &> /dev/null; then
		# airplane mode
		printf '󰀝 '
	else
		printf "%s%s" "$network_name" "$vpn_status"
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
	printf '󰇚 %s\t󰕒 %s' "$__download_speed" "$__upload_speed"
	echo $__current_download_size $__current_upload_size > $tmp_helper
}

function datetime {
	date +'  %d/%m/%y %H:%M:%S'
}

function volume {
	pactl list sinks | awk '
		$1 == "Active" {
			if ($3 == "analog-output-speaker") {
				printf "%s", "󰓃 "
			} else if ($3 == "analog-output-headphones") {
				printf "%s", "󰋋 "
			} else {
				printf "%s", $3
			}
			
			exit
		}'

	amixer sget Master | awk '
		$1 == "Front" {
			printf "%s%%", $4
			exit
		}'
}

function playing {
	local current="$(mpc current -f '%title% by %artist%' 2> /dev/null)"
	if [[ "$current" != '' ]]; then
		printf " %s" "$current"
	else
		printf "%s" '󰝛'
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
			printf "󰍛 %d%%", (mem_total - mem_free + swap_total - swap_free) / mem_total * 100
		}'
}

while true; do
	printf "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" \
		"$(battery)" "$(cpu)" "$(memory)" "$(network)" \
		"$(network_statistics)" "$(volume)" \
		"$(playing)" "$(datetime)"
	sleep 1
done
