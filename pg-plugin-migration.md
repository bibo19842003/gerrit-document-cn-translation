# Gerrit Code Review - PolyGerrit Plugin Development

**CAUTION:**
*此文还未完成。*

## Incremental migration of existing GWT UI plugins

[PolyGerrit plugin API](pg-plugin-dev.md) 基于不同的概念，并且与 GWT plugin 相比，还可以提供不同类型的 API。根据插件的不同，可能需要 PolyGerrit API 对现有 UI scripts 进行大量修改。

为了使迁移更容易，PolyGerrit 推荐一个增加迁移的策略。从 .js 文件开始，plugin 的作者可以把弃用的 API 迁移到新的 plugin 中。

本文提供了集成 .js 文件和 html 文件的方法。

**NOTE:**
*本文不包括单个 .js 文件的 Web UI plugin 的说明。*

比如，一个含有 UI 模块的 plugin，文件结构如下：

  ├── BUILD
  ├── LICENSE
  └── src
      └── main
          ├── java
          │   └── com
          │       └── foo
          │           └── SamplePluginModule.java
          └── resources
              └── static
                  └── sampleplugin.js

简单来说，假设 SamplePluginModule.java 有如下内容：

```java
public class SamplePluginModule extends AbstractModule {

  @Override
  protected void configure() {
    DynamicSet.bind(binder(), WebUiPlugin.class)
        .toInstance(new JavaScriptPlugin("sampleplugin.js"));
  }
}
```

### Step 1: Create `sampleplugin.html`

作为第一步，在模块文件中创建 `sampleplugin.html` 和  UI script 。

**NOTE:**
*GWT UI 不支持 html 文件，所以会忽略 html。*

```java
  @Override
  protected void configure() {
    DynamicSet.bind(binder(), WebUiPlugin.class)
        .toInstance(new JavaScriptPlugin("sampleplugin.js"));
    DynamicSet.bind(binder(), WebUiPlugin.class)
        .toInstance(new JavaScriptPlugin("sampleplugin.html"));
  }
```

下面是 `sampleplugin.html` 的示例:

**NOTE:**
*`dom-module` 的 `id` 属性*一定*要包含一个短线。*

``` html
<dom-module id="sample-plugin">
  <script>
    Gerrit.install(plugin => {
        // Setup block, is executed before sampleplugin.js
    });
  </script>

  <script src="./sampleplugin.js"></script>

  <script>
    Gerrit.install(plugin => {
        // Cleanup block, is executed after sampleplugin.js
    });
  </script>
</dom-module>
```

下面是工作过程的描述：

- 由于 UI scripts 有可能同名或者有不同的扩展，PolyGerrit 需要检查迁移所使用到的脚本。
    PolyGerrit 加载 `sampleplugin.html` 并且忽略 `sampleplugin.js`
    PolyGerrit 为 `Gerrit.install()` 的调用重新使用 `plugin` (aka `self`) 实例

这意味着，plugin 的实例在 .html 文件和 .js 文件中被共享。这允许逐步将代码转到新的 API 。

### Step 2: Create cut-off marker in `sampleplugin.js`

通常, window.Polymer 用于在 GWT UI 脚本中检测是否在 PolyGerrit 中运行。可以将已迁移到 API 的代码和未迁移到 API 的代码分开。

在增量迁移的过程中，一些 UI 需要通过 PolyGerrit plugin API 继续实现。也许，老的代码仍然需要继续使用。

为了处理这种情况，在 `sampleplugin.js` 安装调用的结尾添加如下代码：

```js
Gerrit.install(function(self) {

  // Existing code here, not modified.

  if (window.Polymer) { return; } // Cut-off marker

  // Everything below was migrated to PolyGerrit plugin API.
  // Code below is still needed for the plugin to work in GWT UI.
});
```

### Step 3: Migrate!

废弃的 API 应该用非废弃的 API 进行重写。

如果需要在 .html 和 .js 之间进行数据或者函数共享，那么可以存储在二者共享的 `plugin`(aka `self`) 对象中。

### Step 4: Cleanup

废弃的 API 被迁移后，`sampleplugin.js` 包含的重复代码，只涉及 GWT UI 的使用。如果 gerrit 不再支持 GWT，那么支持 GWT 的文件及其相关脚本的标识可以被删除。

