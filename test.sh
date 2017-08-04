#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 8/4/17
#Time: 4:06 PM
#

## what kind of machine -- begin ##
if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
## what kind of machine -- end ##


## install java  -- begin ##
if [ $machine == "x86_64" ];then
  rm -rf jdk-8u144-linux-i586
  if [ ! -f jdk-8u144-linux-i586.tar.gz ];then
	 wget http://om40sen9v.bkt.clouddn.com/14ca4f70f43e41f4a593fee6e56a1541.gz jdk-8u144-linux-i586.tar.gz
  fi
  tar -xzvf jdk-8u144-linux-i586.tar.gz
else
  rm -rf jdk-8u144-linux-x64
  if [ ! -f jdk-8u144-linux-x64.tar.gz ];then
    wget http://om40sen9v.bkt.clouddn.com/d276ed2fa3bb481388a37853c295ccd4.gz jdk-8u144-linux-x64.tar.gz
  fi
  tar -xzvf jdk-8u144-linux-x64.tar.gz
fi
## install java -- end ##
