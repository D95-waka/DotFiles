#!/usr/bin/env sh
# Use to import the functions to retrieve cpu usage.
# Must being executed from current shell (using 'source' or '.' commands).

# first line for continual usage, latter for universal usage.
#__tmp_helper="/tmp/cpu_retrieve_lib_$PPID"
__tmp_helper="/tmp/cpu_retrieve_lib"

function retrieve_cpu_raw_data {
	cat /proc/stat | head -1 | cut -d ' ' -f3-
}

function _retrieve_cpu_init {
	local raw=($(retrieve_cpu_raw_data))
	local _retrieve_prev_idle=$(( ${raw[3]} + ${raw[4]} ))
	local _retrieve_prev_active=$(( ${raw[0]} + ${raw[1]} + ${raw[2]} ))
	echo $_retrieve_prev_active $_retrieve_prev_idle > $__tmp_helper
}

function retrieve_cpu {
	IFS=' '
	read _retrieve_prev_active _retrieve_prev_idle <<< $(cat $__tmp_helper)

	local raw=($(retrieve_cpu_raw_data))
	local curr_idle=$(( ${raw[3]} + ${raw[4]}))
	local curr_active=$(( ${raw[0]} + ${raw[1]} + ${raw[2]} ))

	local active=$(( $curr_active - $_retrieve_prev_active ))
	local idle=$(( $curr_idle - $_retrieve_prev_idle ))
	echo $curr_active $curr_idle > $__tmp_helper
	cpu_value=$(awk 'BEGIN { print int(100 * '$active' / ('$idle' + '$active')); }')
	echo $cpu_value
}

#_retrieve_cpu_init
