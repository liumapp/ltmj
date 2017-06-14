#!/bin/bash

userdel www
groupadd www
useradd -g www -M -d /lmdata/www -s /sbin/nologin www &> /dev/null

mkdir -p /lmdata
mkdir -p /lmdata/server
mkdir -p /lmdata/server/openssl
mkdir -p /lmdata/www
mkdir -p /lmdata/init
mkdir -p /lmdata/log
mkdir -p /lmdata/log/mysql
chown -R www:www /lmdata/log

mkdir -p /lmdata/server/${mysql_dir}
ln -s /lmdata/server/${mysql_dir} /lmdata/server/mysql

mkdir -p /lmdata/server/${java_dir}
ln -s /lmdata/server/${java_dir} /lmdata/server/java

mkdir -p /lmdata/server/${tomcat_dir}
ln -s /lmdata/server/${tomcat_dir} /lmdata/server/tomcat

mkdir -p /lmdata/server/${maven_dir}
ln -s /lmdata/server/${maven_dir} /lmdata/server/maven
