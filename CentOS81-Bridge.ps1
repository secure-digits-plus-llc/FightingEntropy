# _______________________________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ PowerShell - Obtains pwsh to process script \\
    su -                                                                  
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    yum install powershell -y
    sudo pwsh
#\________________________________________________________________________/
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

    Class Content # Gets content, makes replacements, and sets the updated content back to source
    {
        [ String    ] $Path
        [ String [] ] $Content
        [ String [] ] $Search
        [ String [] ] $Target

        Content( [ String ] $Path , [ String [] ] $Search , [ String [] ] $Target )
        {
            $This.Path    = $Path
            $This.Content = Get-Content $This.Path
            $This.Search  = $Search
            $This.Target  = $Target

            ForEach ( $I in $This.Content )
            {
                If ( $This.Search.Count -gt 1 )
                {
                    ForEach ( $J in 0..( $This.Search.Count - 1 ) )
                    {
                        If ( $This.Content[$I] -match $This.Search[$J] )
                        {
                            $This.Content[$I] = $This.Content[$I] -Replace $This.Search[$J] , $This.Target[$J]
                        }
                    }
                }

                Else
                {
                    If ( $This.Content[$I] -match $This.Search )
                    {
                        $This.Content[$I] = $This.Content[$I] -Replace $This.Search , $This.Target
                    }
                }
            }

            Set-Content $This.Path $This.Content
        }
    }


# ____________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ Join ADDS Domain \\
Function Install-ADDS
{
    Param ( $Username )

    yum install realmd sssd oddjob oddjob-mkhomedir adcli samba samba-common samba-common-tools krb5-workstation -y
    realm join -v -U $Username
}
#\___________________________________________________________________________________________________//
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

# ____________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ CIFS for Windows Shares \\
    Function Install-CIFS
    {
        Param ( $Server , $Share , $Mount = "/mnt" , $Username )

        yum install cifs-utils
        sudo mount.cifs //$Server/$Share $Mount -o user=$Username
    }
#\___________________________________________________________________________________________________//
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

# ____________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ Visual Studio Code \\
    Function Install-VSCode
    {
        "https://packages.microsoft.com" | % {
            
            @{
                Name = $_ 
                Keys = "$_/keys/microsoft.asc"
                Repo = "$_/yumrepos/vscode"
            }
                
            sudo rpm --import $_.Keys
            Set-Content "/etc/yum.repos.d/vscode.repo" "[code]|name=Visual Studio Code|baseurl=$( $_.Repo )|enabled=1|gpgcheck=1|gpgkey=$( $_.Keys )".Split('|') -VB
        }

        sudo yum install code
        code --install-extension ms-vscode.powershell
    }
#\___________________________________________________________________________________________________//
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

yum update

Function Set-Selinux
{
    [Content]::("/etc/sysconfig/selinux","SELINUX=enforcing","SELINUX=disabled")
}

Function Set-Network
{
    Param ( $Target )

    sudo yum install wget tar net-tools

    If ( ( hostname ) -ne $Target )
    {
        hostnamectl set-hostname $Target
    }

    ifconfig | % { 
        
        If ( $_ -match "inet " -and $_ -notmatch "127.0.0.1" ) 
        {
            $X            = $_ -Split " " | ? { $_.Length -gt 0 }
            $Y            = GC /etc/hosts
            $Z            = [ PSCustomObject ]@{

                IPAddress = $X[1]
                Hostname  = ( $Target -Split '.' )[0]
                FullName  = $Target
                Netmask   = $X[3]
                Broadcast = $X[5]
            
            } 
            
            If ( $Z.IPAddress -notin $Y )
            {
                Set-Content /etc/hosts "{0} {1} {2}" -f $Z.IPAddress , $Z.HostName , $Z.FullName
            }
        }
    }
}

Function Initialize-Service
{
    [ CmdLetBinding () ] Param ( [ Parameter ( Mandatory ) ] [ String ] $Name )

    Echo "Initializing/Reloading $Name"
    ForEach ( $I in 0..2 )
    {
        $X = ("Starting,start","Enabling,enable","Reloading,reload")[$I].Split(',')

        Echo $X[0]
        systemctl $X[1] $Name
    }
    Echo "Operation Complete"
}

Function Install-Apache
{
    sudo yum install epel-release httpd httpd-tools -y
    chown apache:apache /var/www/html -R

    "/etc/httpd/conf/httpd.conf" | % { 
        
        @{ 
            Path    = $_ 
            Content = GC $_ 
        
        } | % {

            ForEach ( $I in 0..( $_.Content.Length - 1 ) )
            {
                If ( $_.Content[$I] -match "(<Directory />)" ) 
                { 
                    $_.Content[$I+1] = "    AllowOverride All" 
                }
            }

            Set-Content @_
        }

        "" , "s" | % { 
            
            IEX "firewall-cmd --zone=public --permanent --add-service=http$_"
        }

        Initialize-Service httpd
    }
}

Function Install-MariaDB
{
    sudo yum install mariadb mariadb-server -y
    Initialize-Service mariadb
}

Function Install-PostFix
{
    sudo yum install postfix -y

    "/etc/postfix/main.cf" | % { 

        @{
            Path    = $_
            Content = GC $_ 
        }

    #   30 | compatibility_level = 2
    #   41 | #soft_bounce = no
    #   50 | queue_directory = /var/spool/postfix
    #   55 | command_directory = /usr/sbin
    #   61 | daemon_directory = /usr/libexec/postfix
    #   67 | data_directory = /var/lib/postfix
    #   78 | mail_owner = postfix
    #   85 | #default_privs = nobody
        94 | myhostname = mail.securedigitsplus.com #
    #   95 | #myhostname = More than likely for a virtual host or fallback #
       102 | mydomain = securedigitsplus.com        #
    #  118 | #myorigin = $myhostname
       119 | myorigin = $mydomain
       132 | inet_interfaces = all
    #  133 | #inet_interfaces = $myhostname
    #  134 | #inet_interfaces = $myhostname , localhost
       135 | inet_interfaces = localhost
       138 | inet_protocols = all
    #  149 | #proxy_interfaces = 
    #  150 | #proxy_interfaces = 1.2.3.4
       183 | mydestination = $myhostname, localhost.$mydomain, localhost
    #  184 | #mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
       185 | mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,
    #  186 | #  mail.$mydomain, www.$mydomain, ftp.$mydomain
       227 | local_recipient_maps = unix:passwd.byname $alias_maps
       228 | local_recipient_maps = proxy:unix:passwd.byname $alias_maps
       229 | local_recipient_maps = 
       240 | unknown_local_recipient_reject_code = 550
    #  268 | #mynetworks_style = class
       269 | mynetworks_style  = subnet
    #  270 | #mynetworks_style = host
       283 | mynetworks = 192.168.1.0/24, 127.0.0.0/8
    #  284 | #mynetworks = $config_directory/mynetworks
    #  285 | #mynetworks = hash:/etc/postfix/network_table
    #  315 | #relay_domains = $mydestination [ Scope ]
    #  332 | #relayhost = $mydomain
    #  333 | #relayhost = [gateway.my.domain]
    #  334 | #relayhost = [mailserver.isp.tld]
       335 | #relayhost = uucphost
       336 | #relayhost = [an.ip.add.ress]
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
       438 | home_mailbox = Maildir/
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
    }
}

Function Install-RoundCube
{
    roundcubemail-1.4.2 | % { 

        wget https://github.com/roundcube/roundcubemail/releases/download/1.4.2/$_-complete.tar.gz
        sudo tar xvzf $_-complete.tar.gz
        sudo mv $_ /var/www/roundcube/
    }

    sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
    sudo dnf module reset php
    sudo dnf module enable php:remi-7.4 -y

    sudo dnf install -y " ldap imagick common gd imap json curl zip xml mbstring bz2 intl gmp".Replace(" "," php-")

    @{  
        Path  = "/etc/httpd/conf.d/roundcube.conf" 
        Value = @"
        <VirtualHost *:80>
          ServerName mail.securedigitsplus.com
          DocumentRoot /var/www/roundcube/

          ErrorLog /var/log/httpd/roundcube_error.log        
          CustomLog /var/log/httpd/roundcube_access.log combined

          <Directory />
            Options FollowSymLinks
            AllowOverride All
          </Directory>
        
          <Directory /var/www/roundcube/>
            Options FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            allow from all
          </Directory>
        
        </VirtualHost>
"@ 
    
    }         | % { Set-Content @_ }
    
    # Initialize MySQL Root
    mysql_secure_installation
    mysql -u root -p
    create database roundcube default character set utf8 collate utf8_general_ci;
    create user postmaster@localhost identified by 'password';
    grant all privileges on roundcube.* to postmaster@localhost;
    flush privileges;
    exit;

    mysql -u root -p roundcube < /var/www/roundcube/SQL/mysql.initial.sql

    "start","enable","status" | % { IEX "systemctl $_ php-fpm" }

    systemctl restart httpd
    setsebool -P httpd_execmem 1

    systemctl reload firewalld

    $Conf = gc /etc/php.ini | ? { $_ -match ";date.timezone =" } | % { "date.timezone = America/New_York" }
}

#/_________________________________________

yum install dovecot -y

$Conf           = "/etc/dovecot/conf.d" | % {
    
    @{
        Dovecot = "$_/dovecot.conf" 
        Mail    = "$_/10-mail.conf" 
        Auth    = "$_/10-auth.conf" 
        Master  = "$_/10-master.conf" 
        IMAP    = "$_/20-imap.conf" 
        POP3    = "$_/20-pop3.conf" 
    }
}


gedit /etc/dovecot/dovecot.conf

$Dovecot = "/etc/dovecot/dovecot.conf"

ForEach ( $I in $Dovecot )
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
         
openssl req -new -x509 -days 365 -nodes -out /etc/pki/dovecot/certs/mycert.pem -keyout /etc/pki/dovecot/private/mykey.pem
#

# does not work in pwsh 
sudo firewall-cmd --zone=public --permanent --add-service={http,https,smtp-submission,smtps,imap,imaps}

systemctl reload firewalld
sudo dnf install wget
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
sudo mv certbot-auto /usr/local/bin/certbot
sudo chown root /usr/local/bin/certbot
sudo chmod 0755 /usr/local/bin/certbot

sudo nano /etc/httpd/conf.d/mail.securedigitsplus.com.conf
