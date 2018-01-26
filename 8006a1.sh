#COMP 8006 Assignment 1

iptables -F
iptables -X

#Set default policies
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#do we output on the same port??
#allow DNS traffic 
#iptables -A OUTPUT -m udp -p udp --sport 53 --dport 53 -j ACCEPT # state --state NEW,RELATED -j ACCEPT
#iptables -A OUPUT -m udp -p udp --dport 53 -j ACCEPT
#allow DHCP traffic
#iptables -A INPUT -m udp -p udp --sport 67 -j ACCEPT 
#iptables -A OUTPUT -m udp -p udp --dport 67 -j ACCEPT 
#iptables -A INPUT -m udp -p udp --sport 68 -j ACCEPT 
#iptables -A OUTPUT -m udp -p udp --dport 68 -j ACCEPT 


#allow inbound SSH packets
#iptables -A INPUT -m tcp -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#allow outboud SSH PACKETS
#iptables -A OUTPUT -m tcp -p tcp --sport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT


#allow inbound WWW packets
#iptables -A INPUT -m tcp -p tcp --sport 80 -j ACCEPT
#allow outboud WWW PACKETS
#iptables -A OUTPUT -m tcp -p tcp --dport 80 -j ACCEPT

#drop inboud port 80 (http) from source port <1024
#iptables -A INPUT -m tcp -p tcp --dport 80 -j DROP

#drop all incoming SYN packets
#iptables -A INPUT -m tcp -p tcp --syn -j DROP 
#iptables -A INPUT -p tcp --tcp-flags ALL SYN -j DROP



#drop all inbound traffic from port 0 
#iptables -A INPUT -m tcp -p tcp --dport 0 -j DROP
#drop all outbound traffic from port 0
#iptables -A OUTPUT -m tcp -p tcp --sport 0 -j DROP

#drop all other incoming packets
#iptables -A INPUT -s 192.168.1.0/24 -j DROP
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
