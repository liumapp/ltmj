#!/bin/bash

#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 6/12/17
#Time: 5:37 PM
#

####---- global variables ----begin####
export tomcat_version=7.0.78
export java_version=1.8
export mysql_version=5.5.37
export vsftpd_version=3.0.2
export install_ftp_version=0.0.0
export maven_version=3.5.0
####---- global variables ----end####

install_log=/lmdata/website-info.log

####---- version confirm ----begin####
tmp=1
echo ""
echo "You select the version :"
echo "tomcat    : $tomcat_version"
echo "java      : $java_version"
echo "mysql  : $mysql_version"
echo "maven_version    :   $maven_version"

read -p "Enter the y or Y to continue:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
   exit 1
fi
####---- version selection ----end####


####---- Clean up the environment ----begin####
echo "will be installed, wait ..."
./uninstall.sh in &> /dev/null
####---- Clean up the environment ----end####


if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi

####---- global variables ----begin####
export tomcat_dir=tomcat-${tomcat_version}
export java_dir=java-${java_version}
export mysql_dir=mysql-${mysql_version}
export maven_dir=maven-${maven_version}
export vsftpd_dir=vsftpd-${vsftpd_version}
####---- global variables ----end####

ifcentos=$(cat /proc/version | grep centos)

####---- install dependencies ----begin####

\cp /etc/rc.local /etc/rc.local.bak
if [ "$ifredhat" != "" ];then
rpm -e --allmatches mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 mod_auth_mysql mailman squirrelmail &> /dev/null
fi

if [ "$ifcentos" != "" ];then
  sed -i 's/^exclude/#exclude/' /etc/yum.conf
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 mod_auth_mysql mailman squirrelmail &> /dev/null
  yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
  iptables -F
else
  echo "error !! Your system is not centos!"
  exit 0
fi
####---- install dependencies ----end####

####---- openssl update---begin####
./env/update_openssl.sh
####---- openssl update---end####

####---- install software ----begin####
rm -f tmp.log
echo tmp.log

./env/install_set_ulimit.sh

./env/install_dir.sh
echo "---------- make dir ok ----------" >> tmp.log

./env/install_env.sh
echo "---------- env ok ----------" >> tmp.log

./mysql/install_${mysql_dir}.sh
echo "---------- ${mysql_dir} ok ----------" >> tmp.log

if echo $web |grep "nginx" > /dev/null;then
	./nginx/install_nginx-${nginx_version}.sh
	echo "---------- ${web_dir} ok ----------" >> tmp.log
	./php/install_nginx_php-${php_version}.sh
	echo "---------- ${php_dir} ok ----------" >> tmp.log
else
	./apache/install_httpd-${httpd_version}.sh
	echo "---------- ${web_dir} ok ----------" >> tmp.log
	./php/install_httpd_php-${php_version}.sh
	echo "---------- ${php_dir} ok ----------" >> tmp.log
fi

./php/install_php_extension.sh
echo "---------- php extension ok ----------" >> tmp.log

./ftp/install_${vsftpd_dir}.sh
echo "---------- vsftpd-$vsftpd_version  ok ----------" >> tmp.log

mkdir -p /lmdata/www/default
if echo $web |grep "nginx" > /dev/null;then
	\cp ./res/index-nginx.html /lmdata/www/default/index.html
else
    \cp ./res/index-apache.html /lmdata/www/default/index.html
fi

cat > /lmdata/www/default/info.php << EOF
<?php
phpinfo();
?>
EOF

chown www:www -R /lmdata/www/

\cp ./res/initPasswd.sh /lmdata/init/
chmod 755 /lmdata/init/initPasswd.sh

echo "---------- web init ok ----------" >> tmp.log
####---- install software ----end####


####---- Start command is written to the rc.local ----begin####
if ! cat /etc/rc.local | grep "/etc/init.d/mysqld" > /dev/null;then
    echo "/etc/init.d/mysqld start" >> /etc/rc.local
fi
if echo $web|grep "nginx" > /dev/null;then
  if ! cat /etc/rc.local | grep "/etc/init.d/nginx" > /dev/null;then
     echo "/etc/init.d/nginx start" >> /etc/rc.local
	 echo "/etc/init.d/php-fpm start" >> /etc/rc.local
  fi
else
  if ! cat /etc/rc.local | grep "/etc/init.d/httpd" > /dev/null;then
     echo "/etc/init.d/httpd start" >> /etc/rc.local
  fi
fi
if ! cat /etc/rc.local | grep "/etc/init.d/vsftpd" > /dev/null;then
    echo "/etc/init.d/vsftpd start" >> /etc/rc.local
fi
if ! cat /etc/rc.local | grep "/lmdata/init/initPasswd.sh" > /dev/null;then
    echo "/lmdata/init/initPasswd.sh" >> /etc/rc.local
fi
####---- Start command is written to the rc.local ----end####


####---- centos yum configuration----begin####
if [ "$ifcentos" != "" ] && [ "$machine" == "x86_64" ];then
sed -i 's/^#exclude/exclude/' /etc/yum.conf
mkdir -p /var/lock/subsys/
fi
####---- centos yum configuration ----end####

####---- mysql password initialization ----begin####
echo "---------- rc init ok ----------" >> tmp.log
TMP_PASS=$(date | md5sum |head -c 10)
/lmdata/server/mysql/bin/mysqladmin -u root password "$TMP_PASS"
sed -i s/'mysql_password'/${TMP_PASS}/g account.log
echo "---------- mysql init ok ----------" >> tmp.log
####---- mysql password initialization ----end####


####---- Environment variable settings ----begin####
\cp /etc/profile /etc/profile.bak
if echo $web|grep "nginx" > /dev/null;then
  echo 'export PATH=$PATH:/lmdata/server/mysql/bin:/lmdata/server/nginx/sbin:/lmdata/server/php/sbin:/lmdata/server/php/bin' >> /etc/profile
  export PATH=$PATH:/lmdata/server/mysql/bin:/lmdata/server/nginx/sbin:/lmdata/server/php/sbin:/lmdata/server/php/bin
else
  echo 'export PATH=$PATH:/lmdata/server/mysql/bin:/lmdata/server/httpd/bin:/lmdata/server/php/sbin:/lmdata/server/php/bin' >> /etc/profile
  export PATH=$PATH:/lmdata/server/mysql/bin:/lmdata/server/httpd/bin:/lmdata/server/php/sbin:/lmdata/server/php/bin
fi
####---- Environment variable settings ----end####


####---- restart ----begin####
if echo $web|grep "nginx" > /dev/null;then
/etc/init.d/php-fpm restart > /dev/null
/etc/init.d/nginx restart > /dev/null
else
/etc/init.d/httpd restart > /dev/null
/etc/init.d/httpd start &> /dev/null
fi
/etc/init.d/vsftpd restart
####---- restart ----end####

####---- log ----begin####
\cp tmp.log $install_log
cat $install_log
\cp -a account.log /lmdata/
####---- log ----end####
bash