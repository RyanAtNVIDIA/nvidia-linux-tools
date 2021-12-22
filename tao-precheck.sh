#!/bin/bash
# file: tao-precheck.sh

# Set TAO 3.21.11 requirements
REQ_OS_VERSION="Ubuntu 18.04.6 LTS"
REQ_PYTHON_VERSION="Python 3.6.9"
REQ_DOCKER_CE_VERSION=19.03.5
REQ_DOCKER_API_VERSION=1.40
REQ_NVIDIA_CONTAINER_TOOLKIT_VERSION=1.3.0-1
REQ_NVIDIA_CONTAINER_RUNTIME_VERSION=3.4.0-1
REQ_NVIDIA_DOCKER_VERSION=2.5.0-1
REQ_NVIDIA_DRIVER_VERSION=455
REQ_PYTHON_PIP_VERSION=21.06

echo "Validating System for TAO 3.21.11 Requirements"

#Check OS
this_os=$(cat /etc/os-release | grep -o -P '(?<=PRETTY_NAME=").*(?=")')

if [[ "$REQ_OS_VERSION" == "$this_os" ]]; then
   echo "OS Version satisfied with $this_os."
else
   echo "OS Mismatch"
   echo "This system has $this_os."
   echo "TAO requires $REQ_OS_VERSION."
fi

#Check Python
this_python_version=$(python3 --version)

if [[ "$REQ_PYTHON_VERSION" == "$this_python_version" ]]; then
   echo "Python version satisfied with $this_python_version."
else
   echo "Python version mismatch"
   echo "This system has: $this_python_version."
   echo "TAO requires: $REQ_PYTHON_VERSION."
fi

#Display docker version
#this_docker_ce=$(docker version | grep -o -P '(?<=PRETTY_NAME=").*(?=")')
echo
echo "TAO Requirements:"
echo "docker-ce:   $REQ_DOCKER_CE_VERSION"
echo "docker-api:   $REQ_DOCKER_API_VERSION"
echo "nvidia-container-toolkit:   $REQ_NVIDIA_CONTAINER_TOOLKIT_VERSION"
echo "nvidia-container-runtime:   $REQ_NVIDIA_CONTAINER_RUNTIME_VERSION"
echo "nvidia-docker2:   $REQ_NVIDIA_DOCKER_VERSION"
echo "nvidia-driver:   $REQ_NVIDIA_DRIVER_VERSION"
echo "python-pip:   $REQ_PYTHON_PIP_VERSION"
echo
echo "This system's docker version info:"
docker version

echo
echo "This systems nvidia-docker2 info:"
echo $(dpkg -l | grep nvidia-docker2)
