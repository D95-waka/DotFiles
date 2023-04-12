#!/usr/bin/env sh

export MPD_HOST="master@$HOME/.mpd/socket"
running=0

function idle_await {
	if mpc idle player 2> /dev/null; then
		log "mpc trigger"
		sleep 0.1
		~/Scripts/notification_templates.sh mpc
	else
		sleep 10
	fi
}

while [[ $running -eq 0 ]]; do
	# BUG: when mpc is not running, the error would be outputed directly to user session.
	idle_await
done
