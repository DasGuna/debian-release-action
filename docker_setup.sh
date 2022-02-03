#!/bin/bash

set -e

echo "Setting up and Running Container..."
echo "Path and Contents at this point"
pwd
ls -la
echo "Contents of this action"
ls $ACTION_PATH

# Reference release entrypoint path
entrypoint_path=$ACTION_PATH/release.sh

echo "Make a mount point for package (add test text file)"
mkdir package
mount_point_path=$(realpath package/)
touch $mount_point_path/this_is_a_test.txt

echo "Copy the action entrypoint into the mounted folder"
cp $ACTION_PATH/release.sh $mount_point_path/release.sh

echo "Running Docker Container for Release..."
if [[ $INPUT_ARCH == 'amd64' ]]
then
    echo "AMD 64 RELEASE Confirmed"
    docker build -f $ACTION_PATH/amd64_Dockerfile -t amd64_ros_container:latest .
    docker run -v $mount_point_path:/package_path amd64_ros_container:latest
elif [[ $INPUT_ARCH == 'arm64' ]]
then 
    echo "ARM 64 RELEASE Confirmed"
    docker build -f $ACTION_PATH/arm64_Dockerfile -t arm64_ros_container:latest .
    docker run -v $mount_point_path:/package_path arm64_ros_container:latest
elif [[ $INPUT_ARCH == 'arm32' ]]
then 
    echo "ARM 32 RELEASE Confirmed"
    docker build -f $ACTION_PATH/arm32_Dockerfile -t arm32_ros_container:latest .
    docker run -v $mount_point_path:/package_path arm32_ros_container:latest
else
    echo "UNKNOWN ARCH"
    exit -1
fi

echo "Container Completed Functions"
echo "Path and Contents at this point"
pwd
ls -la
echo "Files in mount point"
ls -la $mount_point_path