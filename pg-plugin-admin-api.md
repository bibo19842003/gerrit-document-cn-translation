# Gerrit Code Review - Admin customization API

此 API 由 [plugin.admin()](pg-plugin-dev.md) 提供，可用于对管理员菜单进行定制化处理。

## addMenuLink
`adminApi.addMenuLink(text, url, opt_capability)`

向管理员的导航菜单中添加一个链接。

_Params_
- *text* ：String，链接显示的文本
- *url* ：String，新链接的 URL
- *opt_capability* ：String，link 显示的长度

当添加一个外部链接的时候，需要添加链接的全路径。另外，内部链接需要以 `/` 开头，例如：为 open 状态的 change 创建一个链接， `/q/status:open`。

