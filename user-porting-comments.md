#  Porting Comments User Documentation

Report a bug or send feedback using this [Monorail template](https://bugs.chromium.org/p/gerrit/issues/entry?template=Porting+Comments). You can also report a bug through the bug icon in the comment.

Comments in Gerrit are associated with a patchset. When a new patchset is uploaded, the comments are lost since they are not associated with the newer patchset.

![](images/user-porting-comments-original-comment.png)
To solve this issue, Gerrit now has “Ported Comments”. These are comments that were left on an older patchset displayed on all the newer patchsets uploaded. For example, a comment left on Patchset 6 will be ported over to Patchset 7, 8 and all subsequent patchsets that are uploaded, not just the latest patchset.

Ported comments are not copies of the comment but the comment simply shown in another place.

Which comments are ported over?

*   Unresolved comments
*   Unresolved drafts
*   Resolved drafts

Resolved comments are not ported over.

![](images/user-porting-comments-ported-comment.png)

## Interaction

Ported comments are visually the same as normal comments. They have a link at the top which shows the original patchset of the comment and links to it.

Interacting with the ported comments is exactly the same as interacting with the original comment (again, they are simply the original comment shown in a different location). \
Marking a ported comment resolved/unresolved will also update the original comment.


## Position

Gerrit tries to calculate the position of this comment on the new version of the file and shows the comment on that position for the newer patchset.

It’s not always possible to calculate an appropriate position for a comment. In this case, Gerrit attaches these comments as File Level Comments.

In some exceptional cases (such as the entire file being reverted), there is no appropriate file to associate this comment with. In this case we do not port this comment over. The comment is still present at its original location and visible in the Comments Tab & Change Log.
