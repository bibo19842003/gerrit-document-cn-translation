# gerrit ls-projects

## NAME
gerrit ls-projects - 列出用户可以看到的 project

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit ls-projects_
  [--show-branch <BRANCH> ...]
  [--description | -d]
  [--tree | -t]
  [--type {code | permissions | all}]
  [--format {text | json | json_compact}]
  [--all]
  [--limit <N>]
  [--prefix | -p <prefix>]
  [--has-acl-for GROUP]
```

## DESCRIPTION
显示用户可以看到的 project，每行显示一条信息。

如果用户是管理员，那么会列出所有的 project。

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令。

## OPTIONS
**--show-branch**
**-b**
	显示含有此分支的 project 列表。
	如果分支不存在或者没有分支的读权限，那么会显示 40 个 `-`。
	如果 project 中的所有分支没有读权限，那么不会显示 project 的名字。

**--description**
**-d**
	显示 project 的描述信息

所有的非显示字符(ASCII 值小于等于 31)会根据语言类型(C, Python, Perl)进行转义输出，如：`\n` and `\t`, `\xNN` 等。shell 脚本中, `printf` 命令可以进行非转义输出。

**--tree**
**-t**
	树状格式显示 project。
	此参数不能与 show-branch 参数一起使用。

**--type**
	显示指定类型的 project。默认的参数值是  `all`。

```
`code`  没有 `--permissions-only` 标识的 project
`permissions`  具有 `--permissions-only` 标识的 project
`all`  所有类型
```

**--format**
	输出格式

```
`text`:: 文本格式
`json`:: json 格式
`json_compact`:: 最小 JSON 格式
```

**--all**
	显示用户可见的所有 project。

**--limit**
	输出 project 个最大个数

**--prefix**
	输出前缀开头的 project

**--has-acl-for**
	显示给某群组配置权限的 project 列表。被继承的 project 不显示。

 此参数可以看出 group 在哪些 project 中进行了配置。

## HTTP
此命令用于 HTTP, `/projects/` 用于匿名用户访问，`/a/projects/` 用于认证用户访问。`/projects/external/` 列出的是以 `external/` 开头的 project。

如果 HTTP header 是 `Accept: application/json` ，那么输出 `json_compact` 格式。如果输出格式是 JSON ，那么需要忽略首行，因为首行是阻止浏览器执行的标识。

如果客户端的 request headers 是 `Accept-Encoding: gzip`，那么输出的 gzip 的压缩包。

## EXAMPLES

显示用户可见的 project:
```
$ ssh -p 29418 review.example.com gerrit ls-projects
platform/manifest
tools/gerrit
tools/gwtorm

$ curl http://review.example.com/projects/
platform/manifest
tools/gerrit
tools/gwtorm

$ curl http://review.example.com/projects/tools/
tools/gerrit
tools/gwtorm
```

下载用户可见的 project:
```
for p in `ssh -p 29418 review.example.com gerrit ls-projects`
do
  mkdir -p `dirname "$p"`
  git clone --bare "ssh://review.example.com:29418/$p.git" "$p.git"
```

## SEE ALSO

* [访问控制](access-control.md)

