#!/bin/bash
#
#Created by PhpStorm.
#User: liumapp
#Email: liumapp.com@gmail.com
#homePage: http://www.liumapp.com
#Date: 8/5/17
#Time: 4:43 PM
#

## install tomcat  -- begin ##
  rm -rf apache-tomcat-7.0.78
  if [ ! -f apache-tomcat-7.0.78.tar.gz ];then
	 echo "ERROR ! Tomcat source file cannot be found "
	 exit 0
  fi
  tar -xzvf apache-tomcat-7.0.78.tar.gz
  mv apache-tomcat-7.0.78/* /alidata/server/tomcat
## install tomcat -- end ##

