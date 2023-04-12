#!/usr/bin/env sh

SOURCE_DIR="$(dirname "$0")/"
inotifywait -mr -e create,delete /dev/disk/by-path/ |
	awk -f "$SOURCE_DIR/dev_scan.awk"
