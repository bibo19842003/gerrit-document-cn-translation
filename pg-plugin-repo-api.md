# Gerrit Code Review - Repo admin customization API

此 API 由 [plugin.repo()](pg-plugin-dev.md) 提供，并可以对管理员页面进行定制化处理。

## createCommand
`repoApi.createCommand(title, checkVisibleCallback)`

在管理员面板创建 repo 命令

_Params_
- *title* ：String ，title 名称
- *checkVisibleCallback* ：function ，用来设置命令是否可见

_Returns_
- GrRepoApi for chaining.

`checkVisibleCallback(repoName, repoConfig)`

_Params_
- *repoName* ：String ，project 名称.
- *repoConfig* ：Object REST API response for repo config.

_Returns_
- `false` ：为指定的 project 隐藏命令

## onTap
`repoApi.onTap(tapCalback)`

添加命令点击

_Params_
- *tapCallback* ：function ，执行命令点击

_Returns_
- Nothing

