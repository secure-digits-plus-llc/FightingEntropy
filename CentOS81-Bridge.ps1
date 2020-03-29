su -
yum update
sudo nano /etc/sysconfig/selinux

	SELINUX=enforcing -> disabled

# Install PowerShell

curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
yum install powershell
pwsh
su -

# firewall-cmd --zone=public --permanent --add-service={http,https,smtp-submission,smtps,imap,imaps}

yum install cifs-utils
mkdir /bin/Module
sudo mount.cifs //dsc1/module /bin/Module -o user=administrator@securedigitsplus.com


# Join AD
#/¯¯¯¯¯¯¯

yum install "realmd,sssd,oddjob,oddjob-mkhomedir,adcli,samba,samba-common,samba-common-tools,krb5-workstation".Split(',')

# File Sharing Capability Tangent
yum install samba
nano /etc/samba.conf

# Install VSCode
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
@: sudo nano /etc/yum.repos.d/vscode.repo ... {
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc

sudo yum install code
#\______________________________


# Install Services List

"epel-release,httpd,httpd-tools,mariadb-server,mariadb,perl,postfix,dovecot,samba,php,php-fpm,php-mysqlnd,php-opcache,php-gd,php-xml,php-mbstring".Split(',')
yum install 

# Initialize Apache
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
systemctl start httpd
systemctl enable httpd
systemctl reload httpd
chown apache:apache /var/www/html -R

# Initialize MariaDB
systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb

# Initialize MySQL Root
mysql_secure_installation
mysql -u root -p

systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm
systemctl restart httpd
setsebool -P httpd_execmem 1

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp

# Installing Roundcube
wget https://github.com/roundcube/roundcubemail/releases/download/1.4.2/roundcubemail-1.4.2-complete.tar.gz
tar xvf roundcubemail-1.4.2-complete.tar.gz
sudo mkdir /var/www # if apache was installed, it'll say it exists... so don't do it unless you want to see the message I just mentioned... which could be fun on another planet maybe
sudo mv roundcubemail-1.4.2 /var/www/roundcube

sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf module reset php
sudo dnf module enable php:remi-7.4 -y

@: sudo dnf install ..{ 
php-ldap 
php-imagick 
php-common 
php-gd 
php-imap 
php-json 
php-curl 
php-zip 
php-xml 
php-mbstring 
php-bz2 
php-intl 
php-gmp
}
# MySQL Database Setup
mysql -u root -p
create database roundcube default character set utf8 collate utf_general_ci;
create user MailAdmin@localhost identified by 'password';
grant all privileges on roundcube.* to MailAdmin@localhost;

mysql -u root -p mail < /var/www/roundcube/SQL/mysql.initial.sql

sudo nano /etc/httpd/conf.d/roundcube.conf
sudo nano /etc/httpd/conf.d/mail.securedigitsplus.com.conf

gedit /etc/postfix/main.cf
#/
         30 | compatibility_level = 2
         41 | soft_bounce = no
         50 | queue_directory = /var/spool/postfix
         55 | command_directory = /usr/sbin
	 61 | daemon_directory = /usr/libexec/postfix
	 67 | data_directory = /var/lib/postfix
	 78 | mail_owner = postfix
	 85 | default_privs = nobody
	 94 | myhostname = "hostname of the system"
        102 | mydomain = "domain of the network"
        118 | myorigin = $mydomain
   132..135 | 0 | inet_interfaces = all
	      1 | inet_interfaces = $myhostname
              2 | inet_interfaces = $myhostname , localhost
	      3 | inet_interfaces = localhost
	138 | inet_protocols = all
	149 | proxy_interfaces = 
	150 | proxy_interfaces = 1.2.3.4
   183..186 | 0 | mydestination = $myhostname, localhost.$mydomain, localhost
              1 | #mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
              2 | mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,
              3 | #  mail.$mydomain, www.$mydomain, ftp.$mydomain
   227..229 | 0 | local_recipient_maps = unix:passwd.byname $alias_maps
              1 | local_recipient_maps = proxy:unix:passwd.byname $alias_maps
              2 | local_recipient_maps = 
        240 | unknown_local_recipient_reject_code = 550
   268..270 | 0 | #mynetworks_style = class
              1 | mynetworks_style  = subnet
	      2 | #mynetworks_style = host
   283..285 | 0 | mynetworks = 192.168.1.0/24, 127.0.0.0/8
              1 | #mynetworks = $config_directory/mynetworks
              2 | #mynetworks = hash:/etc/postfix/network_table
        315 | #relay_domains = $mydestination [ Scope ]
   332..336 | 0 | #relayhost = $mydomain
              1 | #relayhost = [gateway.my.domain]
              2 | #relayhost = [mailserver.isp.tld]
              3 | #relayhost = uucphost
              4 | #relayhost = [an.ip.add.ress]
        350 | #relay_recipient_maps = hash:/etc/postfix/relay_recipients
        367 | in_flow_delay = 1s
	404 | #alias_maps = dbm:/etc/aliases
        405 | alias_maps = hash:/etc/aliases
	406 | #alias_maps = hash:/etc/aliases, nis:mail.aliases
        407 | #alias_maps = netinfo:/aliases
        414 | #alias_database = dbm:/etc/aliases
        415 | #alias_database = dbm:/etc/mail/aliases
        416 | alias_database = hash:/etc/aliases
        417 | #alias_database = hash:/etc/aliases, hash:/opt/majordomo/aliases
        428 | #recipient_delimiter = +
	437 | #home_mailbox = Mailbox
	438 | #home_mailbox = Maildir/
	444 | #mail_spool_directory = /var/mail
	445 | #mail_spool_directory = /var/spool/mail
	466 | #mailbox_command = /some/where/procmail
	467 | #mailbox_command = /some/where/procmail -a "$EXTENSION"
	486 | #mailbox_transport = lmtp:unix:/var/lib/imap/socket/lmtp
	498 | # local_destination_recipient_limit = 300
        499 | # local_destination_concurrency_limit = 5
        510 | #mailbox_transport = cyrus
	526 | #fallback_transport = lmtp:unix:/var/lib/imap/socket/lmtp
	527 | #fallback_transport = 
	548 | #luser_relay = $user@other.host
	549 | #luser_relay = $local@other.host
	550 | #luser_relay = admin+$local
	567 | #header_checks = regexp:/etc/postfix/header_checks
	580 | #fast_flush_domains = $relay_domains
	591 | #smtpd_banner = $myhostname ESMTP $mail_name
	592 | #smtpd_banner = $myhostname ESMTP $mail_name ($mail_version)
	608 | #local_destination_concurrency_limit = 2
	609 | #default_destination_concurrency_limit = 20
	617 | debug_peer_level = 2
	625 | #debug_peer_list = 127.0.0.1
	626 | #debug_peer_list = some.domain
	635 | debugger_command = 
	636 |      PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
	637 | 	   ddd $daemon_directory/$process_name $Process_id & sleep 5
	665 | sendmail_path = /usr/sbin/sendmail.postfix
	670 | newaliases_path = /usr/bin/newaliases.postfix
	675 | mailq_path = /usr/bin/mailq.postfix
	681 | setgid_group = postdrop
	685 | html_directory = no
	689 | manpage_directory = /user/share/man
	694 | sample_directory = /usr/share/doc/postfix/samples
	698 | readme_directory = /usr/share/doc/postfix/README_FILES
	709 | smtpd_tls_cert_file = /etc/pki/tls/certs/postfix.pem
	715 | smtpd_tls_key_file = /etc/pki/tls/private/postfix.key
	720 | smtpd_tls_security_level = may
	725 | smtpd_tls_CApath = /etc/pki/tls/certs
	731 | smtpd_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
	736 | smtp_tls_security_level = may
	737 | meta_directory = /etc/postfix
	738 | shlib_directory = /usr/lib64/postfix
#\

yum install dovecot -y
gedit /etc/dovecot/conf.d/dovecot.conf
	 24 | protocols = imap pop3 lmtp

gedit /etc/dovecot/conf.d/10-mail.conf
	 24 | mail_location = maildir:~/Maildir

gedit /etc/dovecot/conf.d/10-auth.conf
	 10 | disable_plaintext_auth = yes
	100 | auth mechanisms = plain login

gedit /etc/dovecot/conf.d/10-master.conf
	 91 | user = postfix
	 92 | group = postfix

gedit /etc/dovecot/conf.d/20-imap.conf
         67 | imap_client_workarounds = delay-newmail tb-extra-mailbox-sep

gedit /etc/dovedot/conf.d/20-pop3.conf
	 50 | pop3_uidl_format = %08Xu%08Xv
	 90 | pop3_client_workarounds = outlook-no-nuls oe-ns-eoh
         
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
ARCH=$( /bin/arch )
subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"
dnf config-manager --set-enabled PowerTools

openssl req -new -x509 -days 365 -nodes -out /etc/pki/dovecot/certs/mycert.pem -keyout /etc/pki/dovecot/private/mykey.pem

sudo firewall-cmd --zone=public --permanent --add-service={http,https,smtp-submission,smtps,imap,imaps}
systemctl reload firewalld
sudo dnf install wget
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
sudo mv certbot-auto /usr/local/bin/certbot
sudo chown root /usr/local/bin/certbot
sudo chmod 0755 /usr/local/bin/certbot

