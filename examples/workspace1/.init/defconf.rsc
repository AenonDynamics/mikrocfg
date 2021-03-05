# initial delay
# ---------------------------

:delay 15

# create user accounts
# ---------------------------

# direct management access via ether1 untagged
/user
set 0 password="admin" address=192.168.88.0/24 comment="default management"

# setup device access (temporary until deployment)
# -------------------------------------------------

# uplink interface; 100mbps in case auto negotiation has been disabled
/interface ethernet
set [ find default-name=ether1 ] speed=100Mbps

# main bridge
/interface bridge add name=bridge

# add ip to bridge for direct management
/ip address
add address=192.168.88.1/24 comment="direct management" interface=bridge

# add uplink port to bridge
/interface bridge port
add bridge=bridge interface=ether1
