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
