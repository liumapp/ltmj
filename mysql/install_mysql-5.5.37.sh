#!/bin/bash
if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.5.37-linux2.6-x86_64
  if [ ! -f mysql-5.5.37-linux2.6-x86_64.tar.gz ];then
	 wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.37-linux2.6-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.5.37-linux2.6-x86_64.tar.gz
  mv mysql-5.5.37-linux2.6-x86_64/* /lmdata/server/mysql
else
  rm -rf mysql-5.5.37-linux2.6-i686
  if [ ! -f mysql-5.5.37-linux2.6-i686.tar.gz ];then
    wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.37-linux2.6-i686.tar.gz
  fi
  tar -xzvf mysql-5.5.37-linux2.6-i686.tar.gz
  mv mysql-5.5.37-linux2.6-i686/* /lmdata/server/mysql
fi

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
/lmdata/server/mysql/scripts/mysql_install_db --datadir=/lmdata/server/mysql/data/ --basedir=/lmdata/server/mysql --user=mysql
chown -R mysql:mysql /lmdata/server/mysql/
chown -R mysql:mysql /lmdata/server/mysql/data/
chown -R mysql:mysql /lmdata/log/mysql
\cp -f /lmdata/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/lmdata/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/lmdata/server/mysql/data#' /etc/init.d/mysqld
\cp -f /lmdata/server/mysql/support-files/my-medium.cnf /etc/my.cnf
sed -i 's#skip-external-locking#skip-external-locking\nlog-error=/lmdata/log/mysql/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
