#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 8/4/17
#Time: 4:06 PM
#

echo Hello

# exit 0

echo World

#create account.log
cat > account.log << END
##########################################################################
#
# thank you for using aliyun virtual machine
# User: liumapp
# Email: liumapp.com@gmail.com
# homePage: http://www.liumapp.com
#
##########################################################################

FTP:
account:www
password:ftp_password

MySQL:
account:root
password:mysql_password
END