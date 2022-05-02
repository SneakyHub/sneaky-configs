echo ""
echo "Downloading Dependencies!"
echo ""
sudo apt install -y sudo software-properties-common curl apt-transport-https ca-certificates mariadb-common mariadb-server mariadb-client
echo ""
echo "Done!"
echo ""
echo ""
echo "Updating and Upgrading!"
echo ""
sudo apt update -y && sudo apt upgrade -y
echo ""
echo "Done!"
echo ""
echo ""
echo "Starting MariaDB"
echo ""
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo ""
echo "Done!"
echo ""
echo ""
echo "Installing php packages!"
echo ""
curl https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg
echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list
echo ""
echo ""
echo "Done!"
echo ""
echo ""
echo "Updating and Upgrading!"
echo ""
sudo apt update -y && sudo apt upgrade -y
echo ""
echo "Done!"
echo ""
echo ""
echo "Installing Php, Nginx and extensions!"
echo ""
sudo apt install -y nginx php8.0 php8.0-{cli,common,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip}
echo ""
echo "Done!"
echo ""
echo ""
echo "Installing redis server"
echo ""
sudo apt install -y redis-server
echo ""
echo "Done!"
echo ""
echo "Starting Redis Server"
echo ""
sudo systemctl start redis-server
sudo systemctl enable redis-server
echo ""
echo "Done!"
echo ""
echo ""
echo "Installing Composer"
echo ""
sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
echo ""
echo "Done!"
echo ""
echo ""
echo "Setting up MySQL - Grab a long random password"
echo ""
echo ""
echo ""
echo ""
echo ""
read -p "Press enter to continue with MariaDB installation - Make sure you have the password!"
sudo mysql_secure_installation
echo ""
echo "good job, now lets enable php fpm"
echo ""
sudo systemctl enable php8.0-fpm
sudo systemctl start php8.0-fpm
echo ""
echo "Done!"
echo ""
echo ""
echo "Lets make the pterodactyl directory and download web server files!"
echo ""
sudo mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
sudo curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
echo ""
echo "Done!"
echo ""
echo "Okay, lets extract the panel files and install them!"
echo ""
sudo tar -xzvf panel.tar.gz
sudo chmod -R 755 storage/* bootstrap/cache/
sudo cp .env.example .env
sudo composer install --no-dev --optimize-autoloader
echo ""
echo "Done!"
echo ""
sudo php artisan key:generate --force
echo ""
echo "Setting Pterodactyl web server permissions!"
echo ""
sudo chown -R www-data:www-data /var/www/pterodactyl/*
echo ""
echo "Done!"
echo ""
echo ""
echo "Downloading Pteroq service from SneakyHub github"
echo ""
cd /etc/systemd/system

wget -O pteroq.service https://raw.githubusercontent.com/SneakyHub/sneaky-configs/main/pteroq.service
echo ""
echo "Done!"
echo ""

cd /var/www/pterodactyl
echo ""
echo "Enabling Systemctl Redis & Pteroq services"
echo ""
sudo systemctl enable --now redis-server
sudo systemctl enable --now pteroq.service
echo ""
echo "Done!"
echo ""


echo "Downloading Custom Web Server .conf for SneakyHub & Removing default"
cd /etc/nginx/sites-enabled
rm default
wget -O panel.sneakydev.xyz.conf https://raw.githubusercontent.com/SneakyHub/sneaky-configs/main/panel.sneakydev.xyz.conf
echo ""
echo "Done!"
echo ""

echo "Creating SSL for panel.sneakydev.xyz!"
cd /root/.acme.sh/
./acme.sh --issue --dns dns_cf -d "panel.sneakydev.xyz" \
--key-file /etc/letsencrypt/live/panel.sneakydev.xyz/privkey.pem \
--fullchain-file /etc/letsencrypt/live/panel.sneakydev.xyz/fullchain.pem 
echo ""
echo "Done!"
echo ""
echo "Restarting Nginx (may throw an error)"
sudo systemctl restart nginx
echo ""
echo "Done!"
echo ""
echo ""
echo ""
echo "Changing back to main pterodactyl directory!"
echo ""
cd /var/www/pterodactyl
echo ""
echo "Done!"
echo ""
echo ""
echo "Please complete the following tasks to complete the rest of the panel!"
echo ""
echo ""
echo "you need to setup the following... "
echo "Command: php artisan p:environment:setup"
echo "Command: php artisan p:environment:database"
echo "Command: php artisan migrate --seed --force"
echo "Create a user: php artisan p:user:make"

echo "Setup a cronjob https://pterodactyl.io/panel/1.0/getting_started.html#crontab-configuration"
