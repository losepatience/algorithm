#! /bin/bash

sudo yum install httpd -y
sudo systemctl enable httpd.service
sudo systemctl start httpd.service #(systemctl reload httpd.service)
sudo firewall-cmd --permanent --add-service=http

sudo yum install mysql mysql-server -y
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service
sudo mysql_secure_installation	# set password etc.

sudo yum install php php-mysql -y

grep "<?php phpinfo();" /var/www/html/info.php
if [[ ! $? -eq 0 ]];then
	su root -c "echo \<?php phpinfo\(\)\; >> /var/www/html/info.php"
fi

sudo systemctl restart httpd.service
