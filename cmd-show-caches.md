# gerrit show-caches

## NAME
gerrit show-caches - 显示当前缓存的信息

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit show-caches_
  [--gc]
  [--show-jvm]
```

## DESCRIPTION
显示当前缓存的信息，如：大小，命中率等。

## OPTIONS
**--gc**
	需要事先对 Java 环境执行 gc 操作。

**--show-jvm**
	显示 JVM 的相关信息。

**--show-threads**
	显示线程的数量。

**--width**
**-w**
	表格的输出宽度。

## ACCESS
需要有下列之一的权限：

* [访问控制](access-control.md) 的 `View Caches` 权限
* [访问控制](access-control.md) 的 `[Maintain Server` 权限
* 管理员权限

## SCRIPTING
建议交互使用

## EXAMPLES

```
$ ssh -p 29418 review.example.com gerrit show-caches
Gerrit Code Review        2.9                       now   11:14:13   CEST
                                                 uptime    6 days 20 hrs
  Name                          |Entries              |  AvgGet |Hit Ratio|
                                |   Mem   Disk   Space|         |Mem  Disk|
--------------------------------+---------------------+---------+---------+
  accounts                      |  4096               |   3.4ms | 99%     |
  adv_bases                     |                     |         |         |
  changes                       |                     |  27.1ms |  0%     |
  groups                        |  5646               |  11.8ms | 97%     |
  groups_bymember               |                     |         |         |
  groups_byname                 |                     |         |         |
  groups_bysubgroup             |   230               |   2.4ms | 62%     |
  groups_byuuid                 |  5612               |  29.2ms | 99%     |
  groups_external               |     1               |   1.5s  | 98%     |
  ldap_group_existence          |                     |         |         |
  ldap_groups                   |   650               | 680.5ms | 99%     |
  ldap_groups_byinclude         |  1024               |         | 83%     |
  ldap_usernames                |   390               |   3.8ms | 81%     |
  permission_sort               | 16384               |         | 99%     |
  plugin_resources              |                     |         |         |
  project_list                  |     1               |   3.8s  | 99%     |
  projects                      |  6477               |   2.9ms | 99%     |
  sshkeys                       |  2048               |  12.5ms | 99%     |
D diff                          |  1299  62033 132.36m|  22.0ms | 85%  99%|
D diff_intraline                | 12777 218651 128.45m| 171.1ms | 31%  96%|
D git_tags                      |     3      6  11.85k|         |  0% 100%|
D web_sessions                  |  1024 151714  59.10m|         | 99%  57%|

SSH:    385  users, oldest session started    6 days 20 hrs ago
Tasks:   10  total =    6 running +      0 ready +    4 sleeping
Mem:  14.94g total =   3.04g used +  11.89g free +  10.00m buffers
      28.44g max
         107 open files

Threads: 4 CPUs available, 371 threads
```

## SEE ALSO

* [gerrit flush-caches](cmd-flush-caches.md)
* [系统配置](config-gerrit.md) 中的 Cache 部分

