# not valid ref

推送时，如果目标分支的格式不正确，会报此错误，如目标分支错误的写成了： '/refs/for/master'，'refs/for//master'。

为了解决此问题，需要正确书写目标分支。commit 走评审和不走评审 ref 格式是不一样的：


## commit 需要走评审:

此时目标分支的格式为：`refs/for/branch` 

如：

```
$ git push ssh://JohnDoe@host:29418/myProject HEAD:refs/for/master
```


## commit 直接合入代码库:

此时目标分支的格式为：`branch` 

如：
```
$ git push ssh://JohnDoe@host:29418/myProject HEAD:master
```


