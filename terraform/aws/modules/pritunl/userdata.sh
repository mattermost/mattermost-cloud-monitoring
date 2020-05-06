#!/usr/bin/env bash

###
# Redirecting STDOUT and STDERR to LOG_FILE
##
printf "\n### Redirecting STDOUT and STDERR to LOG_FILE ###\n"
export LOG_FILE=/var/log/bootstrap.log
# Close STDOUT file descriptor
exec 1<&-
# Close STDERR FD
exec 2<&-
# Open STDOUT as $LOG_FILE file for read and write.
exec 1<>$LOG_FILE
# Redirect STDERR to STDOUT
exec 2>&1

# -----  Security and patches -----
# Install basic update
printf "\n### Installing basic update ###\n"
apt-get update && apt-get upgrade -y


printf "\n### Preparation for Pritunl installation ###\n"
printf "\n### Increase Open File Limit ###\n"
sudo sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'


printf "\n### Installing Pritunl ###\n"
sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list << EOF
deb https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse
EOF
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt bionic main
EOF
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get --assume-yes install pritunl


printf "\n### Install pymongo for MongoDB Atlas  ###\n"
apt install python-pip --assume-yes
pip install --target=/usr/lib/pritunl/local/lib/python2.7 pymongo[srv]


printf "\n### MongoDB setup for pritunl ###\n"
pritunl set-mongodb ${mongodb_uri}
pritunl set app.reverse_proxy true
pritunl set app.server_ssl false
pritunl set app.server_port 443


printf "\n### Enabling Pritunl ###\n"
sudo systemctl enable pritunl


printf "\n### Starting Pritunl ###\n"
sudo systemctl start pritunl





