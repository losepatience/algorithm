#! /bin/sh

if [[ `whoami` != "git" ]]; then
	echo "It could only be executed by git"
	exit 1
fi

sudo yum install -y ruby ruby-devel mysql-devel sqlite-devel \
	rubygem-bundler libyaml-devel zlib-devel openssl-devel \
	gdbm-devel readline-devel ncurses-devel libffi-devel \
	curl redis libxml2-devel libxslt-devel \
	libicu-devel logrotate
sudo gem install bundler --no-ri --no-rdoc

cat /etc/redis.conf > .tmp
# Disable Redis listening on TCP
sed -i 's/^port .*/port 0/' .tmp
echo 'unixsocket /var/run/redis/redis.sock' >> .tmp
echo 'unixsocketperm 770' >> .tmp
sudo mv .tmp /etc/redis.conf

# Persist the directory which contains the socket, if applicable
if [ -d /etc/tmpfiles.d ]; then
  echo 'd  /var/run/redis  0755  redis  redis  10d  -' | \
	  sudo tee -a /etc/tmpfiles.d/redis.conf
fi

sudo systemctl restart redis.service
sudo systemctl enable redis.service

sudo systemctl restart httpd.service
sudo systemctl enable httpd.service

sudo usermod -aG redis git

# Secure your installation. Set a password here.
sudo mysql_secure_installation

query='
CREATE USER "git"@"localhost" IDENTIFIED BY "123login";
SET storage_engine=INNODB;

CREATE DATABASE IF NOT EXISTS `gitlabhq_production`
	DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE,
	CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.*
	TO "git"@"localhost";
\q
'
mysql -u root -p <<< "$query"

cd /home/git
git clone http://github.com/gitlabhq/gitlabhq.git -b 7-5-stable gitlab

cd gitlab
cp config/gitlab.yml.example config/gitlab.yml
cp config/unicorn.rb.example config/unicorn.rb
sed -i "s/\(worker_processes[ \t]\+\)[1-9]\+/\1`nproc`/" config/unicorn.rb

mkdir /home/git/gitlab-satellites
chmod u+rwx,g=rx,o-rwx /home/git/gitlab-satellites

cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb

git config --global user.name "GitLab"
git config --global user.email "furious_tauren@163.com"
git config --global core.autocrlf input

cp config/resque.yml.example config/resque.yml
cp config/database.yml.mysql config/database.yml

vim config/database.yml
chmod o-rwx config/database.yml

# Or if you use MySQL (note, the option says "without ... postgres")
bundle install --deployment --without development test postgres aws

# Run the installation task for gitlab-shell (replace `REDIS_URL` if needed):
bundle exec rake gitlab:shell:install[v2.2.0] \
	REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production

# By default, the gitlab-shell config is generated from your main GitLab config.
# You can review (and modify) the gitlab-shell config as follows:
vim /home/git/gitlab-shell/config.yml
bundle exec rake gitlab:setup RAILS_ENV=production

sudo cp lib/support/init.d/gitlab /etc/init.d/gitlab
sudo cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

bundle exec rake gitlab:env:info RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
sudo service gitlab start
