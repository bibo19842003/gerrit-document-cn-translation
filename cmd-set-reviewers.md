# gerrit set-reviewers

## NAME
gerrit set-reviewers - 添加或移除评审人员

## SYNOPSIS
```
ssh -p <port> <host> gerrit set-reviewers
  [--project <PROJECT> | -p <PROJECT>]
  [--add <REVIEWER> ... | -a <REVIEWER> ...]
  [--remove <REVIEWER> ... | -r <REVIEWER> ...]
  [--]
  {CHANGE-ID}...
```

## DESCRIPTION
对 change 添加或移除评审人员。

## OPTIONS

**--project**
**-p**
	change 所在的 project 名称。必要参数。

**--add**
**-a**
	添加评审人员。可以添加具体的帐号或者群组。

**--remove**
**-r**
	移除评审人员。可以移除具体的帐号或者群组。

**--help**
**-h**
	显示帮助信息

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令。

## EXAMPLES

对 change Iac6b2ac2 添加评审人员 alice 和 bob，移除评审人员 eve 。
```
$ ssh -p 29418 review.example.com gerrit set-reviewers \
  -a alice@example.com -a bob@example.com \
  -r eve@example.com \
  Iac6b2ac2
```

对 "graceland" 的 1935 号 change 添加评审人员 elvis
```
$ ssh -p 29418 review.example.com gerrit set-reviewers \
  --project graceland \
  -a elvis@example.com \
  1935
```

对 change Iac6b2ac2 添加此 project 的 owner 作为评审人员
```
$ ssh -p 29418 review.example.com gerrit set-reviewers \
  -a "'Project Owners'" \
  Iac6b2ac2
```

对 13dff08acca571b22542ebd2e31acf4572ea0b86 添加此 project 的 owner 作为评审人员
```
$ ssh -p 29418 review.example.com gerrit set-reviewers \
  -a "'Project Owners'" \
  13dff08acca571b22542ebd2e31acf4572ea0b86
```

