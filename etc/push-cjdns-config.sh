#!/usr/bin/env bash

LOCAL_CONFIG=${1}
REMOTE_HOST=${2}

if [ -z "${LOCAL_CONFIG}" ] || [ -z "${REMOTE_HOST}" ]; then
    echo ""
    echo "Usage: ./push-cjdns-config.sh <local-cjdroute.conf> <remote-host-address>"
    echo " - pushes via SSH a locally stored cjdroute.conf file to a remote host and restarts the cjdns system service"
    echo ""
    exit 1
fi

shopt -s expand_aliases
alias ssh-insecure='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=3'
alias scp-insecure='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=3'

echo "Testing SSH connection to ${REMOTE_HOST}..."
ssh-insecure ${REMOTE_HOST} date > /dev/null
while test $? -gt 0
do
   sleep 5
   echo "Testing SSH connection to ${REMOTE_HOST} again..."
   ssh-insecure ${REMOTE_HOST} date > /dev/null
done
echo "SSH connection to ${REMOTE_HOST} sucess!!"

REMOTE_TEMPFILE=/tmp/cjdroute-`head /dev/urandom | md5sum | head -c16`.conf
scp-insecure ${LOCAL_CONFIG} ${REMOTE_HOST}:${REMOTE_TEMPFILE} > /dev/null

ssh-insecure ${REMOTE_HOST} > /dev/null << EOF
    if [ -f /etc/systemd/system/cjdns.service ]; then
        sudo systemctl stop cjdns
    fi
    sudo chmod 0600 ${REMOTE_TEMPFILE}
    sudo mv ${REMOTE_TEMPFILE} /etc/cjdroute.conf
    if [ -f /etc/systemd/system/cjdns.service ]; then
        sleep 5
        sudo systemctl start cjdns
    fi
EOF
