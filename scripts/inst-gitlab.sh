#! /bin/sh
# default for gitlab: dir~>/home/git/gitlab; user~>git; port~>8080

if [[ `whoami` != "root" ]]; then
	echo "must run as root"
	exit 1
fi

#url="localhost"
url="git.yourdomain.com"
read -e -p "Enter git's password of mysql:" passwd
read -e -p "Enter your email:" email

# ------ pre-install
yum install -y sqlite-devel libyaml-devel zlib-devel openssl-devel \
	gdbm-devel readline-devel ncurses-devel libffi-devel \
	curl-devel libxml2-devel libxslt-devel libicu-devel

# postfix(recommended): Mail server to receive mail notifications
# rubygem-bundler: No need to run gem install bundler --no-ri --no-rdoc
# logrotate: Default log manager
# pygments(python gadget): Syntax highlight
yum install -y ruby-devel rubygem-bundler mysql-devel mysql-server \
	redis httpd gitolite3 logrotate postfix python-pip

# setup postfix(stmp)
rpm -qa | grep sendmail
if [[ $? == 0 ]]; then
	yum remove -y sendmail
fi
sudo alternatives --set mta /usr/sbin/sendmail.postfix

pip install pygments

systemctl restart redis.service
systemctl enable redis.service

systemctl restart mariadb.service 
systemctl enable mariadb.service

systemctl restart httpd.service
systemctl enable httpd.service
# ------------------------------------------------
# ------ setup users
adduser -r -s /bin/bash -c 'Gitlab' -m -d /home/git/ git
usermod -a -G git apache
usermod -a -G git gitolite3
passwd -d git

grep "git" /etc/sudoers | grep "ALL=(ALL)" | grep -v "#"
if [[ ! $? -eq 0 ]]; then
	echo -e "git\tALL=(ALL)\tALL" >> /etc/sudoers
fi
# ------------------------------------------------
# ------ setup mysql
mysql_secure_installation 
cmd='
CREATE USER "git"@"localhost" IDENTIFIED BY "$passwd";
SET storage_engine=INNODB;

CREATE DATABASE IF NOT EXISTS `gitlabhq_production`
	DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP,
	INDEX, ALTER ON `gitlabhq_production`.* TO "git"@"localhost";
\q
'
mysql -u root -p <<< "$cmd"
# ------------------------------------------------
# ------ setup gitolite
git_home="/home/git"

sudo -u git -H mkdir -p $git_home/.ssh
sudo -u git -H ssh-keygen -q -N '' -t rsa -f $git_home/.ssh/id_rsa
sudo -u git -H gitolite setup -pk $git_home/.ssh/id_rsa.pub

# change default permissions
sed -i "s/\(UMASK[ \t=>]\+\)[0-7]\+/\10007/" $git_home/.gitolite.rc
chmod -R ug+rwX,o-rwx $git_home/repositories/
chmod -R ug-s $git_home/repositories/
find $git_home/repositories/ -type d -print0 | xargs -0 chmod g+s
chown git:git -R $git_home/
# ------------------------------------------------
# ------ setup gitolite redis
sed -i 's/^port .*/port 0/' /etc/redis.conf

grep 'unixsocketperm 0775' /etc/redis.conf > /dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
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
	sudo -u git -H git clone git://github.com/gitlabhq/gitlabhq.git gitlab
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
sudo -u git -H bundle install --deployment --without development \
	test postgres aws

# install gitlab shell
sudo -u git -H bundle exec rake gitlab:shell:install[v2.2.0] \
	REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production

# initialize database and activate advanced features
sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production

# install init script
cp lib/support/init.d/gitlab /etc/init.d/gitlab
chkconfig --add gitlab
chkconfig gitlab on

# setup logrotate
cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

# compile assets
sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production

# start your gitlab instance
systemctl start gitlab.service

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

