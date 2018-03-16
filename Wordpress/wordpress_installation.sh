#!/bin/bash
yum install wget unzip -y
yum -y install httpd
systemctl enable httpd
systemctl start httpd
yum install mariadb-server mariadb -y 
systemctl enable mariadb
systemctl start mariadb
mysql -e "UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE test;"
mysql -e "FLUSH PRIVILEGES;"
mysql -u root -proot <<'EOF'
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES on wordpress.* to 'root'@'localhost' identified by 'root';
FLUSH PRIVILEGES;
exit
EOF

yum -y install php php-mysql php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl
yum -y install epel-release
yum -y install phpmyadmin
systemctl restart httpd.service
cd /opt/;wget http://wordpress.org/latest.zip
unzip latest.zip
cp -avr wordpress /var/www/html
chmod -R 775 /var/www/html/wordpress
chown apache:apache /var/www/html/wordpress
systemctl restart httpd

