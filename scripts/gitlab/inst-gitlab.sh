#! /bin/sh
# default for gitlab: dir~>/home/git/gitlab; user~>git; port~>8080

if [[ `whoami` != "root" ]]; then
    echo "You should run this script as root, exit!" && exit;
fi

oldir=`pwd`
gitlab_url="repos.ci.org"
gitlab_root="/home/git/gitlab"

# ------------------------------------------------
# ------ setup env and add user git
gitlab_setup_env() {
    read -s -e -p "Password for gitlabhq_production(default):" gitlab_passwd
    echo
    if [[ -z $gitlab_passwd ]]; then
        gitlab_passwd="123login"
    fi

    read -e -p "Enter email(furious_tauren@163.com):" gitlab_email
    if [[ -z $gitlab_email ]]; then
        gitlab_email="furious_tauren@163.com"
    fi

    read -e -p "Enter redmine port(3000):" redmine_port
    if [[ -z $redmine_port ]]; then
        redmine_port="3000"
    fi

    id -g git > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        adduser -r -s /bin/bash -c 'GitLab' -g git -m -d /home/git/ git
    else
        adduser -r -s /bin/bash -c 'GitLab' -m -d /home/git/ git
    fi

    passwd -d git

    grep "git" /etc/sudoers | grep "ALL=(ALL)" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "git\tALL=(ALL)\tALL" >> /etc/sudoers
    fi

    # access gitlab from a subdir
    chmod g+rx /home/git/
}

gitlab_prepare() {

    # ----------------------------
    # ------ setup environment
    gitlab_setup_env

    # ----------------------------
    # ------ pre-install
    yum install sqlite-devel libyaml-devel zlib-devel openssl-devel \
                gdbm-devel readline-devel ncurses-devel curl-devel \
                libxml2-devel libxslt-devel libicu-devel cmake -y || exit

    # postfix(recommended): Mail server to receive mail notifications
    # logrotate: Default log manager
    # pygments(python gadget): Syntax highlight
    yum install ruby-devel mysql-devel mysql-server httpd-devel \
                redis logrotate postfix python-pip \
                apr-devel apr-util-devel libffi-devel -y || exit

    # ----------------------------
    # download gitlab
    if [[ ! -d "$gitlab_root" ]]; then
        sudo -u git -H git clone https://github.com/gitlabhq/gitlabhq.git \
		/home/git/gitlab || exit
    fi

    cd $gitlab_root
    # ----------------------------
    # rubygem-bundler: to slow, use taobao as an alternative
    gem sources -r https://rubygems.org/
    gem sources -a https://ruby.taobao.org/ || exit
    gem install bundler --no-ri --no-rdoc || exit

    find /usr -name "mod_passenger.so" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        gem install passenger || exit
        passenger-install-apache2-module
    fi

    # ----------------------------
    # setup postfix(stmp)
    rpm -qa | grep sendmail
    if [[ $? -eq 0 ]]; then
        yum remove -y sendmail
    fi
    sudo alternatives --set mta /usr/sbin/sendmail.postfix

    pip install pygments || exit

    # ----------------------------
    # setup redis
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
    # ----------------------------
    usermod -aG redis git
    usermod -a -G git apache
    usermod -a -G apache git

    systemctl enable redis.service
    systemctl enable mariadb.service
    systemctl enable httpd.service
    systemctl enable postfix.service

    systemctl restart mariadb.service
    systemctl restart postfix.service
    systemctl restart redis.service
}

# ------------------------------------------------
# ------ setup mysql
gitlab_setup_mysql() {
    gitlab_query="
    SET storage_engine=INNODB;

    CREATE DATABASE IF NOT EXISTS gitlabhq_production DEFAULT
    CHARACTER SET utf8 COLLATE utf8_unicode_ci;

    GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP,
    INDEX, ALTER ON gitlabhq_production.* TO \"git\"@\"localhost\"
    IDENTIFIED BY \"$gitlab_passwd\";

    \q
    "
    echo -n "root on 'mysql', "
    mysql -u root -p <<< "$gitlab_query"
    if [[ $? -ne 0 ]]; then
        mysql_secure_installation || exit

	# make sure it's the last cmd in this function
        gitlab_setup_mysql
    fi
}

# ------------------------------------------------
# ------ setup apache
gitlab_setup_httpd() {

    psger=`find /usr -name "mod_passenger.so"`
    psger_root=`echo $psger | sed -e "s/\(passenger-[0-9\.]\+\).*/\1/"`
    sed "s:so:$psger:;s:psgroot:$psger_root:" $oldir/passenger.conf > .conf
    sed "s:example.com:$gitlab_url:" $oldir/gitlab.conf > .gconf
    mv .conf /etc/httpd/conf.d/passenger.conf
    mv .gconf /etc/httpd/conf.d/gitlab.conf

    rm /var/www/html/gitlab -fr
    ln -s /home/git/gitlab/public /var/www/html/gitlab

    systemctl restart httpd.service
}
# ------------------------------------------------
# ------ install gitlab
gitlab_install() {

    gitlab_prepare
    gitlab_setup_mysql

    cd $gitlab_root

    # set user.name to GitLab(avoiding "configured for git user? ... no")
    sudo -u git -H git config --global user.name "GitLab"
    sudo -u git -H git config --global user.email "$gitlab_email"
    sudo -u git -H git config --global core.autocrlf input

    gitlab_clean

    # create directory for satellites
    sudo -u git -H mkdir -p /home/git/gitlab-satellites
    chmod u+rwx,g=rx,o-rwx /home/git/gitlab-satellites
    chown -R git {log,tmp}
    chmod -R u+rwX {log,tmp}
    chmod -R u+rwX tmp/{pids,sockets}
    chmod -R u+rwX public/uploads

    # copy data­base and gitlab config files from example to working copies:
    sudo -u git -H cp config/gitlab.yml.example config/gitlab.yml
    sed -i "s/\(host: \).*/\1$gitlab_url/" config/gitlab.yml
    sed -i "s/\(email_from: \).*/\1$gitlab_email/" config/gitlab.yml
    # use redmine as issue tracker
    sed -i "s/# \(.*\)redmine.sample/\1$gitlab_url:$redmine_port/" config/gitlab.yml
    sed -i "s/# \(redmine:\)/\1/" config/gitlab.yml
    sed -i "s/# \([ ]*title: \"Redmine\"\)/\1/" config/gitlab.yml
    # disable gravatar
    sed -i "/gravatar/,/true/s/true /false/" config/gitlab.yml

    #   title: "Redmine"
    # access gitlab form a subdir
    sed -i "s/# \(relative_url_root\)/\1/" config/gitlab.yml
    sed -i "s/# \(config\.relative_url_root\)/\1/" config/application.rb

    sudo -u git -H cp config/initializers/rack_attack.rb.example \
                      config/initializers/rack_attack.rb

    # configure redis connection
    sudo -u git -H cp config/resque.yml.example config/resque.yml

    # configure gitlab db
    sudo -u git -H cp config/database.yml.mysql config/database.yml
    sed -i "s/secure password/$gitlab_passwd/" config/database.yml
    chmod o-rwx config/database.yml

    # install gems
    sed -i 's/rubygems/ruby.taobao/' Gemfile
    grep "secure_path" /etc/sudoers | grep "/usr/local/bin" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        sed -i "/secure_path/{s/$/:\/usr\/local\/bin/}" /etc/sudoers
    fi
    sudo -u git -H bundle install --deployment --without development \
        test postgres aws || exit

    # install gitlab shell
    sudo -u git -H bundle exec rake gitlab:shell:install \
        REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production || exit

    # initialize database and activate advanced features
    sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production

    # install init script
    cp $oldir/gitlab /etc/init.d/gitlab
    chkconfig --add gitlab
    #chkconfig gitlab on

    # setup logrotate
    cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

    # compile assets
        sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production \
                                        RAILS_RELATIVE_URL_ROOT=/gitlab
    # start your gitlab instance
    systemctl restart gitlab.service
    gitlab_setup_httpd
}

# Check for errors
gitlab_check() {
    cd $gitlab_root

    systemctl restart gitlab.service
    systemctl restart httpd.service
    sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
    sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production
}

gitlab_clean() {
    cd $gitlab_root

    rm /etc/logrotate.d/gitlab
    rm /etc/init.d/gitlab
    rm config/database.yml
    rm config/resque.yml
    rm config/initializers/rack_attack.rb
    rm config/gitlab.yml
    sudo -u git -H git checkout .
}

case "$1" in
  prepare)
        gitlab_prepare
        ;;
  install)
        gitlab_install
        ;;
  check)
        gitlab_check
        ;;
  clean)
        gitlab_clean
        ;;
  *)
        echo "Usage: $0 {prepare|install|check}"
        exit 1
        ;;
esac

exit
