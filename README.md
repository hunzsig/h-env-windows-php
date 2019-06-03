# 完善配置好的一套php/web开发环境，适用于windows平台
> 至于 linux 为什么不配，那是因为 linux 用命令安装本身已经极其方便（推荐CentOS）

### 使用方式（自带admin权限询问）
```
双击 realtime.bat 运行一次性控制
双击 service.bat 进行系统服务级控制
```

### 默认库
```
apache、php（5.6-7.3）
```
### 可选依赖服务
#### 拓展服务都压缩放置于dependent，需要某个时，直接压缩到目录即可
#### 都是默认端口，可自行修改
```
nginx、redis、elastic、rabbitmq
```
#### 开启拓展包含：
```
bz2、gd2、mbstring、xmlrpc
curl、imap、openssl、soap、sockets
odbc、mysqli、pgsql
pdo_mysql、pdo_odbc、pdo_pgsql、pdo_sqlite
opcache( >7.1默认开启)
```
#### 额外拓展包含：
> 5.6
```
igbinary、redis、memcache、lzf、pdo_sqlsrv、sqlsrv、mongo、mongodb、amqp
```
> 7.0
```
igbinary、redis、memcache、lzf、pdo_sqlsrv、sqlsrv、mongodb、amqp
```
> 7.1
```
igbinary、redis、memcache、lzf、pdo_sqlsrv、sqlsrv、mongodb、amqp
```
> 7.2
```
igbinary、redis、memcache、lzf、pdo_sqlsrv、sqlsrv、mongodb、amqp
```
> 7.3
```
igbinary、redis、memcache、lzf、pdo_sqlsrv、sqlsrv、mongodb、amqp
```
#### 各类数据库请自行安装使用，如：
```
mysql、postgresql、mongo等
```
 * [mysql5.7](https://dev.mysql.com/downloads/windows/installer/5.7.html)
 * [mysql8.0](https://dev.mysql.com/downloads/windows/installer/8.0.html)
 * [postgresql](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)
 * [mongo](https://www.mongodb.com/download-center/community)

#### 建议clone到 **D:/Web**，改动最少
> git clone git@github.com:hunzsig/h-web-env-windows.git D:\Web\h-web-env-windows
