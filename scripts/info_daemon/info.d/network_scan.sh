#!/usr/bin/env sh

function profile_changed {
	local profile_name="$1"

	# Blacklisted profiles
	if [[ $profile_name =~ tun ]]; then
		return 0
	fi

	sleep 3
	local profile_enabled=1
	nmcli connection show "$profile_name" |
		grep -q 'GENERAL.STATE.*activated$' &&
		profile_enabled=0
	if [[ $profile_enabled != 0 ]]; then
		return 0
	fi

	local profile_type="$(
		nmcli connection show "$profile_name" |
		awk '$1 == "connection.type:" {
							sub(/.*-/, "", $2)
							print $2
						}')"
	log "Connected to $profile_type: $profile_name"
	~/Scripts/notification_templates.sh network "$profile_type" "$profile_name"
}

function main {
	nmcli connection monitor | while read line; do
		log "$line"
		if [[ $line =~ connection\ profile\ changed ]]; then
			local profile_name="${line//:*/}"
			profile_changed "$profile_name"
		fi
	done
}

main "$@"
