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

echo "Begin install vsftpd:"

./ftp/install_${vsftpd_dir}.sh

/etc/init.d/vsftpd restart

