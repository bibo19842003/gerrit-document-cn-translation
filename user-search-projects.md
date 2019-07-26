# Gerrit Code Review - Searching Projects

## Search Operators

搜索是由条件限制的，需要按照一定的规则来执行。不是随意的输入，就可以搜索到预期的结果。输入的查询字符，需要与查询字段对应的。

**name:'NAME'**

根据 project 名称进行搜索

**parent:'PARENT'**

根据父 project 名称进行搜索

**inname:'NAME'**

根据 project 的部分名称进行搜索

**description:'DESCRIPTION'**

根据描述进行搜索

**state:'STATE'**

根据状态进行搜索，如：'active'，'read-only'

## Magical Operators

**is:visible**

搜索当前用户可访问的 project

**limit:'CNT'**

每页最大显示数量

