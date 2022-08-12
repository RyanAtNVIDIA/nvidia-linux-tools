# Setting the Graphical Configurations in Ubuntu
In some cases xorg can cause issues when attempting to configure some of NVIDIA GPU's functionality, such as MIG. Below are the commands to modify the display configurations to disable / enable the GUI interface.

## Disabling the GUI
To prevent the GUI from launching on boot:
```
sudo systemctl set-default multi-user.target
```

## Enabling the GUI
To enable the GUI at next boot:
```
sudo systemctl set-default graphical.target
```

To launch the GUI after boot:
```
sudo systemctl start gdm3.service
```
## Using nvidia-xconfig
nvidia-xconfig can be used to provide better control xorg. One common issue is that xorg can launch multiple processes on multiple GPU's The results would look like the output below.
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 515.43.04    Driver Version: 515.43.04    CUDA Version: 11.7     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA RTX A6000    On   | 00000000:21:00.0  On |                  Off |
| 30%   49C    P8    35W / 300W |   1661MiB / 49140MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA RTX A6000    On   | 00000000:4B:00.0 Off |                  Off |
| 30%   48C    P8    23W / 300W |     13MiB / 49140MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1683      G   /usr/lib/xorg/Xorg                 57MiB |
|    0   N/A  N/A      5330      G   /usr/lib/xorg/Xorg                220MiB |
|    0   N/A  N/A      5461      G   /usr/bin/gnome-shell               65MiB |
|    0   N/A  N/A      6648      G   ...486537972522382246,131072       82MiB |
|    0   N/A  N/A      7678      G   gnome-control-center                4MiB |
|    0   N/A  N/A      7958      G   ...veSuggestionsOnlyOnDemand       93MiB |
|    0   N/A  N/A     89213      C   ...da/envs/rapids/bin/python     1085MiB |
|    0   N/A  N/A    119435      G   ...2gtk-4.0/WebKitWebProcess       32MiB |
|    1   N/A  N/A      1683      G   /usr/lib/xorg/Xorg                  4MiB |
|    1   N/A  N/A      5330      G   /usr/lib/xorg/Xorg                  4MiB |
+-----------------------------------------------------------------------------+
```

We can use nvidia-xconfig tool to create and/or modifiy the xorg.conf file by running ```sudo nvidia-xconfig -a```

The first modification that can help is to set the AutoAddGPU flag to "false" as shown below:
```
Section "ServerLayout"
  (...)
  Option "AutoAddGPU" "false"
EndSection
```

Next we can create/modify an entry for each GPU as follows:
```
Section "Device"
   Identifier     "Device0"
   Driver         "nvidia"
   VendorName     "NVIDIA Corporation"
   BoardName      "RTX A6000"
   BusID          "PCI:21:00.0 "
   Option         "Accel" "false"
   Option "ProbeAllGpus" "false"
   Option "NoLogo" "true"
   Option "UseEDID" "false"
   Option "UseDisplayDevice" "none"
   Option "MultiGPU" "false"
EndSection
```
and for the second card:
```
Section "Device"
  Identifier     "Device1"
  Driver         "nvidia"
  VendorName     "NVIDIA Corporation"
  BoardName      "RTX A6000"
  BusID          "PCI:4B:00.0"
EndSection
```
next we can configure the screen section:
```
Section "Screen"
    Identifier     "Screen0"
    Device         "Device1"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection
```
If using additional cards such as an A100 be sure to set the screen to display on a different device as the A100 does not have display capabilities.
