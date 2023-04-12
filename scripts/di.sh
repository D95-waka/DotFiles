#!/usr/bin/env sh
# DI system for shell scripts.
# When called, load all available to run functions (which that was signed with annotation) and run the selected one.
# When command name is invalid or not given, the script will print the available commands.

# To use in script, call this script and set the arguments to: $0 $*,
# or set $0 to script location.

# Returns all functions in given file that has the `##export` annotation above of them.
function __get_available_functions {
	cat $1 |
		awk '
			next_line == 1 {
				print $2
				next_line = 0
			}

			$1 == "##export" {
				next_line = 1
			}'
}

function __main {
	local functions_path="$1"
	local command_name="$2"
	if [[ "$command_name" == "" ]]; then
		echo "Please specify function name to run."
		echo "Available functions:"
		printf "\t%s\n" $(__get_available_functions $functions_path)
		return 1
	elif [[ "$command_name" == '-a' ]]; then
		__get_available_functions $functions_path
		return 0
	elif __get_available_functions $functions_path | grep -F "$command_name" > /dev/null; then
		. "$functions_path"
		$command_name ${@:3}
	else
		echo "'$command_name' could not be found."
		echo "Please use one of the functions ahead:"
		printf "\t%s\n" $(__get_available_functions $functions_path)
		return 1
	fi
}

__main $*
