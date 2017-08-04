#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 17/6/14
#Time: 下午2:48
#

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf jdk1.8.0_131
  if [ ! -f mysql-5.5.37-linux2.6-x86_64.tar.gz ];then
	 wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.37-linux2.6-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.5.37-linux2.6-x86_64.tar.gz
  mv mysql-5.5.37-linux2.6-x86_64/* /alidata/server/mysql
else
  rm -rf mysql-5.5.37-linux2.6-i686
  if [ ! -f mysql-5.5.37-linux2.6-i686.tar.gz ];then
    wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.37-linux2.6-i686.tar.gz
  fi
  tar -xzvf mysql-5.5.37-linux2.6-i686.tar.gz
  mv mysql-5.5.37-linux2.6-i686/* /alidata/server/mysql
fi
