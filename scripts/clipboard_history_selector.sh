#!/usr/bin/env sh

history_dir="$HOME/.cache/clipboard_history/"
c=1
list=$(ls -1 "${history_dir}/" | sort -nr)
selected=$(for i in $list; do
	preview="$(head -n1 "$history_dir/$i")"
	echo -e "$c\t$preview"
	let c++
done |
	bemenu |
	sed 's/\t.*//')

if [[ "$selected" == "" ]]; then
	exit 0
fi

echo "$list" |
	head -n $selected |
	tail -1 |
	xargs printf "%s%s" "$history_dir" |
	xargs cat |
	wl-copy
