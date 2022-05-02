echo "Downloading Dependencies!"
sudo apt install -y sudo software-properties-common curl apt-transport-https ca-certificates mariadb-common mariadb-server mariadb-client
echo "Done!"
echo "Updating and Upgrading!"
sudo apt update -y && sudo apt upgrade -y
echo "Done!"
echo "Starting MariaDB"
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo "Done!"
echo "Installing php packages!"
sudo curl https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg
sudo echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list
echo "Done!"
echo "Updating and Upgrading!"
sudo apt update -y && sudo apt upgrade -y
echo "Done!"
echo "Installing Php, Nginx and extensions!"
sudo apt install -y nginx php8.0 php8.0-{cli,common,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip}
echo "Done!"
echo "Installing redis server"
sudo apt install -y redis-server
echo "Done!"
echo "Starting Redis Server"
sudo systemctl start redis-server
sudo systemctl enable redis-server
echo "Done!"
echo "Installing Composer"
sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
echo "Done!"
echo "Setting up MySQL - Grab a long random password"
echo "waiting 30 seconds so you can get ready!"
wait 30
sudo mysql_secure_installation
echo "good job, now lets enable php fpm"
sudo systemctl enable php8.0-fpm
sudo systemctl start php8.0-fpm
echo "Done!"
echo "Lets make the pterodactyl directory and download web server files!"
sudo mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
sudo curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
echo "Done!"
echo "Okay, lets extract the panel files and install them!"
sudo tar -xzvf panel.tar.gz
sudo chmod -R 755 storage/* bootstrap/cache/
sudo cp .env.example .env
sudo composer install --no-dev --optimize-autoloader
echo "Done!"
sudo php artisan key:generate --force

echo "Setting Pterodactyl web server permissions!"
sudo chown -R www-data:www-data /var/www/pterodactyl/*
echo "Done!"

echo "Downloading Pteroq service from SneakyHub github"
cd /etc/systemd/system

wget -O pteroq.service https://raw.githubusercontent.com/SneakyHub/sneaky-configs/main/pteroq.service
echo "Done!"

cd /var/www/pterodactyl

echo "Enabling Systemctl Redis & Pteroq services"
sudo systemctl enable --now redis-server

sudo systemctl enable --now pteroq.service
echo "Done!"

echo ""
echo ""
echo ""

echo "you need to setup the following... "
echo "Command: php artisan p:environment:setup"
echo "Command: php artisan p:environment:database"
echo "Command: php artisan migrate --seed --force"
echo "Create a user: php artisan p:user:make"

echo "Setup a cronjob https://pterodactyl.io/panel/1.0/getting_started.html#crontab-configuration"
