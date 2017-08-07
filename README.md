# ltmj

Linux(CentOS)+Tomcat+Mysql+Java环境自动化搭建脚本

### 安装步骤

* 拷贝项目到服务器上

* 进入项目目录

* 执行命令：

        chmod -R 777 install.sh env/ ftp/ java/ mysql/ res/ tomcat/
        
  赋予脚本可执行权限
  
* 执行 install.sh

* 安装结束，输入 java -version检查java是否安装成功，在浏览器访问http://yourserverIp:8080检查tomcat是否安装成功，mysql与ftp如果您希望远程登录的话，请执行相关配置（见注意事项）。

### 注意事项

* 所有程序都将安装在/alidata目录下

    * /alidata/server : mysql、tomcat、java、openssl的安装位置
     
* tomcat的启动命令我暂时没有写入/etc/init.d下，所以你需要自己进入/alidata/server/tomcat/bin目录去执行catalina.sh的start命令。

* mysql安装好后默认是不允许外网连接的，如果您希望在本地开发环境下远程连接服务器的mysql服务，请执行以下操作：

    * 


* mysql跟ftp帐号密码请见account.log文件



