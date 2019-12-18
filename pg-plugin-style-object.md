# Gerrit Code Review - GrStyleObject

存储 css 风格属性的相关信息。不能直接创建 object，但可以使用 css 相关方法，可以参[plugin style api 开发](pg-plugin-styles-api.md) 的 css 相关部分。此 object 需要在不同的 shadow 目录中应用正确的 element。

## getClassName
`styleObject.getClassName(element)`

_Params_
- `element`: 一个 HTML 元素

_Returns_
- `string`: class 名称。class 名称只在 `element` 的 shadow root 中有效。

创建一个独一无二的 CSS class 并将其嵌入到 DOM 中。此 class 可以后续添加到 element 中或者相同的 shadow root 的其他 element中。每个 shadow root 中只能添加一次 CSS class。

## apply
`styleObject.apply(element)`

_Params_
- `element`: apply 风格的元素

创建一个独一无二的 CSS class，并将 class 添加到 element 中。
