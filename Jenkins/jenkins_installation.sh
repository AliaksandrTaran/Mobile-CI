#!/bin/bash
install java-1.8.0-openjdk-devel.x86_64
wget -O /etc/yum.repos.d/jenkins.repo http://jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum -y install jenkins
systemctl enable jenkins
systemctl start jenkins
