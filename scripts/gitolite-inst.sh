#! /bin/sh

# this script could be run from the ssh guest

if [[ -z `which ssh` ]]; then
	sudo yum install -y openssh-clients openssh-server
	ssh-keygen
fi

read -e -p "Enter Host IP:" SSHHOST

# Without '\' before EOF, The shell on the local host is doing variable
# substitution because the "EOF" isn't escaped
ssh -t root@$SSHHOST <<- \EOF
yum install -y git-core openssh-clients openssh-server gitolite3
passwd -d gitolite3
EOF

scp ~/.ssh/id_rsa.pub root@$SSHHOST:/tmp/admin.pub
if [[ $? -ne 0 ]]; then
	exit 1
fi

ssh -t root@$SSHHOST <<- \EOF
	su gitolite3
	gitolite setup -pk /tmp/admin.pub
EOF

