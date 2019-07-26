# gerrit logging set-level

## NAME
gerrit logging set-level - 设置 log 的级别

gerrit logging set - 设置 log 的级别

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit logging set-level_ | _set_
  <LEVEL>
  <NAME>
```

## DESCRIPTION
设置 log 的级别

## Options
**<LEVEL>**
  必要; 对 logger 设置 log 的级别。`reset` 用于将所有的 logger 恢复为默认值。

**<NAME>**
  对 logger 设置 log 的级别。`reset` 用于将所有的 logger 恢复为默认值。

## ACCESS
需要有管理员权限

## Examples

将 com.google log 级别设置为 DEBUG.
```
$ssh -p 29418 review.example.com gerrit logging set-level debug com.google.
```

将所有的 logger 恢复为默认值。
```
$ssh -p 29418 review.example.com gerrit logging set-level reset
```

