function start_vpn
	set -l vpn_name (tail -n1 /etc/enablevpn)
	nmcli connection up id $vpn_name
	echo $vpn_name > /etc/enablevpn
end
