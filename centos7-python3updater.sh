#!/bin/bash

set -eu

if [ "$1" == "" ]; then
	echo "One argument is needed (e.g. python3.7)
fi

ARG=$1
INSTALL_VER=${ARG:0:7}${ARG:8:1}
VERSION_NUM=${ARG:6:3}

###
yum install -y https://centos7.iuscommunity.org/ius-release.rpm
yum install -y --enablerepo=epel ${INSTALL_VER} ${INSTALL_VER}-devel ${INSTALL_VER}-libs

ln -s /bin/python${VERSION_NUM} /bin/python3
unlink /bin/python
ln -s /bin/python3 /bin/python
ln -s /bin/pip${VERSION_NUM} /bin/pip

cp -rp /usr/libexec/urlgrabber-ext-down /usr/libexec/urlgrabber-ext-down.back
sed -i 's#/usr/bin/python$#/usr/bin/python2#g' /usr/libexec/urlgrabber-ext-down
