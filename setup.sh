ROOTFS_MOUNT_POINT=$1

echo "Enabling serial communication"
sudo echo "enable_uart=1" >> $ROOTFS_MOUNT_POINT/config.txt

echo "Enabling ssh access"
sudo touch $ROOTFS_MOUNT_POINT/ssh

SSID=$(nmcli -t -f SSID dev wifi)
echo "Setting up wifi connection $SSID"
PSK_STR=$(sudo grep -r '^psk' /etc/NetworkManager/system-connections/$SSID)

printf "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=SE

network={
    \tssid=%s
    \t%s
    \tkey_mgmt=WPA-PSK
}" "$SSID" "PSK_STR" > wpa_supplicant.conf

#  All raspberry devices MAC addresses started with B8:27:EB.
#  
#  So, on *nix systems, this can be accomplished by executing the following command:
#  
#  sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
#  
#  where 192.168.1.* will be your local network mask. You will get an answer like:
#  
#  Nmap scan report for raspberrypi.localnetwork.lan (192.168.1.179)
#  
#  The 192.168.1.179 is the Raspberry Pi IP address on you network.
