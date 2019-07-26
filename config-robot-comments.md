# Gerrit Code Review - Robot Comments

Gerrit 支持第三方系统自动对 change 发布 `inline comments`，因此称为 `robot comments`。例如，`robot comments` 可以用作工具对代码的分析。

In addition it is
planned that robot comments can contain fixes, that users can apply by
a single click.

常规 `inline comments` 比较自由，没有固定的格式；然后，`robot comments` 却更加结构化，可以包含一些种类的数据，例如：robot ID，robot run ID，URL 等。具体信息可以参考 [api change](rest-api-changes.md) 的 `RobotCommentInfo` 部分。

计划在网页中，将 `robot comments` 进行可视化，并将其与手动的评论进行区分；用户还可以过滤 `robot comments`，然后将过滤结果显示出来；`robot comments` 还可以包含修复功能，点击按钮就可解决问题。

## REST endpoints

* 发布 `robot comments`，可以参考 [api change](rest-api-changes.md) 的 `review-input` 部分。
* 列举 `robot comments`，可以参考 [api change](rest-api-changes.md) 的 `list-robot-comments` 部分。
* 查看 `robot comments`，可以参考 [api change](rest-api-changes.md) 的 `get-robot-comment` 部分。

## Storage

`robot comments` 存储在 changes 的命名空间下，如：`refs/changes/XX/YYYY/robot-comments`。

若要删除 `robot comments` 的话，可以删除此命名空间。

## Limitations

* `robot comments` 在网页上不显示
* 不支持 draft robot comments，但是 `robot comments` 可以被发布并且在 change 页面上可以查看。

