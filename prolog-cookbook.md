# Gerrit Code Review - Prolog Submit Rules Cookbook

## Submit Rule

_Submit Rule_ 通过逻辑来定义 change 是否可以合入。默认情况下，所有的打分项都有最高的得分，没有最低的得分，那么 change 是可以合入的。通常，change 有 `Code-Review+2`, `Verified+1` 但没有 `Code-Review-2` 和 `Verified-1` ，change 此时可以合入。

有的时候，可以自定义合入的规则，gerrit 支持这样的扩展，可以通过 prolog 来实现。

**NOTE:**
*如果要使用 Prolog ，那么需要在 `gerrit.config` 文件中取消或删除 `rules.enable=false` 配置。*

[关于线程的讨论](https://groups.google.com/d/topic/repo-discuss/wJxTGhlHZMM/discussion) 解释了为什么选用 Prolog 来书写 submit 的规则。
[Gerrit 2.2.2 ReleaseNotes](http://gerrit-documentation.googlecode.com/svn/ReleaseNotes/ReleaseNotes-2.2.2.html) 介绍了 Gerrit 中 prolog 的使用情况。

## Submit Type

_Submit Type_ 指的是 commit 合入到目标分支的方式，类型如下：

* `Fast Forward Only`
* `Merge If Necessary`
* `Merge Always`
* `Cherry Pick`
* `Rebase If Necessary`

_Submit Type_ 是 project 的全局设置，意味着一个 project 中的所有 change 的 submit-type 是一样的。

submit-type 会在 change 的页面上显示。

使用 "Submit including ancestors" 或 "Submit whole topic" 批量提交 change 的时候，如果有多种 submit-type ，那么提交会失败。为了避免这个潜在的问题，建议 submit-type 要归一。

## Prolog Language

此文档并不是一个完整的 Prolog 教程，只介绍了 prolog 的一些重要语法及案例。[Prolog 的 Wikipedia 页面](http://en.wikipedia.org/wiki/Prolog) 是学习 Prolog 的良好的开始

## Prolog in Gerrit

Gerrit 根据原始的 [prolog-cafe](http://kaminari.istc.kobe-u.ac.jp/PrologCafe/)，[定义了自己的 prolog-cafe](https://gerrit.googlesource.com/prolog-cafe/)。Gerrit 内置了 prolog-cafe 库文件，可以在运行时直接解释 Prolog 程序。

## Interactive Prolog Cafe Shell

gerrit 提供了 [prolog-shell](pgm-prolog-shell.md) 可以以交互的方式进行相关测试。

对于 batch 或 unit 测试，可以参考 Gerrit 源码目录中的例子 [prologtests/examples](https://gerrit.googlesource.com/gerrit/+/refs/heads/master/prologtests/examples/)

**NOTE:**
*此处交互式的 shell 仅仅是 prolog 的一个 shell，此 shell 并没有加载 gerrit 的环境，因此不能测试 submit-type 。*

## SWI-Prolog

Instead of using the [prolog-shell](pgm-prolog-shell.md) program one can
可以使用 [SWI-Prolog](http://www.swi-prolog.org/) 代替 [prolog-shell](pgm-prolog-shell.md)，因为 SWI-Prolog 有图形化的调试器和更好的交互方式。

## The rules.pl file

此部分描述了如何创建或修改 submit-rule。如何书写 submit-rule 会在下个部分做介绍。

submit-rule 存储在 project 的 `refs/meta/config` 分支的 `rules.pl` 文件中。因此，我们需要 fetch 和 checkout `refs/meta/config` 分支，用来创建或编辑 `rules.pl` 文件。

```
  $ git fetch origin refs/meta/config:config
  $ git checkout config
  ... edit or create the rules.pl file
  $ git add rules.pl
  $ git commit -m "My submit rules"
  $ git push origin HEAD:refs/meta/config
```

## How to write submit rules

gerrit 需要识别 project `P` 中 change `C` 的 submit-rule，首先通过下面的步骤初始化内置的 Prolog 解释器：

* 查看 change `C` 的属性信息
* 验证 project `P` 中的 `rules.pl` 

Conceptually we can imagine that Gerrit adds a set of facts about the change
`C` on top of the `rules.pl` file and then consults it. The set of facts about
the change `C` will look like:
从概念上讲，我们可以想象 Gerrit 在 `rules.pl` 文件的顶部添加了一些 change `C` 的属性信息，然后再验证 `rules.pl` 文件。 关于 change `C` 的属性信息如下所示：

```
  :- package gerrit.                                                   <1>

  commit_author(user(1000000), 'John Doe', 'john.doe@example.com').    <2>
  commit_committer(user(1000000), 'John Doe', 'john.doe@example.com'). <3>
  commit_message('Add plugin support to Gerrit').                      <4>
  ...
```

<1> Gerrit 在 package `gerrit` 中提供 change 的属性信息。意味着我们写代码时需要使用这些属性信息。例如：`gerrit:commit_author(ID, N, M)`
<2> user ID, full name 以及 author 的邮箱
<3> user ID, full name 以及 committer 的邮箱
<4> commit message

change 的完整的属性信息可以参考：[Prolog Facts for Gerrit Change](prolog-change-facts.md)。

默认情况下，Gerrit 会在 `rules.pl` 文件中搜索 `submit_rule/1`，识别出 `submit_rule(X)` ，然后检查 `X` 的值以确定 change 是否可提交，并且还要找到影响 change 提交的因素。`submit` 返回值如下格式：

```
  submit(label(label-name, status) [, label(label-name, status)]*)
```

`label-name` 通常是 `'Code-Review'` 或 `'Verified'` ，有时也可以自定义。其 `status` 如下:

* `ok(user(ID))`. 此打分项通过
* `need(_)` 此打分项还需要继续评审
* `reject(user(ID))`. 此打分项不通过
* `impossible(_)` 从逻辑角度判断此 change 不能合入。比方说无用户有相关打分项的权限。
* `may(_)` 此打分项为可选

**NOTE:**
*只有所有的打分项的 `submit` 返回值是 `ok` 或 `may` 状态，change 才可以合入。*

**IMPORTANT:**
*Gerrit 会让 Prolog 引擎持续搜索 `submit_rule(X)` 的结果，直到搜索到打分项的状态为 `ok` 或 `may` 或没有结果为止。如果所有的打分项的状态都是 `ok` ，那么之前的搜索出的结果会被忽略。否则，gerrit 页面上打分项会有 `need` 的显示，直到 change 变为可提交状态。*

下面是 `submit_rule` 判断的可能返回值:

```
  submit(label('Code-Review', ok(user(ID))))                        <1>
  submit(label('Code-Review', ok(user(ID))),
      label('Verified', reject(user(ID))))                          <2>
  submit(label('Author-is-John-Doe', need(_)))                      <3>
```

<1> label `'Code-Review'` 通过，因为没有其他的打分项，所以 change 为可提交状态。
<2> label `'Verified'` 被拒绝，change 不能合入。
<3> label `'Author-is-John-Doe'` 需要此打分项打分，change 才能合入。此状态并没有说明怎样打分才可以通过。但通过的话，`submit_rule` 会返回 `label('Author-is-John-Doe', ok(user(ID)))` 。很有可能，需要检查 `gerrit:commit_author`。下面会有更详细的例子说明。

当然，会使用 Gerrit 提供的相关 change 属性来实施 `submit_rule`。

`submit_rule` 返回结果的另一个应用是在 Gerrit 页面上显示还需要哪些打分项继续打分。如果返回结果包含打分项 `'ABC'`，并且 `'ABC'` 已在 project 中配置，则显示 `'ABC'` 需要继续打分。否则，不会显示。请注意，project 不会为 `submit_rule` 返回结果中的打分项再定义打分项。例如，`'Author-is-John-Doe'` 打分项是否通过，可能不需要进行对其打分，而是通过分析 change 的属性来给出结果。

## Submit Filter

改变 submit-rule 的另一个方法是 `submit_filter/2` 。当 gerrit 只在 project 中的 `rules.pl` 文件中搜索 `submit_rule` 的时候， `submit_filter` 会在其所有的父 project 的 `rules.pl` 文件中被搜索，但不会在当前的 project 中进行搜索。搜索会在当前 project 的父 project 开始，直到  `'All-Projects'`。

submit-filter 的目的在于过滤 `submit_rule`，因此 `submit_filter` 函数有两个参数：

```
  submit_filter(In, Out) :- ...
```
Gerrit 调用 `submit_filter` 时，把 `In` 参数包含了 `submit_rule` 所产生的 `submit` 规则，而 `Out` 参数则为相应的输出结果。

`submit_filter` 的 `Out` 值会成为其下一个父 project 的 `submit_filter` 的 `In` 值。最后一个执行的 `submit_filter` 的 `Out` 参数值，用来表示 change 是否可以提交。

**IMPORTANT:**
*`submit_filter` 是 Gerrit 管理员对所有 project 的 submit-rule 的一个管理机制，而 `submit_rule` 是 project-owner 对某 project 的 submit-rule 的一个管理机制。然而，project-owner 管理多个 project 的时候，可以设置一个父 project，然后在这个父 project 中实施 `submit_filter`，这样可以避免所有的 project 中都重复的配置 `submit_rule`。*

下面的 "drawing" 描述了 `submit_rule` 和 `submit_filter` 调用的顺序和结果。

```
  All-Projects
  ^   submit_filter(B, S) :- ...  <4>
  |
  Parent-3
  ^   <no submit filter here>
  |
  Parent-2
  ^   submit_filter(A, B) :- ...  <3>
  |
  Parent-1
  ^   submit_filter(X, A) :- ...  <2>
  |
  MyProject
      submit_rule(X) :- ...       <1>
```

<1> `MyProject` 中的 `submit_rule` 首先被调用。
<2> `X` 是 `Parent-1` 调用 `submit_filter` 后，过滤出的信息。
<3> `Parent-1` 的 `submit_filter` 过滤出的信息被 `Parent-2` 再次过滤。由于 `Parent-3` 没有 `submit_filter`，所有忽略。
<4> `Parent-2` 的 `submit_filter` 过滤出的信息被 `All-Projects` 再次过滤，`S` 为 change 最终的识别后的可否提交的值。

**NOTE:**
*如果 `MyProject` 没有定义自己的 `submit_rule` ，那么 Gerrit 会调用默认的 `gerrit:default_submit` 规则，然后参照上面的步骤继续执行。*

## How to write submit type

使用 prolog 定制 submit-type 的规则和定制 submit-rule 类似。不同的地方在于接口的使用，`submit_type` 和 `submit_rule`，`submit_type` 的返回结果如下：

* `fast_forward_only`
* `merge_if_necessary`
* `merge_always`
* `cherry_pick`
* `rebase_if_necessary`

## Submit Type Filter

submit-type 的过滤方式和 submit 的过滤方式类似，只不过函数名称不一样，为 `submit_type_filter`。

```
  submit_type_filter(In, Out).
```

Gerrit 调用 `submit_type_filter` ，`In` 参数包含了 `submit_type` 的信息，`Out` 参数则为过滤后的结果。

## Testing submit rules

使用命令 [test-submit rule](cmd-test-submit-rule.md) 可以对具体的 change 执行 `submit_rule` 的测试，参考命令如下：

```
  $ cat rules.pl | ssh gerrit_srv gerrit test-submit rule I45e080b105a50a625cc8e1fb5b357c0bfabe6d68 -s
```

## Prolog vs Gerrit plugin for project specific submit rules

gerrit 从 v2.5 开始，支持 plugin。plugin 可以用来定制 submit-rule。某些方面，书写和部署 prolog 要比 plugin 开发方便很多。比如 submit-rule，使用 prolog 的话 project-owner 可以部署；使用 plugin 的话，需要联系管理员进行操作。另外，书写 prolog 还可以在 gerrit 上走评审流程，通过后，规则会自动实施。

换句话说，prolog 可以调用 change 的少数的属性，而 plugin 可以访问 change 的全部属性，所以实现功能的丰富程度也显而易见。

gerrit 从 v2.6 开始，plugin 可以使用 prolog 语言进行开发。

## Examples - Submit Rule

下面介绍了一些 submit-rule 的例子。

再进行一次重申，`submit_rule` 只在当前的 project 中执行，而 `submit_filter` 在当前 project 的所有的父 project 中执行。

### Example 1: Make every change submittable

任何 change 都可以合入，但不能进行打分操作:

`rules.pl`

```
submit_rule(submit(W)) :-
    W = label('Any-Label-Name', ok(user(1000000))).
```

在这种情况下，submit_rule 函数的返回值中没有所需要的打分项信息，所以 gerrit 不会识别 change 的打分项状态，并且在网页上页不会显示打分项的情况。同样， `'Any-Label-Name'` 可以定义成其他打分项的名字。

The `user(1000000)` 表示 account-ID 是 `1000000`。

**NOTE:**
*这里用的 account-ID 是 `1000000` ，当然也可以用其他的 account-ID。后面的例子中，使用 `user(ID)` 代替 `user(1000000)`，是从可读性的角度考虑的，并不代表其他的特殊用途。*

### Example 2: Every change submittable and voting in the standard categories possible

延续 `example 1`，显示 `'Code-Review'` 和 `'Verified'` 打分项并可以打分。

`rules.pl`

```
submit_rule(submit(CR, V)) :-
    CR = label('Code-Review', ok(user(ID))),
    V = label('Verified', ok(user(ID))).
```

因为 change 每个打分项的状态都是 `'ok'` ，无论再怎样进行打分，change 都可以合入。

### Example 3: Nothing is submittable

无论怎样打分，任何 change 都不可以合入，和示例 1 相反：

`rules.pl`

```
submit_rule(submit(R)) :-
    R = label('Any-Label-Name', reject(user(ID))).
```

因为所有的 change 返回的打分项的状态是 `reject`, 因此没有 change 可以合入。然而，gerrit 页面不会显示需要哪些打分项继续打分，因为并没有返回打分项 `need` 的状态。

### Example 4: Nothing is submittable but UI shows several 'Need ...' criteria

此示例中，任何 change 都不能合入，并且 gerrit 页面会显示 'Need <label>' 。

`rules.pl`

```
% In the UI this will show: Need Any-Label-Name
submit_rule(submit(N)) :-
    N = label('Any-Label-Name', need(_)).

% We could define more "need" labels by adding more rules
submit_rule(submit(N)) :-
    N = label('Another-Label-Name', need(_)).

% or by providing more than one need label in the same rule
submit_rule(submit(NX, NY)) :-
    NX = label('X-Label-Name', need(_)),
    NY = label('Y-Label-Name', need(_)).
```

gerrit 页面会显示:

* `Need Any-Label-Name`
* `Need Another-Label-Name`
* `Need X-Label-Name`
* `Need Y-Label-Name`

从此示例可以看出:

* prolog 中的注释以 `%` 字符开头
* 可以有多个 `submit_rule` 函数。默认，会把所有的结果联合到一起，然后进行搜索。所有，页面上可以看到  4 `need` 的打分项。

### Example 5: The 'Need ...' labels not shown when change is submittable

如果 `submit_rule(X)` 的结果为所有打分项的状态是 `ok`，那么 gerrit 不显示 “`need` 打分项”。

`rules.pl`

```
submit_rule(submit(N)) :-
    N = label('Some-Condition', need(_)).

submit_rule(submit(OK)) :-
    OK = label('Another-Condition', ok(user(ID))).
```

`'Need Some-Condition'` 因为第二条规则的结果，不会在 gerrit 页面显示。

如果规则交互了位置，执行的结果不变：

`rules.pl`

```
submit_rule(submit(OK)) :-
    OK = label('Another-Condition', ok(user(ID))).

submit_rule(submit(N)) :-
    N = label('Some-Condition', need(_)).
```

第一条规则的结果会停止其他规则的执行。

### Example 6: Make change submittable if commit author is "John Doe"

此示例为 `example 1` 的扩展，只要 commit 的 author 为 `'John Doe'`，那么 change 就可以提交合入代码库。

`rules.pl`

```
submit_rule(submit(Author)) :-
    Author = label('Author-is-John-Doe', need(_)).
```

gerrit 页面会显示:

* `Need Author-is-John-Doe`

我们可以再添加一条规则：

`rules.pl`

```
submit_rule(submit(Author)) :-
    Author = label('Author-is-John-Doe', need(_)).

submit_rule(submit(Author)) :-
    gerrit:commit_author(A, 'John Doe', _),
    Author = label('Author-is-John-Doe', ok(A)).
```

第二条规则中，如果 `commit_author` 是 `'John Doe'`，那么 `'Author-is-John-Doe'` 这个打分项将返回 `ok`。change 的 author 若是 `'John Doe'`，第二条规则会返回 `ok` 状态，并且 change 会变成可合入状态。如果 author 不是 `'John Doe'`，那么就是应用第一条规则，gerrit 页面会显示 `'Need Author-is-John-Doe'` ，并且 change 也不会合入。

同样，也可以对用户的 email 做检查：

`rules.pl`

```
submit_rule(submit(Author)) :-
    Author = label('Author-is-John-Doe', need(_)).

submit_rule(submit(Author)) :-
    gerrit:commit_author(_, _, 'john.doe@example.com'),
    gerrit:uploader(U),
    Author = label('Author-is-John-Doe', ok(U)).
```

假设 user-id 是 `1000000`:

`rules.pl`

```
submit_rule(submit(Author)) :-
    Author = label('Author-is-John-Doe', need(_)).

submit_rule(submit(Author)) :-
    U = user(1000000),
    gerrit:commit_author(U, _, _),
    Author = label('Author-is-John-Doe', ok(U)).
```

或者，同时使用上面 3 个属性信息：

`rules.pl`

```
submit_rule(submit(Author)) :-
    Author = label('Author-is-John-Doe', need(_)).

submit_rule(submit(Author)) :-
    gerrit:commit_author(_, 'John Doe', 'john.doe@example.com'),
    gerrit:uploader(U),
    Author = label('Author-is-John-Doe', ok(U)).
```

### Example 7: Make change submittable if commit message starts with "Fix "

此示例描述了如何将打分项与 commit-msg 信息相匹配，如：判断 commit-msg 是否以 `Fix` 开头。与 commit 的 author 类似，commit-msg 作为 change 的属性，可以用做 prolog 作为相关判断的依据。为了匹配 commit-msg 中的信息，至少需要注意两点：

* 将字符串转换为字符列表，并且用 "classical" 方式进行匹配
* 使用 `regex_matches/2` 或 `gerrit:commit_message_matches/1`

下面是实现过程:

`rules.pl`

```
submit_rule(submit(Fix)) :-
    Fix = label('Commit-Message-starts-with-Fix', need(_)).

submit_rule(submit(Fix)) :-
    gerrit:commit_message(M), name(M, L), starts_with(L, "Fix "),
    gerrit:uploader(U),
    Fix = label('Commit-Message-starts-with-Fix', ok(U)).

starts_with(L, []).
starts_with([H|T1], [H|T2]) :- starts_with(T1, T2).
```

**NOTE:**
*`name/2` 内置函数用于转换成字符列表。如，字符串 `abc` 转换成字符列表为 `[97, 98, 99]`； 双引号的字符串 `"abc"` 会转换成 `[97, 98, 99]`。建议字符串用双引号。*

需要定义一个 `starts_with` 函数。

使用 `gerrit:commit_message_matches` 函数定义会更加方便：

`rules.pl`

```
submit_rule(submit(Fix)) :-
    Fix = label('Commit-Message-starts-with-Fix', need(_)).

submit_rule(submit(Fix)) :-
    gerrit:commit_message_matches('^Fix '),
    gerrit:uploader(U),
    Fix = label('Commit-Message-starts-with-Fix', ok(U)).
```

上面的例子中，检查 commit-msg 是否以 `Fix` 开头。如果结果是 `true`，那么状态为 `ok`并使用字符 `!` 停止对字符串的分割：

`rules.pl`

```
submit_rule(submit(Fix)) :-
    gerrit:commit_message_matches('^Fix '),
    gerrit:uploader(U),
    Fix = label('Commit-Message-starts-with-Fix', ok(U)),
    !.

% Message does not start with 'Fix ' so Fix is needed to submit
submit_rule(submit(Fix)) :-
    Fix = label('Commit-Message-starts-with-Fix', need(_)).
```

## The default submit policy

到目前为止，所有示例都集中在 change 数据的方面。但是，在现实场景中，我们复用 Gerrit 的默认提交策略，并进行扩展，可以通过下面方式完成：

* 了解 submit 策略的方式，并在其基础上进行扩展。
* 调用默认的 submit-rule ，根据返回的执行结果来确定下一步的操作。

### Default submit rule implementation

比如 submit-rule 有两个打分项, `Code-Review` 和 `Verified`, 可以按如下实现:

`rules.pl`

```
submit_rule(submit(V, CR)) :-
    gerrit:max_with_block(-2, 2, 'Code-Review', CR),
    gerrit:max_with_block(-1, 1, 'Verified', V).
```

了解了相关的原理，就可以做 submit-rule 的定制了。在 project 的配置文件中，如果添加了新的打分项，那么这个地方也有相应的进行添加，或者在父 project 中添加  `submit_filter`。

### Reusing the default submit policy

为了使用 gerrit 默认的 submit 策略，我们可以使用 `gerrit:default_submit` 。`gerrit:default_submit(X)` 包括配置文件中所有的打分项，如下：

`rules.pl`

```
submit_rule(X) :- gerrit:default_submit(X).
```

once we invoke the `gerrit:default_submit(X)` we can
perform further actions on the return result `X` and apply our specific
logic. The following pattern illustrates this technique:
上面的命令相当于不使用 `rules.pl`，只是使用默认的逻辑。然而，调用 `gerrit:default_submit(X)`，我们就可以对返回结果 `X` 执行下一步的操作。以下是命令的格式：

`rules.pl`

```
submit_rule(S) :- gerrit:default_submit(R), project_specific_policy(R, S).

project_specific_policy(R, S) :- ...
```

下面的示例中会向相关的描述。

### Example 8: Make change submittable only if `Code-Review+2` is given by a non author

本示例中，添加了一个新的标识 `Non-Author-Code-Review` ，意味着需要非 commit 的 author 进行 `Code-Review+2`，其他的默认策略保持不变。

#### Reusing the `gerrit:default_submit`

首先，调用 `gerrit:default_submit` 来执行默认的 submit 策略，然后识别 `Non-Author-Code-Review` 标识。如果非 author 进行了 `Code-Review+2`，那么 `Non-Author-Code-Review` 返回的状态为 `ok`。

`rules.pl`

```
submit_rule(S) :-
    gerrit:default_submit(X),
    X =.. [submit | Ls],
    add_non_author_approval(Ls, R),
    S =.. [submit | R].

add_non_author_approval(S1, S2) :-
    gerrit:commit_author(A),
    gerrit:commit_label(label('Code-Review', 2), R),
    R \= A, !,
    S2 = [label('Non-Author-Code-Review', ok(R)) | S1].
add_non_author_approval(S1, [label('Non-Author-Code-Review', need(_)) | S1]).
```

示例中使用 `univ` 操作符 `=..` 来解析 default_submit 的结果，default_submit 的格式为 `submit(label('Code-Review', ok(user(ID))), label('Verified', need(_)), ...)`，与 `[submit, label('Code-Review', ok(user(ID))), label('Verified', need(_)), ...]` 类似。然后把列表的尾部作为 prolog 的列表，这样处理起来会容易一些。最后，使用 `univ` 运算符将生成的列表转换回 submit 的数据结构。`univ` 运算符可以双向运行。

`add_non_author_approval` 中，一旦搜索到结果后，使用 `cut` 运算符 `!` 来阻止在其他的数据集中搜索。这很重要，因为在第二个 `add_non_author_approval` 规则中，在没有检查非 author `Code-Review+2` 时，添加了 `label('Non-Author-Code-Review', need(_))` 规则。

可以添加 `Forge Author` 权限。

#### Don't use `gerrit:default_submit`

不使用 `gerrit:default_submit`，使用其他的方法来实现，如下：

`rules.pl`

```
submit_rule(submit(CR, V)) :-
    base(CR, V),
    CR = label(_, ok(Reviewer)),
    gerrit:commit_author(Author),
    Author \= Reviewer,
    !.

submit_rule(submit(CR, V, N)) :-
    base(CR, V),
    N = label('Non-Author-Code-Review', need(_)).

base(CR, V) :-
    gerrit:max_with_block(-2, 2, 'Code-Review', CR),
    gerrit:max_with_block(-1, 1, 'Verified', V).
```

此方法更容易理解，并且看起来也比较清晰。然而，此方法有个弊端，如果添加了新的打分项，函数仍然返回两个打分项（`Code-Review` 和 `Verified`）的结果，不包括新打分项的结果。若要包含新打分项的结果，可以同时添加新打分项的规则，或在父 project 中将新的打分项添加到 `submit_filter`。

然而，前一个示例默认包括新的打分项，因为调用的是 `gerrit:default_submit`。

两种方法各有利弊，可根据实际情况来选择。

### Example 9: Remove the `Verified` category

一个 project 不涉及构建和测试，只有文本文件，所以只需要 code-review，此时可以移除 `Verified`，因此 change 有 `Code-Review+2` 并且没有 `-2` 的话，就会合入代码库。希望 gerrit 页面不显示 `Verified` 打分，并且 `Verified` 不影响 change 的合入。

不使用 `gerrit:default_submit`:

`rules.pl`

```
submit_rule(submit(CR)) :-
    gerrit:max_with_block(-2, 2, 'Code-Review', CR).
```

使用 `gerrit:default_submit` :

`rules.pl`

```
submit_rule(S) :-
    gerrit:default_submit(X),
    X =.. [submit | Ls],
    remove_verified_category(Ls, R),
    S =.. [submit | R].

remove_verified_category([], []).
remove_verified_category([label('Verified', _) | T], R) :- remove_verified_category(T, R), !.
remove_verified_category([H|T], [H|R]) :- remove_verified_category(T, R).
```

### Example 10: Combine examples 8 and 9

examples 8 and 9 的结合。

`rules.pl`

```
submit_rule(S) :-
    gerrit:default_submit(X),
    X =.. [submit | Ls],
    remove_verified_category(Ls, R1),
    add_non_author_approval(R1, R),
    S =.. [submit | R].
```

定义 `remove_verified_category` 和 `add_non_author_approval` 两个函数。

不使用 `gerrit:default_submit` 函数来实现需求，如下：

`rules.pl`

```
submit_rule(submit(CR)) :-
    base(CR),
    CR = label(_, ok(Reviewer)),
    gerrit:commit_author(Author),
    Author \= Reviewer,
    !.

submit_rule(submit(CR, N)) :-
    base(CR),
    N = label('Non-Author-Code-Review', need(_)).

base(CR) :-
    gerrit:max_with_block(-2, 2, 'Code-Review', CR).
```

### Example 11: Remove the `Verified` category from all projects

Example 9, 在具体的 project 中使用 `submit_rule` 移除 `Verified` 打分项。此示例中，在所有的 project 中移除 `Verified`，意味着在 `All-Projects` 的 `rules.pl` 文件中使用 `submit_filter` 函数来实现。

`rules.pl`

```
submit_filter(In, Out) :-
    In =.. [submit | Ls],
    remove_verified_category(Ls, R),
    Out =.. [submit | R].

remove_verified_category([], []).
remove_verified_category([label('Verified', _) | T], R) :- remove_verified_category(T, R), !.
remove_verified_category([H|T], [H|R]) :- remove_verified_category(T, R).
```

### Example 12: On release branches require DrNo in addition to project rules

release 分支上添加了一个新的打分项 'DrNo'。使用 `drno('refs/heads/branch')` 来标识 release 分支。

`rules.pl`

```
drno('refs/heads/master').
drno('refs/heads/stable-2.3').
drno('refs/heads/stable-2.4').
drno('refs/heads/stable-2.5').
drno('refs/heads/stable-2.5').

submit_filter(In, Out) :-
    gerrit:change_branch(Branch),
    drno(Branch),
    !,
    In =.. [submit | I],
    gerrit:max_with_block(-1, 1, 'DrNo', DrNo),
    Out =.. [submit, DrNo | I].

submit_filter(In, Out) :- In = Out.
```

### Example 13: 1+1=2 Code-Review

此示例中，如果 `Code-Review` 得分总和 大于等于 2 的话，那么 change 可以合入。

此示例的代码和 `example 8` 类似，需要再添加 `findall/3` 和 `gerrit:remove_label`。

`findall/3` 在此示例中用于获取 `Code-Review` 的打分列表。`gerrit:remove_label` 和前面示例中的 `remove_verified_category` 类似。

`rules.pl`

```
sum_list([], 0).
sum_list([H | Rest], Sum) :- sum_list(Rest,Tmp), Sum is H + Tmp.

add_category_min_score(In, Category, Min,  P) :-
    findall(X, gerrit:commit_label(label(Category,X),R),Z),
    sum_list(Z, Sum),
    Sum >= Min, !,
    gerrit:commit_label(label(Category, V), U),
    V >= 1,
    !,
    P = [label(Category,ok(U)) | In].

add_category_min_score(In, Category,Min,P) :-
    P = [label(Category,need(Min)) | In].

submit_rule(S) :-
    gerrit:default_submit(X),
    X =.. [submit | Ls],
    gerrit:remove_label(Ls,label('Code-Review',_),NoCR),
    add_category_min_score(NoCR,'Code-Review', 2, Labels),
    S =.. [submit | Labels].
```

不使用 `gerrit:default_submit` 进行实现:

`rules.pl`

```
submit_rule(submit(CR, V)) :-
    sum(2, 'Code-Review', CR),
    gerrit:max_with_block(-1, 1, 'Verified', V).

% Sum the votes in a category. Uses a helper function score/2
% to select out only the score values the given category.
sum(VotesNeeded, Category, label(Category, ok(_))) :-
    findall(Score, score(Category, Score), All),
    sum_list(All, Sum),
    Sum >= VotesNeeded,
    !.
sum(VotesNeeded, Category, label(Category, need(VotesNeeded))).

score(Category, Score) :-
    gerrit:commit_label(label(Category, Score), User).

% Simple Prolog routine to sum a list of integers.
sum_list(List, Sum)   :- sum_list(List, 0, Sum).
sum_list([X|T], Y, S) :- Z is X + Y, sum_list(T, Z, S).
sum_list([], S, S).
```

### Example 14: Master and apprentice

示例中的两个角色，开发某模块时，`apprentice`，为此模块的普通开发人员；`master` 此模块的评审人员。

先检查 commit 的 author 是否为此模块的开发人员（`apprentice`），如果是的话，再检查此模块的评审人员（`master`）是否有 `+2` 的打分。 

`rules.pl`

```
% master_apprentice(Master, Apprentice).
% Extend this with appropriate user-id for your master/apprentice setup.
master_apprentice(user(1000064), user(1000000)).

submit_rule(S) :-
    gerrit:default_submit(In),
    In =.. [submit | Ls],
    add_apprentice_master(Ls, R),
    S =.. [submit | R].

check_master_approval(S1, S2, Master) :-
    gerrit:commit_label(label('Code-Review', 2), R),
    R = Master, !,
    S2 = [label('Master-Approval', ok(R)) | S1].
check_master_approval(S1, [label('Master-Approval', need(_)) | S1], _).

add_apprentice_master(S1, S2) :-
    gerrit:commit_author(Id),
    master_apprentice(Master, Id),
    !,
    check_master_approval(S1, S2, Master).

add_apprentice_master(S, S).
```

### Example 15: Make change submittable if all comments have been resolved

通过 change 的 `unresolved_comments_count` 属性，来阻止含有解决 comment 的 change 合入。

`rules.pl`

```
submit_rule(submit(R)) :-
    gerrit:unresolved_comments_count(0),
    !,
    gerrit:uploader(U),
    R = label('All-Comments-Resolved', ok(U)).

submit_rule(submit(R)) :-
    gerrit:unresolved_comments_count(U),
    U > 0,
    R = label('All-Comments-Resolved', need(_)).
```

假设当前 change 合入的规则是需要 `Code-Review +2` 和 `Verified +1`：

`rules.pl`

```
submit_rule(submit(CR, V, R)) :-
    base(CR, V),
    gerrit:unresolved_comments_count(0),
    !,
    gerrit:uploader(U),
    R = label('All-Comments-Resolved', ok(U)).

submit_rule(submit(CR, V, R)) :-
    base(CR, V),
    gerrit:unresolved_comments_count(U),
    U > 0,
    R = label('All-Comments-Resolved', need(_)).

base(CR, V) :-
    gerrit:max_with_block(-2, 2, 'Code-Review', CR),
    gerrit:max_with_block(-1, 1, 'Verified', V).
```

不用在 project.config 文件中配置 `All-Comments-Resolved`，`'Needs All-Comments-Resolved'` 仅用于在 gerrit 页面上显示，当所有的 comment 都解决了，那么 change 就可以合入了。

### Example 16: Make change submittable if it is a pure revert

使用 change 的 `pure_revert` 属性，如果 revert 的 change 不是 pure 类型的话，阻止 change 的合入。

`rules.pl`

```
submit_rule(submit(R)) :-
    gerrit:pure_revert(1),
    !,
    gerrit:uploader(U),
    R = label('Is-Pure-Revert', ok(U)).

submit_rule(submit(label('Is-Pure-Revert', need(_)))).
```

假设当前 change 合入的规则是需要 `Code-Review +2` 和 `Verified +1`：

`rules.pl`

```
submit_rule(submit(CR, V, R)) :-
  base(CR, V),
  set_pure_revert_label(R).

base(CR, V) :-
  gerrit:max_with_block(-2, 2, 'Code-Review', CR),
  gerrit:max_with_block(-1, 1, 'Verified', V).

set_pure_revert_label(R) :-
  gerrit:pure_revert(1),
  !,
  gerrit:uploader(U),
  R = label('Is-Pure-Revert', ok(U)).

set_pure_revert_label(label('Is-Pure-Revert', need(_))).
```

不用在 project.config 文件中配置 `Is-Pure-Revert`，`'Needs Is-Pure-Revert'` 仅用于在 gerrit 页面上显示，当所有的 comment 都解决了，那么 change 就可以合入了。

## Examples - Submit Type

下面的例子展示了如何定义 submit-type。

### Example 1: Set a `Cherry Pick` submit type for all changes

定义 change 的默认 submit-type  为 `Cherry Pick` 。

rules.pl

```
submit_type(cherry_pick).
```

### Example 2: `Fast Forward Only` for all `refs/heads/stable*` branches

对 `refs/heads/stable*` 命名空间，使用 `Fast Forward Only` 的 submit-type 。原因是不要破坏稳定分支的构建。对应其他并不匹配 `refs/heads/stable*` 格式的分支来说，使用 project 的默认 submit-type 。

`rules.pl`

```
submit_type(fast_forward_only) :-
    gerrit:change_branch(B), regex_matches('refs/heads/stable.*', B),
    !.
submit_type(T) :- gerrit:project_default_submit_type(T).
```

第一个 `submit_type` 为 `refs/heads/stable.*` 定义了 submit-type  为 `Fast Forward Only`。第二个 `submit_type` 为默认的 submit-type 。

