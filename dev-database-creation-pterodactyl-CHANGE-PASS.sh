
echo "Login as root for MariaDB!"
read -p "Please make sure you have changed the password within the file before continuing since the default is public on the github!"
mysql -u root -p
CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY 'X4JqBcxfo544Yhy47SE3QkxH4xp3kfRQ6iDtrPc';
CREATE DATABASE pterodactyl;
GRANT ALL PRIVILEGES ON pterodactyl.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION;
exit
echo "Database and user should have been created!"