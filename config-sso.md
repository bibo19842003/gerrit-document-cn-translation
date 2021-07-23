# Gerrit Code Review - Single Sign-On Security

Gerrit 可以与 `SSO` 系统集成，方便用户用已有的用户名进行访问 gerrit。

## OpenID

默认情况下，gerrit 可以配置 OpenID 认证，如要使用此认证方式，需要将 auth.type 设置为 `OpenID`:

```
  git config --file $site_path/etc/gerrit.config auth.type OpenID
```

管理员无需通过 OpenID 验证。

* [openid.net](http://openid.net/)

如果使用了 Jetty，由于 header 比较长，那么需要增加 `header buffer size` 对应的变量值。在 `$JETTY_HOME/etc/jetty.xml` 文件的 `org.mortbay.jetty.nio.SelectChannelConnector` 行的下面添加如下内容:

```
  <Set name="headerBufferSize">16384</Set>
```

为了可以使用 `Anonymous Users` 和 `Registered Users` 群组，账户的 OpenIDs 格式至少要与 `gerrit.config` 中的 一种 `auth.trustedOpenID` 格式相匹配。格式可以是 [标准的 Java 正则表达式(java.util.regex)](http://download.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html) (一定要以 `^` 开头，以 `$` 结尾) 或者一个普通的字符串。

Gerrit 可以配置两种格式来匹配网络上的任一一家 OpenID 提供商：

* `http://` -- 使用 HTTP 协议配置所有的 OpenID 提供商
* `https://` -- 使用 HTTPS 协议配置所有的 OpenID 提供商

例如，仅支持 Launchpad:
```
  git config --file $site_path/etc/gerrit.config auth.trustedOpenID https://login.launchpad.net/+openid
```

### Database Schema

从 OpenID 提供商获取到的身份标识，作为用户的 `external IDs` 存储起来。`external IDs` 可以参考 [NoteDb 中的账户](config-accounts.md) 相关章节。

### Multiple Identities

同一个 gerrit 账户有可能关联多个 OpenID，换句话说，登录 gerrit 的时候，使用了不同的 OpenID。

**WARNING:**
*有时，用户希望关联另外一个 OpenID，但这个 OpenID 不能单独的进行登录。如果单独登录的话，系统会生成一个新帐号，再次关联此 OpenID 的时候，会失败。如果发生这种情况，管理员需要手动操作合并帐号。如要了解更多，请参考 [Merging Gerrit User Accounts](https://gerrit.googlesource.com/homepage/+/md-pages/docs/SqlMergeUserAccounts.md)。*

如果 OpenID 提供商停止了服务，那么用户关联其他的 OpenID 是有必要的。

关联一个已经存在的帐号：

* 用已存在的帐号登录
* 依次点击： Settings -> Identities
* 再点击 'Link Another Identity' 按钮
* 选择 OpenID 提供商
* 认证

关联成功后，就可以使用新关联的帐号登录 gerrit 了。

## HTTP Basic Authentication

使用 HTTP 认证的时候，gerrit 在处理用户的请求之前会假设 servlet 容器或前端的 web 服务器已经完成了对用户的认证。

因此，在 gerrit 页面上不显示 "Sign In" 和 "Sign Out" 的链接。

下面是启启用 HTTP 认证的的配置命令：

```
  git config --file $site_path/etc/gerrit.config auth.type HTTP
  git config --file $site_path/etc/gerrit.config --unset auth.httpHeader
  git config --file $site_path/etc/gerrit.config auth.emailFormat '{0}@example.com'
```

`auth.type` 需要设置为 HTTP，表明用户的身份会从 HTTP 的认证数据中获取。

不要对 `auth.httpHeader` 设置任何值，否则 Gerrit 将无法按照正常的标准执行。

`auth.emailFormat`，这个不是必须配置的参数，此参数用来在用户首次登录的时候自动设置首选邮箱，因为 Gerrit 会从认证头部中获取的帐号名称来取代 `{0}`。例如，上面示例中所示的格式是典型的，可以添加组织的域名。

如果配置了 Apache HTTPd 服务，那么 Apache 服务器会处理用户的认证，相关的 Apache 配置如下：

```
  <Location "/login/">
    AuthType Basic
    AuthName "Gerrit Code Review"
    Require valid-user
    ...
  </Location>
```

### Database Schema

从认证头部获取用户信息，然后作为 `external IDs` 存储起来。

## Computer Associates Siteminder

Siteminder 是 ‘Computer Associates’ 发布的一个 `SSO` 商用方案，一般应用在大型企业中。

使用 Siteminder 的时候，Gerrit 会认为在 Apache 服务器的后面已经安装了 servlet 容器，并且 Siteminder 的认证模块已经配置到了 Apache 的 gerrit 应用中。在这样的配置下，所有的用户访问 gerrit 之前都需要经过 Siteminder 的认证。

因此，在 gerrit 页面上不显示 "Sign In" 和 "Sign Out" 的链接。

下面是启启用认证的的配置命令：

```
  git config --file $site_path/etc/gerrit.config auth.type HTTP
  git config --file $site_path/etc/gerrit.config auth.httpHeader SM_USER
  git config --file $site_path/etc/gerrit.config auth.emailFormat '{0}@example.com'
```

`auth.type` 需要设置为 HTTP，表明用户的身份会从 HTTP 的认证数据中获取。

`auth.httpHeader`  表明在 HTTP 的头部中，Siteminder 已经存储了用户名称，通常是 "SM_USER"，但也有可能不同，具体的参数值可以询问 `SSO` 项目组。

`auth.emailFormat`，这个不是必须配置的参数，此参数用来在用户首次登录的时候自动设置首选邮箱，因为 Gerrit 会从认证头部中获取的帐号名称来取代 `{0}`。例如，上面示例中所示的格式是典型的，可以添加组织的域名。

如果使用了 Jetty，由于 header 比较长，那么需要增加 `header buffer size` 对应的变量值。在 `$JETTY_HOME/etc/jetty.xml` 文件的 `org.mortbay.jetty.nio.SelectChannelConnector` 行的下面添加如下内容:

```
  <Set name="headerBufferSize">16384</Set>
```


### Database Schema

从 Siteminder（参数值在 "SM_USER" 的 HTTP header）获取用户信息，然后作为 `external IDs` 存储起来。

