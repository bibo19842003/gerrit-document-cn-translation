# Gerrit Code Review - Design Docs

对于设计开发流程来说，`design doc` 中需要明确相关信息。

## Design Doc 结构

design doc 需要包含下面部分：

* Use-Cases:
  用户和系统之间的交互，以实现特定目标。
* Acceptance Criteria
  满足相关条件，相关功能已完成。
* Background:
  需要了解相关的 use-cases (如，示例、先前版本的优缺点，相关的设计文档等)
* Possible Solutions:
  需要描述方案的实施细节及相关的利弊。
* Conclusion:
  作出的每个决定都要给出响应的原因。

作为一个团体，在设计文档方面大家尽可能通过迭代的方式一起合作来完成。为了让工作的效果更好，把设计文档拆分成几个部分，这样大家可以并行工作，效率更高：

* `index.md`:
  实体文件（参考 'dev-design-doc-index-template.md'），需包含下面文件的的链接。
* `use-cases.md`:
  use-cases， acceptance criteria 和 background 的相关描述，具体可以参考 'dev-design-doc-use-cases-template.md'。
* `solution-<n>.md`:
  每个解决方案写一个文档（需要包含方案利弊，实现细节等），具体可以参考 'dev-design-doc-solution-template.md'。
* `conclusion.md`:
  方案结论的讨论，具体参考 'dev-design-doc-conclusion-template.md'。

期望:

* 在评审之前，需要将 use-cases 进行归档。
* 如果对解决方案有新的想法的话，需要在 `solution-<n>.md` 文档中进行详细描述并作为 change 上传。如果对现有方案进行修改的话，需要取得方案 owner 的同意。
* 所有的解决方案需要讨论利弊，并最终给出结论。
* 方案讨论过程中，识别出来的问题，要及时的更新到相关文件中。
* change 可以频繁的进行提交。
* 方案讨论通过后，需要更新设计文档，并开始实施。

## 如何提出新的 design

对于新的 design，可以上传 change 到 [homepage](https://gerrit-review.googlesource.com/admin/repos/homepage) ，需要在 `pages/design-docs/` 下面添加新的目录，新目录需包含至少如下文件：`index.md` 和 `uses-cases.md` 。

推动 design 文档的相关评审。可以参考: [contributor](dev-roles.md)。

design 文档尽可能在各个方面作出详细说明，便于相关人员评审

评审人员需要仔细认真的进行评审。同时，也可以将相关信息发到 [repo-discuss](https://groups.google.com/d/forum/repo-discuss)，这样可以让更多的人看到并发起讨论。但评审的结论需要在 change 中说明，不能通过邮件来传递。

## Design doc 评审

[Gerrit community](dev-roles.md) 中的每个人都可以对设计文档表达自己的看法，因此每个评审人员需要尊重[Code of Conduct](https://www.gerritcodereview.com/codeofconduct.html)。

`Code-Review` 时，若新 patch 改动不大，`Code-Review+1` 和 `Code-Review+2` 需要在新 patch 中进行体现；若新 patch 改动较大，需要重新进行评审。

解决方案若有变化，需要上传新的 change，并作出相关说明，并通知相关的已评审人员。

验证是通过 `jekyll` 站点的 `docker` 完成的，而不是通过相关的 `gitiles`。

关于 design 结论的 change，至少公示 10 天才能合入，目的是让更多的人可以看到并给出更多的合理的建议。

其他相关文档的 change，可以随时合入。

对于申请，在无变化的情况下，评审人员需要在 14 天内给出结论。

## design 变更了，如何获取相关信息

* 进入页面：[notification settings](https://gerrit-review.googlesource.com/settings/#Notifications)
* 对 `homepage` project 进行关注，如：'query: `dir:pages/design-docs`'。

