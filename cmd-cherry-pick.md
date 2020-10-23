# gerrit-cherry-pick

## NAME
gerrit-cherry-pick - 下载及 cherry-pick change (commit)

## SYNOPSIS
```
gerrit-cherry-pick <remote> <changeid>...
gerrit-cherry-pick --continue | --skip | --abort
gerrit-cherry-pick --close <remote>
```

## DESCRIPTION
下载 change 并 cherry-pick 到本地的当前分支上。

如果 cherry-pick 失败，会提示接冲突，冲突解决后，执行 `gerrit-cherry-pick --continue` 。

需要明确具体的 change id 及 patch-set 号(如 1234/8)，如果不写 patch-set 号，那么 patch-set 号默认为 `/1` 。

`--close` 参数已废弃。

## OBTAINING
可以使用 scp, curl 或 wget 命令下载脚本 `gerrit-cherry-pick` 。

```
  $ scp -p -P 29418 john.doe@review.example.com:bin/gerrit-cherry-pick ~/bin/

  $ curl -Lo ~/bin/gerrit-cherry-pick http://review.example.com/tools/bin/gerrit-cherry-pick
```

