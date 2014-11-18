#! /bin/sh

repo_base="/var/lib/gitolite3"

sudo yum install -y httpd highlight cgit

# given permissions to enable gitweb and git-daemon export
sudo sed -i "s/\(UMASK[ \t=>]\+\)[0-7]\+/\10027/" $repo_base/.gitolite.rc

# if there are alread repositories, following 2 lines is needed.
sudo chmod g+r $repo_base/projects.list
sudo chmod -R g+rx $repo_base/repositories

rm -f .tmp
sudo grep "$repo_base/projects.list" /etc/cgitrc
if [[ $? -ne 0 ]]; then
cat << EOF > .tmp
enable-git-config=1
enable-gitweb-owner=1
remove-suffix=1
project-list=$repo_base/projects.list
scan-path=$repo_base/repositories
EOF
fi
su root -c "cat .tmp >> /etc/cgitrc" > /dev/null 2>&1

sudo sed -i "s/^#\(source-filter\)/\1/" /etc/cgitrc 

sudo usermod -a -G gitolite3 apache
sudo systemctl restart httpd.service
