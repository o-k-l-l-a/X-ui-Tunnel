#!/bin/bash

apt update -y
# Prompt user for location choice
read -p "Please choose your location (iran/uk): " location

# Define the URL of the setup script based on user's choice
case "$location" in
    iran)
        url="https://raw.githubusercontent.com/o-k-l-l-a/X-ui-Tunnel/main/src/iran.sh"
        ;;
    uk)
        url="https://raw.githubusercontent.com/o-k-l-l-a/X-ui-Tunnel/main/src/uk.sh"
        ;;
    *)
        echo "Invalid choice. Please enter 'iran' or 'uk'."
        exit 1
        ;;
esac

# Download and execute the setup script
curl -o setup.sh "$url" && bash setup.sh

# Clean up by removing the downloaded script
rm setup.sh
