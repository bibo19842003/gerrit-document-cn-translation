# Gerrit Code Review - Dashboards

## Custom Dashboards

定制的 dashboard 和用户的 dashboard 类似，但是需要按照 URL 格式进行配置。由于定制的 dashboard 在服务器端是无状态的，用户可以把其看作是一个链接，好比 project 的 wiki 一样。管理员可以把链接添加到 `GerritHeader.html` 和 `GerritFooter.html`.。

Dashboards 的 URL 示例如下：
```
  /#/dashboard/?title=Custom+View&To+Review=reviewer:john.doe@example.com&Pending+In+myproject=project:myproject+is:open
```
此链接打开后，title 的名称显示为 "Custom View"，页面分为两部分："To Review" 和 "Pending in myproject":
```
  Custom View

  To Review

    Results of `reviewer:john.doe@example.com`

  Pending In myproject

    Results of `project:myproject is:open`
```

dashboard 的 URLs 的配置比较容易，采用键值对的方式，如： `title=Text` 。

每部分的标题由参数定义，每部分按照 URL 中参数的顺序在页面显示，搜索结果由参数值定义。搜索中，`limit:N` 可以限制显示的行数，否则会按照用户子定义的上限将搜索结果显示出来。

参数之间可以使用以下字符进行分隔，`&` ， `;` ， `,`

`foreach=...` 参数比较特殊，可以用来方便的书写相似的搜索条件。

下面的示例展示了定制的 dashboard 使用 foreach 来显示当前用户某类 change 的信息。

```
  /#/dashboard/?title=Mine&foreach=owner:self&My+Pending=is:open&My+Merged=is:merged
```

## Project Dashboards

可以在 project 层级共享定制的 dashboard，不过需要在 project 的 `refs/meta/dashboards/*` 分支上进行定制。每个定制 dashboard 需要创建一个配置文件。文件的名称可以作为定制 dashboard 的 title。

dashboard 参考的配置文件如下:

```
[dashboard]
  description = Most recent open and merged changes.
[section "Open Changes"]
  query = status:open project:myProject limit:15
[section "Merged Changes"]
  query = status:merged project:myProject limit:15
```

定义好以后，project-dashboard 可以使用 URL 的方式进行访问。如，`All-Projects` 的 `refs/meta/dashboards/Site` 分支有一个 `Main` 配置文件，访问的 URL 如下：

```
  /#/projects/All-Projects,dashboards/Site:Main
```

Project-dashboard 可以被继承，也可以重载。如果使用了相同的分支和 dashboard 名称的时候，会被重载。

### Token `${project}`

Project-dashboard 搜索的时候可能会包含特殊的 `${project}` 标记，该标记可以用 project 的名称进行替换，这样可以方便继承。参数的格式为：`project:${project}`。

`${project}` 可以在 dashboard 的 title 和 description 中使用。

### Section `dashboard`

**dashboard.title**

dashboard 的 title

如果不指定具体的 title，那么将使用 dashboard 配置文件的路径作为 title。

**dashboard.description**

dashboard 的描述信息

**dashboard.foreach**

foreach 的参数值用于附加到搜索条件中。

例如，可以将 project 的搜索添加到 dashboard 配置中。

```
[dashboard]
  foreach = project:${project}
```

### Section `section`

**section.<name>.query**

自定义名称进行 change 的搜索。

## Project Default Dashboard

在 `refs/meta/config` 分支的 `project.config` 文件中，可以为 project 定义默认的 dashboard。

```
[dashboard]
  default = refs/meta/dashboards/main:default
```

`local-default` 定义的 dashboard，只能被当前 project 使用，但不能被继承。


```
[dashboard]
  default = refs/meta/dashboards/main:default
  local-default = refs/meta/dashboards/main:local
```

