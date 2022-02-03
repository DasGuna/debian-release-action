#!/bin/bash

set -e

echo "Setting up and Running Container..."
echo "Path and Contents at this point"
pwd
ls -la
echo "Make a mount point for files"
mkdir targets
echo "Running Docker Container for Release..."
# docker build -f ./amd64_Dockerfile -t amd64_ros_container:latest .
# docker run amd64_ros_container:latest
# # # docker cp test-container:/usr/src/my-workdir/my-outputs .

docker build -f ./arm64_Dockerfile -t arm64_ros_container:latest .
docker run -v targets:/test_targets arm64_ros_container:latest

echo "Container Completed Functions"
echo "Path and Contents at this point"
pwd
ls -la
echo "Files in mount point"
cd targets
ls -la