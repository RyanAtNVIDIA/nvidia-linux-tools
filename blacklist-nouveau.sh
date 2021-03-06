#!/bin/bash
# file: blacklist-nouveau.sh

FILE=/etc/modprobe.d/blacklist-nvidia-nouveau.conf

echo "Checking for blacklist file."

if test -f "$FILE"; then
   echo "$FILE exists."
   echo "Nothing to do."
else
   echo "$FILE does not exist."
   echo "Creating blacklist file"

   # blacklist the nouveau drivers to prevent issues with cuda and other NVIDIA tools.
   sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
   sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"

   # regenerate initramfs
   sudo update-initramfs -u

   echo "The system should be rebooted for updates to take effect."
fi
