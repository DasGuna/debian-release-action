#!/usr/bin/bash

echo "Running Release Pipeline..."
echo "Getting Required Libraries..."
apt -y update 
apt install -y python3-pip python3-dev python3-bloom python3-stdeb dh-make git wget fakeroot
# Symbolic link python command to python3 (default behaviour)
ln -s /usr/bin/python3 /usr/local/bin/python

# This has already been build so install only (faster implementation)
echo "Uncompressing and Installing Pre-Built cmake 3.20 Version for Release [Required for armhf]"
tar -xf /docker_ws/dependencies/cmake-3.20-pre-built.tar.gz
cd /docker_ws/dependencies/cmake-3.20
make install
echo "Sanity check of cmake version:"
cmake --version

# Source the ROS workspace
echo "Source ROS workspace"
source /opt/ros/noetic/setup.sh

echo "Checking current directory path"
pwd
echo "Checking current directory content"
ls -la
echo "Sanity check current architecture"
uname -m
echo "Enter docker mounted workspace folder for releasing package(s)"
cd /docker_ws
ls -la
echo "Clone release tools action from QCR repos"
git clone https://github.com/qcr/release-tools-ros.git
cd release-tools-ros
# This is the docker ws/src/<package>/release-tools-ros
ln -s ../src src
echo "running release script"
./release
echo "COMPLETED RELEASE PIPELINE"