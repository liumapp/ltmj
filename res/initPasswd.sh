#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 8/4/17
#Time: 7:44 PM
#

ifrpm=$(cat /proc/version | grep -E "redhat|centos")
ifdpkg=$(cat /proc/version | grep -Ei "ubuntu|debian")

#modify ftp passwd
PASS=$(date | md5sum |head -c 9)
if [ "$ifrpm" != "" ];then
	echo $PASS | passwd --stdin www
else
	echo "www:$PASS" | chpasswd
fi

sed -i "9s/.*/password:${PASS}/" /alidata/account.log
sleep 1

#modify mysql passwd
PASS=$(date | md5sum |head -c 10)
OLDPASSWD=$(sed -n '13p' /alidata/account.log |awk -F: '{print $2}')
/alidata/server/mysql/bin/mysqladmin -uroot -p$OLDPASSWD password $PASS
sed -i "13s/.*/password:${PASS}/" /alidata/account.log

if [ "$ifrpm" != "" ];then
        sed -i "/\/alidata\/init.*/d" /etc/rc.d/rc.local
else
        sed -i "/\/alidata\/init.*/d" /etc/rc.local
fi