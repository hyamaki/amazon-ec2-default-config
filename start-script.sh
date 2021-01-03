#!/bin/bash

# Starting amazon ec2 server deploy

# update system
sudo yum update -y

# install packages
sudo amazon-linux-extras install -y git php7.4 httpd php7.4-mysqlnd
# install php packages
sudo yum install php-mbstring php-xml

# starting apache
sudo service httpd start
sudo chkconfig httpd on

# configure permissions
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

# install composer
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# configure apache virtual host files
cd /etc/httpd/
sudo mkdir sites-available sites-enable
cd /etc/httpd/conf

# add at the last line
echo $'\r'"IncludeOptional sites-enable/*.conf" >> httpd.conf
