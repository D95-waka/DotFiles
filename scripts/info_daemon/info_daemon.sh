#!/usr/bin/env sh

# Force global session id for subprocesses
if [[ "$1" == "" ]]; then
	setsid "$0" sid
	exit 0
fi

SOURCE_DIR="$(dirname "$0")/"
export PATH="$PATH:$SOURCE_DIR"

if [[ -f /tmp/info_daemon_pid ]]; then
	log "Trying to kill previous instance, pids: $(cat /tmp/info_daemon_pid)"
	pkill -s "$(cat /tmp/info_daemon_pid)" 2>&1 | log
fi

echo "$$" > /tmp/info_daemon_pid
for i in "$SOURCE_DIR/info.d/"*; do
	if [[ -x "$i" ]]; then
		"$i" &
		log "Started script '$(basename "$i")'"
	fi
done
