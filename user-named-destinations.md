# Gerrit Code Review - Named Destinations

## User Named Destinations
可以在用户层级定义 `Named Destinations`。在 `All-Users` 中的 `refs/users` 目录进行设置。用户的 ref 格式为 `refs/users/nn/accountid`，其中 `nn` 为 accountid 的后两位。destination 文件分为两列，用 `tab` 分隔，左侧表示目的分支名称，右侧表示 project 名称。

例如： destination file named `destinations/myreviews`:

```
# Ref            	Project
#
refs/heads/master	gerrit
refs/heads/stable-2.11	gerrit
refs/heads/master	plugins/cookbook-plugin
```

