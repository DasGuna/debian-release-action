#!/bin/bash

set -e

echo "Setting up and Running Container..."
echo "Path and Contents at this point"
pwd
ls -la

# Reference release entrypoint path
entrypoint_path=$(realpath release.sh)

echo "Make a mount point for files"
mkdir targets
mount_point_path=$(realpath targets/)


echo "Running Docker Container for Release..."
# docker build -f ./amd64_Dockerfile -t amd64_ros_container:latest .
# docker run amd64_ros_container:latest
# # # docker cp test-container:/usr/src/my-workdir/my-outputs .


# docker build -f ./arm64_Dockerfile -t arm64_ros_container:latest .
docker run --name release-container -v $mount_point_path:/test_targets $FROM $entrypoint_path

echo "Container Completed Functions"
echo "Path and Contents at this point"
pwd
ls -la
echo "Files in mount point"
cd targets
ls -la