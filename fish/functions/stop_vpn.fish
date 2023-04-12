function stop_vpn
	nmcli connection down id (nmcli connection show --active | awk '$3 == "vpn" { print $1; }')
	set -l tmpfile (mktemp)
	echo false >> $tmpfile
	cat /etc/enablevpn >> $tmpfile
	cat $tmpfile > /etc/enablevpn
	rm $tmpfile
end
