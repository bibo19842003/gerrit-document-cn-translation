## Gitweb Integration

Gerrit Code Review 可以与 gitweb 集成，用户可以在 gerrit 和 gitweb 之间跳转，访问的页面虽然不一样，但看到的内容都是相同的。

### Internal/Managed gitweb

与 gitweb 集成后，gerrit 会分析用户的请求，根据认证信息来对 gitweb 实现权限控制。

配置 gitweb 的时候，需要配置 gitweb 的安装路径，linux 对 gitweb 的默认安装路径为 `/usr/lib/cgi-bin/gitweb.cgi`。

gitweb 相关配置如下：

```
  git config -f $site_path/etc/gerrit.config gitweb.type gitweb
  git config -f $site_path/etc/gerrit.config gitweb.cgi /usr/lib/cgi-bin/gitweb.cgi
  git config -f $site_path/etc/gerrit.config --unset gitweb.url
```

另外，如果 gerrit 配置了反向代理，那么会产生不同的 gitweb 的 URL，这时需要在服务器上重新配置 `<gerrit>/gitweb?args`，并且需要配置如下参数：

```
  git config -f $site_path/etc/gerrit.config gitweb.type gitweb
  git config -f $site_path/etc/gerrit.config gitweb.cgi /usr/lib/cgi-bin/gitweb.cgi
  git config -f $site_path/etc/gerrit.config gitweb.url /pretty/path/to/gitweb
```

更新 `'$site_path'/etc/gerrit.config` 文件后，需要重启 gerrit 服务，否则修改不会生效。

#### Configuration

gerrit 会自动处理大多数 gitweb 的配置文件。gerrit 会根据 `'$site_path'/etc/gitweb_config.perl` 此文件中的设置来重载 gitweb，因为此文件作为配置文件的一部分来进行加载。

#### Logo and CSS

如果安装了 CGI (`/usr/lib/cgi-bin/gitweb.cgi`)，CSS 和 logo 文件可以存储在 `/usr/share/gitweb` 或 `/var/www` 文件夹下。

否则， Gerrit 会在 CGI 脚本的目录来查找 `gitweb.css` 和 `git-logo.png` 文件。

#### Access Control

gitweb 页面的访问，需要用户有对应 project 的 `READ +1` 权限。

为了使用户有 gitweb 的访问权限，用户需要有 project 所有的 refs 权限，包括：refs/meta/config, refs/meta/dashboards/* 等。如果对某些 refs 设置了 exclusive 的读权限，要确保所有的用户可以通过 gitweb 访问 project 中的所有 refs。

### External/Unmanaged gitweb

如果 gitweb 运行在其他的服务器上，那么就不能使用 gerrit 的权限配置了。不过，gerrit 可以提供相关参数与 gitweb 进行集成。

#### Linux Installation

##### Install Gitweb

Ubuntu 上的安装:

```
  sudo apt-get install gitweb
```

使用 Yum 安装:

```
  yum install gitweb
```

##### Configure Gitweb


更新 `/etc/gitweb.conf`，添加公共的 GIT repositories 路径:

```
$projectroot = "/var/www/repo/";

# directory to use for temp files
$git_temp = "/tmp";

# target of the home link on top of all pages
#$home_link = $my_uri || "/";

# html text to include at home page
$home_text = "indextext.html";

# file with project list; by default, simply scan the projectroot dir.
$projects_list = $projectroot;

# stylesheet to use
# I took off the prefix / of the following path to put these files inside gitweb directory directly
$stylesheet = "gitweb.css";

# logo to use
$logo = "git-logo.png";

# the favicon
$favicon = "git-favicon.png";
```

#### Configure & Restart Apache Web Server

##### Configure Apache


将 gitweb 链接到 `/var/www/gitweb`，如果不确认 gitweb 的路径，可以查看配置文件 `/etc/gitweb.conf`：

```
  sudo ln -s /usr/share/gitweb /var/www/gitweb
```

在 Apache 的 conf.d 目录中创建名为 "gitweb" 的配置文件，然后把 gitweb 的目录添加到这个配置文件中。

```
  touch /etc/apache/conf.d/gitweb
```

将下面内容添加到配置文件 /etc/apache/conf.d/gitweb:

```
Alias /gitweb /var/www/gitweb

Options Indexes FollowSymlinks ExecCGI
DirectoryIndex /cgi-bin/gitweb.cgi
AllowOverride None
```

**NOTE:**
*使用 yum 或者 apt-get 安装的时候，上面的信息会自动配置，不必重复操作。*

##### Restart the Apache Web Server

```
  sudo /etc/init.d/apache2 restart
```

重启 apache 服务后，可以在网页浏览 project 了，参考路径如下：[http://localhost/gitweb](http://localhost/gitweb) 

#### Windows Installation

可以参考 MsysGit 中的 [GitWeb](https://github.com/msysgit/msysgit/wiki/GitWeb) 说明。

如果 windows 机器上没有安装 Apache，那么可以从 [apachelounge.org](http://www.apachelounge.com/download) 下载安装。

Apache 安装后，需要为 Apache 创建一个名为 Apache 的 [新用户](http://httpd.apache.org/docs/2.0/platform/windows.html#winsvc)。

如果设置权限的时候有困难的话，可以在网上搜索一下 “如何在其他的用户下配置 Apache 服务”。需要给新用户添加 ["run as service"](http://technet.microsoft.com/en-us/library/cc794944(WS.10).aspx) 权限。

msysgit 中的 gitweb，缺少几个重要的 perl 模块，如：CGI.pm。msysgit v1.7.8 版本中，perl 是有问题的，参考如下：[unicore folder is missing along with utf8_heavy.pl and CGI.pm](http://groups.google.com/group/msysgit/browse_thread/thread/ba3501f1f0ed95af)。可以使用 msys 的控制台对 perl 模块进行检查：

```
**  perl -mCGI -mEncode -mFcntl -mFile**Find -mFile**Basename -e ""
```

有可能会遇到下面的异常信息：

```shell
**$ perl -mCGI -mEncode -mFcntl -mFile**Find -mFile**Basename -e ""
Can't locate CGI.pm in @INC (@INC contains: /usr/lib/perl5/5.8.8/msys
/usr/lib/p erl5/5.8.8 /usr/lib/perl5/site_perl/5.8.8/msys
/usr/lib/perl5/site_perl/5.8.8 /u sr/lib/perl5/site_perl .). BEGIN
failed--compilation aborted.
```

如果缺少 CGI.pm，需要在 msys 的环境中部署此模块，比如在 5.8.8 的版本中进行恢复操作：

```
下载路径：http://strawberryperl.com/releases.html

文件名称: strawberry-perl-5.8.8.3.zip

涉及目录: `bin/` `lib/` `site/`

将所涉及的目录复制到 `msysgit/lib/perl5/5.8.8` 目录下，并覆盖已存在的文件。
```

#### Enable Gitweb Integration

为了与外部的 gitweb 集成，需要在 gerrit.config 中设置 `gitweb.url`。

CGI 的参数 `$projectroot` 可以配置 `gerrit.basePath` 参数对应的目录，或者 replication 的目录。

```
  git config -f $site_path/etc/gerrit.config gitweb.type gitweb
  git config -f $site_path/etc/gerrit.config --unset gitweb.cgi
  git config -f $site_path/etc/gerrit.config gitweb.url https://gitweb.corporation.com
```

如果 project 没有按照规范（`\{projectName\}.git`）来命名，若要 gerrit 可以对 project 进行读取，需要加入如下配置：

```
  git config -f $site_path/etc/gerrit.config gitweb.type custom
  git config -f $site_path/etc/gerrit.config gitweb.project ?p=\${project}\;a=summary
  git config -f $site_path/etc/gerrit.config gitweb.revision ?p=\${project}\;a=commit\;h=\${commit}
  git config -f $site_path/etc/gerrit.config gitweb.branch ?p=\${project}\;a=shortlog\;h=\${branch}
  git config -f $site_path/etc/gerrit.config gitweb.roottree ?p=\${project}\;a=tree\;hb=\${commit}
  git config -f $site_path/etc/gerrit.config gitweb.file ?p=\${project}\;hb=\${commit}\;f=\${file}
  git config -f $site_path/etc/gerrit.config gitweb.filehistory ?p=\${project}\;a=history\;hb=\${branch}\;f=\${file}
```

更新 `'$site_path'/etc/gerrit.config` 文件后，需要重启 gerrit 服务。

如果要对 gitweb 进行个性化设置，需要准确的配置如下参数：`project`, `revision`, `branch`, `roottree`,`file`, `filehistory`。否则，配置不会生效。

##### Access Control

Gitweb 使用的是标准 web 服务器的权限控制，但不能和 gerrit 的权限控制相集成。

##### Caching Gitweb

可以参考 kernel.org 和 repo.or.cz 的缓存方案，对 gitweb 进行缓存处理。

### Alternatives to gitweb

Gerrit 可以通过 cgit 来和 gitweb 集成。

将 `gitweb.type` 配置成 'cgit'，然后就可以通过 cgit 来使用了。

cgit 下，同样支持对 gitweb 的定制。

### SEE ALSO

* [系统配置](config-gerrit.md) 的 `gitweb` 相关章节
* [cgit](http://git.zx2c4.com/cgit/about/)

