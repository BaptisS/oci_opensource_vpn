#!/bin/bash
sudo su
yum install libreswan lsof -y
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

systemctl mask iptables
systemctl stop iptables
firewall-offline-cmd --zone=public --add-port=500/udp 
firewall-offline-cmd --zone=public --add-port=500/tcp
firewall-offline-cmd --zone=public --add-port=4500/udp 
firewall-offline-cmd --zone=public --add-port=4500/tcp
systemctl restart firewalld
systemctl enable ipsec

##### IPSEC Variables #####

localip=172.16.100.16
leftid=132.226.yy.yy                   #OCI Reserved Public IP address :
leftsubnet=172.16.100.0/24      #OCI VCN IP address range in CIDR notation :
right=152.67.xx.xx                    #On-premises VPN Public IP address :
rightid=$right                   #Custom IKE IDentifier (Optional) :
rightsubnet=10.90.10.0/24     #On-premises internal network IP address range in CIDR notation:
P1props=aes_cbc256-sha2_384;modp1536   #Phase 1 proposals. Should be modified to match on-premises VPN endpoint configuration.
P1life=28800s                   #Phase 1 (IKE) Lifetime
P2props=aes256-sha1-modp1536     #Phase 2 proposals. Should be modified to match on-premises VPN endpoint configuration.
P2life=3600s                    #Phase 2 (IPSEC) Lifetime
PSK="'Cem6mIexuYuXQRIYnZ9jLue'"        #Pre-Shared Key

##### IPSEC Variables #####

mv /etc/ipsec.d/oci_ipsec.conf /etc/ipsec.d/oci_ipsec.conf.bak
cat <<EOF >> /etc/ipsec.d/oci_ipsec.conf

conn ocitunnel1
        type=tunnel
        pfs=yes
        authby=secret
        auto=start
        keyexchange=ike
        ikev2=insist
        left=$localip
        leftid=$leftid
        leftsubnet=$leftsubnet
        right=$right
        rightid=$rightid  
        rightsubnet=$rightsubnet 
        ike=$P1props
        phase2alg=$P2props
        ikelifetime=$P1life
        salifetime=$P2life

EOF
cat <<EOF >> /etc/ipsec.d/oci_ipsec.secrets
$localip $right : PSK $PSK 
$leftid $right : PSK $PSK
EOF
ipsec restart
touch ~opc/userdata.`date +%s`.finish
#ipsec status
#tail /var/log/pluto.log
