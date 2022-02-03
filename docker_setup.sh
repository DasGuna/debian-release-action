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
if [[ $INPUT_ARCH == 'amd64' ]]
then
    echo "AMD 64 RELEASE Confirmed"
    docker build -f ./amd64_Dockerfile -t amd64_ros_container:latest .
    docker run -v $mount_point_path:/test_targets amd64_ros_container:latest
elif [[ $INPUT_ARCH == 'arm64' ]]
then 
    echo "ARM 64 RELEASE Confirmed"
    docker build -f ./arm64_Dockerfile -t arm64_ros_container:latest .
    docker run -v $mount_point_path:/test_targets arm64_ros_container:latest
else
    echo "UNKNOWN ARCH"
    exit -1
fi

echo "Container Completed Functions"
echo "Path and Contents at this point"
pwd
ls -la
echo "Files in mount point"
cd targets
ls -la