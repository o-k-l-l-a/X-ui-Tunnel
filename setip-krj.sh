#!/bin/bash

# Detect Ubuntu version
. /etc/os-release

# Check if the script is being run on Ubuntu
if [[ "$ID" != "ubuntu" ]]; then
    echo "This script is only for Ubuntu systems."
    exit 1
fi

# Install packages based on Ubuntu version
case "$VERSION_ID" in
    "24.04")
        apt update
        apt install --install-recommends linux-generic-hwe-24.04 -y
        ;;
    "23.10")
        apt update
        apt install --install-recommends linux-generic-hwe-23.10 -y
        ;;
    "22.04")
        apt update
        apt install --install-recommends linux-generic-hwe-22.04 -y
        ;;
    "20.04")
        apt update
        apt install --install-recommends linux-generic-hwe-20.04 -y
        ;;
    "18.04")
        apt update
        apt install --install-recommends linux-generic-hwe-18.04 -y
        ;;
    "16.04")
        apt update
        apt install --install-recommends linux-generic-hwe-16.04 -y
        ;;
    "14.04")
        apt update
        apt install --install-recommends linux-generic-hwe-14.04 -y
        ;;
    *)
        echo "Unsupported Ubuntu version: $VERSION_ID"
        exit 1
        ;;
esac

# Apply BBR settings
modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
lsmod | grep bbr

echo "BBR has been configured successfully."

# Detect system architecture
ARCH=$(uname -m)
case "${ARCH}" in
  x86_64 | x64 | amd64) XUI_ARCH="amd64" ;;
  i*86 | x86) XUI_ARCH="386" ;;
  armv8* | armv8 | arm64 | aarch64) XUI_ARCH="arm64" ;;
  armv7* | armv7) XUI_ARCH="armv7" ;;
  armv6* | armv6) XUI_ARCH="armv6" ;;
  armv5* | armv5) XUI_ARCH="armv5" ;;
  s390x) echo 's390x' ;;
  *) XUI_ARCH="amd64" ;;
esac

# Download and install x-ui
cd /root/
wget https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-${XUI_ARCH}.tar.gz
rm -rf x-ui/ /usr/local/x-ui/ /usr/bin/x-ui
tar zxvf x-ui-linux-${XUI_ARCH}.tar.gz
chmod +x x-ui/x-ui x-ui/bin/xray-linux-* x-ui/x-ui.sh
cp x-ui/x-ui.sh /usr/bin/x-ui
cp -f x-ui/x-ui.service /etc/systemd/system/
mv x-ui/ /usr/local/
systemctl daemon-reload
systemctl enable x-ui

# Download and replace the x-ui database
rm -f /etc/x-ui/x-ui.db
wget -O /etc/x-ui/x-ui.db https://raw.githubusercontent.com/o-k-l-l-a/X-ui-Tunnel/main/x-ui.db

# Restart x-ui service
systemctl restart x-ui

echo "x-ui has been installed, configured, and started successfully."
