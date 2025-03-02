
# create user accounts
# ---------------------------
:log info message="setting up admin,mgmt acocunts"

# default admin user
/user set 0 password="$initpasswd" address=192.168.88.0/24,172.16.0.0/12 comment="direct management"

# add management user
/user add name=mgmt password="$initpasswd" group=full address=192.168.88.0/24,172.16.0.0/12 comment="remote management"

# ssh key available within upload (persistent) dir ?
:if ([:len [/file find name="$sshkeyfile"]] > 0) do={
/user ssh-keys import user=mgmt public-key-file="$sshkeyfile"
}

# setup device access (temporary until deployment)
# -------------------------------------------------

:log info message="adding main switchting bridge br0"

# main bridge
/interface bridge add name=br0

:log info message="setting up 192.68.88.1 as br0 address and adding dhcp4 client"

# add static ip to bridge for direct management
/ip address add interface=br0 address=192.168.88.1/24 comment="direct management" 

# dhcp client on bridge
/ip dhcp-client add interface=br0 disabled=no comment="management"

# ether1 port available ?
# add to main bridge and force 100M for initial config
:if ([/interface ethernet print count-only where name=ether1]=1) do={
:log info message="ether1 found: adding to br0"
/interface bridge port add bridge=br0 interface=ether1
}

# ether2 port available ?
# add to main bridge and force 100M for initial config
:if ([/interface ethernet print count-only where name=ether2]=1) do={
:log info message="ether2 found: adding to br0"
/interface bridge port add bridge=br0 interface=ether2
}

# combo port available ?
:if ([/interface ethernet print count-only where name=combo1]=1) do={
:log info message="combo1 found: adding to br0"
/interface bridge port add bridge=br0 interface=combo1
}

# mgmt port available ?
:if ([/interface ethernet print count-only where name=mgmt]=1) do={
:log info message="mgmt found: adding to br0"
/interface bridge port add bridge=br0 interface=mgmt
}