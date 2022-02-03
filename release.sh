#!/usr/bin/bash

echo "Running Release Pipeline..."
echo "Getting Required Libraries..."
apt-get -y update 
apt-get install -y python3-pip python3-dev python3-bloom python3-stdeb dh-make git wget fakeroot python3-catkin-pkg
ln -s /usr/bin/python3 /usr/local/bin/python

echo "Source ROS workspace"
source /opt/ros/noetic/setup.bash

echo "Checking current directory path"
pwd
echo "Checking current directory content"
ls -la
echo "Current architecture check"
uname -m
echo "Enter docker ws folder for releasing package(s)"
cd docker_ws
ls -la

echo "Clone release tools action from QCR repos"
git clone https://github.com/qcr/release-tools-ros.git
cd release-tools-ros
# This is the docker ws/src/<package>/release-tools-ros
ln -s ../src src
echo "running release script"
./release
echo "COMPLETED RELEASE PIPELINE"