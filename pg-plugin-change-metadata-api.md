# Gerrit Code Review - Change metadata plugin API

此 API 由 此 API 由 [plugin.changeMetadata()](pg-plugin-dev.md) 提供，为定制和 change 的 metadata 更新提供了接口。

## onLabelsChanged
`changeMetadataApi.onLabelsChanged(callback)`

_Params_
- *callback* ：function ，当 label 有变化的时候会执行此函数。Callback 会收到 change 的打分情况，并通过 [LabelInfo](rest-api-changes.md) 的示例来进行相关的匹配。

_Returns_
- `GrChangeMetadataApi` for chaining.

