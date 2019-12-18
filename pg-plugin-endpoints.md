# Gerrit Code Review - PolyGerrit Plugin Styling

plugin 应该以 html 为基础并按照下面的[指导](pg-plugin-dev.md)进行导入。

测试的 endpoint 代码示例：

``` js
Gerrit.install(plugin => {
  // Change endpoint below
  const endpoint = 'change-metadata-item';
  plugin.hook(endpoint).onAttached(element => {
    console.log(endpoint, element);
    const el = element.appendChild(document.createElement('div'));
    el.textContent = 'Ah, there it is. Lovely.';
    el.style = 'background: pink; line-height: 4em; text-align: center;';
  });
});
```

## Default parameters

所有的 endpoint 或接收下面的参数，用来为定制组件设置相关的属性：

* `plugin`

当前的 plugin 实例, 通过 `Gerrit.install()` 来使用。

* `content`

DOM 元素，用于现有组件的注册。

## Plugin endpoints

下列的 endpoint 对 plugin 可使用。

### banner

`banner` 的扩展点在页面的顶部。用来向用户显示一些通知信息。 

### change-view-integration

`change-view-integration` 扩展点在 change 页面的 `Files` 和 `Messages` 之间。用来显示 CI 相关的信息。

* `change`

显示当前的 change，相关信息可参考 [ChangeInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

* `revision`

显示当前 change 的 revision，相关信息可参考 [RevisionInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

### change-metadata-item

`change-metadata-item` 扩展点在 change 左侧面板的底部，在 `Label Status` 和 `Links` 部分的下面。用于 plugin 添加 metadata 的信息。

另外，可以使用如下默认参数

* `change`

显示当前的 change，相关信息可参考 [ChangeInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

* `revision`

显示当前 change 的 revision，相关信息可参考 [RevisionInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

* `labels`

显示打分项和相关的打分。

### robot-comment-controls

`robot-comment-controls` 扩展点位于每个评论的内部，只有 robot 评论的时候才能呈现，因为需要评论的 `robot_id` 属性。

另外，可以使用如下默认参数

* `comment`

显示当前的评论，相关信息可参考 [CommentInfo](rest-api-changes.md) 的 `CommentInfo` 相关章节。

### repo-command

此 endpoint 位于 repository 命令之间。

另外，可以使用如下默认参数

* `repoName`

配置的仓库的名称

* `config`

仓库的配置

### repo-config

`repo-config` 扩展点位于仓库配置的底部。

另外，可以使用如下默认参数

* `repoName`

配置的仓库的名称

* `readOnly`

配置 repository 是否为只读。

### settings-menu-item
此扩展点位于 setting 部分的导航菜单的末尾。

### settings-screen
此扩展点位于 setting 部分的末尾。

### reply-text
此扩展点在 reply 对话框中的文本区域。

### reply-label-scores
此扩展点在 reply 对话框的打分按钮区域。

### header-title
此扩展点标题处。

### confirm-revert-change
此扩展点在 rever 对话框的内部。默认为 revert change 的相关确认信息。plugin 可以在此添加相关内容或者替换此信息。

### confirm-submit-change

此扩展点在提交对话框的内部。默认显示 change 提交的确认信息。plugin 可以修改此处的默认信息。

另外，可以使用如下默认参数

* `change`

即将被提交的 change，相关信息可参考 [ChangeInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

* `action`

提交的行为操作，包括 title 和 label，相关信息可参考 [ActionInfo](rest-api-changes.md) 的 `ActionInfo` 相关章节。

## Dynamic Plugin endpoints

下面的 endpoint 可以被 plugin 使用。

### change-list-header
`change-list-header` 扩展点用于向 change 列表中添加头部信息。

### change-list-item-cell
`change-list-item-cell` 扩展点用于向 change 列表添加单元格。

另外，可以使用如下默认参数

* `change`

列表中每行的 change，相关信息可参考 [ChangeInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

### change-view-tab-header

`change-view-tab-content` 扩展点可以为 change 页面添加标签页。使用时，需要关联 `change-view-tab-content`。

另外，可以使用如下默认参数

* `change`

显示当前的 change，相关信息可参考 [ChangeInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

* `revision`

显示当前 change 的 revision，相关信息可参考 [RevisionInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

### change-view-tab-content

`change-view-tab-content` 扩展点可以为 change 页面添加标签页。使用时，需要关联 `change-view-tab-header`。

另外，可以使用如下默认参数

* `change`

显示当前的 change，相关信息可参考 [ChangeInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

* `revision`

显示当前 change 的 revision，相关信息可参考 [RevisionInfo](rest-api-changes.md) 的 `ChangeInfo` 相关章节。

