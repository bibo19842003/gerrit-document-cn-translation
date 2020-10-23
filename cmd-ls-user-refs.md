# gerrit ls-user-refs

## NAME
gerrit ls-user-refs - 显示用户可以访问的 refs

## SYNOPSIS
```
ssh -p <port> <host> gerrit ls-user-refs
  [--project PROJECT> | -p <PROJECT>]
  [--user <USER> | -u <USER>]
  [--only-refs-heads]
```

## DESCRIPTION
显示用户可以访问的 refs

管理员可以查询用户在某个 project 中可以访问的分支信息。

## ACCESS
需要有管理员权限。

## OPTIONS
**--project**
**-p**
	必要; project 的名称

**--user**
**-u**
	必要; 用户名称。

**--only-refs-heads**
	只显示 `refs/heads/` 下面的分支信息

## EXAMPLES

显示 "mr.developer" 可以访问 "gerrit" 中的分支
```
$ ssh -p 29418 review.example.com gerrit ls-user-refs -p gerrit -u mr.developer
```

