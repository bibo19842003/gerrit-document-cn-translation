# Gerrit Code Review - Themes

Gerrit 支持对网页的定制，允许变更页面的布局，颜色等。 

## HTML Header/Footer and CSS

HTML 的 header, footer 和 CSS 可以为登录页面(LDAP, OAuth, OpenId) 以及 gitweb 页面进行定制。

gerrit 在启动的时候会读取下面文件，并使用他们进行 HTML 页面的定制，然后再将页面返回给客户端：

* `etc/GerritSiteHeader.html`

 位置在页面的菜单下方，内容的上面。用于显示 logo 或者 一些系统的链接。

* `etc/GerritSiteFooter.html`

 位置在页面底部，所有内容的下方，如："Powered by Gerrit Code Review (v....)" 。

* `etc/GerritSite.css`

 CSS 的规则被 HTML 页面的顶部所内置, 在 `<style>` 标签内。这些规则可以支持页面元素的显示，包括 header 和 footer。

*.html 文件必须是有效的 XHTML, 需要有 root 元素，如：`<div>`。服务器按照 XML 格式解析这些文件，然后把 root 元素插入到页面中。如果文件包含的 root 元素多于一个，那么 gerrit 不会启动。

## Static Images

静态图片可以存放到 `'$site_path'/static` 目录下，并且可以被 `GerritSite{Header,Footer}.html` 和 `GerritSite.css` 引用，引用的路径为 `static/$name`，如：`static/logo.png`。

从安全的角度来说，文件需要放到 `'$site_path'/static` 目录下，禁止放到 static 的子目录中，并且文件名称中不能含有字符 `/` 和 `\`。例如，客户端发送请求 `static/foo/bar`，那么服务器将返回 `404 Not Found`。

## HTTP Caching

header, footer, 和 CSS 文件内置到了页面中，但服务器端对页面不做缓存，所以文件一有改变，客户端会立刻会显示出来。

`'$site_path'/static` 目录中，下列格式的文件缓存时间为 1 年，客户端会对这些文件进行缓存：

 * `*.cache.html`
 * `*.cache.gif`
 * `*.cache.png`
 * `*.cache.css`
 * `*.cache.jar`
 * `*.cache.swf`

`'$site_path'/static` 目录下其他的文件缓存时间为 5 分钟。如果文件有修改，5 分钟后，客户端才会看到文件的变化。

建议 header 和 footer 中的静态图片使用上面的格式进行命名，如：`my_logo1.cache.png`, 这样的话，客户端会对图片进行缓存。如果图片需要修改，可以新建一个文件，如： `my_logo2.cache.png`，并且更新 header (或 footer) 中的图片路径。

## Google Analytics Integration

如果要链接 Google Analytics，可以将下列内容添加到 `GerritSiteFooter.html`:

```
  <div>
  <!-- standard analytics code -->
    <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
      var pageTracker = _gat._getTracker("UA-nnnnnnn-n");
      pageTracker._trackPageview();
    </script>
  be <!-- /standard analytics code -->

  <script type="text/javascript">
    window.onload = function() {
      var p = window.location.pathname;
      Gerrit.on('history', function (s) {
        pageTracker._trackPageview(p + '/' + s)
      });
    };
  </script>
  </div>
```

正确的设置请参考 Google Analytics 文档说明，上面仅仅是一个例子。

如果 `GerritSiteFooter.html` 文件是空文件或者不存在，那么将所有脚本标记放到单一的 `<div>` 标记中（如上所述），以确保它是格式良好的 XHTML 格式的文档文件。

全局函数 `Gerrit.on（“history”）`接收字符串和函数。这些函数放在一个列表中，并在 Gerrit 的 URL 变化时被调用。页面名称 `/c/123` 会作为参数传入到函数中，然后这些函数又会被传递给 Google Analytics 进行跟踪分析。上面的例子使用 '/' 而不是 '＃' ，因为 Google Analytics 不会跟踪锚点。

`window.onload` 的调用是必要的，因为可以确保 `Gerrit.on()` 在页面中已定义。

