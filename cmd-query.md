# gerrit query

## NAME
gerrit query - 从 index 中搜索 change

## SYNOPSIS
```
ssh -p <port> <host> gerrit query
  [--format {TEXT | JSON}]
  [--current-patch-set]
  [--patch-sets | --all-approvals]
  [--files]
  [--comments]
  [--commit-message]
  [--dependencies]
  [--submit-records]
  [--all-reviewers]
  [--start <n> | -S <n>]
  [--no-limit]
  [--]
  <query>
  [limit:<n>]
```

## DESCRIPTION

从 index 中搜索 change 并返回匹配的结果。最近更新的 change 会默认排在前面；另外，只对 change 的最新 patch-set 进行搜索。

搜索结果的最大返回上限可以用参数 `limit:` 来控制。如果命令中没有使用此参数，那么系统会用默认参数来对搜索结果进行限制。`--start` 表示忽略前 n 条搜索结果。

不加参数也可以执行搜索。

可以使用匹配的大括号引用值(如：`reviewerin:{Developer Group}`)来回避 2 级 shell 带来的问题 (shell 调用 SSH, SSH 需要在服务器解析)。

## OPTIONS
**--format**
	搜索结果的输出方式。默认是 `TEXT` 格式，也可配置 `JSON` 格式。

**--current-patch-set**
	Include information about the current patch set in the results.
	Note that the information will only be included when the current
	patch set is visible to the caller.

**--patch-sets**
	显示所有 patch-set 的信息。如果与参数 `--current-patch-set` 一起使用，那么 `current patch set` 信息会显示两次。

**--all-approvals**
	显示所有 patch-set 的打分信息。如果与参数 `--current-patch-set` 一起使用，那么 `current patch set` 打分信息会显示两次。

**--files**
	显示所修改的文件列表及文件属性和修改量。

**--comments**
	显示评论信息。如果与参数	`--patch-sets` 一起使用，那么将显示所有 patch-set 的评论。

**--commit-message**
	显示 commit message 

**--dependencies**
	显示依赖与被依赖的 change 信息。

**--all-reviewers**
	信息评审列表中的所有评审人信息，如 name ，email 

**--submit-records**
	显示打分明细

**--start**
**-S**
	忽略前 n 条搜索结果。

**--no-limit**
	返回所有的搜索结果，不做数量上的限制。

**limit:<n>**
	最大返回值

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令。

## EXAMPLES

搜索 tools/gerrit 中 open 状态离当前时间时间最近的两条 change 信息，并以 json 格式显示:
```
$ ssh -p 29418 review.example.com gerrit query --format=JSON status:open project:tools/gerrit limit:2
{"project":"tools/gerrit", ...}
{"project":"tools/gerrit", ...}
{"type":"stats","rowCount":2,"runningTimeMilliseconds:15}
```

不显示 change 号:
```
$ ssh -p 29418 review.example.com gerrit query --format=JSON --start 42 status:open project:tools/gerrit limit:2
{"project":"tools/gerrit", ...}
{"project":"tools/gerrit", ...}
{"type":"stats","rowCount":1,"runningTimeMilliseconds:15}
```

## SCHEMA
JSON 信息可以参考 [JSON 说明](json.md) 

说明，JSON 数据中有的字段有可能会省略，要灵活处理。

## SEE ALSO

* [changes 搜索](user-search.md)
* [JSON Data Formats](json.md)
* [访问控制](access-control.md)

