#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 6/13/17
#Time: 5:15 PM
#

if [ "$1" != "in" ];then
	echo "Before cleaning the installation script environment !"
	echo "Please backup your data !!"
	read -p "Enter the y or Y to continue:" isY
	if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
	   exit 1
	fi
fi

mkdir -p /alidata

/etc/init.d/mysqld stop &> /dev/null
/etc/init.d/vsftpd stop &> /dev/null

killall mysqld &> /dev/null
killall vsftpd &> /dev/null

echo "--------> Clean up the installation environment"
rm -rf /usr/local/freetype.2.1.10
rm -rf /usr/local/libpng.1.2.50
rm -rf /usr/local/freetype.2.1.10
rm -rf /usr/local/libpng.1.2.50
rm -rf /usr/local/jpeg.6

echo ""
echo "--------> Delete directory"
echo "/alidata/server/mysql             delete ok!"
rm -rf /alidata/server/mysql
echo "rm -rf /alidata/server/mysql-*    delete ok!"
rm -rf /alidata/server/mysql-*
echo "/alidata/server/java               delete ok!"
rm -rf /alidata/server/java
echo "/alidata/server/java-*             delete ok!"
rm -rf /alidata/server/java-*
echo "/alidata/server/tomcat             delete ok!"
rm -rf /alidata/server/tomcat
echo "rm -rf /alidata/server/tomcat-*    delete ok!"
rm -rf /alidata/server/tomcat-*
echo ""
echo "/alidata/log                  delete ok!"
rm -rf /alidata/log
echo ""

echo "/alidata/www                      delete ok!"
rm -rf /alidata/www
echo "/alidata/init                     delete ok!"
rm -rf /alidata/init

echo ""
echo "--------> Delete file"
echo "/etc/my.cnf                delete ok!"
rm -f /etc/my.cnf
echo "/etc/init.d/mysqld         delete ok!"
rm -f /etc/init.d/mysqld

echo ""
ifrpm=$(cat /proc/version | grep -E "redhat|centos")
ifdpkg=$(cat /proc/version | grep -Ei "ubuntu|debian")
ifcentos=$(cat /proc/version | grep centos)
echo "--------> Clean up files"
echo "/etc/rc.local                   clean ok!"
if [ "$ifrpm" != "" ];then
	if [ -L /etc/rc.local ];then
		echo ""
	else
		\cp /etc/rc.local /etc/rc.local.bak
		rm -rf /etc/rc.local
		ln -s /etc/rc.d/rc.local /etc/rc.local
	fi
	sed -i "/\/etc\/init\.d\/mysqld.*/d" /etc/rc.d/rc.local
	sed -i "/\/etc\/init\.d\/vsftpd.*/d" /etc/rc.d/rc.local
	sed -i "/\/alidata\/init\/initPasswd\.sh.*/d" /etc/rc.d/rc.local
else
	sed -i "/\/etc\/init\.d\/mysqld.*/d" /etc/rc.local
	sed -i "/\/etc\/init\.d\/vsftpd.*/d" /etc/rc.local
	sed -i "/\/alidata\/init\/initPasswd\.sh.*/d" /etc/rc.local
fi

echo ""
echo "/etc/profile                    clean ok!"
sed -i "/export PATH=\$PATH\:\/alidata\/server\/mysql\/bin.*/d" /etc/profile
source /etc/profile

echo ""
if [ "$ifrpm" != "" ];then
	yum -y remove vsftpd  &> /dev/null
    rpm -e vsftpd
	rm -f /etc/vsftpd/chroot_list
	rm -f /etc/vsftpd/ftpusers
	rm -f /etc/vsftpd/user_list
	rm -f /etc/vsftpd/vsftpd.conf
else
	apt-get -y remove vsftpd
	rm -f /etc/vsftpd.conf
	rm -f /etc/vsftpd.chroot_list
	rm -f /etc/vsftpd.user_list
	rm -rf /etc/pam.d/vsftpd
fi
echo "vsftpd                    remove ok!"

rm -rf /alidata/account.log
rm -rf /alidata/website-info.log
if [ "$1" != "in" ];then
	bash
fi