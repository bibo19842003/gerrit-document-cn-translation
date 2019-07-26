# 使用 Gerrit 将会成为天才程序员

### 概述

词语 _rockstar_ 描述的是那些毫不费力地能制作出梦幻般音乐的作曲家，这里用来形容那些比其他人的工作完成又快又好的天才程序员们．

软件工程大致相同．Changes 需要符合逻辑并且需要多版本和长时间的评审才能合入到代码库中．一个单一的概念性的代码修改(_fix bug 123_)经常需要多次迭代才能完成．
程序员通常：
* 修复编译错误
* 提出方法, 避免代码重复
* 使用更好的算法, 让其更快
* 处理错误条件, 使其更加健壮
* 增加测试, 防止错误再现
* 调整测试, 用来体现修改的变化
* 规范编码, 简单易读
* 改善提交描述, 解释为何修改

事实上, 最初的代码修改方案最好不要在项目历史中．
不仅仅是因为天才程序员要隐藏最初的草率行为，重要的是保持中间状态影响了有效的版本管理．
Git　的最佳效果是一个提交对应一个功能的修改，如下:
* git revert
* git cherry-pick
* [git bisect](https://www.kernel.org/pub/software/scm/git/docs/git-bisect-lk2009.html)


### Amending commits

Git 提供了一个方法用来持续更新一个提交，直到这个提交达到理想状态:使用 `git commit --amend` 用来修改提交信息，用此方法后，分支的最新节点后指向一个新的提交．也许，老的提交不会丢失，有时可以通过命令 `git reflog` 找到．

### Code review

至少两个广为人知的开源项目坚持这样的实践:
* [Git](http://git-scm.com)
* [Linux Kernel](http://www.kernel.org/category/about.html)

但是，项目的贡献者私下并没有使他们的修改到达完美．相反，完善代码是 review 过程的一部分－贡献者提供代码，其他开发人员进行评估和讨论．这个过程称为 _code review_ 并且结果会带来很多好处:
* Code reviews 意味着每次修改有效的共享了作者身份
* 开发者从两个方面分享知识：评审人员从补丁的作者学习如何维护代码，补丁的作者从评审人员那里学习最佳的项目实践
* Code review 鼓励更多的人员阅读代码修改．因此，可以有更多机会找到错误并改进
* 更多人员阅读代码，更多的错误会被识别．因为代码在提交前被评审，错误会在软件开发生命周期的早期被修复
* 评审过程提供了一个机制来执行团队或者公司的策略，例如： _生产环境的代码需要在所有的平台上跑完测试并且至少需要两个人的确认_.

一些成功的软件公司, 包括 Google, 在软件开发过程中将 code review 作为一个准则．

### Web-based code review

为了开展代码 review 工作, Git 和 Linux Kernel 项目通过邮件传递补丁．

Code Review (Gerrit) 在工作流中添加了一个 web 接口，而不是通过邮件传递补丁和评论，Gerrit 使用者可以把提交推送到 Gerrit 上， Gerrit 可以通过 web 页面显示代码的修改．评审人员可以直接在上面提交评论信息．如果一个修改需要重新工作，用户可以以增加版本号的方式在原来的提交基础上推送一个新的提交．评审人员可以根据新版本来检查原始问他是否解决，如果没有解决，重复该过程．
### Gerrit’s magic

当把一个修改推送到 Gerrit,  Gerrit 是如何检查这个提交是 amends　前一个修改的呢？Gerrit 不会使用 SHA-1 方式进行校验, 因为`git commit --amend`时，这个值会变．幸运的是， amend 的时候，提交的描述信息默认是保持不变的．

这个就是　Gerrit 的解决方法： Gerrit 的 change 识别是通过提交的注释信息底部来完成的．每个提交信息的底部包含了 Change-Id 的描述， Change-Id 唯一的标识了一个 change 所有讨论方案的修改．例如：

  `Change-Id: I9e29f5469142cc7fce9e90b0b09f5d2186ff0990`

因此，如果提交被 amend 以后 Change-Id 保持不变，Gerrit 会检测到这个 change 的每一个版本．评审人员在 Gerrit 的网页上会看到 change 的版本的演进．

对应 Gerrit 来说，Change-Id 的值是随机产生的．

Gerrit 提供了客户端的 [message hook](cmd-hook-commit-msg) 用来自动地把 Change-Id 添加到 commit 的 message 中．

