#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -eq 0 ]; then
    echo "This script should not be run as root"
    exit 1
fi

# Trigger sudo for the first time to stop asking for passwords
sudo apt-get -y update

# Add PHP PPA
sudo add-apt-repository ppa:ondrej/php

# Add Caddy repo
sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt-get update

# Install Caddy and PHP
sudo apt-get install -y caddy zip unzip curl
sudo apt-get install -y php{5.6,7.2,8.2,8.3}-{fpm,mysql,curl,zip,mbstring,xml,gd,bcmath,soap,intl,cli,dev,imagick,redis,imap,bcmath,pgsql}
sudo apt-get install -y mariadb-server

# Set up Caddy
sudo rm -f /etc/Caddyfile


# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# Done
echo "Setup done. Please restart your terminal session for the changes to take effect."
exit 0