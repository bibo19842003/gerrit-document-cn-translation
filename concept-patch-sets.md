# Patch Sets

[Changes](concept-changes.md) 就是一个 review 状态下的 commit，每个 change 都有一个 change-id。

有时，commit 在评审时，如果执行了 amend 操作，change-id 要是保持不变，并且将 commit 上传到 gerrit 上，那么 gerrit 会认为是同一个 change ，并生成一个新的 patch-set。当 change 合入代码库时，change 的最新 patch-set 会合入到代码库中。 

**NOTE:**
*commit 的时候，把某 change 的 change-id 复制到 commit-msg 的底部，此时可以通过命令行对这个 change 发表评论。*

## File List

打开一个 change 的网页，commit 中所修改的文件会在屏幕的中部显示出来。文件的相关信息会在表格中显示：

* 复选框，用来标识文件已经过浏览
* 文件的修改类型
* 文件的名称和路径
* 文件的添加行数和删除行数

## File modifications

patch-set 中所修改的文件前面会有一个字符，用来标识文件的修改类型。下面的表格列举了相关类型：

|Letter|Modification Type|Definition
| :------| :------| :------|
|M|修改|修改文件中的内容
|A|添加|新增文件
|D|删除|删除文件
|R|重命名|文件重新命名
|C|复制|复制新的文件

如果类型是 *R* (更名) 或 *C* (复制), 那么在文件名称下面会显示原先文件的名称和路径。

## Views

默认情况下，Gerrit 只显示 change 的最新的 patch-set，如果要查看历史版本的 patch-set，可以点击 `PatchSet` 的下拉菜单。

## Diffs

点击列表中的文件，会打开一个显示此文件修改内容（差异）的页面。点击 `Show Diffs` 链接，会把所有文件的修改内容（差异）都显示出来。

可以点击 `Diff Against` 下拉菜单，然后比较两个 patch-set 的差异。

## Description

gerrit 上的每个 change 都有描述，此描述来自 commit-msg。

另外可以手动对 patch-set 添加描述，这个描述可以协助评审人员表达自己的意愿，如：增加更多的单元测试。与 change 描述不同的是，patch-set 描述不会在 commit 的历史记录中出来。

点击 `Add a patch set description` 链接可以为 patch-set 添加描述。

