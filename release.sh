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
echo "Check package_path folder for debianisable package(s)"
cd package_path
ls -la
# echo "Checking ROS install path"
# ls -la /opt/ros/