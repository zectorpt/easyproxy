#!/bin/bash
clear
echo -e "\n\e[31mWelcome to EasyProxy Hatfield v0.1\e[0m\n\nThis Proxy should be installed in a fresh Centos 7 server.\nAfter the instalation you only can ssh by port 80. \n\nThis setup will not delete any file, will rename it to .old.\n\n"
read -p "Do you want continue? (y/n) " RESP
if [ "$RESP" = "y" ]; then

#Check if is running as root (mandatory)
if [ “$(id -u)” != “0” ]; then
echo -e "\nThis script must be run as root. Login as root and test again.\n" 2>&1
exit 1
fi

#Check if EPEL is installed, if not... install
if ! rpm -qa | grep -qw epel-release; then
    yum -y install epel-release -y
fi

#Check if sshpass is installed, if not... install
if ! rpm -qa | grep -qw sshpass; then
    yum --enablerepo=epel -y install sshpass -y
fi

#Install X and some stuff
yum groupinstall "X Window System" "GNOME Desktop Environment" -y
systemctl set-default graphical.target
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sleep 1
yum install ./google-chrome-stable_current_*.rpm -y

#Generating the new /etc/ssh/sshd_config
echo -e "Backup /etc/ssh/sshd_config\n"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
echo -e "Generating new /etc/ssh/sshd_config\n"
rm -f /tmp/sshd_config
sleep 1
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
echo -e "Backup /etc/ssh/sshd_config\n"
cp /etc/ssh/ssh_config /etc/ssh/ssh_config.old
echo -e "Generating new /etc/ssh/ssh_config\n"
sleep 1
rm -f /tmp/ssh_config
cat <<EOF >> /tmp/ssh_config
Host *
        GSSAPIAuthentication yes
        ForwardX11Trusted yes
        SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
        SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
        SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE
        SendEnv XMODIFIERS
EOF
else
  echo "Quiting!"
fi

