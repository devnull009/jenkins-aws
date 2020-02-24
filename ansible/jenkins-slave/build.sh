#!/usr/bin/env bash

# Remove existing slave images
docker rmi jenkins-slave:devops --force

# Build new slave according to Dockerfile
docker build --no-cache -t jenkins-slave:devops .
