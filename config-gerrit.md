# Gerrit Code Review - Configuration

## File `etc/gerrit.config`

`'$site_path'/etc/gerrit.config` 是一个 Git-style 的配置文件，主要用作系统层级的配置。

**NOTE:**
*`etc/gerrit.config` 文件的内容在 gerrit 启动的时候会被缓存。大多数的属性值修改后，若想让其生效，需要重新启动 gerrit 服务；少数的一些修改不需要重启 gerrit 服务。*

`etc/gerrit.config` 文件模板如下:
```
[core]
  packedGitLimit = 200 m

[cache]
  directory = /var/cache/gerrit
```

### Reload `etc/gerrit.config`

有的属性不需要重启 gerrit 服务，重新加载就可以使用。`reload config` 相关命令可以参考 [`SSH`](cmd-reload-config.md) 或 [`REST API`](rest-api-config.md)。如果属性支持重新加载，本文对其会有标注。

### Section accountPatchReviewDb

`AccountPatchReviewDb` 是一个数据库，用来存储用户对评审文件的 `reviewed` 标识的记录。

**accountPatchReviewDb.url**

`accountPatchReviewDb` 的 url。支持的书刊类型为：`H2`, `POSTGRESQL`,`MARIADB`, `MYSQL`。如果与数据库通信的 Jdbc 驱动没有在 `CLASSPATH` 中，需要手动将此驱动的 jar 文件放到站点的 lib 文件夹内。

默认，会在站点的 db 文件夹中创建 H2 database 。

更改此参数后，需要执行 [MigrateAccountPatchReviewDb](pgm-MigrateAccountPatchReviewDb.md) 程序来完成与数据库的集成。执行的时候，需要停止 gerrit 服务。

在 gerrit 2.x 的站点中，`db_name` 需要使用一个新的名字，不能用老的名字，否则在 gerrit init 的时候会移除相关表格。

```
[accountPatchReviewDb]
  url = jdbc:postgresql://<host>:<port>/<db_name>?user=<user>&password=<password>
```

**accountPatchReviewDb.poolLimit**

与数据库最大的链接数。如果服务器实际的链接超过了这个值，那么超出的部分需要进行等待（等待时长为 poolMaxWait ）。此值建议比 httpd 和 sshd 的线程上限和要高一些，因为有的线程处理起来需要多个链接。

默认值：`sshd.threads` + `httpd.maxThreads` + 2

**database.poolMinIdle**

pool 中，idel 链接的最小值。
默认值：4

**accountPatchReviewDb.poolMaxIdle**

pool 中，idel 链接的最大值。如果 idel 链接数超过了最大值，那么链接会直接被关闭，不再返回 pool。 
默认值：min(accountPatchReviewDb.poolLimit, 16)

**accountPatchReviewDb.poolMaxWait**

超出与数据库链接上限的请求，需要等待链接的最大时长。等待期间，如果没有链接被释放，那么等待的链接会被强制终止并向客户端报出异常。时长的单位描述如下所示：

* ms, milliseconds
* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours

默认的单位为：`milliseconds` 。
默认值是：`30 seconds` 。

### Section accounts

**accounts.visibility**

用于控制用户的信息是否可以被其他用户访问，包括用户的 dashboard 访问和 web 页面中帐号的提醒。

`ALL`, 所有用户可访问，包括 anonymous 用户。

`SAME_GROUP`, 只有在相同群组中的用户可以访问。

`VISIBLE_GROUP`, 只有可见群组中的用户可以访问。

`NONE`, 没有用户可以访问

默认值：`ALL`。

### Section addreviewer

**addreviewer.maxWithoutConfirmation**

不需要确认操作的情况下，用户通过群组的方式添加评审人员数量的上限。

如果设置为 0 ，那么不会出现确认的操作。

默认值：10

此参数只在网页上添加评审人员时，有影响；通过命令行添加评审人员无影响。

此参数支持 `reload` 操作。

**addreviewer.maxAllowed**

用户通过群组的方式添加评审人员数量的上限。

如果设置为 0 ，对人数没有限制。

默认值：20

此参数支持 `reload` 操作。

**addReviewer.baseWeight**

评审者排序算法中应用的权重。权重的增加或减少对 plugin 会有影响。如果设置为 0 ，对排名没有任何影响。评审人员会通过 plugin 进行排序。

默认值：1

### Section auth

可以参考 [单点登录系统](config-sso.md)。

**auth.type**

gerrit 的认证类型，目前支持的认证类型如下：

* `OpenID`

默认的设置。gerrit 可以使用任何有效的 OpenID，可以参考 [openid.net](http://openid.net/)。

* `OpenID_SSO`

使用单一供应商提供的 OpenID 。没有注册链接，"Sign In" 直接链接到供应商的 SSO 系统。

* `HTTP`

Gerrit 依赖于 HTTP 请求中的数据，包括 HTTP 基本认证或 SSO 的解决方案。如果启用此设置，认证必须在 Web 服务器或 servlet 容器中进行，而不是在 Gerrit 中进行。

* `HTTP_LDAP`

和上面的 `HTTP` 极其类似，但 gerrit 会从 LDAP 中获取用户的 `full name` 和邮箱地址。LDAP 中的群组也可以在 gerrit 中使用。于是在认证类型的后面加了后缀 `_LDAP`。不过，gerrit 不通过 LDAP 进行用户认证。

* `CLIENT_SSL_CERT_LDAP`

此认证方式是 SSO 的一种。

Gerrit 配置 Jetty 的 SSL channel 来处理客户端的 SSL 认证。管理员需要将发布给客户端的证书导入到 `$review-site/etc/keystore`。认证通过后，gerrit 会从 LDAP 获取用户的基本注册信息（用户名和邮箱）以及一些群组信息，因此认证类型有 `_LDAP` 的后缀。但 gerrit 不通过 LDAP 进行认证。

此认证模式只能在托管服务下使用，并且 `httpd.listenUrl` 只能使用 https:// 协议。另外，证书可以在 `$review-site/etc/crl.pem` 中进行废除。

更多信息，可以参考 `httpd.sslCrl`。

* `LDAP`

登录的时候，gerrit 会提示输入用户名和密码，提交后，输入的信息会在所配置的 `ldap.server` 中进行验证。gerrit 不参与验证的任何环节。

LDAP 中绑定用户请求的是账户完整的 DN，通过匿名的请求或已配置的 `ldap.username` 查询目录来搜索用户，如果 `ldap.authentication` 设置为 `GSSAPI`，gerrit 可以使用 kerberos。

如果 `auth.gitBasicAuthPolicy` 设置为 `HTTP`，使用随机生成的 HTTP 密码进行认证。如果 `auth.gitBasicAuthPolicy` 设置为 `HTTP_LDAP`，先使用 HTTP 密码认证，若没有通过，再使用 LDAP 认证。Service 类型的用户仅存在与 gerrit 的数据库中，只能通过 HTTP 密码认证。

* `LDAP_BIND`

登录的时候，gerrit 会提示输入用户名和密码，提交后，输入的信息会在所配置的 `ldap.server` 中进行验证。gerrit 不参与验证的任何环节。

和上面的 `LDAP` 有些不同，用于执行 LDAP 绑定请求的用户名是对话框中的字符串。已配置的 `ldap.username` 不用与获取账户信息。

* `OAUTH`

OAuth 是一种协议，允许外部应用程序请求授权帐户信息，而无需获取密码。这种方式比基本验证更受欢迎，因为令牌可以限制为特定类型的数据，并且用户可以随时撤销。

站点管理员需要在 gerrit 启动前在相关应中用进行注册。需要注意的是，plugin 的认证也需要使用此种方式。

Git 客户端可以在基本认证的头部发送 `OAuth 2` 访问令牌，而不是密码。需要注意的是，plugin 的认证也需要使用此种方式。如果安装了多个 `OAuth 2` 提供商的 plugin，需要选择一个提供商作为默认值来配置 `auth.gitOAuthProvider` 参数。

* `DEVELOPMENT_BECOME_ANY_ACCOUNT`

*请不要随意使用*，此参数只能用于开发环境中。

当使用这种认证方法时，`Become` 是一个链接，在页面的右上方，点击后，会弹出一个窗口，可以输入任一的用户名，然后可以不用认证用此用户立即登录。


默认值：`OpenID`

**auth.allowedOpenID**

OpenID 提供商的列表。用户只能使用列表中匹配的 OpenID 进行认证。只有 `auth.type` 是 `OpenID` 的时候才可以使用此参数。

参数的格式如下：
[standard Java regular expression (java.util.regex)](http://download.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html) (以 `^` 开始，以 `$` 结束) 或者一个字符串的前缀。

默认情况下，列表包含连个值：`http://` 和 `https://`，允许用户可以和任何一个 OpenID 提供商进行认证。

**auth.trustedOpenID**

受信的 OpenID 提供商列表，只有 `auth.type` 设置为 `OpenID`(默认值) 才可以使用此参数。

为了使用  `Anonymous Users` 和 `Registered Users` 群组，用户帐号至少匹配上面列表中的一种格式。

参数的格式如下：
[standard Java regular expression (java.util.regex)](http://download.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html) (以 `^` 开始，以 `$` 结束) 或者一个字符串的前缀。

默认情况下，列表包含连个值：`http://` 和 `https://`，允许用户可以和任何一个 OpenID 提供商进行认证。

**auth.openIdDomain**

OpenID 邮件的 domain 列表。只有 `auth.type` 设置为 `OPENID` 或 `OPENID_SSO` 才可以使用此参数。

domain 不区分大小写，但格式一定要正确，如： "example.com"。

默认情况下，任何 domain 都可以。

**auth.maxOpenIdSessionAge**

在用户认证 gerrit 服务器之前，OpenID 供应商必须强制用户对自己做认证的时间。系统会拒绝超时的认证。

如果设置为 0，提供商总是强制用户进行认证。支持的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days
* w, week, weeks (`1 week` 看作 `7 days`)
* mon, month, months (`1 month` 看作 `30 days`)
* y, year, years (`1 year` 看作 `365 days`)

默认值：-1，不限制认证时长。

**auth.registerEmailPrivateKey**

电子邮件验证令牌生成时所使用的 `private key`。

如果不设置，gerrit 在 [站点初始化](pgm-init.md) 的时候会生成一个随机的 key。

**auth.maxRegisterEmailTokenAge**

用户注册邮件过期的时间。

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days
* w, week, weeks (`1 week` 看作 `7 days`)
* mon, month, months (`1 month` 看作 `30 days`)
* y, year, years (`1 year` 看作 `365 days`)

默认值：12 hours

**auth.openIdSsoUrl**

SSO 的 URL，只有 `auth.type` 设置为 `OpenID_SSO` 才可以使用此参数。

点击 gerrit 页面的 "Sign In" 链接时，会直接跳转到这个 URL。

**auth.httpHeader**

HTTP 头部信任的用户名；如果取消，可以使用 HTTP 基础认证。只有 `auth.type` 设置为 `HTTP` 才可以使用此参数。

**auth.httpDisplaynameHeader**

从 HTTP 头部获取用户显示的名称。只有 `auth.type` 设置为 `HTTP` 才可以使用此参数。

如果设置此参数，Gerrit 强制 HTTP 头部中使用 `full name`，并且在联系信息页面不能修改 `full name`。

**auth.httpEmailHeader**

从 HTTP 头部获取用户邮箱。只有 `auth.type` 设置为 `HTTP` 才可以使用此参数。

如果设置此参数，Gerrit 强制 HTTP 头部中使用邮箱，并且在联系信息页面不能修改和注册邮箱。

**auth.httpExternalIdHeader**

从 HTTP 头部获取用户其他的信息。只有 `auth.type` 设置为 `HTTP` 才可以使用此参数。

如果进行了设置，gerrit 会将设置的值添加到 HTTP 的头部，用于用户验证。典型的是与外部系统（如 GitHub OAuth 2.0 认证）联合起来一起进行验证。

示例: `auth.httpExternalIdHeader: X-GitHub-OTP`

**auth.loginUrl**

用户点击页面右上方的 `login` 后，跳转到的新的 URL。只有 `auth.type` 设置为 `HTTP` 或 `HTTP_LDAP` 的时候才可以使用此参数。

同样适用于跳转到 SSO 的页面登录。

如果进行了设置，gerrit 允许匿名访问，直到用户进行登录。如果没有进行设置，并且 HTTP 的头部缺少相关受信任的标识，那么会跳转到 'LoginRedirect.html' 错误页面。

**auth.loginText**

登录链接显示的`文本信息`，只有配置了 `auth.loginUrl` 参数的情况下，才可以使用此参数。

默认值："Sign In"

**auth.registerPageUrl**

用户首次登录 gerrit 的时候，注册页面的 URL 。只有 `auth.type` 设置为 `HTTP` 的时候才可以使用此参数。

如果不设置，使用标准的 gerrit 注册页面：`/#/register/` 。

**auth.logoutUrl**

用户点击 "Sign Out" 后，跳转到的 URL 页面。如果配置了 SSO，可以设置为 SSO 的 sign-out 页面。

如果不设置，将返回到 open change 的页面。

**auth.registerUrl**

页面右上角 "Register" 对应的 URL。只有 `auth.type` 设置为 `LDAP`, `LDAP_BIND`, `CUSTOM_EXTENSION` 才可以使用此参数。

如果不设置，不显示 "Register"。

**auth.registerText**

页面右上角 "Register" 对应的显示的文本信息。只有 `auth.type` 设置为 `LDAP`, `LDAP_BIND`, `CUSTOM_EXTENSION` 才可以使用此参数。

默认值："Register"

**auth.editFullNameUrl**

用户编辑 `full name` 时，点击 "Edit" 按钮后跳转的链接。只有 `auth.type` 设置为 `LDAP`, `LDAP_BIND`, `CUSTOM_EXTENSION` 才可以使用此参数。

**auth.httpPasswordUrl**

点击 "Obtain Password" 只有 `auth.type` 设置为 `CUSTOM_EXTENSION` 才可以使用此参数。

**auth.switchAccountUrl**

用于切换用户的 URL。只有 `auth.type` 设置为 `OPENID`, `DEVELOPMENT_BECOME_ANY_ACCOUNT` 才可以使用此参数。如果配置了此参数，那么 "Switch Account" 会在 "Sign Out" 的附近显示。

如果 `auth.type` 没有启用这个 URL，管理员可以将其设置为 `login/`，这样允许用户开始一个新的 web session。此参数值在 PolyGerrit 可以作为 href，因此绝对路径 `https://someotherhost/login` 同样可以正常工作。

如果包含 ${path} 参数，PolyGerrit 会将当前的链接替换为参数中的路径。需要注意的是，新路径中添加了前缀 `/`，例如：`/login${path}`。

**auth.cookiePath**

设置认证 cookie 的 `path` 属性。

如果不设置，使用 HTTP 请求的路径。

**auth.cookieDomain**

设置认证 cookie 的 `domain` 属性。

如果不设置，使用 HTTP 请求的 `domain`。

**auth.cookieSecure**

设置认证 cookie 的 `secure` 标识。如果为 `true`，cookies 只能通过 HTTPS 协议进行传递。

默认值：`false`。

**auth.emailFormat**

定制用户邮箱的地址。只有 `auth.type` 设置为 `HTTP`, `HTTP_LDAP`, `LDAP` 才可以使用此参数。

使用登录的用户名来取代 `{0}` ，例如，"\{0\}+gerrit@example.com"，使用用户名 "foo" 登录，则邮箱为"foo+gerrit@example.com"。

如果使用 `HTTP_LDAP` 或 `LDAP` 认证，不建议使用此参数。设置 `ldap.accountEmailAddress` 并且从 LDAP 导入的邮箱，是用户的首选邮箱。

**auth.contributorAgreements**

是否启用贡献者声明。如果启用，用户需要在上传 change 之前完成声明的签署。

如果启用，管理员需要在 project.config 文件中添加一个或多个 [contributor-agreement sections](config-cla.md)，并在 `'$site_path'/static` 目录下创建声明文件。

默认值：false (不使用任何声明)

为了启用此功能，`project.config` 文件一定要设置参数：[receive.requireContributorAgreement](config-project-config.md)。

**auth.trustContainerAuth**

如果设置为 true，托管 Gerrit 的容器负责对用户认证，在这种情况下，gerrit 会信任此容器。

此参数仅影响使用 http 协议的 git 仓的下载。如果设置为 false，Gerrit 负责用户认证（使用基本身份验证）。

默认值：false

**auth.gitBasicAuthPolicy**

当 `auth.type` 设置为 `LDAP`, `LDAP_BIND`, `OAUTH` 的时候，用户可以使用生成的 HTTP 密码，LDAP 或 OAUTH 密码，或者 HTTP 与 LDAP 的联合认证的方式对 `REST API` 的请求和 git 仓的 HTTP 下载进行认证。支持的属性值如下：

*`HTTP`

`REST API` 的请求和 git 仓的 HTTP 下载只能使用 HTTP 密码进行认证。

*`LDAP`

`REST API` 的请求和 git 仓的 HTTP 下载只能使用 LDAP 密码进行认证。

*`OAUTH`

`REST API` 的请求和 git 仓的 HTTP 下载只能使用 OAUTH 密码进行认证。

*`HTTP_LDAP`

`REST API` 的请求和 git 仓的 HTTP 下载，先使用 HTTP 密码认证，如果不通过，再使用 LDAP 密码认证。

`auth.type` 设置为 `LDAP` 时，默认值是 `LDAP`；`auth.type` 设置为 `OAUTH` 时，默认值是 `OAUTH`；其余场景默认值是 `HTTP` 。

**auth.gitOAuthProvider**

使用 `OAuth 2` 为 HTTP 访问进行认证。

此参数值必须是 `plugin-name:provider-name` 形式的 `OAuth 2` 提供商的标识符。具体信息，可以参考 plugin 的文件。

**auth.userNameToLowerCase**

gerrit 将用户名的大写转换为小写进行存储。

如果设置为 `true` ，用户名只能用小写进行认证。设置前需要确保用户名已经都是小写。

此参数影响使用 HTTP 和 SSH 协议下载 git 仓。

默认值：false

**auth.enableRunAs**

如果设置为 true，若用户具有 [Run As](access-control.md) 权限，那么 HTTP 请求的头部可以使用 `X-Gerrit-RunAs` 参数，进而用户可以使用他人帐号进行操作。

如果设置为 false，则关闭此功能。如果需要启用此参数，修改 gerrit.config 文件后，还需要重启 gerrit。

默认值：true

**auth.allowRegisterNewEmail**

用户是否可以注册新邮箱。

另外，对呀 HTTP 的认证类型 `auth.httpemailheader` 一定*不能* 启用注册新邮箱。

默认值：true

**auth.autoUpdateAccountActiveStatus**

帐号登录时，系统是否自动同步账户失效的标识。

如果设置为 true，在登录时，系统若认为帐号是有效的，那么数据库中用户失效的标识将被更新为有效；若认为是失效的，那么数据库中用户失效的标识将被更新为失效，并阻止用户的登录。只有 `LDAP` 才支持此参数。

另外，如果未设置此参数或设置为 false，定期扫描失效用户的功能将不能使用。如果此参数设置为 true，管理员还应考虑 `accountDeactivation` 参数的配置。

默认值：false

**auth.skipFullRefEvaluationIfAllRefsAreVisible**

当用户可以访问所有的 ref 时，是否忽略所有 ref 可访问性的校验。

默认值：true

### Section cache

**cache.directory**

gerrit 缓存的路径，用于缓存相关信息，便于搜索。如果 gerrit 重启，缓存不会清除。如果缓存目录不存在，gerrit 会自动创建。

从技术角度说，缓存的信息被存储在 H2 数据库中。

如果不配置绝对路径，缓存目录默认存放在 `$site_path` 目录下。

默认不配置，没有磁盘缓存。

**cache.h2CacheSize**

H2 数据库在内存缓存中的大小。

H2 数据库支持一些 gerrit 的持久性的缓存。H2 使用内存还缓存相关内容。参数 `h2CacheSize` 可以限制 H2 的内存使用，避免 H2 使用太多的内存时报 out-of-memory 错误。

在 H2 的 JDBC 链接的 URL 中，`CACHE_SIZE` 参数的大小为 H2 缓存的大小，可以参考 [cache_settings](http://www.h2database.com/html/features.html#cache_settings) 。

默认值为可使用内存的一半大小。

因为需要在数据库中存储内容，所以不能将此参数设置为 0。

支持以下单位： 'k', 'm', 'g'

**cache.h2AutoServer**

如果设置为 `true`，为 H2-backed 持久性缓存数据库启用 H2 autoserver 模式。

可以点击 [here](http://www.h2database.com/html/features.html#auto_mixed_mode) 获取更多信息。

默认值是：`false`。

**cache.<name>.maxAge**

相关信息在缓存中保存的最大时长。当到达最大时长时，系统会删除对应缓存，并重新刷新生成。支持的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days
* w, week, weeks (`1 week` 看作是 `7 days`)
* mon, month, months (`1 month` 看作是 `30 days`)
* y, year, years (`1 year` 看作是 `365 days`)

默认的单位是 `seconds` 。如果设置为 0 ，若缓存有剩余空间，则不会移除相关数据。

默认值：`0`, 意味着存储的数据永远不会过期，但除了下面的数据：

* `"adv_bases"`: 默认为 `10 minutes`
* `"ldap_groups"`: 默认为 `1 hour`
* `"web_sessions"`: 默认为 `12 hours`

**cache.<name>.memoryLimit**

内存中缓存的数量。不同类型的缓存，数量是不一样的。大多数缓存的数量是相同的，memoryLimit 被定义为所缓存信息的数量（1 条信息的数量看作是 1）。

对于缓存来说，不同类型的缓存大小是不一样的 (特别是 `"diff"`, `"diff_intraline"`), 因此 memoryLimit 是缓存大小的近似值。如果 patch-set 大的话，那么占的缓存也会大一些。对于这样的缓存，管理员可以以字节为单位来设置缓存的大小。

默认值：1024，但以下的类型除外：

* `"adv_bases"`: 默认值 `4096`
* `"diff"`: 默认值 `10m` (10 MiB 内存)
* `"diff_intraline"`: 默认值 `10m` (10 MiB 内存)
* `"diff_summary"`: 默认值 `10m` (10 MiB 内存)
* `"external_ids_map"`: 默认值 `2` ，不要更改此值
* `"groups"`: 默认值 unlimited
* `"groups_byname"`: 默认无限制
* `"groups_byuuid"`: 默认无限制
* `"plugin_resources"`: 默认值 2m (2 MiB 内存)

如果设置为 0,将取消缓存，并且信息会从缓存中移除，可以用于相关测试。

**cache.<name>.expireFromMemoryAfterAccess**

最后一次访问缓存后，缓存失效需要的时长。如果设置为 0 或不设置，缓存中的数据不会过期。

此参数只应用于内存中的缓存；磁盘上的缓存不会过期，如要删除，需要设置 `diskLimit` 参数。

**cache.<name>.diskLimit**

存储在磁盘上的缓存大小。每天 1 AM  会对超过上限的缓存进行扫描，把不常用的缓存信息移除，直到低于上限。

默认值：128 MiB，但以下的类型除外：

* `"change_notes"`: 默认磁盘不存储
* `"diff_summary"`: 默认值 `1g` (1 GiB 的磁盘空间)
* `"external_ids_map"`: 默认磁盘不存储

如果设置为 0 或者负数，将取消磁盘存储缓存。

#### Standard Caches

**cache `"accounts"`**

Cache 包含了用户的一些重要信息，如：`display name`, `preferences`, `email`。信息是从 `All-Users` 仓的 NoteDb 数据中获取的。

如果 `All-Users` 有更新，那么此 cache 也需要刷新。

**cache `"adv_bases"`**

只有在启用分支层级的访问控制时，可以使用 smart HTTP 进行推送。缓存信息包含了差异的 commit。smart HTTP 的推送需要两个 HTTP 的请求，第一个请求用于加载请求的状态，第二个请求用于确认传输完成。

**cache `"changes"`**

`memoryLimit` 的大小决定了缓存 change 的数量。如果此缓存设置为 1024，那么最多只能缓存 1024 个 project 的 change。

默认值：0, 取消缓存。因为此缓存不会在 gerrit 主机之间共享，所以建议在 multi-master/multi-slave 架构中取消缓存的设置。

当 change 有变化时，此缓存需要刷新。

**cache `"diff"`**

每个条目缓存了两个 commit 之间的修改，包括目录和文件。gerrit 使用此缓存会加快文件的显示。

**cache `"diff_intraline"`**

每个条目缓存了两个 commit 之间修改的文件的 `intraline difference`。当评审修改文件的时候，gerrit 使用此缓存会加快 `intraline difference` 的显示。

**cache `"diff_summary"`**

每个条目缓存了两个 commit 之间修改的文件的路径。gerrit 使用这个缓存加快了对 change 页面所修改文件的显示。

理想情况下，使用足够大的磁盘空间来缓存所有的 change，这样会加快重构suoyin，特别是线下重构。

**cache `"external_ids_map"`**

如果缓存只有一个条目，那么此条目是 [所有当前外部 ID]（config-accounts.md）解析后的映射。此缓存也可能包含 2 个条目，但第二个条目已过期。

不建议更改此缓存的默认值。但可以通过设置 `diskLimit` 来存储此缓存，不过仅在冷启动性能有问题时才建议使用。

**cache `"git_tags"`**

如果 branch 设置了读权限，此参数用于缓存 branch 上哪些 tag 可以访问。gerrit 使用此缓存来判断 tag 和哪些 branch 有关系并且用户可以访问哪些 tag。

缓存会一直保存在磁盘上，即使重启也不会删除，因为缓存需要大量的时间 (比如 linux 的 kernel 仓，计算所需的时间至少为 60s)。

**cache `"groups"`**

通过群组 ID 缓存 gerrit 群组信息，包括群组的 owner，名称，描述，ID。

此缓存的大小要大于 gerrit 内部群组的数量，否则会降低 gerrit 的性能。

默认设置无上限。

LDAP 群组使用的缓存为：`"ldap_groups"`

**cache `"groups_byname"`**

通过群组名称缓存 gerrit 群组信息，包括群组的 owner，名称，描述，ID。

此缓存的大小要大于 gerrit 内部群组的数量，否则会降低 gerrit 的性能。

默认设置无上限。

LDAP 群组使用的缓存为：`"ldap_groups"`

**cache `"groups_byuuid"`**

通过群组 ID 缓存 gerrit 群组信息，包括群组的 owner，名称，描述，ID。

此缓存的大小要大于 gerrit 内部群组的数量，否则会降低 gerrit 的性能。

默认设置无上限。

LDAP 群组使用的缓存为：`"ldap_groups"`

**cache `"groups_bymember"`**

缓存包含特定成员的群组。

**cache `"groups_bysubgroups"`**

缓存父群组。

**cache `"ldap_groups"`**

缓存 LDAP 群组。

**cache `"ldap_groups_byinclude"`**

缓存 LDAP 的群组层级结构。

**cache `"ldap_usernames"`**

缓存 LDAP 用户名和 gerrit 用户的对应关系。当 gerrit 有新用户登录时，缓存会刷新，此参数与缓存到期时间无关。

**cache `"permission_sort"`**

缓存 ref 的权限配置。若权限配置使用了正则表达式，缓存需要花费更多的时间，因为需要与每个 ref 进行匹配。

**cache `"plugin_resources"`**

缓存 plugin 的资源，如 文档。`memoryLimit` 指的是存储文件使用的内存大小。

**cache `"projects"`**

缓存 project 的描述信息。如果 project 的描述有更新，缓存需要跟着刷新。新增 project 时不需要刷新，因为首次使用的时候系统会进行读取。

**cache `"prolog_rules"`**

缓存每个 project 的 `rules.pl` 文件内容。此缓存的大小同 `projects` 缓存大小一样，不要单独配置此参数。

**cache `"pure_revert"`**

缓存 change 或 commit 是否为另一个 change 的 pure/clean 的 revert。

**cache `"sshkeys"`**

缓存用户的 `SSH keys`，便于 SSH 认证。

**cache `"web_sessions"`**

跟踪用户的 HTTP 的实时 session，若刷新此缓存，所有用户需要重新登录。`gerrit flush-caches --all` 不包括此缓存，如要刷新此缓存，需要特殊指定。

如果磁盘没有配置此缓存 (或者 `cache.web_sessions.diskLimit` 设置为 0)，那么 gerrit 要是重启的话，登录的用户需要重新再次登录。推荐启用此缓存。

Session 存储的花费比较小，平均每条信息大约 346 bytes。

可以参考 [gerrit flush-caches](cmd-flush-caches.md)。

#### Cache Options

**cache.diff.timeout**

在放弃并回退到简单 diff 算法之前等待 diff 数据的最大时长，该算法无法将修改的区域分解为更小的区域。这是解决默认差分算法中无限循环 bug 的方法。

支持的单位如下：

* ms, milliseconds
* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours

默认的单位为：`milliseconds`

默认值：5 seconds

**cache.diff_intraline.timeout**

在放弃并禁用特定文件之前等待 intraline 差分数据的最大时长。这是解决 intraline 差分算法中无限循环 bug 的方法。

如果计算所花费的时长超过了 timeout，那么工作线程会被终止，并显示错误消息，但不显示文件的 intraline 差异。

支持的单位如下：

* ms, milliseconds
* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours

默认的单位为：`milliseconds`

默认值：5 seconds.

**cache.diff_intraline.enabled**

Boolean 值，用于在写入 diff 缓存时，启用或禁用 intraline 差分计算。为了保持版本的兼容性，如果未位置此参数，将使用 `cache.diff.intraline` 的配置。

默认值：true, 启用。

**cache.projects.checkFrequency**

检查 project 配置文件的频率。gerrit 在内存中缓存 project 的配置，每次都会检查 refs/meta/config 分支是否有新的版本。

如果设置为 0, 无时无刻都在检查，这样会减慢操作速度。

如果设置为 'disabled' 或 'off', 意味着取消检查。

管理员可以通过 [gerrit flush-caches](cmd-flush-caches.md) 命令来强制刷新缓存。

默认值：5 minutes

**cache.projects.loadOnStartup**

gerrit 在启动的时候，是否加载 project 缓存。

所有的 project 同时被加载。管理员事先要确认 `cache.projects.memoryLimit` 不要低于 project 的数量。

默认值：false, 不加载。

**cache.projects.loadThreads**

只有 `cache.projects.loadOnStartup` 设置为 true 的时候，才可以使用此参数。

gerrit 在启动时，加载缓存使用的线程的数量。缓存加载后，线程会释放。

线程默认值为 CPU 的数量。

### Section capability

**capability.administrateServer**

具有 `administrateServer` 权限的群组名称，另外，此权限会在 All-Projects 中列举出来。

配置文件使用的是群组名称，不是 UUIDs。如果群组更名了，需要手动立即更新。

默认情况下，只有 All-Projects 显示的群组才有 `administrateServer` 权限。

**capability.makeFirstUserAdmin**

是否给第一个登录用户添加到 `administrator` 群组并添加 `administrateServer` 权限。

默认值：true

### Section change

**change.allowBlame**

两边可以 diff 的时候可以 balme。如果设置为 false, blame 功能将不能使用。

默认值：true

**change.allowDrafts**

支持 draft 工作流。如果设置为 true, 使用 draft 参数推送的时候会生成一个 private change。

如果启用此参数，可以向 `refs/drafts/branch` 分支进行推送，否则会被拒绝。

默认值：false

**change.api.allowedIdentifier**

API 可以使用 change 相关标识进行搜索。可以参考 进行过滤。可以参考 [Change Id](rest-api-changes.md) 的 `Change Id` 相关章节。

有效值为：`ALL`, `TRIPLET`, `NUMERIC_ID`, `I_HASH`, `COMMIT_HASH` 等。

默认值：`ALL`

**change.api.excludeMergeableInChangeInfo**

如果设置为 true，不会显示 change 是否可以合入的状态。不过可以通过 get-mergeable api 进行查看。具体可以参考 [change api](rest-api-changes.md) 的 change-info 和 get-mergeable 相关章节。

默认值：false

**change.cacheAutomerge**

当查看 commit 的差异的时候，页面的左侧会显示 merge 的输出结果。此参数用来控制 git 仓中是否存储输出结果。

如果设置为 true，automerge 的结果会存储在 git 仓的 `refs/cache-automerge/*` 分支中；change 的 diff 结果会存储在 diff 的缓存中。

如果设置为 false，git 仓中不会存储额外的数据，只有缓存进行存储相关数据。不过可以通过减少 git 仓中的 refs 数量来略微提高系统的性能。

默认值：true

**change.disablePrivateChanges**

如果设置为 true, 用户不运行创建 private changes 。

默认值：false

**change.largeChange**

假设 change 修改行数的上限。修改行数等于添加的行数与删除的行数的和。

具体的值用来参考在 gerrit 页面上可视化显示修改量的大小。

默认值：500

**change.replyLabel**

reply 按钮显示的文本名称。系统会自动添加后缀：`…`。

默认值："Reply"。用户页面会显示："Reply…"。

**change.replyTooltip**

reply 按钮的提示信息。系统会自动附加上快捷键信息。

默认值："Reply and score"。用户页面显示 "Reply and score (Shortcut: a)"。

**change.robotCommentSizeLimit**

robot comment 大小的上限值。

支持的单位如下： 'k', 'm', 'g'

若参数值为 0 或者是负数，那么无大小限制。

默认值：1024kB

**change.showAssigneeInChangesTable**

change 的表格是否显示 assignee 字段信息。如果设置为 false，则不显示。

默认值：false

**change.strictLabels**

拒绝无效的打分项：无效的名称，无效的打分。此参数计划在未来的版本中移除。

默认值：false

**change.submitLabel**

submit 按钮显示的文本名称。

默认值："Submit"

**change.submitLabelWithParents**

当父 change 与当前 change 一起可以合入的时候，submit 按钮显示的文本信息。

默认值："Submit including parents"

**change.submitTooltip**

submit 按钮的提示信息。可用的变量如下：`${patchSet}`，`${branch}`，`${commit}`

默认值："Submit patch set ${patchSet} into ${branch}"

**change.submitTooltipAncestors**

如果父 change 可以与当前 change 一起提交，那么此参数值为当前 submit 按钮的提示。可以使用的变量可以参考 `change.submitTooltip`, 还有一个额外变量 `${submitSize}`。

默认值："Submit all ${topicSize} changes of the same topic (${submitSize} changes including ancestors and other changes related by topic)"。

**change.submitTopicLabel**

如果 `change.submitWholeTopic` 设置了参数值并且 change 也添加了 topic，那么 submit 按钮会显示相应的文本名称。

默认值："Submit whole topic"

**change.submitTopicTooltip**

如果 `change.submitWholeTopic` 设置为 true，并且有相同的 topic 的 change 待提交，这时参数值为 submit 按钮显示的提示信息。此参数值会取代 `change.submitTooltip`，可以的变量为：`${topicSize}`，`${submitSize}`。

默认值："Submit all ${topicSize} changes of the same topic (${submitSize} changes including ancestors and other changes related by topic)"。

**change.submitWholeTopic**

点击 submit 按钮会提交相同 topic 的 change ，而不是值提交当前的 change。

默认值：false

**change.updateDelay**

轮询客户端打开的 change 的频率，用于更新 change 的状态。

如果设置为 0，取消轮询的操作。

默认值：5 minutes

### Section changeCleanup

用于定期执行清理 change 的任务。

**changeCleanup.abandonAfter**

open 状态的 change 自动被 abandon。

默认值：0 ，不自动 abandon change。

```
**警告：**
有的时候，启用自动 abandon change 功能会使用户困惑，启用之前，需要先和用户做好沟通。
```

下面是支持的单位：

* `d, day, days`
* `w, week, weeks` (`1 week` 看作 `7 days`)
* `mon, month, months` (`1 month` 看作 `30 days`)
* `y, year, years` (`1 year` 看作 `365 days`)

**changeCleanup.abandonIfMergeable**

可合入的 change 是否执行自动 abandon 的操作。

默认值：`true`

**changeCleanup.abandonMessage**

change 被自动清理后，系统发布的相关信息。

'${URL}' 可以用作 gerrit 的 URL。

默认值："Auto-Abandoned due to inactivity, see ${URL}Documentation/user-change-cleanup.html#auto-abandon\n\n If this change is still wanted it should be restored."

**changeCleanup.startTime**

执行任务的时间。

**changeCleanup.interval**

执行清理的频率。

配置可以参考本文的 `Schedule Configuration` 部分。

### Section commentlink

commentlink 应用在 change 的描述，patch 的评论，inline 代码评论等场景，已超链接的形式存在，并可以链接到 bug-tracking 系统。

下面的第一个示例，配置了 'changeid'，描述了字符串链接到 gerrit 的 Change-Id 对应的页面。

下面的第二个示例，配置了 'bugzilla'， 描述了字符串链接到 bugzilla 系统。

下面的第三个示例，配置了 'tracker'，使用 HTML 控制相关内容的显示。

此参数支持 `reload` 操作。 可以通过 [flush-caches](cmd-flush-caches.md) 命令来实现。

```
[commentlink "changeid"]
  match = (I[0-9a-f]{8,40})
  link = "#/q/$1"

[commentlink "bugzilla"]
  match = "(bug\\s+#?)(\\d+)"
  link = http://bugs.example.com/show_bug.cgi?id=$2

[commentlink "tracker"]
  match = ([Bb]ug:\\s+)(\\d+)
  html = $1<a href=\"http://trak.example.com/$2\">$2</a>
```

commentlink 可以在 `project.config` 配置。相同的配置，子仓会对父仓的配置进行重载。为了避免随意嵌入用户提供的 HTML，commentlink 在 `project.config` 文件中只支持 `link`，不支持 `html`。

**commentlink.<name>.match**

JavaScript 的正则表达式所匹配到的字符串会被替换成有超链接的字符串。匹配到的 Subexpression 可以存储到群组中，并可以通过 `$'n'` 进行访问，'n' 为组号，从 1 开始。

配置文件解析的时候，字符类 `\\s` 会被解析成 `\s`。另外，# 需要使用双引号 "#" 表示。 

为了匹配不区分大小写的字符串，每个位置需要包含字符的大小写，如：`bug`，匹配的样式为 `[bB][uU][gG]`。

`commentlink.name.match` 正则表达式应用在原始的，未被格式的，未转义的文本表格中。正则表达式不支持 HTML。上面的 commentlink 的样式可以更新为文本格式，如：`bug\\s+(\\d+)`。

**commentlink.<name>.link**

当正则表达式匹配到对应的字符串后，点击字符串会跳转到对应的 URL 上。按照 `match` 的分组格式，通过小括号分组，对应的参数为 `$'n'`，如第一个小括号对应的参数为 `$1`。

当没有配置 html 属性的时候，才可以配置 link 属性。

**commentlink.<name>.html**

HTML 用于替换匹配到的字符串。HTML 会重载 link 的属性。可以使用 `$'n'` 访问所匹配的组。

双引号需要转义，如：`\"` 。

**commentlink.<name>.enabled**

是否启用 commentlink。如果设置为 `enabled = true`，那么对应相同部分的配置，子仓不能重载父仓的配置。

默认值：true

被禁用的 name 和 content 可以通过 [REST API](rest-api-projects.md) 进行访问。

### Section container

下面的设置只应用在 `gerrit.sh` 脚本启动 gerrit 的过程中。

**container.heapLimit**

Java 进程 运行 gerrit 时使用 heap 的最大值。此属性可以通过 '-Xmx' 参数传递到 JVM。

默认值参考不同平台的 JVM 确定。

支持的单位如下：'k', 'm', 'g'

**container.javaHome**

gerrit 使用的 JRE/JDK 的路径。如果不设置，gerrit 的启动脚本会进行自动在系统中搜索。此属性会覆盖环境变量：'JAVA_HOME'。

**container.javaOptions**

Java 运行的时候，添加额外的参数。如果配置多个参数，需要使用空格分开。此属性会附加到 'JAVA_OPTIONS' 的后面。

例如，重写 gerrit 默认的 log4j 的配置：

```
  javaOptions = -Dlog4j.configuration=file:///home/gerrit/site/etc/log4j.properties
```

**container.daemonOpt**

可以向 daemon 添加额外的参数，如：'--enable-httpd'。如果要配置多个参数，需要用空格分开。

执行 `java -jar gerrit.war daemon --help` 可以查看更多参数

**container.slave**

此参数在 Gerrit slave 的安装上使用。如果设置为 true，Gerrit JVM 会调用 '--slave' 参数，启用 slave 模式。如果不设置或设置为其他值，gerrit 会启用 master 模式。

**container.startupTimeout**

从执行 gerrit.sh 脚本到 gerrit 成功启动的最大时长。

默认值：90 seconds

**container.user**

执行 Gerrit JVM 的用户名称，如果没有配置，默认使用执行 `gerrit.sh` 脚本的用户。

**container.war**

被执行的 gerrit 的 war 文件的路径。此文件建议存储在本地。此参数会重载环境变量：'GERRIT_WAR'。

默认值：'$site_path/bin/gerrit.war' 或 '$HOME/gerrit.war'

### Section core

**core.packedGitWindowSize**

执行单一读操作的时候，pack 文件加载到内存中的大小。这个是 JGit buffer 缓存的 "page size"，用来对 pack 文件进行访问。所有的磁盘 IO 都在单一窗口读取的时候发生。设置的值太大，会加载过多不需要的数据；太小会增加系统调用 `read()` 的频率。

JGit 在所有平台上的默认值为：8 KiB

支持的单位如下：'k', 'm', 'g'

**core.packedGitLimit**

加载到内存中并缓存的 pack 文件的大小。如果 JGit 访问是需要更多的字节，系统会通过卸载不常用的窗口来回收内存空间。此配置使用的是 JVM heap 的剩余部分。

JGit 在所有平台上的默认值为：10 MiB

支持的单位如下：'k', 'm', 'g'

**core.deltaBaseCacheLimit**

缓存 git 仓中 object 大小的上限。此参数用来 gerrit 向客户端传输数据时，避免频繁的对 object 解压缩。

JGit 在所有平台上的默认值为：10 MiB，不需要修改此值的大小。

支持的单位如下：'k', 'm', 'g'

**core.packedGitOpenFiles**

同时打开 pack 文件的上限。pack 文件需要被打开，因为缓存的 window 需要使用这个数据。

如果上调了此参数，那么需要在操作系统中相应的上调 JVM 所使用的 `file descriptors` 的上限，因为 gerrit 需要为 `network sockets` 和其他仓的数据操作提供可用的 `file descriptors`。

JGit 在所有平台上的默认值为：128

**core.streamFileThreshold**

JGit 分配给连续数组的对象的最大值。大于此值的文件会使用流方式进行处理，通常使用 '$GIT_DIR/objects' 目录下的临时文件来完成 delta 解压缩期间的 pseudo-random 访问。

流量大的服务器建议将此值设置的大一些，要大于长用文件的大小。例如：经常处理 10-20 MiB 的文件，那么此参数可以设置为 `15 m`。如果此值设置的太大，那么在处理比较大的二进制文件的时候，有可能会耗尽 heap 的空间。

默认值为可使用 JVM heap 的 25%，上限是 2048m。

支持的单位如下：'k', 'm', 'g'

**core.packedGitMmap**

如果设置为 true, JGit 将使用 use `mmap()` 来从 pack 文件中加载数据，而不是使用 `malloc()+read()`。但在某些 JVM 上使用 mmap 可能会有问题。

gerrit 需要链接多个 pack 文件，如果设置为 true，那么有可能会耗尽虚拟地址的空间，因为 gc 不能快速回收未使用的映射空间。

JGit 对此参数的默认值为 false。尽管速度会慢一些，但可以预测某些不好行为的发生。

**core.asyncLoggingBufferSize**

存储 log 的缓冲区的大小。在 AsyncAppender 线程不能从缓存区快速处理 log 时，设置较大的值可以保护线程不停止，还可以保证 log 不丢失。

默认值：64

**core.useRecursiveMerge**

对于 three-way merges，使用 JGit 的 `recursive merger` 处理方法。只会影响允许 merge 的 project。

可以参考 [blog](http://codicesoftware.blogspot.com/2011/09/merge-recursive-strategy.html) 。

默认值：true.

**core.repositoryCacheCleanupDelay**

定期从缓存中清理过期的 repository 的延迟时间。

支持的单位可以用缩写，如：`ms`, `sec`,`min`

如果设置为 0 ，那么将关闭缓存过期的功能。此时，若 heap 不够用的时候，JVM 会将相关信息从缓存中移除。

如果设置为 -1 ，从 `core.repositoryCacheExpireAfter` 获取清除的延迟时间。(选取 `core.repositoryCacheExpireAfter` 的 1/10 与 10 minutes 的最小值)。

默认值：-1

**core.repositoryCacheExpireAfter**

在 repository 的缓存中，如果 repository 在规定的时间内不使用的话，那么会从缓存中移除。

支持的单位可以用缩写，如：`ms`, `sec`,`min`

默认值：1 hour

### Section download

```
[download]
  command = checkout
  command = cherry_pick
  command = pull
  command = format_patch
  scheme = ssh
  scheme = http
  scheme = anon_http
  scheme = anon_git
  scheme = repo_download
```

download 部分配置了 git 仓和 change 的下载方式。

**download.command**

change 的下载命令。系统同时支持多个下载命令：

* `checkout`

用来 fetch 和 checkout patch-set.

* `cherry_pick`

用来下载 patch-set，并将其 pick 到当前的分支上。

* `pull`

用来 pull patch-set。

* `format_patch`

用来下载 patch-set，并用 `format-patch` 命令生成补丁文件。

如果 `download.command` 没有配置，默认显示上面提到的所有的命令。

**download.scheme**

下载 change 的方式。系统同时支持多种下载方式：

* `http`

下载需要 HTTP 的认证。

* `ssh`

下载需要 SSH 的认证。

* `anon_http`

可以 HTTP 匿名下载。

* `anon_git`

可以 Git 协议匿名下载。不过需要配置 `gerrit.canonicalGitUrl`。

* `repo_download`

假设 project 使用 repo 来管理，所以 Gerrit 建议使用 `repo download` 命令来下载 patch-set 。

如果不配置 `download.scheme`，系统默认提供 SSH, HTTP，Anonymous HTTP 的下载方式。

**download.checkForHiddenChangeRefs**

当 change 的 ref 隐藏的时候，是否自动调整下载命令。

git 有一个配置参数(`uploadpack.hideRefs`)，可以初始化的时候隐藏 ref。此参数可以隐藏客户端的 change 的 ref。因此，下载 change 的 ref 也就不起作用了。然而，可以将 `uploadpack.allowTipSha1InWant` 设置为 `true`，这样可以通过 commit-id 来下载 change 了。如果 `download.checkForHiddenChangeRefs` 设置为 `true`，那么 git 的下载命令需要使用 commit-id 进行下载，而不是使用 change 的 ref 进行下载。

.gitconfig 文件参考配置如下：

```
[uploadpack]
  hideRefs = refs/changes/
  hideRefs = refs/cache-automerge/
  allowTipSha1InWant = true
```

默认值：`false`.

**download.archive**

patch-set 的压缩方式，支持的方式如下，同时支持 `git-upload-archive` 操作：

```
[download]
  archive = tar
  archive = tbz2
  archive = tgz
  archive = txz
  archive = zip
```

默认值为上面列出的所有压缩方式。如果值设置为 `off` 或空字符串，那么会取消 patch-set 的压缩，同时取消 `git-upload-archive` 的支持。

不支持 zip 格式，因为会和 Java plugin 的 JAR 文件相冲突。所以不建议使用 `zip` 格式。

**download.maxBundleSize**

下载过程中，bundle 的最大值。bundle 在内存中，用来避免单一的请求消耗太多的 heap，进行影响其他用户使用的情况发生。

默认值：100MB.

### Section gc

此部分用来配置执行 gerrit gc 任务，执行时，所有的 project 都会 gc。

**gc.aggressive**

gerrit 执行 gc 的时候是否使用 aggressive 模式。 Aggressive 的 gc 会耗费系统更多的性能，但效果会更好。

有效值为 "true" 和 "false" 

默认值："false"

**gc.startTime**

gc 开始的时间，可以参考本文 `schedule configuration` 的 `startTime` 部分。

**gc.interval**

执行 gc 的频率，可以参考本文 `schedule configuration` 的 `interval` 部分。

配置示例可参考本文 `Schedule Configuration` 部分。

### Section gerrit

**gerrit.basePath**

本地存储 git 仓的路径。新创建的 git 仓的路径为：`"${basePath}/${project_name}.git"`。

默认路径为：`'$site_path'/git`.

**gerrit.allProjects**

用于全局配置的 project 名称。

默认值：`All-Projects`

**gerrit.allUsers**

用于存储用户信息的 project 名称。

默认值：`All-Users`

**gerrit.canonicalWebUrl**

gerrit 的 web 地址。

需要设置此参数，因为 change 页面显示的一些命令会调用此参数配置。

**gerrit.canonicalGitUrl**

使用 git 协议进行下载的 URL，例如：`git://mirror.example.com/base/`，gerrit 会在页面显示此 URL 的相关下载命令。

默认不设置，因为需要额外配置 `git daemon`。

**gerrit.docUrl**

gerrit 说明文档的 URL，如："index.html", "rest-api.html" 等。此参数对应的是 gerrit 页面的 "Documentation" 标签的链接。

如果不设置或设置为空，URL 为 `/Documentation/index.html` 。

**gerrit.editGpgKeys**

如果启用 GpgKeys 的相关功能，那么服务器端启用推送的签名验证，gerrit 页面可以编辑 `GPG keys`。如果禁用，那么只有管理员可以添加 `GPG keys`。

默认值：true

**gerrit.installCommitMsgHookCommand**

gerrit 上显示的下载 `commit-msg` hook 的命令，如下：

```
fetch-cmd some://url/to/commit-msg .git/hooks/commit-msg ; chmod +x .git/hooks/commit-msg
```

默认不设置，使用 scp 命令或者使用 curl 命令从 gerrit 服务器下载；如果配置了 proxy 获取其他的的 `server/network` 配置，那么有可能会阻止用户的下载。

**gerrit.gitHttpUrl**

使用 HTTP 协议进行下载的 URL，例如：`http://mirror.example.com/base/`，gerrit 会在页面显示此 URL 的相关下载命令。

默认不设置，因为需要额外配置 `HTTP daemon`。

**gerrit.installModule**

在 Gerrit 启动和初始阶段，加载 Guice 模块的类名的列表。

类被 gerrit 加载器所解析，因此，类需要在 `/lib` 目录下的 JAR 文件中声明。

默认不设置。

Example:
```
[gerrit]
  installModule = com.googlesource.gerrit.libmodule.MyModule
  installModule = com.example.abc.OurSpecialSauceModule
```

**gerrit.listProjectsFromIndex**

启用从 `secondary index` 加载 project 列表，而不是从内存的缓存中加载。

默认值：false

**NOTE:**
*缓存 (设置为 false) 可以为 API 或 SSH 命令提供一个长度没有限制的 project 列表。`secondary index` (设置为 true)受 `queryLimit` 限制，默认 500 条信息。*

**gerrit.primaryWeblinkName**

gerrit 页面上 `Weblink` 的名称。 

默认不设置，gerrit 会根据实际情况自动识别，如： Gitiles 和 Gitweb 。

示例:
```
[gerrit]
  primaryWeblinkName = gitiles
```

**gerrit.reportBugUrl**

反馈 bug 的 URL。

默认不设置，意味着不显示 bug 的反馈信息。

**gerrit.reportBugText**

用来显示 `bug report URL` 的文本信息。

只有设置了 `gerrit.reportBugUrl` ，才可以使用此参数。

默认值："Report Bug"

**gerrit.enableReverseDnsLookup**

启用 `reverse DNS lookup`，在 ref log 中记录用户的机器名称。

在 `reverse DNS lookup` 缓慢的情况下，如果启用了 `reverse DNS lookup`，那么在 `git push` 的时候，会引起性能的问题。

默认值： false, 禁用 `reverse DNS lookup`。ref log 中会记录用户的 IP 地址，而不是机器名称。

**gerrit.secureStoreClass**

使用指定类实现安全存储。

如果具体设置，类需要实现 `com.google.gerrit.server.securestore.SecureStore` 接口，并且包含此类的 jar 文件需要存放在 `$site_path/lib` 文件夹下。

如果没有设置，默认使用 no-op 实现。

**gerrit.canLoadInIFrame**

由于安全原因，gerrit 会 `jump out` iframe。如果设置为 true，那么会阻止这个行为。

默认值：false

**gerrit.cdnPath**

如果使用了 CDN，此参数值为 PolyGerrit 静态资源的前缀。

**gerrit.faviconPath**

PolyGerrit 的 favicon 的路径，包括 icon 名称和扩展名。

**gerrit.instanceName**

用于标识 gerrit，在众多的 gerrit 中可以进行识别。

默认值为 gerrit 服务器的名称。

**gerrit.serverId**

用于 NoteDb 识别某个服务器的用户身份。

如果不设置，那么在 gerrit 启动时，会生成随意的 UUID 用以标识服务器。

**NOTE:**
*如果此值与现有 NoteDb 使用的 serverId 不匹配，那么 gerrit 无法使用此 NoteDb，并显示相关异常信息。*

### Section gitweb

Gerrit 可以将请求转发到内部或外部的 gitweb 上面，可以参考 [Gitweb 集成](config-gitweb.md)。

**gitweb.cgi**

`gitweb.cgi` 可执行文件的路径。此文件会在用户链接 `/gitweb` 时被 gerrit 调用。

如果没有设置 `gitweb.url`，那么此参数的默认值为：`/usr/lib/cgi-bin/gitweb.cgi`。

**gitweb.url**

gitweb 服务的 URL。指定 `gitweb.cgi` 的安装位置，用于网页浏览 project。

Gerrit 会在此参数值后面添加一些搜索参数，如：`?p=$project.git;h=$commit`。

**gitweb.type**

gitweb 服务使用的类型。

有效值为：`gitweb`, `cgit`, `disabled`, `custom`.

如果不设置，或设置为 `disabled`, gerrit 页面不显示 gitweb 的超链接。

**gitweb.revision**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定的 commit。

可以使用 `${project}` 代替 project 的名称；`${commit}` 代替 SHA1 hash。

**gitweb.project**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定的 project。

可以使用 `${project}` 代替 project 的名称。

**gitweb.branch**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定的 branch。

可以使用 `${project}` 代替 project 的名称；`${branch}` 代替 branch 名称。

**gitweb.tag**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定的 tag。

可以使用 `${project}` 代替 project 的名称；`${tag}` 代替 tag 名称。

**gitweb.roottree**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定 revision 的根目录。


可以使用 `${project}` 代替 project 的名称；`${commit}` 代替 SHA1 hash。

**gitweb.file**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定 revision 的文件。

可以使用 `${project}` 代替 project 的名称；`${file}` 代替 file 的名称；`${branch}` 代替 branch 名称。

**gitweb.filehistory**

当 `gitweb.type` 设置为 `custom` 时，构造 gitweb 的 URL 用于访问指定的 文件在某个 branch 上修改的历史记录。

可以使用 `${project}` 代替 project 的名称；`${file}` 代替 file 的名称；`${commit}` 代替 SHA1 hash。

**gitweb.linkname**

Gerrit web-UI 所显示的 gitweb 链接名称。

默认值：`gitweb`

**gitweb.pathSeparator**

替代现有的路径分隔符 (斜线 /) 的字符。

默认，gerrit 在 project 和 branch 名称中使用斜线的十六进制编码作为分隔符。但有些 Web 服务器（如 Tomcat）拒绝在 URL 中使用十六进制编码。

有效的字符为： `*`, `(`, `)` 。

**gitweb.urlEncode**

是否对 gitweb 的 URL 进行 encode。通常，一些查看器（如 CGit gitweb）需要这些信息 encode；而其他的查看器（如 GitHub）需要的是未 encode 的信息。

有效值：`true`，`false`。

默认值：`true`

### Section groups

**groups.newGroupsVisibleToAll**

新创建的群组是否自动设置为注册用户可见。

默认值：false

**groups.<uuid>.name**

使用 UUID 来显示群组的名称。

此参数只支持 `system groups` (scheme 'global').

例如：此参数可以为 `Anonymous Users` 群组配置其他的名称：

```
[groups "global:Anonymous-Users"]
  name = All Users
```

设置此参数时，需要应验证系统中是否已有待命名的群组（区分大小写）。配置无效的名称会使 Gerrit 在启动时失败。Gerrit 设置后，确保无法使用此名称来创建群组。Gerrit 还会保留默认的名称，便于不能使用默认名称创建新的群组。这意味删除配置再改回默认名称时，不存在相关的风险。

### Section http

**http.proxy**

为 OpenID 登录进行外发 HTTP 连接的代理服务器的 URL。语法应该是 http://'hostname':'port'。

**http.proxyUsername**

向 HTTP 代理服务器认证的用户名，如果能不使用用户名，是天大的好事。

**http.proxyPassword**

向 HTTP 代理服务器认证的密码，如果能不使用密码，是天大的好事。

**http.addUserAsRequestAttribute**

如果设置为 true, 'User' 属性会添加到请求的属性中，便于链接外部的请求 (设置为 username ，如果 username 没有配置的情况下，使用 id)。

此属性可用于 servlet 容器记录用户的 http 访问 log。

在内置的 servlet 中，此属性用来在 http_log 中打印用户的 log。

* `%{User}r`

Tomcat 的 AccessLog 中，打印用户的格式。

默认值：true

**http.addUserAsResponseHeader**

如果设置为 true, 头部的 'User' 属性会添加到头部的响应列表中，便于反向代理服务器记录用户 log。

默认值：false

### Section httpd

httpd 章节描述的是内置的 servlet 容器。

**httpd.listenUrl**

可以访问 gerrit 提供 HTTP 服务的客户端的地址。'*' 表示所有的客户端都可以链接 gerrit 的 HTTP 服务。

支持多种协议：

* `http://`'hostname'`:`'port'

默认端口 80

* `https://`'hostname'`:`'port'

SSL 加密 HTTP 协议。默认端口 443。

推荐生产环境的站点使用反向代理和 `proxy-https://`（参考下面），而不是使用内嵌的 servlet 容器来实现 SSL 处理。支持 SSL 的代理服务器更容易配置，提供更多配置来控制密码的使用，并且可以使用本机编译的加密算法，从而提高吞吐量。

* `proxy-http://`'hostname'`:`'port'

纯文本的 HTTP 可以使用反向代理。默认端口为：8080。

与 http 类似，启用 http 头部解析特性可以支持 X-Forwarded-For, X-Forwarded-Host 和 X-Forwarded-Server。头部可以通过 Apache 的 [mod_proxy](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#x-headers) 进行设置。

* `proxy-https://`'hostname'`:`'port'

纯文本的 HTTP 可以使用 SSL 加密/解密的反向代理。默认端口为：8080。

行为与 proxy-http 相同，需要将 scheme 设置为假设返回服务器的 'https://' URL。

可以配置多个值。

默认值：http://*:8080

**httpd.reuseAddress**

如果设置为 true，允许 daemon 绑定已经使用的端口。如果设置为 false，需要确保端口没有被使用的情况下才可以使用。

默认值：true

**httpd.gracefulStopTimeout**

设置停止服务的时间。如果设置了，daemon 要确保关闭进程之前，所有的调用要保留一段时间。负载均衡器（例如 HAProxy）后面的站点需要设置此值，为了避免在重新启动期间出现服务错误。

支持的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes

默认值：0 seconds (立刻关闭)

**httpd.inheritChannel**

如果设置为 true, 允许 httpd daemon 从 fd0/1(stdin/stdout) 继承服务器的 socket channel。如果设置为 true，服务器可以通过 systemd 或 xinetd 激活 socket。

默认值：false

**httpd.requestHeaderSize**

解析传入 HTTP 请求的 HTTP 头部缓冲区的大小。完成的请求头部（包括从浏览器发送的 cookie）必须要在此缓冲区内，否则服务器会丢弃此请求并返回响应 '413 Request Entity Too Large'。

每个活动连接会被分配一个此大小的缓冲区。分配的缓冲区太大会浪费内存，分配太小可能会引起异常。

默认情况下，16384（16 K）足以满足大多数 OpenID 和其 SSO 的集成。

**httpd.sslCrl**

PEM 格式的证书废除的列表文件路径。此 crl 文件是可选的，对 CLIENT_SSL_CERT_LDAP 认证是可用的。

使用 openssl 创建和查看 crl：

```shell
openssl ca -gencrl -out crl.pem
openssl crl -in crl.pem -text
```

如果不使用绝对路径，会使用相对路径 `$site_path`。

默认值：`$site_path/etc/crl.pem`.

**httpd.sslKeyStore**

Java keystore 包含服务器的 SSL 证书和 private key 的路径。`https://` 的 URL 需要此 keystore。

创建自认证证书的简单用法：

```shell
keytool -keystore keystore -alias jetty -genkey -keyalg RSA
chmod 600 keystore
```

如果不配置绝对路径，那把路径是 `$site_path` 的相对路径。

默认值：`$site_path/etc/keystore`

**httpd.sslKeyPassword**

用来解密私有部分 sslKeyStore 的密码。即使管理员不需要启用的情况下，Java keystores 仍然需要使用密码。

如果设置为空字符串，那么服务在启动阶段会有密码的相关提示。

默认值：`gerrit`

**httpd.requestLog**

启用或禁用 `'$site_path'/logs/httpd_log` 请求的 log。如果启用，那么会输出关于 HTTP 访问的 NCSA 格式的 log。

`httpd_log` 可以配置 `log4j.appender` 格式的 log。

默认情况下，如果 httpd.listenUrl 设置为 http:// or https://，那么值为 true；如果 httpd.listenUrl 设置为 proxy-http:// or proxy-https://，那么值为 false。

**httpd.acceptorThreads**

允许接受新的 TCP 链接并且使其链接具体资源的线程的数量。

默认值：2，此值适用于流量大的站点。

**httpd.minThreads**

线程池中最小的备用线程的数量。此值至少比 `httpd.acceptorThreads` 设置的值大 1。

默认值：5, 适合于大多数负载不是很高的站点。

**httpd.maxThreads**

线程池内最大的工作线程的数量。

默认值：25, 适合于大多数负载不是很高的站点。

```
NOTE
除非禁用 SSH daemon，否则可以接受的 Git 请求还包括 SSH 协议，如 `sshd.threads`，`sshd.batchThreads`。
```

**httpd.maxQueued**

最大数量的客户端链接，链接进入线程池等待可用的线程进行链接。如果设置为 0，表示队列的大小为 Integer 的最大值。

默认值：200

**httpd.maxWait**

客户端链接（clone，fetch，push）等待可用 HTTP 线程的最大时长。

可以使用的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days
* w, week, weeks (`1 week` 看作是 `7 days`)
* mon, month, months (`1 month` 看作是 `30 days`)
* y, year, years (`1 year` 看作是 `365 days`)


默认单位为 `minutes`。如果设置为 0，那么客户端会无限等待，指导客户端放弃链接。

默认值：5 minutes

**httpd.filterClass**

实现 `javax.servlet.Filter` 接口的类，通过 Gerrit HTTP 协议可以过滤 HTTP 相关的访问。Gerrit Jetty 容器中加载和配置的类，可以在所有的 gerrit URL 前运行，用来分析、修改、允许或拒绝请求。需要将 JAR lib 库存放在 `$GERRIT_SITE/lib` 目录下，因为需要使用默认的 Gerrit 类加载器处理，并且不支持 plugin 的动态加载。

未能加载 Filter 类会导致 Gerrit 启动失败，因为此类应该在 Gerrit HTTP 协议之前进行强制过滤。

通过将受信任的用户名作为 HTTP 头部返回，使用 `auth.type=HTTP` 替换 Apache HTTP 代理层作为 Gerrit 之上的安全实施。

允许多个值使用多个 servlet 过滤器。

例如：在 `$GERRIT_SITE/lib` 目录下存放一个 secure.jar 文件，此文件提供了一个 `org.anyorg.MySecureHeaderFilter` Servlet 过滤器，该过滤器在 `TRUSTED_USER` HTTP 头部中强制使用受信任的用户名；`org.anyorg.MySecureIPFilter` 执行源IP安全过滤。

```
[auth]
	type = HTTP
	httpHeader = TRUSTED_USER

[httpd]
	filterClass = org.anyorg.MySecureHeaderFilter
	filterClass = org.anyorg.MySecureIPFilter
```

**httpd.idleTimeout**

链接闲置时间的最大值，与 TCP socket `SO_TIMEOUT` 对应。

如果链接过程中，有单一的 byte 被读或被写，那么时间会重新计时。

此参数应用如下：

* 等待新消息的接收
* 等待发送新消息

默认值：30 seconds

**httpd.robotsFile**

要使用的外部 robots.txt 文件的位置，此文件用来代替绑定 .war 的文件。

如果不配置绝对路径，那么会使用 `$site_path` 的相对路径。

如果此文件不存在或文件不可读，那么会使用默认绑定 .war 的 robots.txt 文件。

**httpd.registerMBeans**

为 Java JMX 启用或禁用 Jetty MBeans 的注册

默认值：false

### Section index

此部分描述了如何配置 secondary index。

启用 secondary index 后，在重启 gerrit 服务之前，需要使用 [reindex program](pgm-reindex.md) 来构建 index。

**index.type**

支持的 index 类型如下：

* `LUCENE`

使用 [Lucene](http://lucene.apache.org/) 进行 index

* `ELASTICSEARCH` 

使用 [Elasticsearch](https://www.elastic.co/products/elasticsearch) 进行 index，可以参考本文的 `elasticsearch` 部分。

默认值：`LUCENE`.

**index.threads**

处理 index 操作的线程数量。如果设置为 0 ，那么将取消线程池，index 的操作将在系统中的操作线程中完成。

如果不设置或者设置为 0 ，将通过 JVM 返回默认的逻辑 CPU 数量值；如果设置为负数，会被系统直接执行。

**index.batchThreads**

后台处理 index 的线程数量，如：在线升级 schema。

如果不设置或者设置为 0 ，将通过 JVM 返回默认的逻辑 CPU 数量值；如果设置为负数，会被系统直接执行。

**index.onlineUpgrade**

是否可以在线升级 index schema 的版本。推荐启用此功能，因为可以在 gerrit 服务不暂停的情况下进行升级，但使用时，会消耗服务器的性能。

如果设置为 false,，只能停止 gerrit 服务进行 index 的升级。

默认值：true

**index.maxLimit**

允许搜索信息条目的上限。请求的结果会根据此参数值进行截断。设置为 0，此参数值为无上限。

当 `index.type` 设置为 `ELASTICSEARCH`，此参数值不要超过 Elasticsearch 服务器配置的 `index.max_result_window` 值。如果此值没有配置，那么在站点初始化过程中，默认设置为 10000，此默认值来源于 Elasticsearch 的 `index.max_result_window` 的默认值。

当 `index.type` 设置为 `LUCENE`，默认为无限制。

**index.maxPages**

允许的最大搜索结果的 page，因为搜索使用偏移量的时候，index 扫描的时候有可能会跳过大量的数据。请求的结果超过阈值的时候有可能会导致错误。因此设置为 0，表示无限制。

默认为无限制。

**index.maxTerms**

搜索中允许的最大 leaf 数量。太大的搜索执行起来效果比较差。

当 index type 设置为 `LUCENE` 时，还要设置每个 BooleanQuery 允许的最大值。这样可以强制所有的搜索上限是相同的。

默认值：1024

**index.reindexAfterRefUpdate**

更新 ref 后，是否重新 index 受影响的 open 状态的 change，比如需要计算 open 状态的 change 是否为 "mergeable"。

如果不启用此功能，那么相关 change 的信息不会刷新；如果启用，在有大量 open 状态 change 的情况下，会消耗系统的一些性能。

默认值：true

**index.autoReindexIfStale**

index 后，是否立即自动检查文档有没有失效。如果设置为 false，当两个同时写入的时候，其中一个有可能会写入 index 失败。如果设置为 true，会消耗一些系统性能。

默认值：false

#### Subsection index.scheduledIndexer

此部分配置用于定期执行 index 操作。此操作只在 slave 模式的机器上执行，并且用来更新群组的 index 信息。Replication 是 git 层级的操作，对于 slave 模式的 gerrit 来说，是感知不到的。但是 slave 模式下需要更新群组 index，以便保证从 master 同步过来的权限配置可以正常使用。为了保证 slave 机器上的群组 index 状态是最新的，需要定期扫描 All-Users 仓的 ref，以便更新信息。

计划任务需要在 slave 模式下的 gerrit 服务运行的时候执行。如果 slave 模式下的 gerrit 没有启动，此时 master 模式的 gerrit 上面删除了群组，那么在启动 slave 模式的 gerrit 时，需要执行一次 [reindex]（pgm-reindex.md）。

**此部分描述的是 gerrit 运行在 slave 模式下的配置。**

**index.scheduledIndexer.runOnStartup**

gerrit 服务启动时，是否执行一次计划任务。如果设置为 `true`，slave 机器的服务启动要被阻止直到所有群组的 index 状态更新到最新。

默认值：true

**index.scheduledIndexer.enabled**

是否启用计划执行 index 操作。如果禁用此设置，slave 机器中，需要用其他方法保证群组的 index 状态是最新的（例如，使用 ElasticSearch 作为 index）。

默认值：true

**index.scheduledIndexer.startTime**

计划执行 index 开始的时间，可以参考本文 `schedule configuration` 的 `startTime` 部分。

默认值：`00:00`

**index.scheduledIndexer.interval**

计划执行 index 的频率，可以参考本文 `schedule configuration` 的 `interval` 部分。

默认值：`5m`

计划任务的例子可以参考本文的 `schedule configuration` 部分。

#### Lucene configuration

Open 和 closed 状态的 changes 分别被 index，index 的名称为 'open' 和 'closed'。

下面是 index 类型为 `LUCENE` 时的配置描述。

**index.name.ramBufferSize**

在刷新缓存之前，用于存储文档缓存的内存的大小。更多信息可以参考 [Lucene 文档](http://lucene.apache.org/core/4_6_0/core/org/apache/lucene/index/LiveIndexWriterConfig.html#setRAMBufferSizeMB(double))。

默认值：16M

**index.name.maxBufferedDocs**

在刷新缓存之前，用于存储文档缓存的最小内存值。值越大，index 操作越快。更多信息可以参考 [Lucene 文档](http://lucene.apache.org/core/4_6_0/core/org/apache/lucene/index/LiveIndexWriterConfig.html#setMaxBufferedDocs(int))。

默认值：-1，意味着不设置最大值，根据 RAM 的使用情况进行写入。

**index.name.commitWithin**

change 自动存储到硬盘上的时间段。操作花费的代价有些大，因为会阻止 index 的写入，所以要小心操作。

如果设置为 0，change 有变更后，会立即进行存储，虽然花费的代价有些大，但对不可执行线下 index 的服务器和开发的服务器来说却比较有用。

支持的单位如下：`ms`, `sec`,`min` 等。

如果为负数，`commitWithin` 功能会被禁用。当缓存用尽时，change 会存储到硬盘。

默认值：300000 ms (5 minutes)

Lucene index 配置示例如下:
```
[index]
  type = LUCENE

[index "changes_open"]
  ramBufferSize = 60 m
  maxBufferedDocs = 3000

[index "changes_closed"]
  ramBufferSize = 20 m
  maxBufferedDocs = 500
```

### Section elasticsearch

WARNING: Elasticsearch 的支持还在实验阶段，不推荐在生产环境中使用。更多信息，可以参考 [project homepage](https://www.gerritcodereview.com/elasticsearch.html)。

当使用 Elasticsearch version 5.6 时，open 和 closed 状态的 changes 存储在单一的 index 中，存储的类型为 `open_changes` 和 `closed_changes`。当使用 6.2 及以后的版本时，
open 和 closed 状态的 changes 存储的类型为 `_doc`。账户和群组的 index 开始于 6.2 版本。

gerrit 配置 Elasticsearch 时，需要确保 Elasticsearch 可用。

**elasticsearch.prefix**

index 前缀的名称。当多个 gerrit 配置了同一个 elasticsearch 服务器时，需要使用前缀进行区分。例如，前缀 `gerrit1_` ，那么 change index 名称为 `gerrit1_changes_0001`。

默认不设置。

**elasticsearch.server**

Elasticsearch 服务器的 URI，格式为：`http[s]://hostname:port`。`port` 的默认值为 `9200`。

至少需要配置一个服务器信息。

站点初始化的时候只允许配置一个服务器的信息。如果要配置多个服务器，新手动编辑配置文件 `gerrit.config`。

**elasticsearch.numberOfShards**

每个 index 使用的 shard 的数量。可以参考 [Elasticsearch 文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/_basic_concepts.html#getting-started-shards-and-replicas)。

默认值：5

**elasticsearch.numberOfReplicas**

每个 index 使用的 replica 的数量。可以参考 [Elasticsearch 文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/_basic_concepts.html#getting-started-shards-and-replicas)。

默认值：1

#### Elasticsearch Security

当 Elasticsearch 启动安全设置时，需要提供用户名和密码。所有 Elasticsearch 服务器的用户名和密码都是相同的。

Elasticsearch 安全方面的设置，可以参考下面链接：

* [Elasticsearch 5.6](https://www.elastic.co/guide/en/x-pack/5.6/security-getting-started.html)
* [Elasticsearch 6.2](https://www.elastic.co/guide/en/x-pack/6.2/security-getting-started.html)
* [Elasticsearch 6.3](https://www.elastic.co/guide/en/elastic-stack-overview/6.3/security-getting-started.html)
* [Elasticsearch 6.4](https://www.elastic.co/guide/en/elastic-stack-overview/6.4/security-getting-started.html)
* [Elasticsearch 6.5](https://www.elastic.co/guide/en/elastic-stack-overview/6.5/security-getting-started.html)
* [Elasticsearch 6.6](https://www.elastic.co/guide/en/elastic-stack-overview/6.6/security-getting-started.html)

**elasticsearch.username**

链接 Elasticsearch 的 username 。

如果设置了 password ，其默认值为 `elastic`。

**elasticsearch.password**

链接 Elasticsearch 的 密码 。

默认不设置密码。

### Section ldap

如果 `auth.type` 设置为 `HTTP_LDAP`, `LDAP`, `CLIENT_SSL_CERT_LDAP` 将启用 LDAP 的集成。

LDAP 配置的示例如下所示：

```
[ldap]
  server = ldap://ldap.example.com

  accountBase = ou=people,dc=example,dc=com
  accountPattern = (&(objectClass=person)(uid=${username}))
  accountFullName = displayName
  accountEmailAddress = mail

  groupBase = ou=groups,dc=example,dc=com
  groupMemberPattern = (&(objectClass=group)(member=${dn}))
```

**ldap.guessRelevantGroups**

基于猜测来过滤 LDAP 中找到的群组。基于两个方式进行猜测，近期在缓存中使用的项目和权限中已配置的群组。

需要注意的是，即使配置了权限，有权限的人员对于很少使用的项目或者未缓存的项目有可能不能访问。

默认值：true

**ldap.server**

LDAP 服务器的 URL，用于搜索用户和群组信息。格式必须为：`ldap://host` 或者 `ldaps://host`。

如果 `auth.type` 设置为 `LDAP`，此参数值的格式可以是 `ldaps://` ，便于文本格式的密码在传输过程中可以被加密。

**ldap.startTls**

如果设置为 true, Gerrit 会执行 StartTLS 相关的操作。

默认值：false, 不启用 StartTLS 。

**ldap.sslVerify**

如果设置为 false 并且 ldap.server 的格式是 `ldaps://` 或者 `ldap.startTls` 设置为 true, gerrit 不会对服务器的证书进行验证。

默认值：true, 证书需要进行验证

**ldap.groupsVisibleToAll**

如果设置为 true, 注册用户可以看到 LDAP 群组。

默认值：false, 群组成员可以看到所在的 LDAP 群组，管理员可以看到所有 LDAP 群组。

**ldap.username**

访问 LDAP 服务器的用户名称。如果不设置，会用匿名方式链接 LDAP 服务器。

**ldap.password**

与 `ldap.username` 对应的密码。如果不设置，会用匿名方式链接 LDAP 服务器。

**ldap.referral**

如果在目录遍历期间遇到 LDAP 的引用，应如何处理。将值设置为 `follow` 可以自动跟随任何引用，或者设置为 `ignore` 忽略引用。

默认值：`ignore`

**ldap.readTimeout**

LDAP 进行读操作时候的超时时间，值的格式为："1 s", "100 ms" 等。超时可以用来在 LDAP 服务器变得缓慢的时候，避免阻塞 SSH 命令启动的线程。

默认，不配置超时，gerrit 会一直等待 LDAP 服务器响应，直到 TCP 链接超时。

**ldap.accountBase**

包含所有用户账户的树状结构的顶部。格式为：`ou=people,dc=example,dc=com`。

此参数可以配置多个值。

**ldap.accountScope**

搜索帐号的范围，有效值如下：

* `one`: 只搜索 accountBase 下面的一个层级，非递归搜索。
* `sub` 或 `subtree`: 递归搜索 accountBase 下面的层级。
* `base` 或 `object`: 搜索明确的 accountBase；但有可能不是想搜索的范围。

默认值：`subtree`，因为一些目录有子层级。

**ldap.accountPattern**

搜索用户账户时，使用的搜索格式，需要有效的 LDAP 搜索表达式，包括 `(&...)` 和 `(|...)` 操作符。如果 `auth.type` 设置为 `HTTP_LDAP`，那么 `${username}` 变量会用 HTTP 服务器提供的变量进行取代。如果 `auth.type` 设置为 `LDAP`，`${username}` 变量会被用户配置的字符串所取代。

此格式直接在 `ldap.accountBase` 目录下进行搜索，参数一般设置为 `(uid=${username})` 或 `(cn=${username})`，但正确的配置还要参考目录服务器的 LDAP 版本。

对 FreeIPA 和 RFC 2307 服务器来说，默认值是 `(uid=${username})`；对 Active Directory 来说，默认值为 `(&(objectClass=user)(sAMAccountName=${username}))`。

**ldap.accountFullName**

用户账户的一个属性值，用来在 gerrit 中初始化 `full name` 字段。属性值一般是 LDAP 中的 `displayName` 字段，或是 `legalName` 或 `cn`。

属性值可以使用字符串来链接，如 链接 `given` 名字和 `surname` 名字，格式为：`${givenName} ${SN}`。

如果进行了配置，那么用户的 `full name` 字段将不能被修改，因为此数据需要从 LDAP 进行同步。

对 FreeIPA 和 RFC 2307 服务器来说，默认值是 `displayName`；对 Active Directory 来说，默认值为 `${givenName} ${sn}`。

**ldap.accountEmailAddress**

用户账户的一个属性值，此属性值为邮箱地址，来源于 LDAP 服务器。

属性值可以由字符串连接，邮箱地址设置为：sAMAccountName 的小写格式与 domain 名称的连接，如：`${sAMAccountName.toLowerCase}@example.com`。

如果设置此参数，那么 `preferred` 邮箱会默认来源于 LDAP 服务器，用户可以通过注册新邮箱的方式来更改 `preferred` 邮箱。

默认值：`mail`

**ldap.accountSshUserName**

用户账户的一个属性值，为 SSH 用户名称信息。通常，此值为 LDAP 的 `uid` 属性，或是 `cn` 属性。另外，此值可以使用用户工作站的名称，因为 SSH 客户端会默认使用这个名称。

属性值可以强制的转换为小写或者大写，如，`${sAMAccountName.toLowerCase}` 会强制将 sAMAccountName 转换为小写。`.toUpperCase` 用来转换为大写。`.localPart` 可以分离属性值，例如 `${userPrincipalName.localPart}` 可以将 'user@example.com' 的 'user' 信息分离出来。

如果设置此参数，用户不能修改 `SSH username` 字段信息，因为数据来源于 LDAP 服务器。另外，此参数值不建议用户修改，如果修改的有差错，会影响用户登录。

对 FreeIPA 和 RFC 2307 服务器来说，默认值是 `uid`；对 Active Directory 来说，默认值为 `${sAMAccountName.toLowerCase}`。

**ldap.accountMemberField**

用户账户的一个属性，用来描述用户在哪个群组中。一般在 Active Directory 和 FreeIPA 服务器中使用。

对 RFC 2307 服务器来说，默认不设置或禁用；对 Active Directory 和 FreeIPA 来说，默认值为 `memberOf`。

**ldap.accountMemberExpandGroups**

是否展开递归的群组。此参数只有 `ldap.accountMemberField` 设置的时候才可以使用。

对 FreeIPA 来说，默认值为 `true`；对 Active Directory 和 RFC 2307 服务器来说，默认不设置。

**ldap.fetchMemberOfEagerly**

登录的时候是否同步帐号的 `memberOf` 属性。使用 LDAP 进行用户认证，但不使用 LDAP 群组的设置，此时如果将参数值设置为 `false` 的话，那么会家还 LDAP 的登录。

对 RFC 2307 服务器来说，默认不设置；对 Active Directory 和 FreeIPA 来说，默认值为 `true`。

**ldap.groupBase**

包含所有群组的树状结构的顶部。格式为：`ou=groups,dc=example,dc=com`。

此参数可以配置多个值。

**ldap.groupScope**

搜索群组的范围，有效值如下：

* `one`: 只搜索 accountBase 下面的一个层级，非递归搜索。
* `sub` 或 `subtree`: 递归搜索 accountBase 下面的层级。
* `base` 或 `object`: 搜索明确的 accountBase；但有可能不是想搜索的范围。

默认值：`subtree`，因为一些目录有子层级。

**ldap.groupPattern**

搜索群组时，使用的搜索格式，需要有效的 LDAP 搜索表达式，包括 `(&...)` 和 `(|...)` 操作符。`${groupname}` 变量会被用户配置的字符串所取代。

对 FreeIPA 和 RFC 2307 服务器来说，默认值是 `(cn=${groupname})`；对 Active Directory 来说，默认值为 `(&(objectClass=group)(cn=${groupname}))`。

**ldap.groupMemberPattern**

搜索用户所在群组的格式，需要有效的 LDAP 搜索表达式，包括 `(&...)` 和 `(|...)` 操作符。

如果 `auth.type` 设置为 `HTTP_LDAP`，那么 `${username}` 变量会用 HTTP 服务器提供的变量进行取代。如果格式中有其他的变量，如 `${fooBarAttribute}`，会被 `ldap.accountBase` 下面的相关属性（如 `fooBarAttribute`）所取代，有可能还是使用到 `${dn}` 和 `${uidNumber}` 属性。

对 RFC 2307 服务器来说，默认值是 `(|(memberUid=${username})(gidNumber=${gidNumber}))`；对 Active Directory 和 FreeIPA 来说，默认为禁用或不设置。

**ldap.groupName**

群组的一个属性值，包含了 gerrit 上使用的群组名称。

对 RFC 2307 和 Active Directory 服务器来说，默认值是 `cn`；其他的服务器有可能不同，例如在 `Apple MacOS X` 服务器为 `apple-group-realname`。

属性值可以使用字符串进行连接，例如创建一个由 LDAP 群组和 `group ID` 组成的群组名称：`${cn} (${gidNumber})`。

默认值：`cn`

**ldap.mandatoryGroup**

需要是 `mandatoryGroup` 用户的成员才可以进行认证。

配置此参数需要启用 `ldap.fetchMemberOfEagerly` 的设置。

默认不设置

**ldap.localUsernameToLowerCase**

进行 LDAP 认证之前，gerrit 将用户名转换为小写。如果设置为 true，那么只能用小写进行登录。

在此参数设置为 true 之前，需要确保 gerrit 存储的用户名都已经转换为了小写，否则含有大写字符的帐号将不能登录 gerrit。gerrit 存储的用户如何转换为小写，可以参考 [LocalUsernamesToLowerCase](pgm-LocalUsernamesToLowerCase.md)。用户名转换为小写的过程是不可逆的。新增的用户，gerrit 会用小写进行存储。

默认值：false.

**ldap.authentication**

定义 gerrit 如何与 LDAP 服务器认证。如果设置为 `GSSAPI`，gerrit 会使用 Kerberos 进行认证。若要使用 kerberos，需要将 `java.security.auth.login.config` 系统属性指向一个 JAAS 的配置。

jaas.conf 示例如下：

```
KerberosLogin {
    com.sun.security.auth.module.Krb5LoginModule
            required
            useTicketCache=true
            doNotPrompt=true
            renewTGT=true;
};
```

`renewTGT` 属性要确保 TGT 不会过期，并且 `useTicketCache` 会使用操作系统提供的 TGT。因为 GSSAPI 与 LDAP 服务认证的时候不需要密码，并且此参数本身不会获取新的 TGT。

在 Windows 服务器上，注册表 `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa\Kerberos\Parameters` 值的类型设置为 DWORD，`allowtgtsessionkey` 设置为 1 并且帐号需要有管理员权限。

**ldap.useConnectionPooling**

启用或禁用 LDAP 连接池。

如果设置为 true，LDAP 提供商会维护一个线程池用来分配链接，当链接结束后，会进行回收，便于后续其他实例继续使用。

更多信息可以参考：[LDAP connection management (Pool)](http://docs.oracle.com/javase/tutorial/jndi/ldap/pool.html) 和 [LDAP connection management (Configuration)](http://docs.oracle.com/javase/tutorial/jndi/ldap/config.html)。

默认值：false

**ldap.connectTimeout**

建立 LDAP 链接的超时的时长，值的格式为："1 s", "100 ms" 等。

默认不配置超时，gerrit 将无限的等待链接。

#### LDAP Connection Pooling

如果将 `ldap.useConnectionPooling` 属性设置为 `true`，那么可以启用 LDAP 链接线程池，线程池的配置可以通过 JVM 系统属性来配置，可以参考 [Java SE 文档](http://docs.oracle.com/javase/7/docs/technotes/guides/jndi/jndi-ldap.html#POOL)。

对于单独部署的 Gerrit (使用内置的 Jetty 运行)，JVM 系统的属性可以在 gerrit.config 的 `container` 部分进行配置：

```
  javaOptions = -Dcom.sun.jndi.ldap.connect.pool.maxsize=20
  javaOptions = -Dcom.sun.jndi.ldap.connect.pool.prefsize=10
  javaOptions = -Dcom.sun.jndi.ldap.connect.pool.timeout=300000
```

### Section lfs

**lfs.plugin**

plugin 的名称，此 plugin 用于为 `<project-name>/info/lfs/objects/batch` 提供 [LFS protocol](https://github.com/github/git-lfs/blob/master/docs/api/v1/http-v1-batch.md) 的服务。如果不设置，当发送 LFS 协议相关的请求时，gerrit 会返回 `501 Not Implemented`。

默认不设置

### Section log

**log.jsonLogging**

如果设置为 true，使用 JSON 格式存储 log (文件名称: "logs/error_log.json")。

默认值：false.

**log.textLogging**

如果设置为 true，将使用文本格式存储 log。只有 `jsonLogging` 启用的时候，此参数才能设置为 false。

默认值：true.

**log.compress**

如果设置为 true，log 文件会在每天的 23 点被压缩 (服务器的本地时间)。

默认值：true.

**log.rotate**

如果设置为 true，log 文件会在每天的午夜(GMT)重新生成。

默认值：true.

### Section mimetype

**mimetype.<name>.safe**

如果设置为 true, mimetype `<name>` 的文件可以通过浏览器直接下载，而不是压缩包下载。`<name>` 需要指定具体的文件类型，如：`image/gif`, 或者使用通配类型：`+image/*+`，或者使用通配符适配所有类型：`+*/*+`。

默认值：false

示例如下：
```
[mimetype "image/*"]
  safe = true

[mimetype "application/pdf"]
  safe = true

[mimetype "application/msword"]
  safe = true

[mimetype "application/vnd.ms-excel"]
  safe = true
```

### Section noteDb

NoteDb 是基于 git 存储的数据库，用于 gerrit。更多信息可以参考 [notedb](note-db.md)。

**notedb.accounts.sequenceBatchSize**

用户的序列号以 UTF-8 文本格式存储在 blob 中，此 blob 指向了 `All-Users` 仓的 `refs/sequences/accounts` ref。通过使用 git ref 的更新来使计数器递增，进而多个进程可以共享相同的序列号。此参数用于控制每个进程每次可以处理帐号的数量。

默认值：1

### Section oauth

只有 `auth.type` 设置为 `OAUTH` 才可以使用 OAuth 的集成。

默认情况下，当创建用户或重新加载用户信息时，系统会从 OAuth 提供商进行检索相关信息（如：`full name` 和邮箱地址）。如果提供商不支持检索，那么可以在 gerrit 页面手动编辑相关信息。

**oauth.allowEditFullName**

如果设置为 true, 可以在联系信息里编辑 `full name`。

默认值：false

**oauth.allowRegisterNewEmail**

如果设置为 true，可以注册新邮箱。

默认值：false

### Section pack

Gerrit 为客户端的 clone，fetch 或 pull 创建 pack 流的全局设置。

**pack.deltacompression**

如果设置为 true, 对 object 之间的 delta 进行压缩。需要更多的内存和 CPU 资源。

默认值：false

**pack.threads**

在启用 deltacompression 参数的情况下，每个用户请求所使用压缩的线程数量。

默认值：1

### Section plugins

**plugins.checkFrequency**

检查 plugin 的频率，如新的 plugin，移除 plugin，或更新 plugin。值的单位为：'ms', 'sec','min' 等。

如果设置为 0 ，将取消 plugin 的自动 reload 。管理员可以强制 [gerrit plugin reload](cmd-plugin-reload.md)。

默认值：1 minute

**plugins.allowRemoteAdmin**

如果设置为 true，管理可以远程 (SSH 或 HTTP) 启用或禁用 plugin。
默认值：false.

**plugins.jsLoadTimeout**

在 gerrit UI 中，为加载 JavaScript plugin 设置 timeout 的值。值的单位为：'ms', 'sec','min' 等。

默认值：5s 。 

千万不要将值设置为 0 。

### Section receive

此部分用来配置服务器端的 'receive-pack' 相关参数，对应于客户端的 'git push' 操作。

**receive.allowGroup**

允许执行 'git push' 的用户群组，可以配置一个或多个。

如果没有配置群组，那么所有用户都可以执行 'git push' 操作。

**receive.allowPushToRefsChanges**

如果设置为 true，可以向 `refs/changes/` 命名空间进行推送。在未来的版本中，此参数会被移除。

false 意味着禁止向 `refs/changes/` 推送。

默认值：false

**receive.certNonceSeed**

如果设置为非空值，并且服务器端启用了签名认证，那么此参数值用来作为 `HMAC SHA-1 nonce` 生成器 seed。 如果未设置参数值，服务器在启动时生成 64 字节的随机 seed 。

此参数值用于加密算法的 seed，建议在 `secure.config` 文件中配置此参数。

默认不设置

**receive.certNonceSlop**

When validating the nonce passed as part of the signed push protocol,
accept valid nonces up to this many seconds old. This allows
certificate verification to work over HTTP where there is a lag between
the HTTP response providing the nonce to sign and the next request
containing the signed nonce. This can be significant on large repositories,
since the lag also includes the time to count objects on the client.

默认值：5 minutes

**receive.changeUpdateThreads**

用于执行 change 的创建或 patch-set 更新的线程数量。每个线程从数据库线程池中使用自己的数据库链接，如果所有的线程都被使用的话，那么会使用 receive 线程用来创建或更新。

默认值：1，只使用主接收线程。

此功能适用于高延迟的数据库，一次修改多个 change 的场景。

**receive.checkMagicRefs**

如果设置为 true，gerrit 会验证目的 git 仓中没有 'refs/for' 开头的分支。

如果设置为 false，那么 gerrit 不进行验证。

默认值：true

**receive.allowProjectOwnersToChangeParent**

如果设置为 true，project-owner 可以修改 project 的继承关系。

默认只有管理员可以修改 project 的继承关系。

默认值：false

此参数支持 `reload` 操作。

**receive.checkReferencedObjectsAreReachable**

如果设置为 true，gerrit 会检查用户上传的所有 ref 是否可以访问，也就是验证是否有伪造的 SHA1。

在多个 git 仓的 多个 ref 上做此检查，有可能会大量耗费 CPU。对应非公开的 gerrit 服务器，可以禁用此功能。

如果信任用户不会伪造 SHA1，那么可以禁用此功能。

默认值：true.

**receive.enableSignedPush**

如果设置为 true，服务器端启用签名认证。

当客户端执行 `git push --signed` 命令时，要确保推送的证书是有效的，并且用于认证的 public key 已存储到 `All-Users` 的 `refs/meta/gpg-keys` 分支上。

默认值：false

**receive.maxBatchChanges**

一次上传 change 的最大数量。如果实际上传的数量大于此设置值，那么系统会拒绝，并报错。

'Batch Changes Limit' 全局配置参数的优先级高于此参数。

此参数可以用来防止用户错误的上传大量 change。

默认值：0, 无限制

**receive.maxBatchCommits**

一次直接 push 合入代码库（不经过代码评审）的 commit 数量。

默认值：10000

**receive.maxObjectSizeLimit**

接收 'receive-pack' 时，git object 的最大值。如果 object 的实际值大于设定值，那么 gerrit 会丢弃此链接。如果设置为 0，意味着无大小限制。

此参数也可以在 `project.config` 的 [receive.maxObjectSizeLimit](config-project-config.md) 参数中进行设置，这样更为灵活方便。

默认值：0

支持的单位如下：'k', 'm', or 'g'

**receive.inheritProjectMaxObjectSizeLimit**

project 层级的 [receive.maxObjectSizeLimit](config-project-config.md) 设置是否被子仓继承。如果设置为 `true`, 则继承。

默认值：false, 意味着不继承设置

**receive.maxTrustDepth**

如果启用了签名认证，检查 key 是否受信时搜索的最大深度。

默认值：0, 意味着只允许指定的信任的 key。

**receive.threadPoolSize**

用于接收 change 的 commit 的线程池的线程数量。

默认为 Java 运行时的 CPU 数量。

**receive.timeout**

处理 change 的 pack 数据的最大时长。此时长只包括处理 change 和 ref 的更新时间，不包括 change 的 index 时间。支持的单位如下：'ms', 'sec','min', 等。

默认单位：milliseconds

默认值：4 minutes

**receive.trustedKey**

启用签名验证时，服务器需要列出受信的 GPG key 的列表。如果 key 在此列表中，那么此 key 受信。

Key 的 fingerprints 可以通过 `gpg --list-keys --with-fingerprint` 命令进行列出。

信任的签名可以使用 `tsign` 命令及 [`gpg --edit-key`](https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Key-Management.html) 添加到 key 里面，添加后，签名的密钥需要重新上传。

如果没有配置 key，那么会取消 web-of-trust 的检查。默认不检查。

### Section repository

repository 在此章节等同于 project。

下面的示例中，配置 `Registered Users` 群组作为新 project 的 owner。

```
[repository "*"]
  ownerGroup = Registered Users
```

配置的格式支持精确匹配和模糊匹配，如果 project 有多条配置，已更精确的配置为准。示例如下：`project/plugins/a` 的 defaultSubmitType 为 `CHERRY_PICK`。

```
[repository "project/*"]
  defaultSubmitType = MERGE_IF_NECESSARY
[repository "project/plugins/*"]
  defaultSubmitType = CHERRY_PICK
```

```
NOTE
可以配置多个属性。另外，对于上面的示例来说，`project/plugins/\*` 不会从 `project/*` 继承任何属性配置。
```

**repository.<name>.basePath**

`gerrit.basePath` 的备用设置。gerrit 调用 git 仓的路径为：${alternateBasePath}/${projectName}.git.

如果配置了 `basePath`，需要停止 gerrit，并将 git 仓移到备用的 basePath 中，再重启 gerrit 服务。

路径需要为绝对路径。

**repository.<name>.defaultSubmitType**

新创建的 project 的默认 submit 类型。有效值如下：`INHERIT`, `MERGE_IF_NECESSARY`, `FAST_FORWARD_ONLY`, `REBASE_IF_NECESSARY`,`REBASE_ALWAYS`, `MERGE_ALWAYS`, `CHERRY_PICK`。

更多信息可以参考 [Project 的配置文件](config-project-config.md) 的 `Submit Types` 相关章节。

默认值：`INHERIT`

如果使用 API 创建 project ，但没有指定 submit 类型，此时，submit 类型为配置文件所配置的类型。对于一个已创建的 git 仓，如果没有设置 submit 类型，由于兼容性的原因，此时默认值为 `MERGE_IF_NECESSARY`，而不是 `INHERIT`。

**repository.<name>.ownerGroup**

已存在的群组名字。允许配置 0, 1 或多个群组。每个群组配置一行。配置了不存在的群组会被忽略掉。

### Section retry

**retry.maxWait**

当一次尝试操作失败后，等待重试操作的间隔时间。

默认值：5 seconds

默认单位：milliseconds

**retry.timeout**

一次尝试操作失败时，重试操作的超时时长。

通过设置 `retry.<operationType>.timeout` 参数，有可能基于操作类型覆盖此参数值。

默认值：20 seconds; 

默认单位：milliseconds

**retry.<operationType>.timeout**

重试操作的类型，如：`ACCOUNT_UPDATE`, `CHANGE_UPDATE`, `GROUP_UPDATE`, `INDEX_QUERY`。

默认值：`retry.timeout`

默认单位：milliseconds

### Section rules

**rules.enable**

如果设置为 true，gerrit 会加载并执行每个 project 的 refs/meta/config 分支中的 'rules.pl' 文件。

如果设置为 false，只能使用默认继承的规则。

默认值：true

**rules.reductionLimit**

当为单一的 change 评估 rule 时，Prolog reduction 可以被执行的最大次数。在用户的 rule 代码，内部的 Gerrit Prolog 代码或 Prolog 解释器中，每个函数的调用都会计入此限制。

站点使用非常复杂的 rule 时，[rulec](pgm-rulec.md) 需要更多的 reduction 把 Prolog 编译为 Java 字节码。这样可以消除动态 Prolog 解释器对自身 reduction 的限制，进而可以执行更多的命令。

若 reductionLimit 设置为 0 ，意味着无限大，参数值的上限为 2^31-1 。

默认值：100,000 reduction (Intel Core i7 CPU 需要执行 14 ms)

**rules.compileReductionLimit**

将源码编译成内部 Prolog 机器码需要 Prolog reduction 执行的次数。

默认值：10 x reductionLimit (1,000,000).

**rules.maxSourceBytes**

允许 Prolog rules.pl 文件输入的大小。更大的源文件需要更大的 `rules.compileReductionLimit`。考虑使用 [rulec](pgm-rulec.md) 来预编译更大的 rule 文件。

如果设置为 0，那么禁用此功能，等同于 rules.enable = false

支持的单位如下：'k', 'm', or 'g'

默认值：128 KiB

**rules.maxPrologDatabaseSize**

通过 project 的 rule，Prolog 数据库中允许预定义声明的大小。非常复杂的 rule 可能需要超过默认值，但是需要多少内存还需要时间来评估。考虑使用 [rulec](pgm-rulec.md) 来预编译更大的 rule 文件。

默认值：256

### Section execution

**execution.defaultThreadPoolSize**

处理后台其他任务的线程数量。

默认值：1

**execution.fanOutThreadPoolSize**

使用 fan-out 方式工作的线程最大值

如果设置为 0，将使用 direct 模式

默认情况下，25 表示格式化在调用者线程中发生。

### Section receiveemail

**receiveemail.protocol**

接收邮件使用的协议名称。有效的参数为：'POP3', 'IMAP' and 'NONE'。根据加密设置，gerrit 会自动在 POP3 和 POP3s 之间切换，IMAP 和 IMAPS 之间切换。

默认值：'NONE' ，意味着取消接收邮件。

**receiveemail.host**

邮件服务器的名称，如：'imap.gmail.com'。

默认为空字符串，意味着取消接收邮件。

**receiveemail.port**

email 服务器接收邮件的端口号。

下面是不同协议默认使用端口号的信息：POP3: 110; POP3S: 995; IMAP: 143; IMAPS: 993

**receiveemail.username**

用来与 email 服务器认证的用户名。

默认值为空字符串

**receiveemail.password**

用来与 email 服务器认证的密码。

默认值为空字符串

**receiveemail.encryption**

在 gerrit 和邮件服务器之间，传输层使用的加密标准。有效值如下：'NONE', 'SSL'，'TLS'。

默认值：'NONE'

**receiveemail.fetchInterval**

从邮件服务器提取邮件的频率。与邮件服务器的通信不会保持为活动状态。例如：60s，10m，1h。

默认值：60 seconds

**receiveemail.enableImapIdle**

如果使用 IMAP 协议获取邮件，`IMAPv4 IDLE` 可以用来保持与邮件服务器的链接，当有新邮件的时候 gerrit 会立即处理，没有延迟等待。

默认值：false

**receiveemail.filter.mode**

对邮件可以通过黑名单，白名单进行过滤。

如果设置为 `OFF`, 邮件不进行过滤。

如果设置为 `WHITELIST`，只有匹配到的邮件（`receiveemail.filter.patterns`）才会进行处理。

如果设置为 `BLACKLIST`，只有未匹配到的邮件（`receiveemail.filter.patterns`）才会进行处理。

默认值：`OFF`

**receiveemail.filter.patterns**

正则表达式的列表，用于与邮件进行匹配。

### Section sendemail

**sendemail.enable**

如果设置为 false ，gerrit 不会发送相关通知邮件。

默认值：true，允许发送通知邮件。

**sendemail.html**

如果设置为 false，Gerrit 只发送纯文本格式的邮件。

如果设置为 true，Gerrit 可以发送 HTML 和纯文本组成的邮件。

默认值：true

**sendemail.connectTimeout**

链接 SMTP 服务器的超时时长。

支持的单位：'ms', 'sec', 'min' 等。默认单位为：milliseconds

默认值：0，意味着超时时长无限大。

**sendemail.threadPoolSize**

发送通知邮件的线程数量。

默认值：1

**sendemail.from**

系统发邮件时，`From` 字段所使用的名称和邮箱地址。有效值如下：

* `USER`

Gerrit 会使用当前用户的 `Full Name` 和 `Preferred Email` 来设置 From 的头部。如果用户的 domain 启用了 SPF 或 DKIM，并且 `sendemail.smtpServer` 不是可信的，那么可能会将邮件归类为垃圾邮件。可以指定 USER 只有在 `sendemail.allowedDomain` 列出的 domain 中才可以以 USER 身份来发送邮件。

* `MIXED`

格式为 `${user} (Code Review) <review@example.com>`，其中 `review@example.com` 等同于 `user.email`。关于替换的说明，可以参考如下。

* `SERVER`

Gerrit 会使用自身创建的 commit 中的用户名和邮箱地址来设置 From 的头部。

* `Code Review <review@example.com>`

如果设置为尖括号中的用户名和邮箱地址，Gerrit 会使用此配置作为邮箱属性。

默认值：MIXED

**sendemail.allowedDomain**

允许 domain 的列表。只有 `sendemail.from` 设置为 `USER` 才可以使用此参数。如果用户在列表的 domain 中，那么系统使用 `USER` 模式给用户发送邮件，否则使用 `MIXED` 模式。可以使用通配符，例如 `*.example.com` 会与 `example.com` 的 subdomain 进行匹配。

默认值：`*`

**sendemail.smtpServer**

SMTP 服务器的名称或 IP 地址。

默认值：127.0.0.1 (或 localhost)

**sendemail.smtpServerPort**

SMTP 服务器（sendemail.smtpserver）使用的端口

默认值：25（如果使用了'ssl' 的加密，那么默认值为 465）

**sendemail.smtpEncryption**

明确加密的方式，如：'ssl'，'tls'

默认值：'none'（不使用加密）

**sendemail.sslVerify**

如果设置为 false 并且 sendemail.smtpEncryption 设置为 'ssl' 或 'tls', 那么 Gerrit 与 SMTP 服务器连接的时候不会验证证书。

默认值：true, 需要验证证书

**sendemail.smtpUser**

链接 SMTP 服务器使用的用户名。

**sendemail.smtpPass**

链接 SMTP 服务器使用的密码。

**sendemail.allowrcpt**

如果设置了参数值，那么会被添加到白名单中，这样 gerrit 会按照白名单发送邮件。如果设置的是邮箱地址，那么邮箱会被添加到白名单；如果设置的是 domian 信息，那么此 domain 中的邮箱被被添加到白名单。

默认不设置，允许发送到任何邮箱地址。

**sendemail.includeDiff**

如果设置为 true，对于新 change 和已经被合入的 change，gerrit 在发送的邮件中会包含 change 完整的修改。此时，需要配置 `maxmimumDiffSize` 参数。

默认值：false

**sendemail.maximumDiffSize**

邮件中，显示 change 修改大小的上限值。当超过了上限时，只显示相关的文件路径信息。

默认值：256 KiB

**sendemail.importance**

系统发送邮件的紧急程度为 `importance`，有效值包括：'high' 和 'low'。

默认值不设置，邮件头部不显示紧急程度的标识。

**sendemail.expiryDays**

用来配置邮件过期的时间。需要配置大于 0 的正数。

默认不设置，意味着没有过期。

**sendemail.replyToAddress**

自动回复邮件的地址，需要与 `sendemail.from` 设置的值不同。当 gerrit 自动回复用户的邮件时，头部会加上 Reply-To 信息。

默认为空字符串，使用 `sendemail.from` 作为自动回复。

**sendemail.allowTLD**

除了 [IANA list](http://data.iana.org/TLD/) 中指定的 TLD 之外，还允许发送电子邮件时自定义 TLD 列表。

默认为空列表，意味着不允许额外的 TLDs。

**sendemail.addInstanceNameInSubject**

如果设置为 true，gerrit 会在邮件主题中添加标识，收件人根据标识可以识别邮件来源于哪个 gerrit 服务器。

标识可以通过 `gerrit.instanceName` 参数进行设置。

默认值：false

### Section site

**site.allowOriginRegex**

正则表达式的列表，如果匹配，那么可以使用完整的 GERRIT API。

表达式中不能有斜线 `/`，例如有效的格式为：`https://build-status[.]example[.]com`。

默认不设置，拒绝所有的跨源请求。

**site.refreshHeaderFooter**

如果设置为 true，gerrit 会检查站点的 header, footer 和 CSS 文件是否有变更，如果有变更会重新加载相关文件。如果设置为 false，如果文件有变更，需要重启 gerrit 才会生效。

默认值：true

### Section ssh-alias

对 gerrit 或 plugin 的 ssh 命令重新在 `gerrit` 命名空间下命名。例如，将 `replication start` 重命名为 `gerrit replicate`:

```
[ssh-alias]
  replicate = replication start
```

### Section sshd

**sshd.enableCompression**

通常情况下，我们需要取消传输过程终端压缩操作，因为 git 的 pack 文件本身就是压缩文件，再压缩的话，也不会使其变小。

然而，如果有大量闲置的 CPU 资源，并且服务器在一个比较缓慢的网络中，git 仓还有大量的 ref，这时可以启用此压缩功能。因为在握手的时候，git 的 ref 不会被压缩。

当 Gerrit 的 slave 服务器用于较大的下载时，压缩尤其有用，此时 master 服务器主要使用小型接收包。

默认值：`false`

**sshd.backend**

Apache SSHD 项目从 version 0.9.0 开始，添加了 NIO2 功能的支持。为了使用 NIO2 session，需要将 `backend` 设置为 `NIO2`，否则，会被设置为 `MINA`。

默认值：`NIO2`

**sshd.listenAddress**

本地用于监听链接的地址。示例如下：

* `'hostname':'port'` (例如 `review.example.com:29418`)
* `'IPv4':'port'` (例如 `10.0.0.1:29418`)
* `['IPv6']:'port'` (例如 `[ff02**1]:29418`)
* `+*:'port'+` (例如 `+*:29418+`)

如果配置了多个值，daemon 会全都进行监听。

若要取消 SSHD，可将 listenAddress 设置为 `off`.

默认值为：`*:29418`.

**sshd.advertisedAddress**

明确地址，便于客户端链接。此地址与 sshd.listenAddress 参数不同，比如：防火墙开启了重定向功能，使 gerrit 使用 22 端口进行应答。下面为地址的格式，如果端口是 22，那么 `:'port'` 参数可以忽略。

* `'hostname':'port'` (例如 `review.example.com:22`)
* `'IPv4':'port'` (例如 `10.0.0.1:29418`)
* `['IPv6']:'port'` (例如 `[ff02**1]:29418`)

如果配置了多个值，daemon 会全部进行应用。

默认值：`sshd.listenAddress`

**sshd.tcpKeepAlive**

如果设置为 true，那么 gerrit 可以在对方消失的时候关闭链接。

只有 `sshd.backend` 设置为 `MINA` 才可以使用此参数。

默认值：`true`.

**sshd.threads**

用于处理 SSH 命令的线程数量，如果实际的请求超过了此值，那么会使用先到先得的方式进行排队。

默认的线程值为 2 倍的 CPU 数量。

```
NOTE
当启用 SSH daemon 时，同时处理用户 git 请求的最大值是 SSH 和 HTTP 线程的总和。
```

**sshd.batchThreads**

`non-interactive users` 使用 SSH 线程的最大数量。如果设置为 0，那么 `non-interactive` 与 `interactive` 的请求在同一个队列中处理。其他的值，会从 `interactive` 线程中分配出对应的固定的线程给 `non-interactive`。

如果设置的 `non-interactive` 线程数量大于总的 `sshd.threads` 线程数，那么需要上调 `sshd.threads` 的参数值。

如果是单核服务器，默认线程数为 1，其他情况下，默认线程数为 2。

```
NOTE
当启用 SSH daemon 时，同时处理用户 git 请求的最大值是 SSH 和 HTTP 线程的总和。
```

**sshd.streamThreads**

用于流事件的线程数量。

默认值：1 + CPU 的数量

**sshd.commandStartThreads**

解析 SSH 命令行所使用的线程数量。通过 SSH 命令创建内部数据结构，然后使用其他的线程来执行。

默认值：2

**sshd.maxAuthTries**

客户端尝试认证的最大次数。

默认值：6

**sshd.loginGraceTime**

SSH 认证等待的最大时长，超过时长的链接，会被服务器终止。

支持的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days

默认值：2 minutes

**sshd.idleTimeout**

闲置链接的最大时长，超过时长的链接，会被服务器终止。如果设置为 0，则禁用此功能。

支持的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days

默认值：0

**sshd.waitTimeout**

等待服务器操作的最大时长，超过时长的链接，会被服务器终止。比如 clone 一个特别大的 git 仓，这个仓有非常多的 ref。

支持的单位如下：

* s, sec, second, seconds
* m, min, minute, minutes
* h, hr, hour, hours
* d, day, days

默认值：30s

**sshd.maxConnectionsPerUser**

每个用户使用 SSH 链接并发的最大数量。

如果设置为 0，则无上限。

默认值：64

**sshd.cipher**

可用的 cipher。配置文件中可以配置多个 cipher，每行配置一个。Cipher 名字的开头如果以 `+` 开始，表示启用此 cipher，如果以 `-` 开头，表示从默认值中移除此 Cipher。

支持的 ciphers 如下:

* `aes128-ctr`
* `aes192-ctr`
* `aes256-ctr`
* `aes128-cbc`
* `aes192-cbc`
* `aes256-cbc`
* `blowfish-cbc`
* `3des-cbc`
* `arcfour128`
* `arcfour256`
* `none`

默认，除了 `none` ，其他的值都可使用。

如果需要配置 Cipher，建议使用 AES-CTR 模式。

**sshd.mac**

可用的 MAC (消息验证码) 算法。配置文件中可以配置多个 `sshd.mac`，每行配置一个。MAC 名字的开头如果以 `+` 开始，表示启用此 MAC，如果以 `-` 开头，表示从默认值中移除此 MAC。

支持的 MAC 如下:

* `hmac-md5`
* `hmac-md5-96`
* `hmac-sha1`
* `hmac-sha1-96`
* `hmac-sha2-256`
* `hmac-sha2-512`

默认，上面的 MAC 都可用。

**sshd.kex**

可用的 `key exchange algorithms`（密钥交换算法）。配置文件中可以配置多个 `sshd.kex`，每行配置一个。kex 名字的开头如果以 `+` 开始，表示启用此 kex，如果以 `-` 开头，表示从默认值中移除此 kex。

下面的例子中，移除 1024-bit 的 `diffie-hellman-group1-sha1`，那么可以正常使用其他的 kex。

```
[sshd]
  kex = -diffie-hellman-group1-sha1
```

支持的 `key exchange algorithms` 如下:

* `ecdh-sha2-nistp521`
* `ecdh-sha2-nistp384`
* `ecdh-sha2-nistp256`
* `diffie-hellman-group-exchange-sha256`
* `diffie-hellman-group-exchange-sha1`
* `diffie-hellman-group14-sha1`
* `diffie-hellman-group1-sha1`

默认，上面的 `key exchange algorithms` 都可用。

强烈建议移除 `diffie-hellman-group1-sha1`，因为容易遭受攻击。另外，建议移除其余的两个 `sha1` 的 kex 。

**sshd.kerberosKeytab**

在 SSH 连接的时候是否启用 kerberos 认证。若要允许 kerberos 认证，需要有一个 principal 主机 (参考 `sshd.kerberosPrincipal`)，并且主机信息可以从 keytab 中获取。

keytab 至少包含一个 `host/` principal，通常使用主机的 canonical 名称。如果不使用 canonical 名称，`sshd.kerberosPrincipal` 需要配置正确的名字。

默认不设置，意味着不启用 kerberos 认证。

**sshd.kerberosPrincipal**

如果在 kerberos 认证的时候启用 `sshd.kerberosKeytab`，需要使用给定的 principal 名字来代替默认值。如果 principal 不以 `host/` 开头，那么认证的时候会报错。

如果主机位于 IP 负载平衡器或其他的 SSH 转发系统之后，这会很有用，因为主体名称由客户端构造，并且需要匹配 kerberos 的认证才能工作。

默认值：`host/canonical.host.name`

**sshd.requestLog**

启用或禁用 `'$site_path'/logs/sshd_log` 请求的 log。如果启用，SSH daemon 的请求会被写入 log。

`sshd_log` 可以配置 `log4j.appender` 格式的 log。

默认值：`true`

此参数支持 `reload` 操作。

**sshd.rekeyBytesLimit**

SSH daemon 在使用大量数据之后，会发布重新加密。

默认值：1073741824 (bytes, 1GB)

`rekeyBytesLimit` 的设置不能低于 32

**sshd.rekeyTimeLimit**

SSH daemon 在某个时间段之后，会发布重新加密。

默认值：1h

如果设置为 0，意味着取消检验。

### Section suggest

**suggest.maxSuggestedReviewers**

提示评审人员数量的最大值。

默认值：10

此参数支持 `reload` 操作。

**suggest.from**

用户输入几个字符才会出现提示信息。如果设置为 0 ，那么总会有提示。此参数只用于向群组添加用户的场景。

默认值：0

### Section trackingid

从 commit-msg 中解析出 tracking 系统的相关信息，然后保存到 secondary index 。

如果修改了此部分的配置，需要执行 [reindex](pgm-reindex.md)。

trackingid 搜索的格式为："tr:`trackingid`" 或 "bug:`trackingid`"。

```
[trackingid "jira-bug"]
  footer = Bugfix:
  footer = Bug:
  match = JRA\\d{2,8}
  system = JIRA

[trackingid "jira-feature"]
  footer = Feature
  match = JRA(\\d{2,8})
  system = JIRA
```

**trackingid.<name>.footer**

一个前缀的标识可以在 footer 行中解析 trackingid。

多个 trackingid 可以配置相同的 footer 标识。同样，一个 trackingid 可以配置多个 footer 标识。

如果配置了多个 footer 标识，那么每个标识需要单独进行解析，重复的会被忽略掉。

结尾的 ":" 是可选的。

**trackingid.<name>.match**

[标准的 Java 正则表达式 (java.util.regex)](http://download.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html) 可以用来匹配 footer 行的 trackingid。有可能匹配出多个结果。如果正则表达式中使用了分组，那么分组的第一个值会被看作是 trackingid。trackingid 最大的长度是 32 个字符，超过了这个值，那么会被系统忽略掉。

由于反斜线 `\` 会被转义，所以 `\s` 需要在配置文件中设置为 `\\s` 。解析遇到 `#` 会终止，如果涉及到了 `#` 字符，需要加双引号。

**trackingid.<name>.system**

外部 tracking 系统的名称(最多 10 个字符)。同一个 tracking 系统有肯能有多个 trackingid 。

### Section transfer

**transfer.timeout**

在远端机器没有响应的情况下，等待完成读或写的时长。如果设置为 0，意味着没有 timeout，服务器会无限等待直到 transfer 完成。

timeout 需要为 transfer 设置得足够大。对应广域网来说，10-30 seconds 是一个比较合理的值。

默认值：0 seconds，无限等待

### Section upload

此参数用于控制服务器端 `upload-pack` 的操作，与用户的 fetch，clone，repo sync 命令对应。

```
[upload]
  allowGroup = GROUP_ALLOWED_TO_EXECUTE
  allowGroup = YET_ANOTHER_GROUP_ALLOWED_TO_EXECUTE
```

**upload.allowGroup**

服务器端可以向群组中用户提供 'upload-pack' 服务。可以设置一个或多个群组。

如果不添加群组，那么服务器端会向任何用户提供 'upload-pack' 服务。

### Section accountDeactivation

定期执行，根据认证后台来确认帐号是否失效，如果失效，作出相应标识。只有 `LDAP` 认证模式下，才可以使用此参数。

**accountDeactivation.startTime**

任务开始的时间，可以参考本文 `schedule configuration` 的 `startTime` 部分。

**accountDeactivation.interval**

执行任务的频率，可以参考本文 `schedule configuration` 的 `interval` 部分。

### Section urlAlias

URL aliases 会为 URL token 定义正则表达式，用来与目标 URL token 映射。

每个 URL alias 需要在自己的 subsection 进行配置。subsection 名字应该是一个可描述的名称，需要是唯一的。

URL aliases 可以不按特定顺序排列。第一个匹配到的 URL alias 会被使用，其他的匹配会被忽略。

URL aliases 可以将 plugin screens 映射到 Gerrit URL 的命名空间，或用 plugin screen 替代 Gerrit screen 。

示例:

```
[urlAlias "MyPluginScreen"]
  match = /myscreen/(.*)
  token = /x/myplugin/myscreen/$1
[urlAlias "MyChangeScreen"]
  match = /c/(.*)
  token = /x/myplugin/c/$1
```

**urlAlias.match**

URL token 的正则表达式。

URL token 可以被 `urlAlias.token` 参数所代替。

**urlAlias.token**

目标 URL 的 token 。

通过使用 `urlAlias.match` 正则表达式，匹配到的群组可以可能会包含占位符：`$1` 为第一个匹配的群组，`$2` 为第二个匹配的群组。

### Section submodule

**submodule.verboseSuperprojectUpdate**

使用 [automatic superproject updates](user-submodules.md) 功能的时候，此参数决定了 superproject 的 commit-msg 包含 submodule 的 commit-msg 的方式。

如果设置为 `FALSE`, 不包含任何 submodule 的 commit-msg。

如果设置为 `SUBJECT_ONLY`, 只包含 submodule 的 commit subjects。

如果设置为 `TRUE`, 包含 submodule 的 commit-msg 的全部信息。

默认值：`TRUE`

**submodule.enableSuperProjectSubscriptions**

启用 superproject 的订阅机制。

默认值：true

**submodule.maxCombinedCommitMessageSize**

为 submodule 创建新的 commit-msg 的长度的上限。

默认值：262144 (256 KiB)

支持的单位如下：k, m, g

**submodule.maxCommitMessages**

为 submodule 创建新的 commit-msg 时，所合并的 commit-msg 数量的上限。

默认值：1000

### Section user

**user.name**

gerrit 自身创建新 commit（如 change 合入时的 merge 节点）时的用户名称。

默认值："Gerrit Code Review".

**user.email**

gerrit 自身创建新 commit（如 change 合入时的 merge 节点）时的邮箱地址。

如果不设置，Gerrit 会自动生成邮箱地址，格式为："gerrit@`hostname`", 其中 `hostname` 为 gerrit 运行时的系统主机名称。

默认，不设置，邮箱地址在 gerrit 启动的时候自动生成。

**user.anonymousCoward**

如果用户没有配置 `full name`，那么会在 gerrit 页面和邮件通知中以此参数来显示用户名称。

默认值："Name of user not set"

### Schedule Configuration

gerrit 后台执行的计划任务。

计划任务由两个参数组成：

* `interval`:
定期执行计划任务的间隔时间。`interval` 值需要大于 0。支持的单位如下：
    `s`, `sec`, `second`, `seconds`
    `m`, `min`, `minute`, `minutes`
    `h`, `hr`, `hour`, `hours`
    `d`, `day`, `days`
    `w`, `week`, `weeks` (`1 week` 看作是 `7 days`)
    `mon`, `month`, `months` (`1 month` 看作是 `30 days`)
    `y`, `year`, `years` (`1 year` 看作是 `365 days`)

* `startTime`:
计划任务第一次执行的时间。`startTime` 的格式如下：

    `<day of week> <hours>:<minutes>`
    `<hours>:<minutes>`

参考值如下：

    `<day of week>`: `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun`
    `<hours>`: `00`-`23`
    `<minutes>`: `00`-`59`

不能配置时区，使用系统配置的时区。需要使用 0 占位，如 `06:00` 而不是 `6:00`。

`interval` 和 `startTime` 需要配置在对应的 section 下，比如 change 的 cleanup 任务需要配置在 `changeCleanup` section 下面:

```
  [changeCleanup]
    startTime = Fri 10:30
    interval  = 2 days
```

计划任务配置的示例如下：

* Example 1:

```
  startTime = Fri 10:30
  interval  = 2 days
```

假设服务在 `Mon 07:00` 启动，那么 `startTime - now` 等于 `4 days 3:30 hours`，此值大于 `interval` 值，所以计划任务要提前执行，执行时间分别为 `Mon 10:30`（`startTime` - 2 x `interval`）, `Wed 10:30`（`startTime` - `interval`）, `Fri 10:30`。

* Example 2:

```
  startTime = 06:00
  interval = 1 day
```

假设服务在 `Mon 07:00` 启动，则计划任务的第一次执行是在周二的 06:00，并且在每天的这个时间重复执行。

## File `etc/All-Projects/project.config`

`'$site_path'/etc/All-Projects/project.config` 文件的配置来源于 `All-Projects` 的 [`project.config`](config-project-config.md) 文件。与 `gerrit.config` 不一样的是，`project.config` 主要针对 project 的配置，而不是 server 的配置。

大多数的管理员不需要这个配置文件，因为可以在 `All-Projects` 中做相关的全局设置。然而，当使用 Puppet 这样的工具时，不用向 `All-Projects` 推送 commit，可以直接更新此文件，会方便许多。

当 `All-Projects` 重载的时候，此文件也会进行重载。更新此文件后，需要重新加载缓存或者重启 gerrit 服务。

注意事项：

* `'$site_path'/etc/All-Projects` 只是目录，不是 git 仓。
* 系统只读取 `project.config` 文件，如：`rules.pl` 文件会忽略。
* 此文件不推荐配置 ACL，因为涉及到了 `groups` 文件。

## File `etc/secure.config`

如果非必要文件 `'$site_path'/etc/secure.config` 与文件 `'$site_path'/etc/gerrit.config` 中有相同的配置，那么以前者的配置为准。gerrit 进程需要加载 `secure.config` 文件中的内容，由于此文件中包含账户密码，不建议对外公布此文件的内容。

示例：`etc/secure.config`:
```
[auth]
  registerEmailPrivateKey = 2zHNrXE2bsoylzUqDxZp0H1cqUmjgWb6

[database]
  username = webuser
  password = s3kr3t

[ldap]
  password = l3tm3srch

[httpd]
  sslKeyPassword = g3rr1t

[sendemail]
  smtpPass = sp@m

[remote "bar"]
  password = s3kr3t
```

## File `etc/peer_keys`

非必要文件 `'$site_path'/etc/peer_keys` 用来控制用户谁可以登录 gerrit，需要执行 [suexec](cmd-suexec.md) 命令来实现。

格式为每行存放一个基于 Base-64 加密的 public key。

### Configurable Parameters

**site_path**

gerrit 初始化的目录，用来存放 gerrit 相关的文件。建议对相关的配置文件进行版本控制。

可对站点进行个性化配置，如：

  * [主题配置](config-themes.md)

