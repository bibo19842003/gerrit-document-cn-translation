# git-receive-pack

## NAME
git-receive-pack - 接收往 project 推送的对象。

## SYNOPSIS
```
_git receive-pack_
  [--reviewer <address> | --re <address>]
  [--cc <address>]
  <project>
```

## DESCRIPTION
被 'git push' 命令调用，并更新 project，执行 'git push' 命令的时候，会返回相关结果。

## OPTIONS

**<project>**
	project 的名称。

**--reviewer <address>**
**--re <address>**
	此参数已废弃

**--cc <address>**
	此参数已废弃

## ACCESS
需要 SSH 访问权限

## EXAMPLES

向 charlie@example.com 推送一个评审任务:
```
git push ssh://review.example.com:29418/project HEAD:refs/for/master%r=charlie@example.com
```

向 charlie@example.com 推送一个 topic 为 bug42 的评审任务:
```
git push ssh://review.example.com:29418/project HEAD:refs/for/master%r=charlie@example.com,topic=bug42
```

添加抄送人员:
```
git push ssh://review.example.com:29418/project HEAD:refs/for/master%r=charlie@example.com,cc=alice@example.com,cc=bob@example.com
```

配置 git 的 宏命令:
```
git config remote.charlie.url ssh://review.example.com:29418/project
git config remote.charlie.push HEAD:refs/for/master%r=charlie@example.com,cc=alice@example.com,cc=bob@example.com
```

查看 `.git/config` 内容:
```
[remote "charlie"]
 url = ssh://review.example.com:29418/project
 push = HEAD:refs/for/master%r=charlie@example.com,cc=alice@example.com,cc=bob@example.com
```

可以使用命令的简写来发送评审，主送 charlie, 抄送 alice 和 bob :
```
git push charlie
```

## SEE ALSO

* [上传 changes](user-upload.md)

