set -e

echo "Setting up and Running Container..."
ls -la
docker build -f ./amd64_Dockerfile -t amd64_ros_container .
docker run -dp 3000:3000 amd64_ros_container:latest
# # docker cp test-container:/usr/src/my-workdir/my-outputs .
docker rm amd64_ros_container:latest

echo "Container Completed Functions"