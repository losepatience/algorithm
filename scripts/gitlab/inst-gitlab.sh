#! /bin/sh
# default for gitlab: dir~>/home/git/gitlab; user~>git; port~>8080

if [[ `whoami` != "root" ]]; then
    echo "must run as root, exit!"
    exit 1
fi


url="git.yourdomain.com"
oldir=`pwd`

# use passenger to access gitlab from a subdir
env() {
    if [[ -n $email ]]; then
        return;
    fi

    read -e -p "Use Passenger(y/n):" passenger
    if [[ -z $passenger ]]; then
        passenger="y"
    fi

    read -s -e -p "Enter password:" passwd
    echo
    if [[ -z $passwd ]]; then
        passwd="123login"
    fi

    read -e -p "Enter email:" email
    if [[ -z $email ]]; then
        email="furious_tauren@163.com"
    fi
}


prep() {
    # ------ pre-install
    yum install sqlite-devel libyaml-devel zlib-devel openssl-devel \
                gdbm-devel readline-devel ncurses-devel curl-devel \
		libxml2-devel libxslt-devel libicu-devel cmake -y || exit;

    # postfix(recommended): Mail server to receive mail notifications
    # logrotate: Default log manager
    # pygments(python gadget): Syntax highlight
    yum install ruby-devel mysql-devel mysql-server httpd-devel \
                redis logrotate postfix python-pip -y || exit;

    # rubygem-bundler: to slow, use taobao as an alternative
    gem sources -r https://rubygems.org/
    gem sources -a https://ruby.taobao.org/
    which bundler || gem install bundler --no-ri --no-rdoc || exit;

    if [[ $passenger = "y" ]]; then
        find /usr -name "mod_passenger.so" > /dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		yum install apr-devel apr-util-devel libffi-devel -y || exit;
		gem install passenger || exit;
		passenger-install-apache2-module
	fi
    fi

    # setup postfix(stmp)
    rpm -qa | grep sendmail
    if [[ $? -eq 0 ]]; then
        yum remove -y sendmail
    fi
    sudo alternatives --set mta /usr/sbin/sendmail.postfix

    pip install pygments || exit;

    systemctl enable redis.service
    systemctl enable mariadb.service
    systemctl enable httpd.service

    systemctl restart mariadb.service 
}

# ------------------------------------------------
# ------ setup users
add_user_git() {
    id -g git > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        adduser -r -s /bin/bash -c 'GitLab' -g git -m -d /home/git/ git
    else
        adduser -r -s /bin/bash -c 'GitLab' -m -d /home/git/ git
    fi

    usermod -a -G git apache
    passwd -d git

    grep "git" /etc/sudoers | grep "ALL=(ALL)" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "git\tALL=(ALL)\tALL" >> /etc/sudoers
    fi
}

# ------------------------------------------------
# ------ setup mysql
setup_mysql() {
    mysql_secure_installation 
    query="
    SET storage_engine=INNODB;

    CREATE DATABASE IF NOT EXISTS \`gitlabhq_production\` DEFAULT 
    CHARACTER SET \`utf8\` COLLATE \`utf8_unicode_ci\`;

    GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP,
    INDEX, ALTER ON \`gitlabhq_production\`.* TO \"git\"@\"localhost\"
    IDENTIFIED BY \"$passwd\";

    \q
    "
    mysql -u root -p <<< "$query"
}
# ------------------------------------------------
# ------ setup redis
setup_redis() {
    sed -i 's/^port .*/port 0/' /etc/redis.conf

    grep 'unixsocketperm 0775' /etc/redis.conf > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo 'unixsocket /var/run/redis/redis.sock' | tee -a /etc/redis.conf
        echo -e 'unixsocketperm 0775' | tee -a /etc/redis.conf
    fi

    # persist the directory which contains the socket, if applicable
    if [ -d /etc/tmpfiles.d ]; then
        echo 'd  /var/run/redis  0755  redis  redis  10d  -' \
            | tee -a /etc/tmpfiles.d/redis.conf
    fi
    systemctl restart redis.service

    usermod -aG redis git
}
# ------------------------------------------------
# ------ install gitlab
install() {
    cd /home/git
    
    # set user.name to GitLab(avoiding "configured for git user? ... no")
    sudo -u git -H git config --global user.name "GitLab"
    sudo -u git -H git config --global user.email "$email"
    sudo -u git -H git config --global core.autocrlf input
    
    if [[ ! -d gitlab ]]; then
        sudo -u git -H git clone https://github.com/gitlabhq/gitlabhq.git gitlab
        if [[ $? -ne 0 ]]; then
            exit;
        fi
    fi
    
    cd gitlab/
    git checkout .
    
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
    
    if [[ $passenger = "y" ]]; then
        sed -i "s/# \(relative_url_root\)/\1/" config/gitlab.yml
        sed -i "s/# \(config\.relative_url_root\)/\1/" config/application.rb
    else
        sudo -u git -H cp config/unicorn.rb.example config/unicorn.rb
        sed -i "s/\(worker_processes[ \t]\+\)[1-9]\+/\1`nproc`/" config/unicorn.rb
    fi
    
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
    grep "secure_path" /etc/sudoers | grep "/usr/local/bin" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        sed -i "/secure_path/{s/$/:\/usr\/local\/bin/}" /etc/sudoers
    fi
    sudo -u git -H bundle install --deployment --without development \
        test postgres aws || exit;
    
    # install gitlab shell
    sudo -u git -H bundle exec rake gitlab:shell:install \
        REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production || exit;
    
    # initialize database and activate advanced features
    sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production
    
    # install init script
    if [[ $passenger = "y" ]]; then
        cp $oldir/gitlab /etc/init.d/gitlab
    else
        cp lib/support/init.d/gitlab /etc/init.d/gitlab
    fi
    chkconfig --add gitlab
    #chkconfig gitlab on
    
    # setup logrotate
    cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab
    
    # compile assets
    if [[ $passenger = "y" ]]; then
        sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production \
                                        RAILS_RELATIVE_URL_ROOT=/gitlab
    else
        sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production
    fi
    
    # start your gitlab instance
    systemctl restart gitlab.service
}

# setup apache
setup_httpd() {
    if [[ $passenger = "y" ]]; then

        passenger=`find /usr -name "mod_passenger.so"`
        psg_root=`echo $passenger | sed -e "s/\(passenger-[0-9\.]\+\).*/\1/"`
        ruby=`which ruby`

cat <<- EOF > /etc/httpd/conf.d/gitlab.conf
LoadModule passenger_module $passenger 
<IfModule mod_passenger.c>
    PassengerRoot $psg_root
    PassengerDefaultRuby $ruby
</IfModule>

<VirtualHost *:80>
    ServerName $url
    DocumentRoot /var/www/html
 
    <Directory /var/www/html>
        Options FollowSymLinks
        Order allow,deny
        Allow from all
        PassengerResolveSymlinksInDocumentRoot on
    </Directory>
 
    Alias /gitlab "/var/www/html/gitlab"
    <Directory /var/www/html/gitlab>
        Options -MultiViews
        SetEnv RAILS_RELATIVE_URL_ROOT "/gitlab"
        PassengerAppRoot "/home/git/gitlab"
    </Directory>
EOF
    else
cat <<- EOF > /etc/httpd/conf.d/gitlab.conf
<VirtualHost *:80>
    ServerName $url
    ServerSignature Off

    ProxyPreserveHost On
    AllowEncodedSlashes NoDecode

    <Location />
        Require all granted

        ProxyPassReverse http://127.0.0.1:8080
        ProxyPassReverse http://$url/
    </Location>

    RewriteEngine on
    RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
    RewriteRule .* http://127.0.0.1:8080%{REQUEST_URI} [P,QSA]

    # needed for downloading attachments
    DocumentRoot /home/git/gitlab/public
EOF
    fi

    if [[ $passenger != "y" ]]; then
cat <<- EOF >> /etc/httpd/conf.d/gitlab.conf

    ErrorDocument 404 /404.html
    ErrorDocument 422 /422.html
    ErrorDocument 500 /500.html
    ErrorDocument 503 /deploy.html

    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b" common_forwarded
    ErrorLog  /var/log/httpd/${url}_error.log
    CustomLog /var/log/httpd/${url}_forwarded.log common_forwarded
    CustomLog /var/log/httpd/${url}_access.log combined env=!dontlog
    CustomLog /var/log/httpd/${url}.log combined

</VirtualHost>
EOF
    fi

    if [[ $passenger = "y" ]]; then
        ln -s /home/git/gitlab/public /var/www/html/gitlab
    fi

    systemctl restart httpd.service
}

# Check for errors
check() {
    cd /home/git/gitlab

    sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
    sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production
}

case "$1" in
  prepare)
        env
        prep
        add_user_git
        setup_mysql
        setup_redis
        install
        setup_httpd
        ;;
  check)
        check
        ;;
  *)
        echo "Usage: $0 {prepare|install|check}"
        exit 1
        ;;
esac

exit
