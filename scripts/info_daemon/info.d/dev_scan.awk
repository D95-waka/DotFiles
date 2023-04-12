function _log(message) {
	system("sh -c 'log " message "'")
}

$2 == "CREATE" {
	"readlink -f " $1 $3 | getline path
	k[$3] = path
	_log($2 " " path)
	system("~/Scripts/notification_templates.sh device " $2 " " path)
}

$2 == "DELETE" {
	_log($2 " " k[$3])
	system("~/Scripts/notification_templates.sh device " $2 " " k[$3])
}
