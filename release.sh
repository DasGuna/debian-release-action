#!/usr/bin/bash

echo "Running Release Pipeline..."
echo "Getting Required Libraries..."
apt-get -y update 
apt-get install -y python3-pip python3-dev python3-bloom python3-stdeb dh-make git wget fakeroot

echo "Checking current directory path"
pwd
echo "Checking current directory content"
ls -la
echo "Current architecture check"
uname -m
echo "Creating a test file for output in mounted test_targets folder"
cd test_targets
touch test.txt
ls -la
# echo "Checking ROS install path"
# ls -la /opt/ros/