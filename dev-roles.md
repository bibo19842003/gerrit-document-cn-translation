# Gerrit Code Review - Supporting Roles

As an open source project Gerrit has a large community of people
driving the project forward. There are many ways to engage with
the project and get involved.

## Supporter

Supporters are individuals who help the Gerrit project and the Gerrit
community in any way. This includes users that provide feedback to the
Gerrit community or get in touch by other means.

There are many possibilities to support the project, e.g.:

* get involved in discussions on the
  [repo-discuss](https://groups.google.com/d/forum/repo-discuss)
  mailing list (post your questions, provide feedback, share your
  experiences, help other users)
* attend community events like user summits (see
  [community calendar](https://calendar.google.com/calendar?cid=Z29vZ2xlLmNvbV91YmIxcGxhNmlqNzg1b3FianI2MWg0dmRpc0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t))
* report [issues](https://bugs.chromium.org/p/gerrit/issues/list)
  and help to clarify existing issues
* provide feedback on [new releases and release candidates](https://www.gerritcodereview.com/releases-readme.html)
* review [changes](https://gerrit-review.googlesource.com/q/status:open)
  and help to verify that they work as advertised, comment if you like
  or dislike a feature
* serve as contact person for a proprietary Gerrit installation and
  channel feedback from users back to the Gerrit community

Supporters can:

* post on the [repo-discuss](https://groups.google.com/d/forum/repo-discuss)
  mailing list (Please note that the `repo-discuss` mailing list is
  managed to prevent spam posts. This means posts from new participants
  must be approved manually before they appear on the mailing list.
  Approvals normally happen within 1 work day. Posts of people who
  participate in mailing list discussions frequently are approved
  automatically)
* comment on [changes](https://gerrit-review.googlesource.com/q/status:open)
  and vote from `-1` to `+1` on the `Code-Review` label (these votes
  are important to understand the interest in a change and to address
  concerns early, however maintainers can
  overrule/ignore these votes)
* download changes to try them out, feedback can be provided as
  comments and by voting (preferably on the `Verified` label,
  permissions to vote on the `Verified` label are granted by request,
  see below)
* file issues in the [issue tracker](https://bugs.chromium.org/p/gerrit/issues/list) and comment on existing issues
* support the [design-driven contribution process](dev-processes.md) by reviewing incoming
  [design docs](dev-design-docs.md) and raising concerns during
  the design review

Supporters who want to engage further can get additional privileges
on request (ask for it on the
[repo-discuss](https://groups.google.com/d/forum/repo-discuss)
mailing list):

* become member of the `gerrit-verifiers` group, which allows to:
** vote on the `Verified` and `Code-Style` labels
** edit hashtags on all changes
** edit topics on all open changes
** abandon changes
* approve posts to the
  [repo-discuss](https://groups.google.com/d/forum/repo-discuss)
  mailing list
* administrate issues in the
  [issue tracker](https://bugs.chromium.org/p/gerrit/issues/list)

Supporters can become contributors by signing a
contributor license agreement and contributing code to the Gerrit
project.

## Contributor

Everyone who has a valid [contributor license agreement](dev-cla.md) and who has [contributed](dev-contributing.md) at least
one change to any project on
[gerrit-review.googlesource.com](https://gerrit-review.googlesource.com/) is a contributor.

Contributions can be:

* new features
* bug fixes
* code cleanups
* documentation updates
* release notes updates
* propose design docs as part of the
  [design-driven contribution process](dev-contributing.md)
* scripts which are of interest to the community

Contributors have all the permissions that supporters
have. In addition they have signed a [contributor license agreement](dev-cla.md) which enables them to push changes.

Regular contributors can ask to be added to the `gerrit-verifiers`
group, which allows to:

* add patch sets to changes of other users
* propose project config changes (push changes for the
  `refs/meta/config` branch

Being member of the `gerrit-verifiers` group includes further
permissions (see supporter section above).

It's highly appreciated if contributors engage in code reviews,
design reviews and mailing list
discussions. If wanted, contributors can also serve as link:#mentor[
mentors] to support other contributors with getting their features
done.

Contributors may also be invited to join the Gerrit hackathons which
happen regularly (e.g. twice a year). Hackathons are announced on the
[repo-discuss](https://groups.google.com/d/forum/repo-discuss)
mailing list (also see
[community calendar])(https://calendar.google.com/calendar?cid=Z29vZ2xlLmNvbV91YmIxcGxhNmlqNzg1b3FianI2MWg0dmRpc0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t).

Outstanding contributors that are actively engaged in the community, in
activities outlined above, may be nominated as maintainers.

## Maintainer

Maintainers are the gatekeepers of the project and are in charge of
approving and submitting changes. Refer to the project homepage for
the link:https://www.gerritcodereview.com/members.html#maintainers[
list of current maintainers].

Maintainers should only approve changes that:

* they fully understand
* are in line with the project vision and project scope that are
  defined by the link:dev-processes.html#steering-committee[engineering steering
  committee], and should consult them, when in doubt
* meet the quality expectations of the project (well-tested, properly
  documented, scalable, backwards-compatible)
* implement usable features or bug fixes (no incomplete/unusable
  things)
* are not authored by themselves (exceptions are changes which are
  trivial according to the judgment of the maintainer and changes that
  are required by the release process and branch management)

Maintainers are trusted to assess changes, but are also expected to
align with the other maintainers, especially if large new features are
being added.

Maintainers are highly encouraged to dedicate some of their time to the
following tasks (but are not required to do so):

* reviewing changes
* mailing list discussions and support
* bug fixing and bug triaging
* supporting the
  link:dev-processes.html#design-driven-contribution-process[
  design-driven contribution process] by reviewing incoming
  [design docs](dev-design-docs.md) and raising concerns during
  the design review
* serving as mentor
* doing releases (see release manager)

Maintainers can:

* approve changes (vote `+2` on the `Code-Review` label); when
  approving changes, `-1` votes on the `Code-Review` label can be
  ignored if there is a good reason, in this case the reason should be
  clearly communicated on the change
* submit changes
* block submission of changes if they disagree with how a feature is
  being implemented (vote `-2` on the `Code-Review` label), but their
  vote can be overruled by the steering committee, see
  [Project Governance](dev-processes.md)
* nominate new maintainers and vote on nominations (see below)
* administrate the [mailing list](https://groups.google.com/d/forum/repo-discuss), the
  [issue tracker](https://bugs.chromium.org/p/gerrit/issues/list)
  and the [homepage](https://www.gerritcodereview.com/)
* gain permissions to do Gerrit releases and publish release artifacts
* create new projects and groups on [gerrit-review.googlesource.com](https://gerrit-review.googlesource.com/)
* administrate the Gerrit projects on
  [gerrit-review.googlesource.com](https://gerrit-review.googlesource.com/) (e.g. edit ACLs, update project configuration)
* create events in the [community calendar](https://calendar.google.com/calendar?cid=Z29vZ2xlLmNvbV91YmIxcGxhNmlqNzg1b3FianI2MWg0dmRpc0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t)
* discuss with other maintainers on the private maintainers mailing
  list and Slack channel

In addition, maintainers from Google can:

* approve/reject changes that update project dependencies (vote `-1` to
  `+1` on the `Library-Compliance` label), see
  [Upgrading Libraries](dev-processes.md)
* edit permissions on the Gerrit core projects

Maintainers can nominate new maintainers by posting a nomination on the
non-public maintainers mailing list. Nominations should stay open for
at least 10 calendar days so that all maintainers have a chance to
vote. To be approved as maintainer a minimum of 5 positive votes and no
negative votes is required. This means if 5 positive votes without
negative votes have been reached and 10 calendar days have passed, any
maintainer can close the vote and welcome the new maintainer. Extending
the voting period during holiday season or if there are not enough
votes is possible, but the voting period should not exceed 1 month. If
there are negative votes that are considered unjustified, the
link:dev-processes.html#steering-committee[engineering steering
committee] may get involved to decide whether the new maintainer can be
accepted anyway.

To become a maintainer, a contributor should have a
history of deep technical contributions across different parts of the
core Gerrit codebase. However, it is not required to be an expert on
everything. Things that we want to see from potential maintainers
include:

* high quality code contributions
* high quality code reviews
* activity on the mailing list

## Engineering Steering Committee Member

The Gerrit project has an Engineering Steering Committee (ESC) that
governs the project, see [Project Governance](dev-processes.md).

Members of the steering committee are expected to act in the interest
of the Gerrit project and the whole Gerrit community. Refer to the project
homepage for the [list of current committee members](https://www.gerritcodereview.com/members.html#engineering-steering-committee).

For those that are familiar with scrum, the steering committee member
role is similar to the role of an agile product owner.

Steering committee members must be able to dedicate sufficient time to
their role so that the steering committee can satisfy its
responsibilities and live up to the promise of answering incoming
requests in a timely manner.

Community members may submit new items under the
[ESC component](https://bugs.chromium.org/p/gerrit/issues/list?q=component:ESC)
in the issue tracker, or add that component to existing items, to raise them to
the attention of ESC members.

Community members may contact the ESC members directly using
mailto:gerritcodereview-esc@googlegroups.com.
This is a group that remains private between the individual community
member and ESC members.

Maintainers can become steering committee member by
election, or by being appointed by Google (only for the seats that
belong to Google).

## Mentor

A mentor is a maintainer or contributor who is assigned to support the development of a feature
that was specified in a [design doc](dev-design-docs.md) and was
approved by the [steering committee](dev-processes.md).

The goal of the mentor is to make the feature successful by:

* doing timely reviews
* providing technical guidance during code reviews
* discussing details of the design
* ensuring that the quality standards are met (well documented,
  sufficient test coverage, backwards compatible etc.)

The implementation is fully done by the contributor, but optionally
mentors can help out with contributing some changes.

Maintainers and contributors can
volunteer to generally serve as mentors, or to mentor specific features
(e.g. if they see an upcoming feature on the roadmap that they are
interested in). To volunteer as mentor, contact the
[steering committee](dev-processes.md) or
comment on a change that adds a [design doc](dev-design-docs.md).

## Community Manager

Community managers should act as stakeholders for the Gerrit community
and focus on the health of the community. Refer to the project homepage
for the [list of current community managers](https://www.gerritcodereview.com/members.html#community-managers).

Tasks:

* act as stakeholder for the Gerrit community towards the
  [steering committee](dev-processes.md)
* ensure that the [mentorship process](dev-contributing.md) works
* deescalate conflicts in the Gerrit community
* constantly improve community processes (e.g. contribution process)
* watch out for community issues and address them proactively
* serve as contact person for community issues

Community members may submit new items under the
[Community component](https://bugs.chromium.org/p/gerrit/issues/list?q=component:Community)
backlog, for community managers to refine. Only public topics should be
issued through that backlog.

Sensitive topics are to be privately discussed using
mailto:gerritcodereview-community-managers@googlegroups.com.
This is a group that remains private between the individual community
member and community managers.

The community managers should be a pair or trio that shares the work:

* One Googler that is appointed by Google.
* One or two non-Googlers, elected by the community if there are more
  than two candidates. If there is no candidate, we only have the one
  community manager from Google.

Community managers must not be steering committee members at the same time so that they can represent
the community without conflict of interest.

Anybody from the Gerrit community can candidate as community manager.
This means, in contrast to candidating for the ESC, candidating as
community manager is not limited to Gerrit maintainers. Otherwise the
nomination process, election process and election period for the
non-Google community manager are the same as for
[steering committee members](dev-processes.md).

## Release Manager

Each major Gerrit release is driven by a Gerrit maintainer, the so called release manager.

The release manager is responsible for:

* identifying release blockers and informing about them
* creating stable branches and updating version numbers
* creating release candidates, the final major release and minor releases
* announcing releases on the mailing list and collecting feedback
* ensuring that releases meet minimal quality expectations (Gerrit
  starts, upgrade from previous version works)
* publishing release artifacts
* ensuring quality and completeness of the release notes
* cherry-picking bug fixes, see [Backporting to stable branches](dev-processes.md)
* estimating the risk of new features that are added on stable
  branches, see [Development in stable branches](dev-processes.md)

Before each release, the release manager is appointed by consensus among
the maintainers. Volunteers are welcome, but it's also a goal to fairly
share this work between maintainers and contributing companies.

