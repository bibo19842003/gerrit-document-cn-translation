# Gerrit Code Review - Searching Accounts

## Basic Account Search

和其他 web 搜索引擎类似，输入一些字符，然后进行搜索：

|Description                      | Examples
| :------| :------|
|Name                             | John
|Email address                    | jdoe@example.com
|Username                         | jdoe
|Account-Id                       | 1000096
|Own account                      | self

## Search Operators

搜索是由条件限制的，需要按照一定的规则来执行。不是随意的输入，就可以搜索到预期的结果。输入的查询字符，需要与查询字段对应的。

**cansee:'CHANGE'**

搜索可以访问的 change 

**email:'EMAIL'**

根据 email 进行搜索

**is:active**

搜索生效帐号

**is:inactive**

搜索失效帐号

**name:'NAME'**

根据帐号名称搜索

**username:'USERNAME'**

根据帐号名称搜索

## Magical Operators

**is:visible**

搜索可以访问的用户

**is:active**

搜索生效帐号

**limit:'CNT'**

每页最大显示数量

