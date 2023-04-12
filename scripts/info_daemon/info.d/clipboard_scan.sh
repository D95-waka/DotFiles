#!/usr/bin/env sh

export CALL_COUNTER
if [[ "$CALL_COUNTER" == "" ]]; then
	export CALL_COUNTER=1
else
	export CALL_COUNTER=$(($CALL_COUNTER + 1))
fi

log $CALL_COUNTER

if [[ $CALL_COUNTER == 1 ]]; then
	# Act as daemon, calls the same file as watcher.
	watch_command="$0"
	wl-paste --watch "$watch_command"
	exit 0
elif [[ $CALL_COUNTER == 2 ]]; then
	# Acts as watcher, script to save the coppied information and exit
	log 'Saves a coppy'
	history_dir="$HOME/.cache/clipboard_history/"
	stamp="$(date +%s%N)"
	mkdir -p "$history_dir"
	cat > "$history_dir/$stamp.data"

	history_types_file="$HOME/.cache/clipboard_history/mime_types.txt"
	echo "$stamp $(wl-paste -l | head -1)" >> "$history_types_file"

	# Cleanup for old records
	for i in $(ls -1 "$history_dir" | grep -v mime_types | sort -n | head -n -100); do
		rm "$history_dir/$i"
	done

	echo "$(tail -n -100 "$history_types_file")" > "$history_types_file"
	exit 0
fi
