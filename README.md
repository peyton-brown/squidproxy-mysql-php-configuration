# Squid Config Files

## Squid Proxy & MySQL DB (Feb. 2021)

---

## Requirements
- apt-get update       
- apt-get install build-essential binutils autoconf automake libcap-dev libltdl-dev grep wget net-tools g++ git vim perl mysql-server -y           

---

## Squid Install Steps (for DB)
- cd /tmp/    
- wget http://www.squid-cache.org/Versions/v4/squid-4.13.tar.gz      
- tar xvf squid-4.14.tar.gz    
- cd squid-4.14/     
- ./configure --sysconfdir=/etc/squid/ --enable-basic-auth-helpers=DB      
- make all     
- make install         

### Give permission to caching/log folder:                 
- mkdir /cachedir/             
- cd /cachedir/         
- mkdir coredumps/             
- chmod -R ugo+rwx /usr/local/squid/      
- chmod -R ugo+rwx /cachedir/       s

### Location of Squid Files:  
- cd /usr/local/squid    

### Git Clone Folder
- cd /   
- mkdir /git/      
- cd /git/       
- git clone https://github.com/peyton-brown/squidproxy-mysql-php-configuration.git              
- cd /squidproxy-mysql-php-configuration.git             

### Copy squid.conf
- cp squid.conf /usr/local/squid/etc/            

### Copy Whitelist
- cp Whitelist/allowed_sites.acl /usr/local/squid/etc/         

### Copy basic_db_auth
- cp MySQLFiles/basic_db_auth /usr/local/squid/libexec/          

### Starting Squid
After compiling squid, run this command to verify your configuration file. If this outputs any errors then these are syntax errors or other fatal misconfigurations and needs to be corrected before you continue. If it is silent and immediately gives back the command prompt then your squid.conf is syntactically correct and could be understood by Squid.       
- /usr/local/squid/sbin/squid -k parse        

Create swap directories using -z.     
- /usr/local/squid/sbin/squid -z     

If you want to run squid in the background or on startup, leave off all options:          
- /usr/local/squid/sbin/squid           

[SOURCE](https://wiki.squid-cache.org/SquidFaq/InstallingSquid)             

---

## MySQL-Server Install Steps
- apt-get install mysql-server    
- mysql_secure_installation   

The first prompt will ask whether you’d like to set up the Validate Password Plugin, which can be used to test the strength of your MySQL password. Regardless of your choice, the next prompt will be to set a password for the MySQL root user. Enter and then confirm a secure password of your choice. From there, you can press Y and then ENTER to accept the defaults for all the subsequent questions. [SOURCE](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04)    

- sudo mysql   

### MySQL code is in the MySQLFiles folder.

---

## Squid Configuration with MySQL Authentication

- cd /usr/local/squid/libexec/    
- sudo vim basic_db_auth    

Search for 'my $dsn ='   
- Example: (my $dsn = "DBI:mysql:database=yourdatabasename;host=192.168.1.1";)    
Change 'yourdatabasename' to whatever your database name is    
Change 'host' to ip of mysql server (ifconfig)    

Leave '$db_user' & '$db_passwd' as undef    

Change '$db_table' to the table name where username/password is saved    
- Example: (my $db_table = "users";)    

Change '$db_usercol' to the username column in mysql table    
- Example: (my $db_usercol = "username";)    

Change '$db_passwdcol' to the password column in mysql table    
- Example: (my $db_passwd = "password";)    

[SOURCE](http://linchpincorner.blogspot.com/2016/08/squid-proxy-server-configuration-with_23.html)

---

## Connect to Proxy with FireFox

- On Firefox, go to options   
- Network Settings   
- Manual proxy configuration   
- Go to your Ubuntu Server and type in 'ifconfig'   
- Find the inet address (ip address)   
- Go back to Firefox   
- Enter that ip into HTTP Proxy   
- Check 'Also use this proxy for FTP and HTTPS'   
- Make sure the port is the same as the one in squid.conf   
- Click OK   

---

## Potential Error Messages

1. **Failed to start squid.service: Unit not found**
  - cd /etc/systemd/system, if squid.service is not there, make the file. (sudo touch squid.service)
  - Paste the following code into that file:    
      [Unit]    
      Description=Squid caching proxy    
      Documentation=man:squid(8)    
      After=network.target network-online.target nss-lookup.target    

      [Service]       
      Type=simple            
      PIDFile=/run/squid.pid        
      ExecStart=/usr/sbin/squid --foreground $SQUID_OPTS -f /etc/squid/squid.conf      
      ExecReload=/usr/bin/kill -HUP $MAINPID      
      KillMode=mixed       
      NotifyAccess=all       

      [Install]          
      WantedBy=multi-user.target   


      **INSERT INTO TERMINAL**    
      mkdir /var/log/squid    
      chown proxy: /var/log/squid    
      chmod 4664 /var/log/squid        
