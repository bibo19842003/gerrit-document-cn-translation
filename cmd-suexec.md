# suexec

## NAME
suexec - 使用其他用户的身份来执行命令

## SYNOPSIS
```
_ssh_ -p <port>
  -i SITE_PATH/etc/ssh_host_rsa_key
  "Gerrit Code Review@localhost"
  _suexec_
  --as <EMAIL>
  [--from HOST:PORT]
  [--]
  [COMMAND]
```

## DESCRIPTION
suexec 命令允许使用其他用户的身份来执行命令。

用户只有被赋予了 `Run As` 权限，才可以执行 suexec 命令。同时，`auth.enableRunAs` 需要设置为 true。

## OPTIONS

**--as**
	被模仿的用户的 Email 

**--from**
	在指定的机器上(机器的 IP 和 端口)执行命令。

**COMMAND**
	要执行的命令

## ACCESS
需要 `Run As` 权限

## SCRIPTING
建议在脚本中执行此命令

## EXAMPLES

通过用户 bob@example.com 对 commit c0ff33 打分 "Verified +1"
```
$ sudo -u gerrit ssh -p 29418 \
  -i site_path/etc/ssh_host_rsa_key \
  "Gerrit Code Review@localhost" \
  suexec \
  --as bob@example.com \
  -- \
  gerrit approve --verified +1 c0ff33
```

