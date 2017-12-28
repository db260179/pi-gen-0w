# pi-gen-0w

_Tool used to create Raspbian images customized from the standard
raspberrypi.org Raspbian Lite image._


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

Monitor nohup.out. When complete, images will be stored in the deploy/
subfolder.

### Clean-up

   $ docker rm -v pigen_work


