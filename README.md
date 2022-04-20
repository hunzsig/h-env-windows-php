# 完善配置好的一套php/web开发环境

> 只适用于windows平台

### 使用方式（自带admin权限询问，任意目录皆可）

```
双击 run.bat 运行
```

### 默认库

```
apache
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

### 可选依赖服务

#### 拓展服务都压缩放置于dependent，需要某个时，直接压缩到目录即可

#### 都是默认端口，可自行修改

```
nginx、redis、rabbitmq等
```

#### 其他各种库请自行下载并放到dependent目录

```
mysql、postgresql、mongo、redis、rabbitmq等

mysql 需要注册进服务
    bin mysqld.exe install MySQL
rabbitmq 需要注册进服务
    sbin\rabbitmq-service.bat install RabbitMQ
```

> 根据run.bat里面的编写凑齐即可
