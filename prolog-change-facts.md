# Prolog Facts for Gerrit Changes

在为 change 调用 `submit_rule(X)` 查询之前，Gerrit 使用 change 的属性信息（当前数据）初始化 Prolog。下表提供了供属性的描述。

**IMPORTANT:**
*下面列出的术语在 `gerrit` package 中有定义，要使用它们中的任何一个，必须使用像 `gerrit:change_branch(X)` 这样规范的名称。*

Prolog facts about the current change

|Fact                 |Example  |Description | Variable type
| :------| :------| :------| :------|
|`change_branch/1`    |`change_branch('refs/heads/master').`    | change 合入的目的分支 | string
|`change_owner/1`     |`change_owner(user(1000000)).`    | change-owner 的 `user(ID)` | numeric
|`change_project/1`   |`change_project('full/project/name').`    | project 的名称 | string
|`change_topic/1`     |`change_topic('plugins').`    | Topic 名称 | string
|`commit_author/1`    |`commit_author(user(100000)).`    |commit 的 author `user(ID)` | numeric
|`commit_author/3`    |`commit_author(user(100000), 'John Doe', 'john.doe@example.com').`    |ID, full name 以及 commit 的 author 邮箱 | numeric string string
|`commit_committer/1` |`commit_committer(user(100000)).`    |commit 的 committer `user(ID)` | numeric
|`commit_committer/3` |`commit_committer(user(100000), 'John Doe', 'john.doe@example.com').`    |ID, full name 以及 commit 的 committer 邮箱 | numeric string string
|`commit_label/2`  |`commit_label(label('Code-Review', 2), user(1000000)).` ; `commit_label(label('Verified', -1), user(1000001)).`| change 的最新 patch-set 的打分情况 | --
|`commit_message/1`   |`commit_message('Fix bug X').`    | Commit message | string
|`commit_parent_count/1`   |`commit_parent_count(1).`    |Nparent commits 的数量，可以用来检测 `merge commits`
|`commit_stats/3`   |`commit_stats(5,20,50).`    | 修改行数, 添加行数，删除行数 | --
|`files/3` |`files(file('modules/jgit', 'A', 'SUBMODULE')).`, `files(file('a.txt', 'M', 'REGULAR')).` | file 的 3 个参数：第一个是文件名称；第二个参数是文件的修改方式（'A' 添加, 'M' 修改, 'D'删除, 'R' 重命名, 'C' 复制，'W' 'rewrite'）；第三个参数为文件的子模块类型（'SUBMODULE' 子模块文件，'REGULAR' 非子模块文件）| |
|`pure_revert/1`     |`pure_revert(1).`    | change 是否 revert，1 为 revert，0 为非 revert | --
|`uploader/1`     |`uploader(user(1000000)).`    | Uploader 的 `user(ID)`  | numeric
|`unresolved_comments_count/1`     |`unresolved_comments_count(0).`    | 未解决的评论数量 | integer


另外，gerrit 提供了内置帮助手册，可以帮助 `submit_rule` 的使用。常见的信息如下表所示。

Built-in Prolog helper predicates

|Predicate                  |Example usage  |Description
| :------| :------| :------|
|`commit_delta/1`           |`commit_delta('\\.java$').`    | 正则表达式如果匹配到 patch-set 中所修改的文件，则为 True
|`commit_delta/3`           |`commit_delta('\\.java$', T, P)`    | 返回 change 中所修改文件的类型 (via `T`) 和路径 (via `P`)。如果所修改文件的类型是 `delete`, 那么会返回老的路径；如果是 `rename`, 那么反回新老两个路径；如果是 `copy`, 那么返回新路径。    有效的类型如下：`add`, `modify`, `delete`, `rename`, `copy`
|`commit_delta/4`           |`commit_delta('\\.java$', T, P, O)`    | 如果适用的话，同 `commit_delta/3` ，在加上老路经 (via `O`)
|`commit_edits/2`           |`commit_edits('/pom.xml$', 'dependency')`    | 第一个参数为正则表达式匹配到的文件，第二个参数为文件修改处匹配到的字符串，如果二者都匹配上，则为 True。如果文件名regex（第一个参数）匹配的任何文件具有与第二个参数中的正则表达式匹配的已编辑行，则为 True。如果 `pom.xml` 文件的修改处包含字符串 'dependency'，则为true。
|`commit_message_matches/1` |`commit_message_matches('^Bug fix')`    | 正则表达式如果 commit-msg 中的信息，则为 True


**NOTE:**
*若要了解 `gerrit_common.pl` 和所有 Gerrit 源代码中匹配的 `PRED_*.java` Java 类，请阅读内置帮助手册。*

