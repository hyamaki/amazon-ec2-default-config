#!/bin/bash

# Configuring a virtual host

site_url=$1
github_url=$2

# create virtual host file
cd /etc/httpd/sites-available
sudo touch $1.conf

# editing file content
echo $'\r'"
# add the content to the config file
<VirtualHost *:80>
DocumentRoot /var/www/html/$1/public_html/public
ServerName $1
ServerAlias $1
<Directory />
    Options FollowSymLinks
    AllowOverride All
</Directory>
<Directory /var/www/html/$1/public_html/public>
    Options FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    Allow from All
</Directory>

ErrorLog /var/www/html/$1/logs/error.log
CustomLog /var/www/html/$1/logs/access.log combined
</VirtualHost>" >> $1.conf

# create a link to sites-enable path
cd /etc/httpd/sites-enable/
sudo ln -s ../sites-available/$1.conf $1.conf

# create virtual host site path
cd /var/www/html
mkdir $1
cd $1/
mkdir public_html logs

cd public_html/
git clone $2 .

cd /var/www/html/$1/public_html/
composer install

cp .env.example .env
