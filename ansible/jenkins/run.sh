#!/usr/bin/env bash

# Reset contents of persistent volume
rm -frv ~/jenkins

# Make sure the persistent volume for Jenkins is present
mkdir -pv ~/jenkins

# Remove previously running container if exists
docker kill jenkins
docker rm jenkins

# Set super secure password for the account
export KRIS_PWD=kristiyan

# Run Jenkins as Docker service
# Make sure plugins and configuration is present
docker run -d \
           -p 8080:8080 \
           -p 50000:50000 \
           --name jenkins \
           --env KRIS_PWD=$KRIS_PWD \
           --env JAVA_OPTS=-Djenkins.install.runSetupWizard=false \
           --env CASC_JENKINS_CONFIG=/var/jenkins_conf/jenkins.yaml \
           -v $PWD/jenkins.yaml:/var/jenkins_conf/jenkins.yaml \
           -v /home/$USER/jenkins:/var/jenkins_home \
           jenkins:devops

# Tail log
docker logs -f jenkins
