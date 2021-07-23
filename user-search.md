# Gerrit Code Review - Searching Changes

## Default Searches

大多数的基本 search 在页面上右上方点击 `search` 按钮来完成，在搜索框中会预制一个搜索字符串，点击 `search` 按钮后，会显示搜索结果。

| Description          |  Default Query 
| :------| :------|
|All > Open           | status:open '(or is:open)'
|All > Merged         | status:merged
|All > Abandoned      | status:abandoned
|My > Watched Changes | is:watched is:open
|My > Starred Changes | is:starred
|My > Draft Comments  | has:draft
|Open changes in Foo  | status:open project:Foo

## Basic Change Search

和其他 web 搜索引擎类似，输入一些字符，然后进行搜索：

|Description                      | Examples
| :------| :------|
|Legacy numerical id              | 15183
|Full or abbreviated Change-Id    | Ic0ff33
|Full or abbreviated commit SHA-1 | d81b32ef
|Email address                    | user@example.com

对于搜索 change (如： numerical id, Change-Id, commit SHA-1), 如果结果是一条 chang 的话，那么直接会跳转到这个 change 的页面。

关于搜索，可以参考本文下面章节的描述。

## Search Operators

搜索是由条件限制的，需要按照一定的规则来执行。不是随意的输入，就可以搜索到预期的结果。输入的查询字符，需要与查询字段对应的。

**age:'AGE'**

 描述的是 change 最后一次更新(包括新的评论或新的 patch-set)经历的时间。时间需要加上单位，如： `-age:2d`:

 * s, sec, second, seconds
 * m, min, minute, minutes
 * h, hr, hour, hours
 * d, day, days
 * w, week, weeks (`1 week` 等于 `7 days`)
 * mon, month, months (`1 month` 看作是 `30 days`)
 * y, year, years (`1 year` 看作是 `365 days`)

`age` 可以用来向前或向后进行搜索：`age:2d` 表示大于 2 days，`-age:2d` 表示最多 2 days。

**assignee:'USER'**

 Change 的处理人。

**attention:'USER'**

需要提醒的用户。

**before:'TIME'/until:'TIME'**

　在 'TIME'　之**前**所修改的 change．格式为： `2006-01-02[ 15:04:05[.890][ -0700]]`; 时间默认为 00:00:00 ；时区默认为： UTC.

**after:'TIME'/since:'TIME'**

　在 'TIME'　之**后**所修改的 change．格式为： `2006-01-02[ 15:04:05[.890][ -0700]]`; 时间默认为 00:00:00 ；时区默认为： UTC.

**mergedbefore:'TIME'**

  'TIME' 之前 merged 的 change，与 `before:'TIME'` 相同。

**mergedafter:'TIME'**

  'TIME' 之后 merged 的 change，与 `after:'TIME'` 相同。

**change:'ID'**

 使用 change 的 'ID' (不是change-id) 进行搜索，如： 15183．

**conflicts:'ID'**

 和搜索 change 相冲突的 change ．使用 'ID' (不是change-id) 进行搜索，如：15183．

**destination:'[name=]NAME[,user=USER]'**

 使用具体的用户名搜索 change。如 'USER' 为指定，那么为当前用户。可以参考 [Named Destinations](user-named-destinations.md)

**owner:'USER', o:'USER'**

 根据 owner 来搜索 change。`owner:self` ，owner 此处默认是当前用户。

**ownerin:'GROUP'**

 把用户组内的成员作为 owner 来搜索 change。

**query:'NAME'**

 使用具体的用户名搜索 change。如 'USER' 为指定，那么为当前用户。可以参考 [Named Queries](user-named-queries.md)

**reviewer:'USER', r:'USER'**

 需要被某人评审的 change。特殊情况 `reviewer:self` ，需要被当前登录人员评审的 change。

**cc:'USER'**

 根据 cc 用户进行搜索。

**revertof:'ID'**

 revert 后，产生的新 change。

**submissionid:'ID'**

Change 的 submission 'ID'.

**reviewerin:'GROUP'**

 需要被某组成员评审的 change。

**commit:'SHA-1'**

 通过 commit-id 来搜索 Change。

**project:'PROJECT', p:'PROJECT'**

 通过 project 搜索 change。如果使用则在表达式，要以 `^` 开头，可以参考 [dk.brics.automatonlibrary](http://www.brics.dk/automaton/)。

**projects:'PREFIX'**

 通过 'PREFIX' 开头的 project 搜索 change。

**parentof:'ID'**
  查询 'ID' 的 parent change。查询结果只返回 parent change。

**parentproject:'PROJECT'**

 子孙 project 中搜索 change。

**repository:'REPOSITORY', repo:'REPOSITORY'**

 通过 project 搜索 change。如果使用则在表达式，要以 `^` 开头，可以参考 [dk.brics.automatonlibrary](http://www.brics.dk/automaton/)。

**repositories:'PREFIX', repos:'PREFIX'**

 通过 'PREFIX' 开头的 project 搜索 change。

**parentrepository:'REPOSITORY', parentrepo:'REPOSITORY'**

 子孙 project 中搜索 change。

**branch:'BRANCH'**

 通过 branch 搜索 change。如果使用则在表达式，要以 `^` 开头，可以参考 [dk.brics.automatonlibrary](http://www.brics.dk/automaton/)。

**intopic:'TOPIC'**

 通过 TOPIC 模糊搜索 change。如果使用则在表达式，要以 `^` 开头，可以参考 [dk.brics.automatonlibrary](http://www.brics.dk/automaton/)。

**topic:'TOPIC'**

 通过 TOPIC 精确搜索 change。

**hashtag:'HASHTAG'**

 通过 'HASHTAG' 搜索 change。

**cherrypickof:'CHANGE[,PATCHSET]'**

通过 'cherry-pick' 方式生成的 change，用来匹配源 change 的 change-id 和 patchset 信息。
'PATCHSET' 是可选参数。例如，`cherrypickof:12345` 会匹配从 `change 12345` cherry-picked 的 change；`cherrypickof:12345,2` 会匹配从 `change 12345` 的 `第2个 patchset` cherry-picked 的 change。

**ref:'REF'**

 通过 branch 搜索 change，不过，此处 branch 要以 'REF' 开头。如果使用则在表达式，要以 `^` 开头，可以参考 [dk.brics.automatonlibrary](http://www.brics.dk/automaton/)。

**tr:'ID', bug:'ID'**

 通过 commit-message 中的 tr/bug 'ID' 进行搜索。

**label:'VALUE'**

 搜索某打分项打分通过的 change。

**message:'MESSAGE'**

 通过 'MESSAGE' 搜索 change。

**comment:'TEXT'**

 通过评论搜索 change。

**path:'PATH'**

 根据文件路径搜索 change。如果使用则在表达式，要以 `^` 开头，可以参考 [dk.brics.automatonlibrary](http://www.brics.dk/automaton/)。例如匹配所有的 XML 文件  `file:^.*\.xml$`；匹配多个 XML 文件  'name1.xml', 'name2.xml', 和 'name3.xml' ，格式为： `file:"^name[1-3].xml"`。

 斜线 ('/') 用作路径分割。

 例如：
* `-file:^path/.*` - 在 `path/` 路径下修改文件的 change。
* `file:{^~(path/.*)}` - 未在 `path/` 路径下修改文件的 change。

**file:'NAME', f:'NAME'**

 通过文件搜索 change。

**extension:'EXT', ext:'EXT'**

 通过文件扩展名来搜索 change。

**onlyextensions:'EXT_LIST', onlyexts:'EXT_LIST'**

 通过文件扩展名的列表来搜索 change。

**directory:'DIR', dir:'DIR'**

 根据文件路径搜索 change。

**footer:'FOOTER'**

 根据 commit-msg 底部的信息搜索 change。'FOOTER' 格式为 '<key>: <value>' 或 '<key>=<value>'。

**star:'LABEL'**

 搜索当前用户关注的 change。'LABEL' 为 `ignore` 或 `star`。

 'star:star' 等同于 'has:star' 和 'is:starred'.

**has:draft**

 搜索当前用户 draft 状态的 change。

**has:star**

 搜索当前用户关注的 change。

**has:stars**

 搜索当前用户关注的 change。

**has:edit**

 搜索当前用户在线编辑过的 change。

**has:unresolved**

 搜索当前用户含有 unresolved 状态的 change。

**is:assigned**

 搜索已经有分配人员的 change。

**is:starred**

 搜索当前用户关注的 change。

**is:unassigned**

 搜索没有分配人员的 change。

**is:watched**

 搜索当前用户 watched 的 change。

**is:reviewed**

 搜索被评审过的 change。

**is:owner**

 搜索当前用户是 owner 的 change。等同于 `owner:self`.

**is:reviewer**

 搜索当前用户是 reviewer 的 change。等同于 `reviewer:self`.

**is:cc**

  根据 cc 当前用户进行搜索。

**is:open, is:pending, is:new**

 搜索 open/pending 状态的 change。

**is:closed**

 搜索 closed 状态的 change。包括 merged 和 abandoned 状态的 change。

**is:merged, is:abandoned**

 搜索 merged/abandoned 状态的 change。

**is:submittable**

 搜索可以点击 submit 按钮的 change。

**is:mergeable**

 搜索可以点击合入到代码库 change。如果 Gerrit 的 index 配置了 'mergeable'，才能使用此搜索。可以参考 [Gerrit 配置](config-gerrit.md) 的 'indexMergeable' 部分。

**is:ignored**

 搜索被当前用户设置 ignored 状态的 change。等同于 `star:ignore`.

**is:private**

 搜索 private 状态的 change。

**is:wip**

 搜索 wip 状态的 change。

**is:merge**

 如果 change 是 merge 节点的话，则为 True

**status:open, status:pending, status:new**

 搜索 open/pending 状态的 change。

**status:reviewed**

 搜索评审过的 change。

**status:closed**

 搜索 merged 和 abandoned 状态的 change。

**status:merged**

 搜索 merged 状态的 change。

**status:abandoned**

 搜索 abandoned 状态的 change。

**added:'RELATION''LINES', deleted:'RELATION''LINES', delta/size:'RELATION''LINES'**

 根据修改量（添加/删除行数）来搜索 change。

 例如：added:>50 搜索至少添加 50 行的修改。

**commentby:'USER'**

 搜索某人评论过的 change。

**from:'USER'**

 搜索某人评论过的 change。等同于 `owner:USER 或 commentby:USER`。

**reviewedby:'USER'**

 搜索某人评论过的 change。

**author:'AUTHOR'**

 根据 author 搜索 change。'AUTHOR' 可以是用户名称或邮箱地址。

**committer:'COMMITTER'**

 根据 committer 搜索 change。'COMMITTER' 可以是用户名称或邮箱地址。

**submittable:'SUBMIT_STATUS'**

 根据 submit-record-status 搜索 change。`status` 可以参考 [rest-api-changes](rest-api-changes.md) 的 SubmitRecord 部分。

**unresolved:'RELATION''NUMBER'**

 根据 unresolved 的数量搜索 change。

 例如：unresolved:>0 表明至少有 1 个 unresolved。

## Argument Quoting

引用需要使用双引号 `message:"the value"` ，或者使用大括号  `message:{the value}`。

## Boolean Operators

默认使用 `AND` 联合多条件搜索。

OR 的优先级高于 AND.

### Negation
 `-` 表示取反，如：`-is:starred` 与 `is:starred` 相反。

 `-` 等同于 `NOT` 。

### AND
 `AND` 用于联合搜索。

### OR
 `OR` 用于联合搜索。

## Labels
可以通过 Label 名称进行搜索。如：`Code-Review` 。

label 参考如下:

 * label 名称，如：`label:Code-Review`.

 * label 名称后面跟随 ','和 reviewer-id 或 group-id。表明用户或者组是否做了对应的评审。

label 名字后必须要有分值或状态描述。

首先, 一些例子如下：

**`label:Code-Review=2`**
**`label:Code-Review=+2`**
**`label:Code-Review+2`**

用来匹配 Code-Review 至少有一个 +2。其中，不一定要有 `=` 。

**`label:Code-Review=-2`**
**`label:Code-Review-2`**

用来匹配 Code-Review 至少有一个 -2。其中，不一定要有 `=` 。

**`label:Code-Review=1`**

用来匹配 Code-Review 至少有一个 +1。+2 或更高分值不进行匹配。

**`label:Code-Review>=1`**

匹配 +1, +2, 或更高分值。

同样，可以用 label 的状态描述来代替分值进行搜索。可以参考 [rest-api-changes](rest-api-changes.md) 的 SubmitRecord 部分。

**`label:Non-Author-Code-Review=need`**

需要进行 `Non-Author-Code-Review` 打分的 change。`Non-Author-Code-Review` 可以参考 [Prolog Cookbook](prolog-cookbook.md) 的 NonAuthorCodeReview 部分。

**`label:Code-Review=+2,aname`**
**`label:Code-Review=ok,aname`**

匹配 Code-Review 打了 +2 的人员或者组。

**`label:Code-Review=2,user=jsmith`**

匹配 jsmith 给 Code-Review 打了 +2 的 change。

**`label:Code-Review=+2,user=owner`**
**`label:Code-Review=ok,user=owner`**
**`label:Code-Review=+2,owner`**
**`label:Code-Review=ok,owner`**

匹配 owner 给 Code-Review 打了 +2 的 change。

**`label:Code-Review=+1,group=ldap/linux.workflow`**

匹配 +1 以及评审人员在 ldap/linux.workflow 群组中的 change。

**`label:Code-Review\<=-1`**

匹配 -1, -2, 或更低打分。

**`is:open label:Code-Review+2 label:Verified+1 NOT label:Verified-1 NOT label:Code-Review-2`**
**`is:open label:Code-Review=ok label:Verified=ok`**

匹配可以点击 submit 按钮的 change。

**`is:open (label:Verified-1 OR label:Code-Review-2)`**
**`is:open (label:Verified=reject OR label:Code-Review=reject)`**

匹配禁止合入的 change。

## Magical Operators

搜索的结果是受权限控制的。

**visibleto:'USER-or-GROUP'**

因为受权限控制的原因，不同的用户返回的搜索结果有可能不一致。对于 LDAP 群组格式 `visibleto:"CN=Developers, DC=example, DC=com"`。

**is:visible**

 搜索用户可以访问的 change。默认为当前用户。

**starredby:'USER'**

 搜索某人 star 的 change。

**watchedby:'USER'**

 搜索某人 watch 的 change。

**draftby:'USER'**

 搜索某人发布 draft-comment 的 change。

**limit:'CNT'**

 每页最多显示多少条搜索结果。

