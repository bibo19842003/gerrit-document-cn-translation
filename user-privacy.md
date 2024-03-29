# Gerrit Code Review - User Privacy

## Purpose

This page documents how Gerrit handles user data.

```
Note: Gerrit has extensive support for [plugins](config-plugins.md)
  which extend Gerrits functionality, and these plugins could access, export, or
  maniuplate user data. This document only focuses on the behavior of Gerrit
  core and its [core plugins](dev-core-plugins.md).
```

## Types of User Data

Gerrit stores account data required for collaborating on source code changes.
This data is described by
link:config-accounts.html#account-data-in-user-branch[Account Data in User
Branch] and includes `External IDs`,
`User Preferences`,
`Project Watches` and personally
identifiable information, including  name and email address. The email
address is required to associate Git commits with a Gerrit user account. All
data except passwords is made accessible to other users who you are visible to,
as detailed below.

## User Visibility

Gerrit has a concept of `account visibility`
which determines what users a given user can see. This visibility configuration
applies in account search, reviewer suggestion, and when accessing data through
the `Account REST endpoints`. If
you can see a user, you have read access to most of the
`AccountInfo` for that user, including
name and email address. Additional information, including secondary emails, is
included in AccountInfo if the caller has “Modify Account” permissions.

Additionally, all users on a change (author, cc’d, reviewer) can see each other,
irrespective of the  account visibility settings. For example: Say you are a
reviewer on a change where user Foo is also a reviewer. Even if by account
visibility you could not search for Foo, you'd still see their avatar, name,
and email now because you can see the change; this information is required to
collaborate on a code review. If Foo wasn't on that change, you could not add
them because reviewer suggestions would not find them due to the account
visibility settings.

By default, account visibility on a Gerrit instance is set to `ALL` which allows
all users to be visible to other users, even anonymous (i.e. unauthenticated)
users. Depending on your installation type, you may want to change this:

* For completely company-internal Gerrit installations (no external users), the
`ALL` default may make sense.

* If you work with multiple vendors who have
access to their own independent sets of repos, `VISIBLE_GROUP` may be more
appropriate as you wouldn’t want vendor A to see accounts from vendor B.

* For public installations, e.g. for open source projects, you may want to
change this setting or add a notice for users when they create an account e.g.
“Most of what you submit on this site, including your email address and name,
will be visible to others who use this service. You may prefer to use an email
account specifically for this purpose.” One way to do this is using
`auth.registerPageUrl` in `gerrit.config`.

## ACLs and User Visibility

User suggestions for changes, when adding a reviewer or cc-ing someone, always
respect ACLs for that change: only users who can see the change are suggested.
The suggested users are an intersection of who you can see and who can see the
change.

Consider the following situation:

* `READ` permission for Registered Users on the host
* User visibility is set to `VISIBILE_GROUP`, so only users of the same domain can
  see each other
* a@foo.com creates change 123

This would mean:

* a@foo.com cannot add b@bar.com to the change because these users cannot see
  each other due to the user visibility setting.
* b@bar.com can find change 123
  because they have READ permission and could add themselves to the change.
* a@foo.com would then be able to see b@bar.com’s name, avatar, and email on
  change 123

The only caveat to the above are Private Changes, which are only visible to the
owner and reviewers; reviewers can only see the change once they are added to
the change (if ACLs allow them to be added in the first place), not before.

## Right to be Forgotten Limitations

As a source control system, Gerrit has limited abilities to remove personally
identifiable information. Notably, Gerrit cannot:

* Remove a user's e-mail from all existing commits
* Remove a user's username

There is also a known
[bug](https://bugs.chromium.org/p/gerrit/issues/detail?id=14185) where a
user's username is stored in metadata for link:user-attention-set.html[Attention
Set].


## Open Source Software Limitations

Gerrit is open-source software licensed under the Apache 2.0 license.  Unless
required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
OF ANY KIND, either express or implied. See the License for the specific
language governing permissions and limitations under the License.
