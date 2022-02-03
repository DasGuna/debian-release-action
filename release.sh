#!/usr/bin/bash

echo "Running Release Pipeline..."
echo "Checking current directory path"
pwd
echo "Checking current directory content"
ls -la
echo "Current architecture check"
uname -m
# echo "Checking ROS install path"
# ls -la /opt/ros/