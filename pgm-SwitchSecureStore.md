# SwitchSecureStore

## NAME
SwitchSecureStore - 更改当前使用的 SecureStore 接口

## SYNOPSIS
```
_java_ -jar gerrit.war _SwitchSecureStore_
  [--new-secure-store-lib]
```

## DESCRIPTION
更改当前使用的 SecureStore 接口。从 `$site_path/lib` 移走老的 SecureStore 文件，并放入新文件。最后在 `gerrit.config` 更新 secureStoreClass 属性。

在运行 `SwitchSecureStore` 命令前，需要把所依赖的 jar 文件必须放到 `$site_path/lib` 目录中。

执行上面的操作后，gerrit 没有提供自动回退到默认的非 securstore 接口方式，如要回退，需要按下面步骤手动执行：
* 停止 Gerrit 服务
* 从 `$site_path/lib` 移走 SecureStore 文件
* 密码写入 `$site_path/etc/secure.conf` 文件
* 启动 Gerrit 服务

## OPTIONS

**--new-secure-store-lib**
	新 SecureStore 接口的 jar 文件名称。所依赖的 jar 文件必须放到 `$site_path/lib` 目录中。

