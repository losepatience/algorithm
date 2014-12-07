#! /bin/sh

if [[ `whoami` != "git" ]]; then
    echo "Should run this script as user git, EXIT!" && exit
fi

redmine_user="git"
instdir="/home/git"
redminedir="$instdir/redmine"

redmine_prepare() {
    cd $instdir

    if [[ ! -d $redminedir ]]; then
        git clone https://github.com/redmine/redmine || exit
    fi

    sudo yum install ImageMagick-devel -y || exit

    # when invoked by inst-gitlab.sh, the following line is unecessary.
    sudo yum install apr-devel apr-util-devel curl-devel httpd httpd-devel \
                     mysql-devel mysql-server postfix ruby-devel -y || exit

    sudo systemctl enable mariadb.service
    sudo systemctl enable httpd.service
    sudo systemctl enable postfix.service

    sudo systemctl restart mariadb.service
    sudo systemctl restart postfix.service
}

redmine_setup_mysql() {
    redmine_query="
    CREATE DATABASE IF NOT EXISTS redmine CHARACTER SET utf8;

    GRANT ALL PRIVILEGES ON redmine.* TO \"redmine\"@\"localhost\"
    IDENTIFIED BY \"$redmine_passwd\";

    \q
    "

    echo -n "root on 'mysql', "
    mysql -u root -p <<< "$redmine_query"
    if [[ $? -ne 0 ]]; then
        mysql_secure_installation || exit

	# make sure it's the last cmd in this function
        redmine_setup_mysql
    fi
}

redmine_install() {

    read -e -p "Redmine URL(repos.ci.org): " redmine_url
    if [[ -z "$redmine_url" ]]; then
        redmine_url="repos.ci.org"
    fi
    redmine_domain=`echo $redmine_url | sed "s/[0-9_a-zA-Z]*\.//"`

    read -s -e -p "Enter database password(default):" redmine_passwd
    echo
    if [[ -z $redmine_passwd ]]; then
        redmine_passwd="123login"
    fi

    redmine_setup_mysql
    cd $redminedir > /dev/null 2>&1 || redmine_prepare
    cd $redminedir

# configure database
cat > config/database.yml << EOF
production:
  adapter: mysql2
  database: redmine
  host: localhost
  username: redmine
  password: "$redmine_passwd"
  encoding: utf8

EOF

# email stmp
cat > config/configuration.yml << EOF
production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: "$redmine_url"
      port: 25
      domain: "$redmine_domain"

  rmagick_font_path: /usr/share/fonts/wqy-zenhei/wqy-zenhei.ttc

EOF

    sudo gem sources -r https://rubygems.org/
    sudo gem sources -a https://ruby.taobao.org/ || exit
    sed -i 's/rubygems/ruby.taobao/' Gemfile
    sudo gem install bundler --no-ri --no-rdoc || exit
    bundle install --without development test || exit

    # this is a patch
    bundle show mysql2 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        redmine_mysql2=`bundle show mysql2`
        redmine_alt=`sudo find $redmine_mysql2 -name "mysql2.so"`
        redmine_rb=`sudo find $redmine_mysql2 -name "mysql2.rb"`
        sudo grep "mysql2.so" $redmine_rb > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            sudo sed -i "s:mysql2/mysql2:$redmine_alt:" $redmine_rb
        fi
    fi

    # encode cookies 
    bundle exec rake generate_secret_token
    
    # create the database structure
    bundle exec rake db:migrate RAILS_ENV=production
    
    # insert default configuration data in database
    bundle exec rake redmine:load_default_data RAILS_ENV=production

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
