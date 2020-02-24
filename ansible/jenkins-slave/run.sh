#!/usr/bin/env bash

# Make sure there is one instance only
docker kill jenkins-slave
docker rm jenkins-slave

# Run the custom Slave image
# Note: This way allows to have multiple slave on single VM
#docker run -d \
#           --name jenkins-slave \
#           -e url=192.168.0.110 \
#           -e node=kris \
#           -e secret=jlk3jl41... \
#jenkins-slave:devops

# Run the custom Slave image with provided environment file
docker run -d --name jenkins-slave --env-file env.txt jenkins-slave:devops

# Tail log file
docker logs -f jenkins-slave
