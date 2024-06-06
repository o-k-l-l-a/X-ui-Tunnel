#!/bin/bash

# Add PPA repository for HAProxy 2.4
sudo add-apt-repository ppa:vbernat/haproxy-2.9 -y

# Update package list and install HAProxy 2.4
sudo apt update
sudo apt install haproxy=2.9.\* -y

# Prompt user for domain name
read -p "Please enter the domain name to replace 'dowmin.ir' in haproxy.cfg: " DOMAIN_NAME

# Download and replace the haproxy.cfg file
sudo rm -f /etc/haproxy/haproxy.cfg
sudo wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/o-k-l-l-a/X-ui-Tunnel/main/haproxy.cfg

# Replace 'dowmin.ir' with the user-provided domain name in haproxy.cfg
sudo sed -i "s/dowmin.ir/$DOMAIN_NAME/g" /etc/haproxy/haproxy.cfg

# Restart HAProxy service
sudo systemctl restart haproxy

# Verify installation and restart
if systemctl is-active --quiet haproxy; then
    echo "HAProxy has been installed and restarted successfully."
else
    echo "HAProxy installation or restart failed."
fi
