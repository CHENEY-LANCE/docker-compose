1 登录zabbix图形化网址：

ip:9999/zabbix

Admin

zabbix



2添加服务器主机：

sed -i 's/Server=127.0.0.1/Server=172.20.238.6/'  /etc/zabbix/zabbix_agent2.conf

#后面ServerActive=服务端ip
sed -i 's/ServerActive=127.0.0.1/ServerActive=172.20.238.6/'  /etc/zabbix/zabbix_agent2.conf

