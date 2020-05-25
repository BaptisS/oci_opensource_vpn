#!/bin/bash
sudo su
yum install strongswan lsof -y
for vpn in /proc/sys/net/ipv4/conf/*;
do echo 0 > $vpn/accept_redirects;
echo 0 > $vpn/send_redirects;
done
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.all.accept_redirects = 0 >> /etc/sysctl.conf
echo net.ipv4.conf.all.send_redirects = 0 >> /etc/sysctl.conf
echo net.ipv4.tcp_max_syn_backlog = 1280 >> /etc/sysctl.conf
echo net.ipv4.icmp_echo_ignore_broadcasts = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.all.accept_source_route = 0 >> /etc/sysctl.conf
echo net.ipv4.conf.all.accept_redirects = 0 >> /etc/sysctl.conf
echo net.ipv4.conf.all.secure_redirects = 0 >> /etc/sysctl.conf
echo net.ipv4.conf.all.log_martians = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.default.accept_source_route = 0 >> /etc/sysctl.conf
echo net.ipv4.conf.default.accept_redirects = 0 >> /etc/sysctl.conf
echo net.ipv4.conf.default.secure_redirects = 0 >> /etc/sysctl.conf
echo net.ipv4.icmp_echo_ignore_broadcasts = 1 >> /etc/sysctl.conf
echo net.ipv4.icmp_ignore_bogus_error_responses = 1 >> /etc/sysctl.conf
echo net.ipv4.tcp_syncookies = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.all.rp_filter = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.default.rp_filter = 1 >> /etc/sysctl.conf
echo net.ipv4.tcp_mtu_probing = 1 >> /etc/sysctl.conf
echo 2 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 2 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 2 > /proc/sys/net/ipv4/conf/eth0/rp_filter
echo 2 > /proc/sys/net/ipv4/conf/eth1/rp_filter
echo 2 > /proc/sys/net/ipv4/conf/ens3/rp_filter
echo 2 > /proc/sys/net/ipv4/conf/ens4/rp_filter
sysctl -p

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F

systemctl enable strongswan
mv /etc/strongswan/ipsec.conf /etc/strongswan/ipsec.conf.bak
cat <<EOF >> /etc/strongswan/ipsec.conf
conn Azure
        authby=psk
        auto=start
        left=192.168.240.3
        leftid=	1.2.3.4
        leftsubnet=192.168.240.0/24
        right=9.8.7.6
        rightid=9.8.7.6
        rightsubnet=10.50.0.0/16
        ike=aes256-sha1-modp1024
        esp=aes256-sha1-modp1024

conn OCI
        authby=psk
        auto=start
        keyexchange=ikev2
        left=192.168.240.3
        leftid=	1.2.3.4
        leftsubnet=192.168.240.0/24
        right=5.4.3.2
        rightid=5.4.3.2
        rightsubnet=172.29.30.0/24
        ike=aes256-sha384-modp1536
        esp=aes256-sha1-modp1536
EOF
cat <<EOF >> /etc/strongswan/ipsec.secrets
192.168.240.3 9.8.7.6 : PSK "baptisteAZ"
1.2.3.4 9.8.7.6 : PSK "baptisteAZ"
192.168.240.3 5.4.3.2 : PSK "baptisteOCI"
1.2.3.4 5.4.3.2 : PSK "baptisteOCI"

EOF
strongswan restart
touch ~opc/userdata.`date +%s`.finish
strongswan status
