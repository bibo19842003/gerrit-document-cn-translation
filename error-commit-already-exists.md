# commit already exists

如果 commit 已经生成 change，这个时候再将此 commit 推送评审的话，会报 "commit already exists (as current patchset)" 或 "commit already exists (in the change)" 或 "commit already exists (in the project)" 错误。

因为对 gerrit 来说没有新的 commit ，因此会报上面的错误。

更多可以参考 [no new changes](error-no-new-changes.md)。

