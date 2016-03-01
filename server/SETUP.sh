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


#Check if EPEL is installed, if not... install
if ! rpm -qa | grep -qw epel-release; then
    yum -y install epel-release -y
fi

#Check if sshpass is installed, if not... install
if ! rpm -qa | grep -qw sshpass; then
    yum --enablerepo=epel -y install sshpass -y
fi

#Install X and some stuff
#yum groupinstall "X Window System" "GNOME Desktop" -y --skip-broken
yum groupinstall "X Window System" -y --skip-broken
systemctl set-default graphical.target
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sleep 1
yum install ./google-chrome-stable_current_*.rpm -y
wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/AdbeRdr9.5.5-1_i486linux_enu.rpm
sleep 1
yum localinstall http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm -y
yum localinstall AdbeRdr9.5.5-1_i486linux_enu.rpm -y
sleep 1
yum install dialog -y

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
Subsystem       sftp    /usr/libexec/openssh/sftp-server" > /tmp/sshd_config
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

#Add user trtcode / password... and create folder scripts
useradd trtcode; echo "trtcode" | passwd trtcode --stdin

#Generating the new /home/trtcode/scripts/menu.sh
echo -e "Generating new /home/trtcode/scripts/menu.sh\n"
sleep 1
rm -f /home/trtcode/scripts/menu.sh
chmod 755 /home/trtcode/
mkdir /home/trtcode/scripts/
chmod 755 /home/trtcode/scripts/
cat <<EOF >> /home/trtcode/scripts/menu.sh
#!/bin/bash

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Display System Information" \
    "2" "Display Disk Space" \
    "3" "Display Home Space Utilization" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      result=$(echo "Hostname: $HOSTNAME"; uptime)
      display_result "System Information"
      ;;
    2 )
      result=$(df -h)
      display_result "Disk Space"
      ;;
    3 )
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
  esac
done
EOF

sleep 1
chmod 755 /home/trtcode/scripts/menu.sh

#Restarting services
service sshd restart

else
  echo "Quiting!"
fi
