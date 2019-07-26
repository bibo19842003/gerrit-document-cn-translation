# One or more refs/for/ names blocks change upload

由于服务器端的 project 有 `refs/for/` 开头的分支，当向这个 project 推送新的 change 时，会报此错误。

Gerrit 服务器端使用 `refs/for/` 命名空间用于存储 change 的相关信息，如果分支以此开头，那么会产生混淆，所以不建议创建 `refs/for/` 开头的分支。

为了解决上面的报错信息，可以将服务器的 project 中 `refs/for/` 开头的分支删除或重命名。

管理员可以使用下面的命令来查看 project 中以 `refs/for/` 开头的分支：

```
  $ git for-each-ref refs/for
```

如果要删除以  `refs/for/`  开头的分支，可以执行下面命令：

```
  $ for n in $(git for-each-ref --format='%(refname)' refs/for);
    do git update-ref -d $n; done
```

用户可以通过 push 命令直接在服务器端创建以 'refs/for/' 开头的分支。

