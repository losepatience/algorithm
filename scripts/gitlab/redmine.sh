#! /bin/sh

user=`whoami`
instdir="$HOME/bin"
redminedir="$instdir/redmine"

redmine_prepare() {
    mkdir -p $instdir
    cd $instdir

    git clone https://github.com/redmine/redmine || exit;

    sudo yum install apr-devel apr-util-devel curl-devel httpd \
                     httpd-devel ImageMagick-devel mysql-devel \
                     mysql-server postfix ruby-devel -y || exit;
}

redmine_setup_mysql() {
    query="
    CREATE DATABASE IF NOT EXISTS redmine CHARACTER SET utf8;

    GRANT ALL PRIVILEGES ON redmine.* TO \"redmine\"@\"localhost\"
    IDENTIFIED BY \"$passwd\";

    \q
    "
    echo $query
    mysql -u root -p <<< "$query"
}

redmine_install() {

    read -s -e -p "Enter password for redmine database:" passwd
    echo
    if [[ -z $passwd ]]; then
        passwd="123login"
    fi

    redmine_setup_mysql
    if [[ $? -ne 0 ]]; then
        echo "Bad password, re-setup mysql"
        mysql_secure_installation 
    fi

    cd $redminedir || redmine_prepare;

    cp config/database.yml.example config/database.yml
    sed -i "s/\(username: \).*/\1redmine/" config/database.yml
    sed -i "s/\(password: \).*/\1\"$passwd\"/" config/database.yml
    sudo gem sources -r https://rubygems.org/
    sudo gem sources -a https://ruby.taobao.org/ || exit;
    sed -i 's/rubygems/ruby.taobao/' Gemfile
    sudo gem install bundler --no-ri --no-rdoc || exit;

    # this is a patch
    mysql2=`sudo -u $user -H bundle show mysql2`
    alt=`find $mysql2 -name "mysql2.so"`
    rb=`find $mysql2 -name "mysql2.rb"`
    grep "mysql2.so" $rb > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        sudo sed -i "s:mysql2/mysql2:$alt:" $rb
    fi

    sudo -u $user -H bundle install --without development test || exit;

    # encode cookies 
    sudo -u $user -H bundle exec rake generate_secret_token
    
    # create the database structure
    sudo -u $user -H bundle exec rake db:migrate RAILS_ENV=production
    
    # insert default configuration data in database
    sudo -u $user -H bundle exec rake redmine:load_default_data RAILS_ENV=production
}

case "$1" in
  prepare)
        redmine_prepare
        ;;
  install)
        redmine_install
        ;;
  check)
        cd $redminedir; ruby bin/rails server webrick -e production -d
        ;;
  *)
        echo "Usage: $0 {prepare|install|check}"
        exit 1
        ;;
esac

exit
