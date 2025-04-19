#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -eq 0 ]; then
    echo "This script should not be run as root"
    exit 1
fi

# Trigger sudo for the first time to stop asking for passwords
sudo apt-get -y update
sudo apt-get -y upgrade

# Install Docker
curl -s https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
sudo systemctl enable docker

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
sudo wget https://raw.githubusercontent.com/liamdemafelix/sandbox/refs/heads/master/caddy/Caddyfile -O /etc/caddy/Caddyfile
sudo mkdir -p /etc/caddy/snippets
sudo wget https://raw.githubusercontent.com/liamdemafelix/sandbox/refs/heads/master/caddy/snippets/php -O /etc/caddy/snippets/php

# Adjust PHP settings
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 100M/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/php.ini
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/php.ini
sudo sed -i 's/^user = www-data/user = liam/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/^group = www-data/group = liam/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/listen\.owner = www-data/listen\.owner = caddy/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/listen\.group = www-data/listen\.group = caddy/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/\;env\[HOSTNAME\]/env\[HOSTNAME\]/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/\;env\[PATH\]/env\[PATH\]/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/\;env\[TMP\]/env\[TMP\]/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/\;env\[TMPDIR\]/env\[TMPDIR\]/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf
sudo sed -i 's/\;env\[TEMP\]/env\[TEMP\]/g' /etc/php/{5.6,7.2,8.2,8.3}/fpm/pool.d/www.conf

# Configure and restart services
sudo systemctl enable caddy
sudo systemctl enable php{5.6,7.2,8.2,8.3}-fpm
sudo systemctl enable mariadb
sudo systemctl restart caddy
sudo systemctl restart php{5.6,7.2,8.2,8.3}-fpm
sudo systemctl restart mariadb

# Set up composer
wget https://getcomposer.org/download/latest-2.2.x/composer.phar -O /usr/local/bin/composer-legacy
wget https://getcomposer.org/download/latest-2.x/composer.phar -O /usr/local/bin/composer.phar
# Add PHP composer aliases
sudo tee -a /etc/bash.bashrc > /dev/null << 'EOT'

# PHP Composer version aliases
alias php5.6-composer='/usr/bin/php5.6 /usr/local/bin/composer-legacy'
alias php7.2-composer='/usr/bin/php7.2 /usr/local/bin/composer.phar'
alias php8.2-composer='/usr/bin/php8.2 /usr/local/bin/composer.phar'
alias php8.3-composer='/usr/bin/php8.3 /usr/local/bin/composer.phar'
EOT

# Set up PHP switcher
sudo wget https://raw.githubusercontent.com/liamdemafelix/sandbox/refs/heads/master/php-switcher -O /usr/local/bin/php-switcher
sudo chmod +x /usr/local/bin/php-switcher

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

# Done
echo "Setup done. Restarting system..."
sudo reboot