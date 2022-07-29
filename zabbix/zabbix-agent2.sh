#! /bin/bash


#关闭防火墙和selinux
echo "开启防火墙10050端口....."
firewall-cmd --zone=public --permanent --add-port=10050/tcp 
firewall-cmd --reload

setenforce 0
echo "开启防火墙10050端口完成....."

echo "------- 时区配置--------"
yum install ntpdate -y

ntpdate -u ntp.aliyun.com

#centos8 下的时区配置
#sudo yum install -y chrony
# systemctl start chronyd
#sudo systemctl enable chronyd
#sed -i 's/pool 2.centos.pool.ntp.org iburst/#&/' /etc/chrony.conf
#sed -i '$a\server ntp.aliyun.com iburst' 
#sed -i '$a\server cn.ntp.org.cn iburst' 
#systemctl restart chronyd.service

mv /etc/localtime{,.bak} 

ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "------- 时区配置完成--------"

echo "正在更改yum源，请稍候......"
/usr/bin/wget -O /etc/yum.repos.d/Centos-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null
/bin/wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo &> /dev/null
#centos8下yum配置
#yum install epel-release
if [ $? -eq 0 ]
then
echo "基础源和扩展源已经更改为阿里源"
yum clean all 
yum makecache
else
exit
echo "基础源安装失败"
fi

echo "正在更改zabbix yum源，请稍候......"
rpm -Uvh https://mirrors.aliyun.com/zabbix/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm &>/dev/null
#centos8下
#rpm -Uvh https://mirrors.aliyun.com/zabbix/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm

sed -i 's#http://repo.zabbix.com#https://mirrors.aliyun.com/zabbix#' /etc/yum.repos.d/zabbix.repo

yum clean all

yum makecache


echo "正在安装zabbix客户端，请稍候......"
yum -y  install zabbix-agent2 &> /dev/null
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
sed -i 's/Hostname=Zabbix server/Hostname=appsrv_163/'  /etc/zabbix/zabbix_agent2.conf



echo "---------查看zabbix客户端配置-----"


grep -Ev '^#|^$' /etc/zabbix/zabbix_agent2.conf



echo "--------------"


#开机启动客户端
systemctl enable --now zabbix-agent2
#重启客户端
systemctl restart zabbix-agent2
