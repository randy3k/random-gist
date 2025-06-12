## nmcli

```
# device status
sudo nmcli device status
# scan wifi
sudo nmcli device wifi
```

```
WIFIAPSSID=mywifiap
read -s WIFIAPPASSWORD
sudo nmcli device wifi hotspot ifname wlan0 ssid $WIFIAPSSID password $WIFIAPPASSWORD
sudo nmcli connection modify Hotspot connection.autoconnect true
sudo nmcli connection modify Hotspot ipv4.addresses 10.10.0.1/24
sudo nmcli connection modify Hotspot ipv4.gateway 10.10.0.1
sudo nmcli connection modify Hotspot ipv4.never-default yes
```

Restart NetworkManager - `sudo systemctl restart NetworkManager`.




## Hostapd

# /etc/hostapd/hostapd.conf
```
interface=wlan0
ssid=wifiname
hw_mode=g
channel=6
ieee80211n=1
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wmm_enabled=1
```

# /etc/dnsmasq.conf
```
interface=wlan0
bind-dynamic
domain-needed
bogus-priv

dhcp-option=option:router,10.0.1.1
dhcp-option=option:dns-server,8.8.8.8
dhcp-option=option:netmask,255.255.255.0
dhcp-range=10.0.1.10,10.0.1.240,255.255.255.0,1h
```

# /etc/network/interfaces.d/wlan0.conf
```
auto wlan0
iface wlan0 inet static
address 10.0.1.1
netmask 255.255.255.0
dns-nameservers 8.8.8.8
```

# Enable IP forward
```
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
```

# use iptables-persistent to save
```
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -j MASQUERADE
```

