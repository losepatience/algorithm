#! /bin/sh
# default for gitlab: dir~>/home/git/gitlab; user~>git; port~>8080

if [[ `whoami` != "root" ]]; then
	echo "must run as root, exit!"
	exit 1
fi

#url="localhost"
url="git.yourdomain.com"
read -s -e -p "Enter password:" passwd
echo
read -e -p "Enter email:" email

# ------ pre-install
yum install -y sqlite-devel libyaml-devel zlib-devel openssl-devel \
	gdbm-devel readline-devel ncurses-devel libffi-devel \
	curl-devel libxml2-devel libxslt-devel libicu-devel cmake

# postfix(recommended): Mail server to receive mail notifications
# logrotate: Default log manager
# pygments(python gadget): Syntax highlight
yum install -y ruby-devel mysql-devel mysql-server \
	redis httpd logrotate postfix python-pip

# rubygem-bundler: to slow, use taobao as an alternative
gem sources -r https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem install bundler --no-ri --no-rdoc

# setup postfix(stmp)
rpm -qa | grep sendmail
if [[ $? -eq 0 ]]; then
	yum remove -y sendmail
fi
sudo alternatives --set mta /usr/sbin/sendmail.postfix

pip install pygments

systemctl enable redis.service
systemctl enable mariadb.service
systemctl enable httpd.service

systemctl restart mariadb.service 
# ------------------------------------------------
# ------ setup users
id -g git > /dev/null
if [[ $? -eq 0 ]]; then
	adduser -r -s /bin/bash -c 'GitLab' -g git -m -d /home/git/ git
else
	adduser -r -s /bin/bash -c 'GitLab' -m -d /home/git/ git
fi

usermod -a -G git apache
passwd -d git

grep "git" /etc/sudoers | grep "ALL=(ALL)" | grep -v "^#"
if [[ ! $? -eq 0 ]]; then
	echo -e "git\tALL=(ALL)\tALL" >> /etc/sudoers
fi
# ------------------------------------------------
# ------ setup mysql
mysql_secure_installation 
query="
SET storage_engine=INNODB;

CREATE DATABASE IF NOT EXISTS \`gitlabhq_production\` DEFAULT CHARACTER
SET \`utf8\` COLLATE \`utf8_unicode_ci\`;

GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX,
ALTER ON \`gitlabhq_production\`.* TO \"git\"@\"localhost\"
IDENTIFIED BY \"$passwd\";

\q
"
mysql -u root -p <<< "$query"
# ------------------------------------------------
# ------ setup gitolite redis
sed -i 's/^port .*/port 0/' /etc/redis.conf

grep 'unixsocketperm 0775' /etc/redis.conf > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo 'unixsocket /var/run/redis/redis.sock' | tee -a /etc/redis.conf
	echo -e 'unixsocketperm 0775' | tee -a /etc/redis.conf
fi

# persist the directory which contains the socket, if applicable
if [ -d /etc/tmpfiles.d ]; then
	echo 'd  /var/run/redis  0755  redis  redis  10d  -' | \
		tee -a /etc/tmpfiles.d/redis.conf
fi
systemctl restart redis.service

usermod -aG redis git


# ------------------------------------------------
# ------ install gitlab

cd /home/git
if [[ ! -d gitlab ]]; then
	sudo -u git -H git clone https://github.com/gitlabhq/gitlabhq.git gitlab
fi

# set user.name to GitLab(avoiding "configured for git user? ... no")
sudo -u git -H git config --global user.name "GitLab"
sudo -u git -H git config --global user.email "$email"
sudo -u git -H git config --global core.autocrlf input

cd gitlab/

# create directory for satellites
sudo -u git -H mkdir -p /home/git/gitlab-satellites
chmod u+rwx,g=rx,o-rwx /home/git/gitlab-satellites
chown -R git {log,tmp}
chmod -R u+rwX {log,tmp}
chmod -R u+rwX tmp/{pids,sockets}
chmod -R u+rwX public/uploads

# copy data­base and gitlab config files from example to working copies:
sudo -u git -H cp config/gitlab.yml.example config/gitlab.yml
sed -i "s/\(host: \).*/\1$url/" config/gitlab.yml
sed -i "s/\(email_from: \).*/\1$email/" config/gitlab.yml

sudo -u git -H cp config/unicorn.rb.example config/unicorn.rb
sed -i "s/\(worker_processes[ \t]\+\)[1-9]\+/\1`nproc`/" config/unicorn.rb

sudo -u git -H cp config/initializers/rack_attack.rb.example \
	config/initializers/rack_attack.rb

# configure redis connection
sudo -u git -H cp config/resque.yml.example config/resque.yml

# configure gitlab db
sudo -u git -H cp config/database.yml.mysql config/database.yml
sed -i "s/secure password/$passwd/" config/database.yml
chmod o-rwx config/database.yml

# install gems
sed -i 's/rubygems/ruby.taobao/' Gemfile
grep "secure_path" /etc/sudoers | grep "/usr/local/bin"
if [[ $? -ne 0 ]]; then
	sed -i "/secure_path/{s/$/:\/usr\/local\/bin/}" /etc/sudoers
fi
sudo -u git -H bundle install --deployment --without development \
	test postgres aws

# install gitlab shell
sudo -u git -H bundle exec rake gitlab:shell:install \
	REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production

# initialize database and activate advanced features
sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production

# install init script
cp lib/support/init.d/gitlab /etc/init.d/gitlab
chkconfig --add gitlab
#chkconfig gitlab on

# setup logrotate
cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

# compile assets
sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production

# start your gitlab instance
systemctl restart gitlab.service

# setup apache
cat <<- EOF > /etc/httpd/conf.d/gitlab.conf
<VirtualHost *:80>
    ServerName $url
    DocumentRoot /home/git/gitlab/public
    CustomLog logs/$url combined
    ErrorLog logs/$url-error.log
    
    ProxyPass /  http://127.0.0.1:8080/
    ProxyPassReverse /  http://127.0.0.1:8080/
    ProxyPreserveHost On
</VirtualHost>
EOF
systemctl restart httpd.service

# Check for errors
sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production

