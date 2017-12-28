# pi-gen-0w

_Tool used to create Raspbian images customized from the standard
raspberrypi.org Raspbian Lite image._


## Objective

To build a custom Raspbian Lite image that can be burned onto a minimal microSD
card to allow a potentially headless Raspberry Pi Zero W to immediately come
up, connect to a known WPA2 AES wireless network, and provide an SSH server
for remote access on the LAN.


## Differences

This section outlines the high-level differences from the parent repository
at the time this repo was forked.

 * Stage 1:
    * `ssh` file placed in boot partition to enable ssh by default
 * Stage 2:
    * Modified `wpa_supplicant.conf` to capture the configuration for a WPA2
      AES network, using variables `WIFI_SSID` and `WIFI_PSK` that can be
      provided in the config.
 * Stages 3, 4, and 5 disabled.
 * Created new Stage 3 installing the following packages:
    * git
    * openssh-server
 * `export-image`:
    * Added a second `8.8.4.4` name server to `resolv.conf`.
    * Added a file to `/etc/network/interfaces.d` for configuring `wlan0`.
       * The file contains the stanza to set up wlan0 as a DHCP client.
       * The file contains commented-out stanza for convenience in case I want
         to set up wlan0 with a static IP address if desired.
    * Modified `prerun.sh` to reduce the amount of space allocated to the root
      partition from 800 MB extra down to 100 MB extra.


## Config

The modified wpa_supplicant.conf takes advantage of the following additional
environment variables:

 * `WIFI_SSID` (Default: unset)

   The SSID of the WPA2 network to which the Raspberry Pi Zero W will connect.

 * `WIFI_PSK` (Default: unset)

   The WPA2 pre-shared key to be used when connecting to the `WIFI_SSID`.


## Output

I'm only interested in running the Docker build. Running the build produces
the usual Stage 2 "lite" build, and now also produces a new Stage 3 "0w"
build that I can use as an SD card image on a headless Raspberry Pi Zero W
once the image is tweaked to include the actual wi-fi SSID and password.


## Build Procedure

To build the image, I run the following:

   $ echo "IMG_NAME=Raspbian_0w" > config
   $ echo "WIFI_SSID=MySsid" >> config
   $ echo "WIFI_PSK=MyPsk" >> config
   $ docker rm -v pigen_work
   $ nohup time ./build-docker.sh

Monitor nohup.out. When complete, images will be stored in the `deploy`
subfolder.


### Clean-up

   $ docker rm -v pigen_work


## Deploy Procedure

On success, the `deploy` subfolder contains the zip files of the images. The
desired zip file can be unzipped and written on my SD card.

**Warning:** Proceeding will overwrite all data on the SD card.

**Warning:** Ensure the desired device name is used. Specifying an incorrect
device name will cause data on an unintended device to be overwritten, such
as your computer's hard drive.

To minimize data loss due to accidental copy/paste, the device used below is
a fake `/dev/sdX`. Substitute as necessary for your own SD card's device.

Run the following:

   $ cd deploy
   $ unzip image_2018-xx-xx-Raspbian_0w-0w.zip

Insert SD card, ensure it is available, and get its device name. (Run in a
separate window to monitor.)

   $ sudo tail -F /var/log/syslog

Write the image to the SD card:

   $ sudo dd if=2018-xx-xx-Raspbian_0w-0w.img of=/dev/sdX bs=4M conv=fsync; sync

Eject the SD card and place in Raspberry Pi Zero W device.

Apply power to the device.

### First Boot

If an HDMI monitor is connected to the device, then boot-up will indicate that
the device is booting successfully. It should eventually display a log-in
prompt, and it should also display its IP address on the wlan0 interface just a
few lines above the log-in prompt if it connected to the target wireless
network successfully.

Without an HDMI monitor, tools such as `nmap` from another computer should be
able to find the new device, or examine the list of connected devices from your
router's web interface.

For example:

   $ sudo nmap -sP 192.168.1.0/24

It might help to run this command once before applying power, and then again a
few minutes after applying power after giving time for the device to boot up
and connect to the network, and finally, comparing the output of the two runs.

With the SSH server running and the IP address known, we should be able to
log-into the device from another computer on the network. The following example
assumes IP address 192.168.1.99 for the device:

   $ ssh pi@192.168.1.99

Once logged-in, we might want to get some information about the device.

   $ cat /proc/cpuinfo
   $ cat /sys/class/net/wlan0/address

The serial number would be good to note down, but the MAC address would be
useful if configuring static DHCP settings on the wireless router.

Before anything else, we likely want to change the default password:

   pi$ passwd

We might also want to update packages:

   pi$ sudo apt-get -y update
   pi$ sudo apt-get -y upgrade

We might want to run raspi-config to change other common settings:

   pi$ sudo raspi-config

Finally, we might want to clean up apt:

   pi$ sudo apt-get clean

