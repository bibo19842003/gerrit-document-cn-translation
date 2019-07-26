# Gerrit 如何工作

在一个项目里，如何把 Gerrit 融入到开发者的工作流程．下面的项目包含了一个中心库．

![Central Source Repository](images/intro-quick-central-repo.png)

如果按图中操作, Gerrit 会称为中心代码库．介绍一个概念:  _Pending Changes_

![Gerrit as the Central Repository](images/intro-quick-central-gerrit.png)

当 Gerrit 作为中心库的时候, 为了开发人员的评审和讨论，所有代码的 changes 会成为 Pending Changes. 在有足够的评审人员赞同 change 的时候，可以把 change 合入到代码库．

除了存储 Pending Changes, Gerrit 还会获取每个 change 的评论．这样会使评审 changes 的时候更为便利．另外， change 会显示评论的历史信息，包括谁修改的，为什么修改等

类似其他的 repository 管理软件, Gerrit 提供了一个有效的 [访问控制模型](access-control.md), 可以更好的控制对 repository 的访问．

