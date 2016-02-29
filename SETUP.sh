#!/bin/bash
#yum -y install epel-release -y
#yum --enablerepo=epel -y install sshpass -y
#Generating the new /etc/ssh/sshd_config
echo "Backup /etc/ssh/sshd_config\n"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
echo "Generating new /etc/ssh/sshd_config\n"
cat <<EOF >> /tmp/sshd_config
Port 80
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
SyslogFacility AUTHPRIV
AuthorizedKeysFile      .ssh/authorized_keys
PasswordAuthentication yes
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials no
UsePAM yes
X11Forwarding yes
UsePrivilegeSeparation sandbox          # Default for new installations.
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
Subsystem       sftp    /usr/libexec/openssh/sftp-server" > /tmp/sshd_config
EOF
#Generating the new /etc/ssh/sshd_config
echo "Backup /etc/ssh/sshd_config\n"
cp /etc/ssh/ssh_config /etc/ssh/ssh_config.old
echo "Generating new /etc/ssh/ssh_config\n"
cat <<EOF >> /tmp/ssh_config
Host *
        GSSAPIAuthentication yes
        ForwardX11Trusted yes
        SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
        SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
        SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE
        SendEnv XMODIFIERS
EOF
