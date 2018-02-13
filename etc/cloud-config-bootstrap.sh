#!/usr/bin/env bash

# sshd - PermitRootLogin
if [ -f '/etc/ssh/sshd_config' ]; then
    sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
    service ssh restart
fi

# resolved - LLMNR
if [ -f '/etc/systemd/resolved.conf' ]; then
    sed -i -e '/^#LLMNR/s/^.*$/LLMNR=no/' /etc/systemd/resolved.conf
    systemctl restart systemd-resolved.service
fi

# packages
apt-get update
apt-get -y install python nodejs htop iftop tree jq traceroute nmap tcpdump netcat figlet
rm -f /usr/bin/node
ln -s /usr/bin/nodejs /usr/bin/node

# cjdns
curl \
    --location \
    --silent \
    -o /opt/cjdns-${cjdns_commit}.tar.gz \
    'https://github.com/cjdelisle/cjdns/archive/${cjdns_commit}.tar.gz'
tar -zxvf /opt/cjdns-${cjdns_commit}.tar.gz --directory /opt/

apt-get -y install gcc make
export Log_LEVEL=INFO
cd /opt/cjdns-${cjdns_commit}; ./do
apt-get -y remove gcc make
apt-get -y autoremove

cp /opt/cjdns-${cjdns_commit}/cjdroute /usr/bin/
cp /opt/cjdns-${cjdns_commit}/contrib/systemd/cjdns.service /etc/systemd/system/
cp /opt/cjdns-${cjdns_commit}/contrib/systemd/cjdns-resume.service /etc/systemd/system/
rm -f /opt/cjdns
ln -s /opt/cjdns-${cjdns_commit} /opt/cjdns

systemctl enable cjdns
systemctl start cjdns

# ipfs
if [ `echo -n "${ipfs_version}" | wc -c` -gt 0 ]; then
    curl \
        --location \
        --silent \
        -o /tmp/go-ipfs_${ipfs_version}_linux-amd64.tar.gz \
        'https://dist.ipfs.io/go-ipfs/${ipfs_version}/go-ipfs_${ipfs_version}_linux-amd64.tar.gz'
    tar -zxvf /tmp/go-ipfs_${ipfs_version}_linux-amd64.tar.gz --directory /tmp/
    cd /tmp/go-ipfs/; sudo ./install.sh
fi

# hostname
echo '${hostname}' | head -c 10 | figlet > /etc/motd
