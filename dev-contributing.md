# Gerrit Code Review - Contributing

## Contributor License Agreement

In order to contribute to Gerrit a [Contributor License Agreement](dev-cla.md) must be completed before contributions are accepted.

## Contribution Processes

The Gerrit project offers two contribution processes:

* Lightweight Contribution Process
* Design-Driven Contribution Process

The lightweight contribution process has little overhead and is best
suited for small contributions (documentation updates, bug fixes, small
features). Contributions are pushed as changes and
[maintainers](dev-roles.md) review them adhoc.

For large/complex features, it is required to follow the
link:#design-driven-contribution-process[design-driven contribution
process] and specify the feature in a link:dev-design-docs.html[design
doc] before starting with the implementation.

If [contributors](dev-roles.md) choose the
lightweight contribution process and during the review it turns out
that the feature is too large or complex,
[maintainers](dev-roles.md) can require to follow the
design-driven contribution process instead.

If you are in doubt which process is right for you, consult the
[repo-discuss](https://groups.google.com/d/forum/repo-discuss)
mailing list.

These contribution processes apply to everyone who contributes code to
the Gerrit project, including `maintainers`. When reading this document, keep in mind that maintainers
are also contributors when they contribute code.

If a new feature is large or complex, it is often difficult to find a
maintainer who can take the time that is needed for a thorough review,
and who can help with getting the changes submitted. To avoid that this
results in unpredictable long waiting times during code review,
contributors can ask for `mentor support`. A mentor
helps with timely code reviews and technical guidance. Doing the
implementation is still the responsibility of the contributor.

### Quick Comparison

|        |Lightweight Contribution Process|Design-Driven Contribution Process
| :------| :------| :------|
|Overhead|low (write good commit message, address review comments)|high (write [design doc](dev-design-docs.md) and get it approved)
|Technical Guidance|by reviewer|during the design review and by reviewer/mentor
|Review  |adhoc (when reviewer is available)|by a dedicated mentor (if a `mentor` was assigned)
|Caveats |features may get vetoed after the implementation was already done, maintainers may make the design-driven contribution process required if a change gets too complex/large|design doc must stay open for a minimum of 10 calendar days, a mentor may not be available immediately
|Applicable to|documentation updates, bug fixes, small features|large/complex features

### Lightweight Contribution Process

The lightweight contribution process has little overhead and is best
suited for small contributions (documentation updates, bug fixes, small
features). For large/complex features the
`design-driven contribution process` is required.

As Gerrit is a code review tool, naturally contributions will
be reviewed before they will get submitted to the code base.  To
start your contribution, please make a git commit and upload it
for review to the [gerrit-review.googlesource.com](https://gerrit-review.googlesource.com/) Gerrit server.  To help speed up the
review of your change, review these [guidelines](dev-crafting-changes.md) before submitting your change.  You can view the pending
Gerrit contributions and their statuses
[here](https://gerrit-review.googlesource.com/#/q/status:open+project:gerrit).

Depending on the size of that list it might take a while for
your change to get reviewed.  Naturally there are fewer
[maintainers](dev-roles.md), that can approve changes,
than [contributors](dev-roles.md); so anything that
you can do to ensure that your contribution will undergo fewer
revisions will speed up the contribution process.  This includes
helping out reviewing other people's changes to relieve the load from
the maintainers.  Even if you are not familiar with Gerrit's internals,
it would be of great help if you can download, try out, and comment on
new features.  If it works as advertised, say so, and if you have the
privileges to do so, go ahead and give it a `+1 Verified`.  If you
would find the feature useful, say so and give it a `+1 Code Review`.

And finally, the quicker you respond to the comments of your reviewers,
the quicker your change might get merged!  Try to reply to every
comment after submitting your new patch, particularly if you decided
against making the suggested change. Reviewers don't want to seem like
nags and pester you if you haven't replied or made a fix, so it helps
them know if you missed it or decided against it.

Features or API extensions, even if they are small, will incur
long-time maintenance and support burden, so they should be left
pending for at least 24 hours to give maintainers in all timezones a
chance to evaluate.

### Design-driven Contribution Process

The design-driven contribution process applies to large/complex
features.

For large/complex features it is important to:

* agree on the functionality and scope before spending too much time
  on the implementation
* ensure that they are in line with Gerrit's project scope and vision
* ensure that they are well aligned with other features
* think about possibilities how the feature could be evolved over time

This is why for large/complex features it is required to describe the
feature in a [design doc](dev-design-docs.md) and get it approved
by the [steering committee](dev-processes.md),
before starting the implementation.

The design-driven contribution process has the following steps:

* A l[contributor](dev-roles.md)
  `proposes` a new feature by
  uploading a change with a [design doc](dev-design-docs.md).
* The design doc is `reviewed` by
  interested parties from the community. The design review is public
  and everyone can comment and raise concerns.
* Design docs should stay open for a minimum of 10 calendar days so
  that everyone has a fair chance to join the review.
* Within 30 calendar days the contributor should hear back from the
  `steering committee`
  whether the proposed feature is in scope of the project and if it can
  be accepted.
* To be submitted, the design doc needs to be approved by the `steering committee`.
* After the design was approved, the implementation is done by pushing
  changes for review, see link:#lightweight-contribution-process[
  lightweight contribution process]. Changes that are associated with
  a design should all share a common hashtag. The contributor is the
  main driver of the implementation and responsible that it is done.
  Others from the Gerrit community are usually much welcome to help
  with the implementation.

In order to be accepted/submitted, it is not necessary that the design
doc fully specifies all the details, but the idea of the feature and
how it fits into Gerrit should be sufficiently clear (judged by the
steering committee). Contributors are expected to keep the design doc
updated and fill in gaps while they go forward with the implementation.
We expect that implementing the feature and updating the design doc
will be an iterative process.

While the design doc is still in review, contributors may already start
with the implementation (e.g. do some prototyping to demonstrate parts
of the proposed design), but those changes should not be submitted
while the design wasn't approved yet.

By approving a design, the steering committee commits to:

* Accepting the feature when it is implemented.
* Supporting the feature by assigning a [mentor](dev-roles.md) (if requested, see `mentorship`).

If the implementation of a feature gets stuck and it's unclear whether
the feature gets fully done, it should be discussed with the steering
committee how to proceed. If the contributor cannot commit to finish
the implementation and no other contributor can take over, changes that
have already been submitted for the feature might get reverted so that
there is no unused or half-finished code in the code base.

For contributors, the design-driven contribution process has the
following advantages:

* By writing a design doc, the feature gets more attention. During the
  design review, feedback from various sides can be collected, which
  likely leads to improvements of the feature.
* Once a design was approved by the `steering committee`, the
  contributor can be almost certain that the feature will be accepted.
  Hence, there is only a low risk to invest into implementing a feature
  and see it being rejected later during the code review, as it can
  happen with the lightweight contribution process.
* The contributor can `get a dedicated mentor assigned`
  who provides timely reviews and serves as a contact person for
  technical questions and discussing details of the design.

## Mentorship

For features for which a [design](dev-design-docs.md) has been
approved (see link:#design-driven-contribution-process[design-driven
contribution process]), contributors can gain the support of a mentor
if they are committed to implement the feature.

A [mentor](dev-roles.md) helps with:

* doing timely reviews
* providing technical guidance during code reviews
* discussing details of the design
* ensuring that the quality standards are met (well documented,
  sufficient test coverage, backwards compatible etc.)

A feature can have more than one mentor. To be able to deliver the
promised support, at least one of the mentors must be a
[maintainer](dev-roles.md).

Mentors are assigned by the `steering committee`. To gain a mentor, ask for a mentor in the
`Implementation Plan` section of the design doc or ask the steering committee after the
design has been approved.

Mentors may not be available immediately. In this case, the steering
committee should include the approved feature into the roadmap or
prioritize it in the backlog. This way, it is transparent for the
contributor when they can expect to be able to work on the feature with
mentor support.

Once the implementation phase starts, the contributor is expected to do
the implementation in a timely manner.

For every mentorship, the end must be clearly defined. The design doc
must specify:

* a maximum time frame for the mentorship, after which the mentorship
  automatically ends, even if the feature is not done yet
* done criteria that define when the feature is done and the mentorship
  ends

If a feature is not finished in time, it should be discussed with the
steering committee how to proceed. If the contributor cannot commit to
finish the implementation in time and no other contributor can take
over, changes that have already been submitted for the feature might
get reverted so that there is no unused or half-finished code in the
code base.

## How the ESC evaluates design documents
This section describes how the ESC evaluates design documents. It’s
meant as a guideline rather than being prescriptive for both ESC
members and contributors.

### General Process
As part of the design process, the ESC makes a final decision if a
design gets to be implemented. If there are multiple alternative
solutions, the ESC will decide which solution can be implemented.

The ESC should wait until all contributors had the chance to
voice their opinion in review comments or by proposing alternative
solutions. Due to the infrequent ESC meetings (every 2-4 weeks)
the ESC might discuss documents in cases where the discussion is
already advanced far enough, but not make a decision yet. In this
case, contributors can still voice concerns or discuss alternatives.
The decision can be at the next meeting or via email in between
meetings.

### Evaluation
Product/Vision fit

Q: `Do we believe this feature belongs to Gerrit Code Review use-cases?`

* Yes: Customizable dashboards
* No: UI for managing an LDAP server

Q: `Is the proposed solution aligned with Gerrit’s vision?`

* Yes: Showing comments of older patch sets in newer patch sets to
  keep track (core code review)
* No: Implement a bug tracker in Gerrit (not core code review).

### Impact
Q: `Will the new feature have a measurable, positive impact?`

* Yes: Increased productivity, faster/smoother workflow, etc.
* Yes: Better latency, more reliable system.
* No: Unclear impact or lacking metrics to measure.

### Complexity
Q: `Can we support/maintain this feature once it is in Gerrit?`

* Yes: Code will fit into codebase, be well tested, easy to
  understand.
* No: Will add code or a workflow that is hard to understand
  and easy to misinterpret.

Q: `Is the proposed feature or rework adding unnecessary complexity?`

* Yes: Adding a dependency on a well-supported library.
* No: Adding a dependency on a library that is not widely used
  or not actively maintained.

### Core vs. Plugin decision
Q: `Would this fit better in a plugin?`

* Yes:The proposed feature or rework is an implementation (e.g. Lucene
  is an index implementation) of a generic concept that others
  might want to implement differently.
* Yes: The proposed feature or rework is very specific to a custom setup.
* No: The proposed feature or rework is applicable to a wider user
  base.
* No: The proposed feature or rework is a `core code review feature`.

### Commitment
Q: `Is someone willing to implement it?` (this question is
especially important when reviewers propose alternative designs
to the author’s own solution).

* Yes: The author or someone else commits to implementing the
  proposed solution.
* Yes: If a mentorship is required, a mentor is willing to help.
* No: Unclear ownership, mentorship or implementation plan.

### Community
Q: `If in doubt, is there a substantial benefit to a long-standing
community member with many users?`

* The community shapes the future of Gerrit as a product. In
  cases of doubt, the ESC can be more generous with long-standing
  community members compared to `drive-by` contributions.
