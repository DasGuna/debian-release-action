#!/bin/bash

set -e

echo "Installing some dependencies..."
sudo apt install qemu-user-static

echo "Setting up and Running Container..."
echo "Make a mount point for workspace (if not available)"
if [ ! -d ws ]; then
  mkdir -p ws;
fi
mount_point_path=$(realpath ws/)

echo "Copy the action entrypoint into the mounted folder"
cp $ACTION_PATH/release.sh $mount_point_path/release.sh
echo "Copy the pre-built dependencies (i.e., cmake-3.20 version) for installation in container"
rsync -aPv $ACTION_PATH/dependencies $mount_point_path
echo "Sanity check in mount path:"
ls -la $mount_point_path
echo "Sanity check within dependencies:"
ls -la $mount_point_path/dependencies

echo "Running Docker Container for Release..."
if [[ $INPUT_ARCH == 'amd64' ]]
then
    echo "AMD 64 RELEASE Confirmed"
    # docker build -f $ACTION_PATH/amd64_Dockerfile -t amd64_ros_container:latest .
    # docker run -v $mount_point_path:/docker_ws amd64_ros_container:latest

    docker run -v $mount_point_path:/docker_ws --rm -t amd64/ros:noetic docker_ws/release.sh
elif [[ $INPUT_ARCH == 'arm64' ]]
then 
    echo "ARM 64 RELEASE Confirmed"
    # docker build -f $ACTION_PATH/arm64_Dockerfile -t arm64_ros_container:latest .
    # docker run -v $mount_point_path:/docker_ws arm64_ros_container:latest

    docker run -v $mount_point_path:/docker_ws --rm -t arm64v8/ros:noetic docker_ws/release.sh
elif [[ $INPUT_ARCH == 'arm32' ]]
then 
    echo "ARM 32 RELEASE Confirmed"
    # docker build -f $ACTION_PATH/arm32_Dockerfile -t arm32_ros_container:latest .
    # docker run -v $mount_point_path:/docker_ws arm32_ros_container:latest

    docker run -v $mount_point_path:/docker_ws --rm -t arm32v7/ros:noetic docker_ws/release.sh
else
    echo "UNKNOWN ARCH - Exiting Gracefully"
    exit -1
fi

echo "Container Completed Builds Successfully"
echo "Enter Mount Point to Get debs..."
cd $mount_point_path/release-tools-ros/target
# Check for debs
if [ -f *.deb ]; then
    # Debs found, so set to output
    file_arr=(./*.deb)
    echo "Number of debs: ${#file_arr[@]}"
    file_num=${#file_arr[@]}
    counter=1
    for f in "${file_arr[@]}"; do 
        realpath_file=$(realpath $f)
        echo "$realpath_file"
        list+=\"$realpath_file\"
        if [ $counter != $file_num ]
        then
            echo "counter is $counter and file num is $file_num"
            echo "adding comma"
            list+=','
        fi
        ((counter=counter+1))
    done
    echo "list: [$list]"
    echo "::set-output name=files::[$list]"
else
    echo "No debs found..."
fi