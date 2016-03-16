#!/bin/bash
# josemedeirosdealmeida@gmail.com
# Jose Almeida
clear
echo -e "\n\e[31mWelcome to EasyProxy Hatfield 2016 v0.1\e[0m\n\nThis Proxy should be installed in a fresh Centos 7 server.\nAfter the instalation you only can ssh to port 80. \n\nThis setup will not delete any file, will rename it to .old.\n\n"
read -p "Do you want continue? (y/n) " RESP
if [ "$RESP" = "y" ]; then

#Check if is running as root (mandatory)
if [ “$(id -u)” != “0” ]; then
echo -e "\nThis script must be run as root. Login as root and test again.\n" 2>&1
exit 1
fi

#Disable iptables
service iptables stop
chkconfig iptables off

#Stoping Apache
service httpd stop

#Add user trtcode / password... and create folder scripts
useradd trtcode; echo "trtcode" | passwd trtcode --stdin

#Check if EPEL is installed, if not... install
echo -e "\nInstalling EPEL.\n"
sleep 2
if ! rpm -qa | grep -qw epel-release; then
    yum install epel-release -y
fi

#Install X and some stuff
echo -e "\nInstalling X Window.\n"
sleep 2
yum groupinstall "X Window System" -y --skip-broken
echo -e "\nInstalling Xclock.\n"
sleep 2
yum install xclock nautilus xeyes xcalc gedit -y
echo -e "\nYum updating....\n"
sleep 2
yum update -y
systemctl set-default graphical.target
sleep 1
echo -e "\nInstalling Chrome.\n"
sleep 2
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install ./google-chrome-stable_current_*.rpm -y --skip-broken
echo -e "\nInstalling Evince PDF Reader.\n"
sleep 2
yum install evince -y
echo -e "\nInstalling dialog.\n"
sleep 2
yum install dialog -y

#Generating the new /etc/ssh/sshd_config
echo -e "Backup /etc/ssh/sshd_config\n"
sleep 1 
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
echo -e "Generating new /etc/ssh/sshd_config\n"
sleep 2
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
sleep 2
cp /home/trtcode/.bashrc /tmp/bashrc.old
echo -e "Generating new /home/trtcode/.bashrc\n"
sleep 2
rm -f /home/trtcode/.bashrc
cat <<EOF >> /home/trtcode/.bashrc
# .bashrc
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
clear
sh /home/trtcode/scripts/.menu.sh
EOF

#Generating the new /etc/ssh/sshd_config
echo -e "Backup /etc/ssh/ssh_config\n"
cp /etc/ssh/ssh_config /etc/ssh/ssh_config.old
echo -e "Generating new /etc/ssh/ssh_config\n"
sleep 2
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

#Generating the new /etc/httpd/conf/httpd.conf
echo -e "Backup /etc/httpd/conf/httpd.conf\n"
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.old
echo -e "Generating new /etc/httpd/conf/httpd.conf\n"
sleep 2
rm -f /etc/httpd/conf/httpd.conf
cat <<EOF >> /etc/httpd/conf/httpd.conf
ServerRoot "/etc/httpd"
Listen 443
Include conf.modules.d/*.conf
User apache
Group apache
ServerAdmin root@localhost
<Directory />
    Options +Indexes
</Directory>
DocumentRoot "/home/trtcode/Downloads"
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "logs/error_log"
LogLevel warn
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>
<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>
AddDefaultCharset UTF-8
<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>
EnableSendfile on
IncludeOptional conf.d/*.conf
EOF

#Generating the new /etc/httpd/conf.d/welcome.conf
echo -e "Backup /etc/httpd/conf.d/welcome.conf\n"
cp /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.old
echo -e "Generating new /etc/httpd/conf.d/welcome.conf\n"
sleep 2
rm -f /etc/httpd/conf.d/welcome.conf
cat <<EOF >> /etc/httpd/conf.d/welcome.conf
<LocationMatch "^/+$">
    Options +Indexes
    ErrorDocument 403 /.noindex.html
</LocationMatch>

<Directory /usr/share/httpd/noindex>
    AllowOverride None
    Require all granted
</Directory>

Alias /.noindex.html /usr/share/httpd/noindex/index.html
Alias /noindex/css/bootstrap.min.css /usr/share/httpd/noindex/css/bootstrap.min.css
Alias /noindex/css/open-sans.css /usr/share/httpd/noindex/css/open-sans.css
Alias /images/apache_pb.gif /usr/share/httpd/noindex/images/apache_pb.gif
Alias /images/poweredby.png /usr/share/httpd/noindex/images/poweredby.png
EOF

#Generating the new /home/trtcode/scripts/.menu.sh
echo -e "Generating new /home/trtcode/scripts/.menu.sh\n"
sleep 2
rm -f /home/trtcode/scripts/.menu.sh
mkdir /home/trtcode/scripts/
chmod 755 /home/trtcode/scripts/
cp .menu.sh /home/trtcode/scripts/.menu.sh
sleep 1
chmod 755 /home/trtcode/scripts/.menu.sh

#Restarting services
service sshd restart
systemctl restart httpd
chkconfig httpd on

#Cleaning rpm's
echo -e "Cleaning RPM's\n"
sleep 2
rm -f *rpm*

#Permissions
chmod 777 -R /home/trtcode/

echo -e "\n\e[31mReboot server to enter in runlevel 5 (Just in case). Reboot it and use the local scripts on your computer!\e[0m\n"
else
  echo "Quiting!"
fi
