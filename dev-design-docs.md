# Gerrit Code Review - Design Docs

For the `design-driven contribution process` it is required to specify features
upfront in a design doc.

## Design Doc Structure

A design doc should discuss the following aspects:

* Use-Cases:
  The interactions between a user and a system to attain particular
  goals.
* Acceptance Criteria
  Conditions that must be satisfied to consider the feature as done.
* Background:
  Stuff one needs to know to understand the use-cases (e.g. motivating
  examples, previous versions and problems, links to related
  changes/design docs, etc.)
* Possible Solutions:
  Possible solutions with the pros and cons, and explanation of
  implementation details.
* Conclusion:
  Which decision was made and what were the reasons for it.

As community we want to collaborate on design docs as much as possible
and write them together, in an iterative manner. To make this work well
design docs are split into multiple files that can be written and
refined by several persons in parallel:

* `index.md`:
  Entry file that links to the files below (also see
  'dev-design-doc-index-template.md').
* `use-cases.md`:
  Describes the use-cases, acceptance criteria and background (also see
  'dev-design-doc-use-cases-template.md').
* `solution-<n>.md`:
  Each possible solution (with the pros and cons, and implementation
  details) is described in a separate file (also see
  'dev-design-doc-solution-template.md').
* `conclusion.md`:
  Describes the conclusion of the design discussion (also see
  'dev-design-doc-conclusion-template.md').

It is expected that:

* An agreement on the use-cases is achieved before solutions are being
  discussed in detail.
* Anyone who has ideas for an alternative solution uploads a change
  with a `solution-<n>.md` that describes their solution. In case of
  doubt whether an idea is a refinement of an existing solution or an
  alternative solution, it's up to the owner of the discussed solution
  to decide if the solution should be updated, or if the proposer
  should start a new alternative solution.
* All possible solutions are fairly discussed with their pros and cons,
  and treated equally until a conclusion is made.
* Unrelated issues (judged by the design doc owner) that are identified
  during discussions are extracted into new design docs (initially
  consisting only of an `index.md` and a `use-cases.md` file).
* Changes making iterative improvements can be submitted frequently
  (e.g. additional uses-cases can be added later, solutions can be
  submitted without describing implementation details, etc.).
* After a conclusion has been approved contributors are expected to
  keep the design doc updated and fill in gaps while they go forward
  with the implementation.

## How to propose a new design?

To propose a new design, upload a change to the
link:[homepage](https://gerrit-review.googlesource.com/admin/repos/homepage) repository that adds a new folder under `pages/design-docs/`
which contains at least an `index.md` and a `uses-cases.md` file (see
`design doc structure` above).

Pushing a design doc for review requires to be a
[contributor](dev-roles.md).

When contributing design docs, contributors should make clear whether
they are committed to do the implementation. It is possible to
contribute designs without having resources to do the implementation,
but in this case the implementation is only done if someone volunteers
to do it (which is not guaranteed to happen).

Only very few maintainers actively watch out for uploaded design docs.
To raise awareness you may want to send a notification to the
[repo-discuss](https://groups.google.com/d/forum/repo-discuss)
mailing list about your uploaded design doc. But the discussion should
not take place on the mailing list, comments should be made by reviewing
the change in Gerrit.

## Design doc review

Everyone in the link:html[Gerrit community](dev-roles.md) is welcome to
take part in the design review and comment on the design.

Ideas for alternative solutions should be uploaded as a change that
describes the solution (see collaboration above).

Changes which make a conclusion on a design (changes that add/change
the `conclusion.md` file, see `Design Doc Structure`)
should stay open for a minimum of 10 calendar days so that everyone has
a fair chance to see them. It is important that concerns regarding a
feature are raised during this time frame since once a conclusion is
approved and submitted the implementation may start immediately.

Other design doc changes can and should be submitted quickly so that
collaboration and iterative refinements work smoothly (see collaboration above).

For proposed features the contributor should hear back from the
link:dev-processes.html#steering-committee[engineering steering
committee] within 14 calendar days whether the proposed feature is in
scope of the project and if it can be accepted.

## How to get notified for new design docs?

. Go to the
  link:https://gerrit-review.googlesource.com/settings/#Notifications[
  notification settings]
. Add a project watch for the `homepage` repository with the following
  query: `dir:pages/design-docs`
