#!/bin/bash

set -e

echo "Setting up and Running Container..."
ls -la
# docker build -f ./amd64_Dockerfile -t amd64_ros_container:latest .
# docker run amd64_ros_container:latest
# # # docker cp test-container:/usr/src/my-workdir/my-outputs .

docker build -f ./arm64_Dockerfile -t arm64_ros_container:latest .
docker run arm64_ros_container:latest
docker cp arm64_ros_container:test.txt .

echo "Container Completed Functions"