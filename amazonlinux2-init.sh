#!/bin/bash

set -ue

echo -n "Do you want to set the hostname? (Y/n)"
read ans

echo "### Set datetime to Japan time."
timedatectl set-timezone Asia/Tokyo

### Hostname Param Check
if [ "$ans" = 'Y' ]; then
    echo -n "Please enter the hostname you wish to set: "
    read param
    hostnamectl set-hostname $param
    echo "export PS1='\[\033[01;31m\]\u@\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '" >> /root/.bashrc
    echo "export PS1='\[\033[01;36m\]\u@\H\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '" >> /etc/profile
fi

echo "### yum update, develop packages, git, docker, python3 install"
yum update -y
yum -y install gcc openssl-devel libffi-devel bzip2-devel
yum -y install git docker python3 

echo "### Enable auto-starting of Docker services"
systemctl start docker
systemctl enable docker

echo "### python3 yum error fix"
cp -rp /usr/libexec/urlgrabber-ext-down /usr/libexec/urlgrabber-ext-down.back
sed -i 's#/usr/bin/python$#/usr/bin/python2#g' /usr/libexec/urlgrabber-ext-down

cp -rp /bin/yum /bin/yum.back
sed -i 's#/usr/bin/python$#/usr/bin/python2#g' /bin/yum

echo "### Install: python3"
type python3
if [ "$?" -ne 0 ]; then
    unlink /usr/bin/python
    ln -s /usr/bin/python3 /usr/bin/python
fi

echo "### Install: docker-compose"
type docker-compose
if [ "$?" -ne 0 ]; then
    curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo "### Install: AWS CLI Version2"
type /usr/local/aws-cli/v2/current/bin/aws
if [ "$?" -ne 0 ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

echo "
###  Complete!  ###

# Example: Command to run aws cli2 via docker.
docker run --rm -it amazon/aws-cli s3 ls

# Example: Command to download the s3 file using the host terminal's credentials.
docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli s3 cp s3://aws-cli-docker-demo/hello
"