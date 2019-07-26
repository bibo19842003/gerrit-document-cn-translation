# Gerrit Code Review - Automatic Site Initialization on Startup

## Description

当 gerrit 运行在 Gerrit servlet 容器中的时候，gerrit 支持服务器启动的时候进行站点自动初始化，包括新建站点或升级已有站点。默认情况下，在 servlet 容器中部署 gerrit 的时候，所有的 plugin 会被安装，并可以确认 gerrit 运行时的 gerrit 执行文件的位置。同样，plugin 可以部分安装也可以不安装。

这个功能是很有必要的，因为有的时候，管理员在安装 gerrit 时，没有权限直接访问 gerrit 所在服务器的文件系统，所以就不能进行相关部署。这时，因为不涉及站点初始化，所以在本地的 servlet 容器中可以更快的进行相关的部署和测试。

## Gerrit Configuration

如要进行站点初始化，需要定义 `gerrit.site_path` 这个属性的值。如果站点已经存在，需要配置此参数；如果站点不存在，需要设置 `gerrit.init` 属性的值用来站点自动初始化。

在初始化期间，如果 `gerrit.install_plugins` 属性没有定义，那么所有的 plugin 会被安装。如果属性值为空，则不安装任何 plugin；如果要安装指定 plugin，可以在此处进行赋值。

### Example

准备 Tomcat 以便在给定路径上进行站点初始化（如果站点不存在），并安装所有 plugin。

```
  $ export CATALINA_OPTS='-Dgerrit.init -Dgerrit.site_path=/path/to/site'
  $ catalina.sh start
```

