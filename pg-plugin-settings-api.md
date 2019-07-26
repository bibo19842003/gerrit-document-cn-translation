# Gerrit Code Review - Settings admin customization API

此 API 由 [plugin.settings()](pg-plugin-dev.md) 提供，用于页面的定制。

## title
`settingsApi.title(title)`

_Params_
- `*string* title` : 菜单名称

_Returns_
- `GrSettingsApi` for chaining.

## token
`settingsApi.token(token)`

_Params_
- `*string* token` ：用于直接访问页面某部分的 URL，如：`settings/#x/some-plugin/*token*`

_Returns_
- `GrSettingsApi` for chaining.

## module
`settingsApi.module(token)`

_Params_
- `*string* module` ：在 plugin 设置区域，实例化自定义元素的名称
area.

_Returns_
- `GrSettingsApi` for chaining.

## build

_Params_
- none

应用相关配置并创建 UI 元素。

