#!/bin/bash

# Remove previous image
docker rmi jenkins:devops --force

# Re-build the new image with plugins
# Keep in mind that build may fail because of network issues with Jenkins mirrors for plugins!
docker build --no-cache -t jenkins:devops .
