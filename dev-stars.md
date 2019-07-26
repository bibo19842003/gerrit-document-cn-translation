# Gerrit Code Review - Stars

## Description

Change 可以根据个人喜好来添加星标。不过加星标的 change 只有操作人自己可以看到。

Stars 可以帮助用户按照自己的标准把 change 分类，并且可以利用搜索操作在 [Dashboards](user-dashboards.md) 上显示相关 change。

## Star API

[star 的 REST API](rest-api-accounts) 支持如下:

* [get star labels from a change](rest-api-accounts.md)
* [update star labels on a change](rest-api-accounts.md)
* [list changes that are starred by any label](rest-api-accounts.md)

另外，也可以通过 [ChangeInfo](rest-api-changes.md) 和 [changes REST API](rest-api-changes.md) 来获取具有星标标识的 change。

只有 `default star` 可以在 WebUI 中显示。`default star` 可以参考 [REST endpoints](rest-api-accounts.md) 相关章节。

## Default Star

如果用户对 change 设置了 `default star`，change 有更新的时候，此用户可以收到相关的邮件通知。

`default star` 可以在 WebUI 中显示。

`default star` 由一个特殊的星标 'star' 进行标识。

## Ignore Star

如果用户对 change 取消了 star 的设置，change 有更新的时候，此用户不会再收到相关的邮件通知，即使此用户是 change 的评审人员也不会收到邮件通知。

由于 change 只能在创建后被忽略；用户 watch project 后，如有新的 change 生成，那么用户会收到相关邮件通知，只有此时的 change 才可以标识为 `ignore`。

用户向 change 添加了评审人员，但之前评审人员对此 change 进行了 `ignore` 的设置，如果被添加的评审人员想继续收到此 change 的邮件通知，那么需要评审人员移除 `ignore`。

忽略的星标由 'ignore' 进行标识。

## Reviewed Star

如果用户对 "reviewed/<patchset_id>" 添加了标识，并且 <patchset_id> 是当前 change 的最新 patch-set，那么 change 会在 changeinfo 栏中显示 "reviewed"。

## Unreviewed Star

如果用户对 "unreviewed/<patchset_id>" 添加了标识，并且 <patchset_id> 是当前 change 的最新 patch-set，那么 change 会在 changeinfo 栏中显示 "unreviewed"。

## Query Stars

下面是搜索星标 change 的方法：

* 请参考 [changes 搜索](user-search.md) 的 `star` 相关章节。

## Syntax

星标的名称中不能有空白。

