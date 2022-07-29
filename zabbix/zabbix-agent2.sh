#! /bin/bash



echo "------- 时区配置--------"


#centos8 下的时区配置
sudo yum install -y chrony
systemctl start chronyd
sudo systemctl enable chronyd
sed -i 's/pool 2.centos.pool.ntp.org iburst/#&/' /etc/chrony.conf
sed -i '$a\server ntp.aliyun.com iburst'   /etc/chrony.conf
sed -i '$a\server cn.ntp.org.cn iburst'    /etc/chrony.conf
systemctl restart chronyd.service

chronyc  sources -v



echo "------- 时区配置完成--------"
#
#centos8下yum配置
#yum install -y epel-release
#if [ $? -eq 0 ]
#then
#echo "基础源和扩展源已经更改为阿里源"
#yum clean all 
#yum makecache
#else
#exit
#echo "基础源安装失败"
#fi

echo "正在更改zabbix yum源，请稍候......"

#centos8下
rpm -Uvh https://mirrors.aliyun.com/zabbix/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm

sed -i 's#http://repo.zabbix.com#https://mirrors.aliyun.com/zabbix#' /etc/yum.repos.d/zabbix.repo

yum clean all

yum makecache


echo "正在安装zabbix客户端，请稍候......"
yum -y  install zabbix-agent2
if [ $? -eq 0 ]
then
echo " 已经安装成功！"
else
exit
echo "客户端 安装失败"
fi

#后面Server=服务端ip
sed -i 's/Server=127.0.0.1/Server=192.168.0.163/'  /etc/zabbix/zabbix_agent2.conf

#后面ServerActive=服务端ip
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.0.163/'  /etc/zabbix/zabbix_agent2.conf

#后面Hostname=可以设置为自己定义的本机名称
sed -i 's/Hostname=Zabbix server/Hostname=app_tomcat_71/'  /etc/zabbix/zabbix_agent2.conf

sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/'  /etc/zabbix/zabbix_agent2.conf

echo "---------查看zabbix客户端配置-----"


grep -Ev '^#|^$' /etc/zabbix/zabbix_agent2.conf



echo "--------------"


#开机启动客户端
systemctl enable --now zabbix-agent2
#重启客户端
systemctl restart zabbix-agent2
