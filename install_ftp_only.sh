#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 8/8/17
#Time: 1:47 PM
#

export vsftpd_version=3.0.2

export vsftpd_dir=vsftpd-${vsftpd_version}

echo "Begin install vsftpd:"

./ftp/install_${vsftpd_dir}.sh

if ! cat /etc/rc.local | grep "/etc/init.d/vsftpd" > /dev/null;then
    echo "/etc/init.d/vsftpd start" >> /etc/rc.local
fi

/etc/init.d/vsftpd restart

