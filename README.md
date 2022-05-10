# 完善配置好的一套php/web开发环境

> 只适用于windows平台

### 使用方式（自带admin权限询问，任意目录皆可）

```
双击 run.bat 运行
```

### 默认库

```
nginx
    1.21.6
php
    5.6.40
    7.0.33
    7.1.33
    7.2.34
    7.3.33
    7.4.29
    8.0.18
    8.1.5
    
    默认拓展
    bz2、gd2、mbstring、xmlrpc、fileinfo
    curl、imap、openssl、soap、sockets
    odbc、mysqli、pgsql
    pdo_mysql、pdo_odbc、pdo_pgsql、pdo_sqlite
    opcache( >7.1默认开启)
    
    第三方拓展
    igbinary、redis、lzf
    pdo_sqlsrv、sqlsrv、mongodb
    amqp、rdkafka
```

#### 其他服务请自行下载并放到喜欢的目录

> 如 ./service/...

```
mysql、postgresql、mongo、redis、rabbitmq等

需要注册进服务
    mysql
        ./service/mysql-8.0.28-winx64/bin/mysqld.exe install MySQL
    rabbitmq
        ./services/rabbitmq_server-3.9.15/sbin/rabbitmq-service.bat install RabbitMQ
    redis
        ./service/Redis-x64-5.0.14.1/redis-server.exe --service-install redis.windows-service.conf --service-name Redis --loglevel verbose
```

> 根据run.bat里面的编写凑齐即可
