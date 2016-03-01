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

#Disable iptables and apache
service iptables stop
chkconfig iptables off
service httpd stop
chkconfig httpd off

#Add user trtcode / password... and create folder scripts
useradd trtcode; echo "trtcode" | passwd trtcode --stdin

#Check if EPEL is installed, if not... install
echo -e "\nInstalling EPEL.\n"
if ! rpm -qa | grep -qw epel-release; then
    yum install epel-release -y 1> /dev/null
fi

#Check if sshpass is installed, if not... install
echo -e "\nInstalling sshpass.\n"
if ! rpm -qa | grep -qw sshpass; then
    yum --enablerepo=epel -y install sshpass 1> /dev/null
fi

#Install X and some stuff
echo -e "\nInstalling X Window.\n"
yum groupinstall "X Window System" -y --skip-broken 1> /dev/null
echo -e "\nInstalling Xclock.\n"
yum install xclock nautilus -y 1> /dev/null
echo -e "\nYum updating....\n"
yum update -y 1> /dev/null
systemctl set-default graphical.target
sleep 1
echo -e "\nInstalling Chrome.\n"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install ./google-chrome-stable_current_*.rpm -y 1> /dev/null
sleep 1
echo -e "\nInstalling Adobe Acrobat.\n"
wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/AdbeRdr9.5.5-1_i486linux_enu.rpm
yum localinstall AdbeRdr9.5.5-1_i486linux_enu.rpm -y 1> /dev/null
sleep 1
echo -e "\nInstalling dialog.\n"
yum install dialog -y 1> /dev/null

#Generating the new /etc/ssh/sshd_config
echo -e "Backup /etc/ssh/sshd_config\n"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
echo -e "Generating new /etc/ssh/sshd_config\n"
rm -f /etc/ssh/sshd_config
sleep 1
cat <<EOF >> /etc/ssh/sshd_config
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
Subsystem       sftp    /usr/libexec/openssh/sftp-server
EOF

#Generating bashrc
echo -e "Backup /home/trtcode/.bashrc\n"
cp /home/trtcode/.bashrc /tmp/bashrc.old
echo -e "Generating new /home/trtcode/.bashrc\n"
sleep 1
rm -f /home/trtcode/.bashrc
cat <<EOF >> /home/trtcode/.bashrc
# .bashrc
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
clear
sh /home/trtcode/scripts/menu.sh
EOF

#Generating the new /etc/ssh/sshd_config
echo -e "Backup /etc/ssh/ssh_config\n"
cp /etc/ssh/ssh_config /etc/ssh/ssh_config.old
echo -e "Generating new /etc/ssh/ssh_config\n"
sleep 1
rm -f /etc/ssh/ssh_config
cat <<EOF >> /etc/ssh/ssh_config
Host *
        GSSAPIAuthentication yes
        ForwardX11Trusted yes
        SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
        SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
        SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE
        SendEnv XMODIFIERS
EOF

#Generating the new /home/trtcode/scripts/menu.sh
echo -e "Generating new /home/trtcode/scripts/menu.sh\n"
sleep 1
rm -f /home/trtcode/scripts/menu.sh
mkdir /home/trtcode/scripts/
chmod 755 /home/trtcode/scripts/
cp menu.sh /home/trtcode/scripts/menu.sh
sleep 1
chmod 755 /home/trtcode/scripts/menu.sh

#Restarting services
service sshd restart

#Cleaning rpm's
echo -e "Cleaning RPM's\n"
rm -f *rpm*

echo -e "\n\e[31mReboot server to enter in runlevel 5 (Just in case). Reboot it and use the local scripts on your computer!\e[0m\n"
else
  echo "Quiting!"
fi
