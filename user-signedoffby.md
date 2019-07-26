# Gerrit Code Review - Signed-off-by Lines

**NOTE:**
*此文章参考 [linux-2.6 Documentation/SubmittingPatches](http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/SubmittingPatches;hb=4e8a2372f9255a1464ef488ed925455f53fbdaa1) ，并使用 GPLv2 协议。*

## Signed-off-by:

为了提高对内核补丁的跟踪管理，我们对邮件传递的补丁已经引入了 "sign-off" 方法。

"sign-off" 是 patch 的简单的说明，比如谁写的补丁或者可以作为开源的补丁来使用。这个规则比较简单，如下：

```
        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.
```

可以添加一行：

```
	Signed-off-by: Random J Developer <random@developer.example.org>
```

需要使用实际的名字 (不能使用假名或者匿名)。

有时可以在 "sign-off" 结尾添加一些额外的标识，比方说公司的内部流程或其他的说明。

如果是子系统或者分支的维护者，遇到 patch 中的代码的目录结果和当前代码结果不一致的情况时，需要做简单的修改；严格的说，这个目录的调整需要 patch 的提供者来完成，不过这样来来回回的比较消耗时间。如果维护者调整了代码的目录，建议加上对应的标识，如下：

```
	Signed-off-by: Random J Developer <random@developer.example.org>
	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>
```

这样，可以更好的对 patch 进行跟踪以及可以减少开发人员的抱怨。在任何情况下，可以改变作者的身份，因为作者的身份会在修改记录中出现。

## Acked-by:, Cc:

Signed-off-by: 开发人员的标识或者 patch 的出处。

如果一个人并没有直接参与到补丁的修改，但还要记录他们曾经的付出，可以把他们添加到 'Acked-by:' 中。

Acked-by: 不同于 Signed-off-by:.  记录了 acker 评审过 patch 或者对 patch 提出过建议。

Acked-by: 不代表对整个 patch 的确认。例如：一个 patch 影响了多个子系统并且有一个 'Acked-by: from one subsystem maintainer'，这表明影响了维护者的代码。如果对此有疑问，可以参考邮件列表中之前的讨论。

如果一个人有机会对 patch 提出评论，但这个人并没有实际提出，这时可以在 patch 中添加 `Cc:` 标识。这是唯一一个在没有明确操作的情况下，可以添加相关人员的名字。

## Reported-by:, Tested-by: and Reviewed-by:

如果 patch 修复了一个人提出的问题，那么可以把这个人添加到 `Reported-by:` 标识中。即使问题没有在公开的论坛上反馈过，如果没得到问题提出人的允许，那么不能添加这个标识。也就是说，如果我们信任问题的反馈人员，那么他们将来会帮忙我们反馈更多的问题。

Tested-by: 测试人员的信息。此标识可以告诉维护人员：patch 已经做了相关的测试。

Reviewed-by: patch 评审人员信息及评审意见如下：

```
	Reviewer's statement of oversight

	By offering my Reviewed-by: tag, I state that:

 	 (a) I have carried out a technical review of this patch to
	     evaluate its appropriateness and readiness for inclusion into
	     the mainline kernel.

	 (b) Any problems, concerns, or questions relating to the patch
	     have been communicated back to the submitter.  I am satisfied
	     with the submitter's response to my comments.

	 (c) While there may be things that could be improved with this
	     submission, I believe that it is, at this time, (1) a
	     worthwhile modification to the kernel, and (2) free of known
	     issues which would argue against its inclusion.

	 (d) While I have reviewed the patch and believe it to be sound, I
	     do not (unless explicitly stated elsewhere) make any
	     warranties or guarantees that it will achieve its stated
	     purpose or function properly in any given situation.
```

`Reviewed-by` 可以看作是对 patch 评审的一个说明，比如没有遗留的技术问题。另外，从 `Reviewed-by` 可以看到对 patch 的评审程度。评审人员可以在此给出简短的评论。

