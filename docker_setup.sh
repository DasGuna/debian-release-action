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

ls -la $ACTION_PATH

# Only copy dependencies for arm32/armhf
# Bug in cmake that needs cmake-3.20 and greater AND an update to the bootstrap script (missing in standard cmake-3.20)
# This is why a pre-built cmake-3.20 is included for specifically building armhf debs successfully
# Also copy across action release workflow (specific if required) to required mount point
if [[ $INPUT_ARCH == 'arm32' ]]
then
    echo "Copy the action entrypoint into the mounted folder"
    cp $ACTION_PATH/release_std.sh $mount_point_path/release_std.sh
    echo "Copy the pre-built dependencies (i.e., cmake-3.20 version) for installation in container"
    rsync -aPv $ACTION_PATH/dependencies $mount_point_path
else
    echo "Copy the action entrypoint into the mounted folder"
    cp $ACTION_PATH/release_armhf.sh $mount_point_path/release_armhf.sh
fi

echo "Running Docker Container for Release..."
if [[ $INPUT_ARCH == 'amd64' ]]
then
    echo "AMD 64 RELEASE Confirmed"
    # Run standard release workflow
    docker run -v $mount_point_path:/docker_ws --rm -t amd64/ros:noetic docker_ws/release_std.sh
elif [[ $INPUT_ARCH == 'arm64' ]]
then 
    echo "ARM 64 RELEASE Confirmed"
    # Run standard release workflow
    docker run -v $mount_point_path:/docker_ws --rm -t arm64v8/ros:noetic docker_ws/release_std.sh
elif [[ $INPUT_ARCH == 'arm32' ]]
then 
    echo "ARM 32 RELEASE Confirmed"
    # Run updated release workflow for installing pre-built cmake-3.20 in armhf images
    docker run -v $mount_point_path:/docker_ws --rm -t arm32v7/ros:noetic docker_ws/release_armhf.sh
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