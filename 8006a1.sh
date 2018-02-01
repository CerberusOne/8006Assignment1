#COMP 8006 Assignment 1


#User defined section###############################################################
PERMIT_TCP='22, 53, 80, 443'
PERMIT_UDP='22, 53, 67, 68'
REJECT='0'

#Clear existing IP table
iptables -F
iptables -X

#Create a chain to track www and ssh
iptables -N PERMIT-TRAFFIC
iptables -N ALL-TRAFFIC

#Set default policies
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP


#Accounting#########################################################################
#SSH and WWW traffic
iptables -A INPUT -m tcp -p tcp --sport 22 -j PERMIT-TRAFFIC
iptables -A INPUT -m tcp -p tcp --dport 22 -j PERMIT-TRAFFIC
iptables -A INPUT -m tcp -p tcp --sport 80 -j PERMIT-TRAFFIC
iptables -A INPUT -m tcp -p tcp --dport 80 -j PERMIT-TRAFFIC
iptables -A INPUT -m tcp -p tcp --sport 443 -j PERMIT-TRAFFIC
iptables -A INPUT -m tcp -p tcp --dport 443 -j PERMIT-TRAFFIC
iptables -A OUTPUT -m tcp -p tcp --sport 22 -j PERMIT-TRAFFIC
iptables -A OUTPUT -m tcp -p tcp --dport 22 -j PERMIT-TRAFFIC
iptables -A OUTPUT -m tcp -p tcp --sport 80 -j PERMIT-TRAFFIC
iptables -A OUTPUT -m tcp -p tcp --dport 80 -j PERMIT-TRAFFIC
iptables -A OUTPUT -m tcp -p tcp --sport 443 -j PERMIT-TRAFFIC
iptables -A OUTPUT -m tcp -p tcp --dport 443 -j PERMIT-TRAFFIC

#Accounting#########################################################################
iptables -A INPUT -p all -j ALL-TRAFFIC
iptables -A OUTPUT -p all -j ALL-TRAFFIC

#RULES#########################################################################
#iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#drop inboud port 80 (http) from source port <1024
iptables -A PERMIT-TRAFFIC -p tcp -m tcp --dport 80 --sport :1023 -j DROP 

#drop all incoming SYN packets
iptables -A INPUT -m tcp -p tcp --syn -j DROP 

#Reject all packets for ports in the reject list
IFS=',' read -ra LIST <<< "$REJECT"
for i in "${LIST[@]}"; do
    iptables -A ALL-TRAFFIC -p tcp --sport $i -j DROP
    iptables -A ALL-TRAFFIC -p tcp --dport $i  -j DROP
    iptables -A ALL-TRAFFIC -p udp  --sport $i -j DROP
    iptables -A ALL-TRAFFIC -p udp --dport $i -j DROP
done

#Accept all packets for ports in the permitted tcp list
IFS=',' read -ra LIST <<< "$PERMIT_TCP"
for i in "${LIST[@]}"; do
    iptables -A PERMIT-TRAFFIC -p tcp --dport $i -j ACCEPT
    iptables -A PERMIT-TRAFFIC -p tcp --sport $i -j ACCEPT
    iptables -A ALL-TRAFFIC -p tcp --dport $i -j ACCEPT
    iptables -A ALL-TRAFFIC -p tcp --sport $i -j ACCEPT
done

#Accept all packets for ports in the permitted udp list
IFS=',' read -ra LIST <<< "$PERMIT_UDP"
for i in "${LIST[@]}"; do
    iptables -A PERMIT-TRAFFIC -p udp --dport $i -j ACCEPT
    iptables -A PERMIT-TRAFFIC -p udp --sport $i -j ACCEPT
    iptables -A ALL-TRAFFIC -p udp --dport $i -j ACCEPT
    iptables -A ALL-TRAFFIC -p udp --sport $i -j ACCEPT
done

