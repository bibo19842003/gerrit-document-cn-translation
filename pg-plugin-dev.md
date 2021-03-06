# Gerrit Code Review - PolyGerrit Plugin Development

**CAUTION:**
*此文还有多出地方未完成，暂不进行翻译。*

CAUTION: Work in progress. Hard hat area. Please
link:https://bugs.chromium.org/p/gerrit/issues/entry?template=PolyGerrit%20plugins[send
feedback] if something's not right.

For migrating existing GWT UI plugins, please check out the
link:pg-plugin-migration.html#migration[migration guide].

## Plugin loading and initialization

link:js-api.html#_entry_point[Entry point] for the plugin.
 
* The plugin provides pluginname.js, and can be a standalone file or a static
   asset in a jar as a link:dev-plugins.html#deployment[Web UI plugin].

* pluginname.js contains a call to `Gerrit.install()`. There should
  only be single `Gerrit.install()` per file.
* PolyGerrit imports pluginname.js.
* For standalone plugins, the entry point file is a `pluginname.js` file
   located in `gerrit-site/plugins` folder, where `pluginname` is an alphanumeric
   plugin name.
 
 Note: Code examples target modern browsers (Chrome, Firefox, Safari, Edge).
 
Here's a recommended starter `myplugin.js`:
 

``` js
Gerrit.install(plugin => {
  'use strict';
 

  // Your code here.
});

```

## Low-level DOM API concepts

Basically, the DOM is the API surface. Low-level API provides methods for
decorating, replacing, and styling DOM elements exposed through a set of
link:pg-plugin-endpoints.html[endpoints].

PolyGerrit provides a simple way for accessing the DOM via DOM hooks API. A DOM
hook is a custom element that is instantiated for the plugin endpoint. In the
decoration case, a hook is set with a `content` attribute that points to the DOM
element.

1. Get the DOM hook API instance via `plugin.hook(endpointName)`
2. Set up an `onAttached` callback
3. Callback is called when the hook element is created and inserted into DOM
4. Use element.content to get UI element

``` js
Gerrit.install(plugin => {
  const domHook = plugin.hook('reply-text');
  domHook.onAttached(element => {
    if (!element.content) { return; }
    // element.content is a reply dialog text area.
  });
});
```

### Decorating DOM Elements

For each endpoint, PolyGerrit provides a list of DOM properties (such as
attributes and events) that are supported in the long-term.

``` js
Gerrit.install(plugin => {
  const domHook = plugin.hook('reply-text');
  domHook.onAttached(element => {
    if (!element.content) { return; }
    element.content.style.border = '1px red dashed';
  });
});
```

### Replacing DOM Elements

An endpoint's contents can be replaced by passing the replace attribute as an
option.

``` js
Gerrit.install(plugin => {
  const domHook = plugin.hook('header-title', {replace: true});
  domHook.onAttached(element => {
    element.appendChild(document.createElement('my-site-header'));
  });
});
```

### Styling DOM Elements

A plugin may provide Polymer's
https://polymer-library.polymer-project.org/3.0/docs/devguide/style-shadow-dom[style
modules,role=external,window=_blank] to style individual endpoints using
`plugin.registerStyleModule(endpointName, moduleName)`. A style must be defined
as a standalone `<dom-module>` defined in the same .js file.

See `samples/theme-plugin.js` for examples.
 
Note: TODO: Insert link to the full styling API.
 

``` js
const styleElement = document.createElement('dom-module');
styleElement.innerHTML =
 `<template>
    <style>
     html {

      --primary-text-color: red;
     }

   </style>
 </template>`;

styleElement.register('some-style-module');

Gerrit.install(plugin => {
  plugin.registerStyleModule('change-metadata', 'some-style-module');
});
```

## High-level DOM API concepts

High level API is based on low-level DOM API and is essentially a standardized
way for doing common tasks. It's less flexible, but will be a bit more stable.

The common way to access high-level API is through `plugin` instance passed
into setup callback parameter of `Gerrit.install()`, also sometimes referred to
as `self`.

## Low-level DOM API

The low-level DOM API methods are the base of all UI customization.

### attributeHelper
`plugin.attributeHelper(element)`

Alternative for
link:https://polymer-library.polymer-project.org/3.0/docs/devguide/data-binding[Polymer data
binding,role=external,window=_blank] for plugins that don't use Polymer. Can be used to bind element
attribute changes to callbacks.
 
See `samples/bind-parameters.js` for examples on both Polymer data bindings
and `attibuteHelper` usage.

### eventHelper
`plugin.eventHelper(element)`

Note: TODO

### hook
`plugin.hook(endpointName, opt_options)`

See list of supported link:pg-plugin-endpoints.html[endpoints].

Note: TODO

### registerCustomComponent
`plugin.registerCustomComponent(endpointName, opt_moduleName, opt_options)`

See list of supported link:pg-plugin-endpoints.html[endpoints].

Note: TODO

### registerDynamicCustomComponent
`plugin.registerDynamicCustomComponent(dynamicEndpointName, opt_moduleName,
opt_options)`

See list of supported link:pg-plugin-endpoints.html[endpoints].

Note: TODO

### registerStyleModule
`plugin.registerStyleModule(endpointName, moduleName)`

Note: TODO

## High-level API

Plugin instance provides access to number of more specific APIs and methods
to be used by plugin authors.

### admin
`plugin.admin()`

.Params:
- none

.Returns:
- Instance of link:pg-plugin-admin-api.html[GrAdminApi].

### changeReply
`plugin.changeReply()`

Note: TODO

### delete
`plugin.delete(url, opt_callback)`

Note: TODO

### get
`plugin.get(url, opt_callback)`

Note: TODO

### getPluginName
`plugin.getPluginName()`

Note: TODO

### getServerInfo
`plugin.getServerInfo()`

Note: TODO

### on
`plugin.on(eventName, callback)`

Note: TODO

### panel
`plugin.panel(extensionpoint, callback)`

Deprecated. Use `plugin.registerCustomComponent()` instead.

``` js
Gerrit.install(function(self) {
  self.panel('CHANGE_SCREEN_BELOW_COMMIT_INFO_BLOCK', function(context) {
    context.body.innerHTML =
      'Sample link: <a href="http://some.com/foo">Foo</a>';
    context.show();
  });
});
```

Here's the recommended approach that uses Polymer for generating custom elements:

``` js
class SomeCiModule extends Polymer.Element {
  static get is() {
    return "some-ci-module";
  }
  static get template() {
    return Polymer.html`
      Sample link: <a href="http://some.com/foo">Foo</a>
    `;
  }
}

// Register this element
customElements.define(SomeCiModule.is, SomeCiModule);

// Install the plugin
Gerrit.install(plugin => {
  plugin.registerCustomComponent('change-view-integration', 'some-ci-module');
});
```
 
See `samples/` for more examples.

Here's a minimal example that uses low-level DOM Hooks API for the same purpose:
 
``` js
Gerrit.install(plugin => {
  plugin.hook('change-view-integration', el => {
    el.innerHTML = 'Sample link: <a href="http://some.com/foo">Foo</a>';
  });
});
```

### popup
`plugin.popup(moduleName)`

Note: TODO

### post
`plugin.post(url, payload, opt_callback)`

Note: TODO

### restApi
`plugin.restApi(opt_prefix)`

.Params:
- (optional) URL prefix, for easy switching into plugin URL space,
  e.g. `changes/1/revisions/1/cookbook~say-hello`

.Returns:
- Instance of link:pg-plugin-rest-api.html[GrPluginRestApi].

### repo
`plugin.repo()`

.Params:
- none

.Returns:
- Instance of link:pg-plugin-repo-api.html[GrRepoApi].

### put
`plugin.put(url, payload, opt_callback)`

Note: TODO

### screen
`plugin.screen(screenName, opt_moduleName)`

.Params:
- `*string* screenName` URL path fragment of the screen, e.g.
`/x/pluginname/*screenname*`
- `*string* opt_moduleName` (Optional) Web component to be instantiated for this
screen.

.Returns:
- Instance of GrDomHook.

### screenUrl
`plugin.url(opt_screenName)`

.Params:
- `*string* screenName` (optional) URL path fragment of the screen, e.g.
`/x/pluginname/*screenname*`

.Returns:
- Absolute URL for the screen, e.g. `http://localhost/base/x/pluginname/screenname`

### settings
`plugin.settings()`

.Params:
- none

.Returns:
- Instance of link:pg-plugin-settings-api.html[GrSettingsApi].

### settingsScreen
`plugin.settingsScreen(path, menu, callback)`

Deprecated. Use link:#plugin-settings[`plugin.settings()`] instead.

### styles
`plugin.styles()`

.Params:
- none

.Returns:
- Instance of link:pg-plugin-styles-api.html[GrStylesApi]

### changeMetadata
`plugin.changeMetadata()`

.Params:
- none

.Returns:
- Instance of link:pg-plugin-change-metadata-api.html[GrChangeMetadataApi].

### theme
`plugin.theme()`

Note: TODO

### url
`plugin.url(opt_path)`
