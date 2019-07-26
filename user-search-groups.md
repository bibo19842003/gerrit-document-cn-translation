# Gerrit Code Review - Searching Groups

Group 搜索只适用与内部群组。外部群组的搜索不涉及。 

## Basic Group Search

和其他 web 搜索引擎类似，输入一些字符，然后进行搜索：

|Description | Examples
| :------| :------|
|Name        | Foo-Verifiers
|UUID        | 6a1e70e1a88782771a91808c8af9bbb7a9871389
|Description | deprecated

## Search Operators

搜索是由条件限制的，需要按照一定的规则来执行。不是随意的输入，就可以搜索到预期的结果。输入的查询字符，需要与查询字段对应的。

**description:'DESCRIPTION'**

根据描述进行搜索

**inname:'NAMEPART'**

根据部分字符进行搜索

**is:visibletoall**

群组是否全员可见

**name:'NAME'**

根据群组名称进行搜索

**owner:'OWNER'**

根据群组 owner 进行搜索

**uuid:'UUID'**

根据 UUID 进行搜索

**member:'MEMBER'**

根据群组成员进行搜索

**subgroup:'SUBGROUP'**

根据子群组进行搜索

## Magical Operators

**is:visible**

搜索当前用户可访问的群组

**limit:'CNT'**

每页最大显示数量

