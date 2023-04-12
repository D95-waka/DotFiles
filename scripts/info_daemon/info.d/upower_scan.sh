#!/usr/bin/env sh

SOURCE_DIR="$(dirname "$0")/"
upower --monitor-detail /org/freedesktop/UPower/devices/battery_BAT0 | \
	awk -f "$SOURCE_DIR/upower_scan.awk"
