# gerrit logging ls-level

## NAME
gerrit logging ls-level - 显示 log 的级别

gerrit logging ls - 显示 log 的级别
## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit logging ls-level_ | _ls_
  <NAME>
```

## DESCRIPTION
显示 log 的级别

## Options
**<NAME>**
  显示具体 logger 的 log 级别，如果不提供此参数，那么显示所有 logger 的 log 级别。

## ACCESS
需要有管理员权限

## Examples

显示包 com.google 的 log 级别:
```
$ssh -p 29418 review.example.com gerrit logging ls-level com.google.
```

显示每一个 logger 的级别
```
$ssh -p 29418 review.example.com gerrit logging ls-level
```

