#!/bin/bash

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
ifrpm=$(cat /proc/version | grep -E "redhat|centos")
ifdpkg=$(cat /proc/version | grep -Ei "ubuntu|debian")
ifcentos=$(cat /proc/version | grep centos)

if [ "$ifrpm" != "" ];then
	if [ ! -f vsftpd-3.0.2-2.el6.x86_64.rpm ];then
		wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/vsftpd-3.0.2-2.el6.x86_64.rpm
	fi
	rpm -ivh vsftpd-3.0.2-2.el6.x86_64.rpm
	\cp -f ./ftp/config-ftp/rpm_ftp/* /etc/vsftpd/
fi

if [ "$ifcentos" != "" ] && [ "$machine" == "i686" ];then
    rm -rf /etc/vsftpd/vsftpd.conf
	\cp -f ./ftp/config-ftp/vsftpdcentosi686.conf /etc/vsftpd/vsftpd.conf
fi

/etc/init.d/vsftpd start

chown -R www:www /alidata/www

#bug kill: '500 OOPS: vsftpd: refusing to run with writable root inside chroot()'
chmod a-w /alidata/www

MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LENGTH="9"
while [ "${n:=1}" -le "$LENGTH" ]
do
	PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
	let n+=1
done
if [ "$ifrpm" != "" ];then
echo $PASS | passwd --stdin www
else
echo "www:$PASS" | chpasswd
fi

sed -i s/'ftp_password'/${PASS}/g account.log