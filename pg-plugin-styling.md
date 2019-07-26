# Gerrit Code Review - PolyGerrit Plugin Styling

## Plugin styles

Plugins 可以提供 [Polymer style modules](https://www.polymer-project.org/2.0/docs/devguide/style-shadow-dom#style-modules) 用于对以 CSS 为基础的 UI 的定制。

PolyGerrit UI 可以执行多个 `styling endpoints`。CSS mixins 通过[使用 @apply](https://tabatkins.github.io/specs/css-apply-rule/) ，来在 `styling endpoints` 中进行应用。

**NOTE:**
*本文描述的的 item (如 CSS 属性和 mixin 标识) 可以保证长期正常使用，因为这些 item 已经被集成测试所覆盖。如果要添加新的属性或者 endpoint，可以[提交 bug](https://bugs.chromium.org/p/gerrit/issues/entry?template=PolyGerrit%20Issue) 来说明情况，便于后继的跟踪和维护。*

Plugins 需要基于 html 并按照 PolyGerrit's [开发指导](pg-plugin-dev.md) 进行导入。

Plugins 应该提供 Style Module, 如下:

```html
  <dom-module id="some-style">
    <style>
      :root {
        --css-mixin-name: {
          property: value;
        }
      }
    </style>
  </dom-module>
```

Plugins 应该通过使用 `Plugin.prototype.registerStyleModule(endpointName, styleModuleName)` 的 `styling endpoint` 来注册 style module ，如：

```js
  Gerrit.install(function(plugin) {
    plugin.registerStyleModule('some-endpoint', 'some-style');
  });
```

## Available styling endpoints

### change-metadata

下面自定义的 CSS mixins 可以被系统识别：

* `--change-metadata-assignee`

应用 `gr-change-metadata section.assignee`

* `--change-metadata-label-status`

应用 `gr-change-metadata section.labelStatus`

* `--change-metadata-strategy`

应用 `gr-change-metadata section.strategy`

* `--change-metadata-topic`

应用 `gr-change-metadata section.topic`

下面 CSS 属性 [通过集成测试并获得长期支持](https://gerrit.googlesource.com/gerrit/+/master/polygerrit-ui/app/elements/change/gr-change-metadata/gr-change-metadata-it_test.html)

* `display`

设置为 `none` 可以隐藏此部分。

