- Fix xdpr graphic issue
  https://astroisk.nl/install-and-use-xrdp-on-a-raspberry-pi-5/
  https://forums.raspberrypi.com/viewtopic.php?t=323471&start=25
  ```
  nano /etc/X11/xrdp/xorg.conf
  Find :
  Option "DRMDevice" "/dev/dri/renderD128"
  Change to:

  #Option "DRMDevice" "/dev/dri/renderD128"
  Option "DRMDevice" ""
  ```



- Fix "Authentication required to refresh system repositories" issue
  https://astroisk.nl/configuring-polkit-localauthority-to-allow-wi-fi-scans-on-a-raspberry-pi-5/
  
