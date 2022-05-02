sudo apt install -y sudo software-properties-common curl apt-transport-https ca-certificates

sudo apt update -y && sudo apt upgrade -y

sudo apt install -y mariadb-common mariadb-server mariadb-client

sudo systemctl start mariadb

sudo systemctl enable mariadb

sudo curl https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg

sudo echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list

sudo apt update -y && sudo apt upgrade -y

sudo apt install -y php8.0 php8.0-{cli,common,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip}

sudo apt install -y nginx

sudo apt install -y redis-server

sudo systemctl start redis-server

sudo systemctl enable redis-server

sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

sudo mysql_secure_installation

sudo systemctl enable php8.0-fpm

sudo systemctl start php8.0-fpm

sudo mkdir -p /var/www/pterodactyl

cd /var/www/pterodactyl

sudo curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz

sudo tar -xzvf panel.tar.gz

sudo chmod -R 755 storage/* bootstrap/cache/

sudo cp .env.example .env

sudo composer install --no-dev --optimize-autoloader

sudo php artisan key:generate --force

sudo chown -R www-data:www-data /var/www/pterodactyl/*

echo "you need to setup the following... "
echo "Command: php artisan p:environment:setup"
echo "Command: php artisan p:environment:database"
echo "Command: php artisan migrate --seed --force"
echo "Create a user: php artisan p:user:make"

echo "Setup a cronjob https://pterodactyl.io/panel/1.0/getting_started.html#crontab-configuration"
