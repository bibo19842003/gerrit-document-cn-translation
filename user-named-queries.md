# Gerrit Code Review - Named Queries

## User Named Queries
可以在用户层级定义 `Named Queries`。 `queries` 文件需要放到  `All-Users` 的 用户分支下面。 `queries` 文件分为两列，用 `tab` 分隔，左侧栏是搜索名称，右侧栏是搜索条件。

`named destinations` 默认可以被其他用户访问。

例如:

```
# Name         	Query
#
selfapproved   	owner:self label:code-review+2,user=self
blocked        	label:code-review-2 OR label:verified-1
# Note below how to reference your own named queries in other named queries
ready          	label:code-review+2 label:verified+1 -query:blocked status:open
```

