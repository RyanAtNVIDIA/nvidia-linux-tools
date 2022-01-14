# Building a system with Ubuntu 18.04 LTS
The steps listed in this document are intended to be completed after a fresh install of Ubuntu 18.04 LTS.

## Step 1 - Setting up basic tools
### Setup SSH
```
sudo apt install ssh
sudo ufw allow ssh
```
or if specifying a different port than 22. Change to required port.
```
sudo ufw allow 22/tcp
```
### Setup curl
```
sudo apt install curl
```

## Step 2 - Setting up drivers
After installing the standard version of Ubuntu the OS defaults to using nouveau drivers for the GPU(s). We need to configure the system to use NVIDIA's drivers but first we will blacklist the nouveau drivers to prevent conflicts.

### NVIDIA driver installation
More information can be found in NVIDA documentation: https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html

Verify your system has NVIDIA CUDA-Capable GPU(s)
```
lspci | grep -i nvidia
```

### Check if nouveau is blacklisted
```
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
```

If nouveau is properly blacklisted the output should appear as follows:
```
blacklist nouveau
options nouveau modeset=0
```

### Check if nouveau drivers are loaded
```
lsmod | grep nouveau
```

### Check if NVIDIA drivers are loaded
```
lsmod | grep -i nvidia
```

### Blacklisting Nouveau
Blacklist the nouveau drivers to prevent issues with cuda and other NVIDIA tools.
```
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
```
Regenerate initramfs
```
sudo update-initramfs -u
```
The system should be rebooted for updates to take effect.

### NVIDIA driver installation
More information can be found in NVIDA documentation: https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html

Verify your system has NVIDIA CUDA-Capable GPU(s)
```
lspci | grep -i nvidia
```
If the output does not show the model of the gpu but rather "Device" followed by hex chars your can update the PCI ids with the following:
```
sudo update-pciids
```



It is highly likely the system does not have gcc and other build tools installed. Install the build-essential package which includes gcc, g++, make, and the manual pages.

```
sudo apt install build-essential
sudo apt-get install manpages-dev
```

Verify the version of gcc
```
gcc --version
```

Verify the syste has the correct Kernel Headers and Development packages installed.
```
uname -r
```
The kernel headers and development packages for the currently running kernel can be installed with: 
```
sudo apt-get install linux-headers-$(uname -r)
```

Clean up
```
sudo apt autoremove
```

Install the cuda toolkit
https://developer.nvidia.com/cuda-downloads
https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=18.04&target_type=deb_network
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
```
Post install
```
export PATH=/usr/local/cuda-11.5/bin${PATH:+:${PATH}}
```

``` 
cat /proc/driver/nvidia/version
```
## Step 3 Configure for Containers
Setup Docker
```
curl https://get.docker.com | sh \
  && sudo systemctl start docker \
  && sudo systemctl enable docker
```

Install NVIDIA's container toolkit
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update

sudo apt-get install -y nvidia-docker2

sudo systemctl restart docker
```

Validate that you can run an NVIDIA docker container
```
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

Add user to docker group
```
sudo usermod -a -G docker $USER
```

Setup NGC key
```
docker login nvcr.io
```
