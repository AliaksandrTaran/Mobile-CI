#!/bin/bash
yum -y install java-1.8.0-openjdk-devel.x86_64
yum install postgresql-server postgresql-contrib -y
postgresql-setup initdb
sed -i 's/ident/md5/g' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/peer/ident/' /var/lib/pgsql/data/pg_hba.conf
systemctl start postgresql
systemctl enable postgresql
echo "postgres" | passwd postgres --stdin
su - postgres <<'EOF'
psql
create user sonar;
alter role sonar WITH CREATEDB;
alter user sonar with encrypted password 'sonar';
create database sonar owner sonar;
grant all privileges on database sonar to sonar;
\q
EOF
systemctl restart postgresql
wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.7.2.zip
yum -y install unzip
unzip sonarqube-6.7.2.zip -d /opt
mv /opt/sonarqube-6.7.2 /opt/sonarqube
sed -i 's@#sonar.jdbc.username=@sonar.jdbc.username=sonar@' /opt/sonarqube/conf/sonar.properties 
sed -i 's@#sonar.jdbc.password=@sonar.jdbc.password=sonar@' /opt/sonarqube/conf/sonar.properties 
sed -i 's@#sonar.jdbc.url=jdbc:postgresql@sonar.jdbc.url=jdbc:postgresql@' /opt/sonarqube/conf/sonar.properties
sed -i 's@#sonar.web.port@sonar.web.port@' /opt/sonarqube/conf/sonar.properties

chown -R vagrant: /opt/sonarqube
systemctl enable sonar
systemctl start sonar

