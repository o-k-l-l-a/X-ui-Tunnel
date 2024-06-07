#!/bin/bash

# Add PPA repository for HAProxy 2.9
sudo add-apt-repository ppa:vbernat/haproxy-2.9 -y

# Update package list and install HAProxy 2.9
sudo apt update
sudo apt install haproxy=2.9.\* -y

# Prompt user for domain name
read -p "Please enter the domain name to replace 'dowmin.ir' in haproxy.cfg: " DOMAIN_NAME

# Download and replace the haproxy.cfg file
sudo rm -f /etc/haproxy/haproxy.cfg
sudo wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/o-k-l-l-a/X-ui-Tunnel/main/Tunnel/haproxy.cfg

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

# ANSI color code for orange
ORANGE='\033[38;5;214m'
NC='\033[0m' # No Color

# Create a list with the updated domain name
echo -e "${ORANGE}Here is your list with the domain name $DOMAIN_NAME:${NC}"
echo -e "${ORANGE}ss://YWVzLTI1Ni1nY206NDQz@$DOMAIN_NAME:443?type=tcp#Direct-Tunnel-443%20mci%20fast-443-443${NC}"
echo -e "${ORANGE}vless://2052@$DOMAIN_NAME:2052?type=tcp&path=%2F&headerType=http&security=none#Direct-Tunnel-2052-2052${NC}"
echo -e "${ORANGE}vless://2053@$DOMAIN_NAME:2053?type=ws&path=%2F&host=&security=none#Cloudflare-Direct-Tunnel-2053-2053${NC}"
echo -e "${ORANGE}vless://2086@$DOMAIN_NAME:2086?type=tcp&security=none#Direct-Tunnel-2086%20mci%20fast-2086${NC}"

# Decode Base64, replace domain, and re-encode for vmess link
VMESS_JSON=$(echo "ewogICJ2IjogIjIiLAogICJwcyI6ICJEaXJlY3QtVHVubmVsLTg0NDMtODQ0MyIsCiAgImFkZCI6ICIxODguMjQ1LjM1LjIwMiIsCiAgInBvcnQiOiA4NDQzLAogICJpZCI6ICI4NDQzIiwKICAibmV0IjogImdycGMiLAogICJ0eXBlIjogIm5vbmUiLAogICJ0bHMiOiAibm9uZSIsCiAgInBhdGgiOiAiIiwKICAiYXV0aG9yaXR5IjogIiIKfQ==" | base64 --decode)
VMESS_JSON_UPDATED=$(echo $VMESS_JSON | sed "s/188.245.35.202/$DOMAIN_NAME/")
VMESS_BASE64=$(echo $VMESS_JSON_UPDATED | base64)

echo -e "${ORANGE}vmess://$VMESS_BASE64${NC}"
echo -e "${ORANGE}vless://2096@$DOMAIN_NAME:2096?type=grpc&serviceName=&authority=&security=none#Direct-Tunnel-2096%20mci%20fast-2096${NC}"
echo -e "${ORANGE}ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTo4MDgw@$DOMAIN_NAME:8080?type=tcp#Direct-Tunnel-8080%20mci%20fast-8080${NC}"
echo -e "${ORANGE}vless://8880@$DOMAIN_NAME:8880?type=ws&path=%2F&host=&security=none#Direct-Tunnel-8880-mci%20fast-8880${NC}"
echo -e "${ORANGE}vless://2082@$DOMAIN_NAME:2082?type=tcp&security=none#Direct-Tunnel-2082-2082${NC}"
echo -e "${ORANGE}trojan://80@$DOMAIN_NAME:80?type=tcp&path=%2F&headerType=http&security=none#Direct-Tunnel-80%20mci%20fast-80${NC}"
