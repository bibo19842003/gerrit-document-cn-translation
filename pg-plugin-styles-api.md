# Gerrit Code Review - Plugin styles API

此 API 的文档可以参考 [plugin 开发](pg-plugin-dev.md) 的 `plugin.styles()` 部分。

## css
`styles.css(rulesStr)`

.Params
- `*string* rulesStr` CSS 风格声明的 string

Example:
```
const styleObject = plugin.styles().css('background: black; color: white;');
...
const className = styleObject.getClassName(element)
...
element.classList.add(className);
...
styleObject.apply(someOtherElement);
```
+
.Returns
- 参考 [GrStyleObject](pg-plugin-style-object.md).

