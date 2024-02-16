#!/bin/bash

# Install Docker
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo service jenkins start

# Install SonarQube
sudo yum install java-11-openjdk-devel -y
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip
sudo unzip sonarqube-8.9.2.46101.zip
sudo mv sonarqube-8.9.2.46101 /opt/sonarqube
sudo /opt/sonarqube/bin/linux-x86-64/sonar.sh start

# Install Maven
sudo yum install maven -y

