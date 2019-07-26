# Permission denied (publickey)

SSH 认证失败会报此错误。

[SSH](http://en.wikipedia.org/wiki/Secure_Shell) 协议使用 [Public-key Cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography) 进行认证。

默认情况下，gerrit 使用 `public keys` 进行认证。也可以使用 `kerberos` 进行认证。

用 ssh 命令可以测试本地环境的配置，如果报错，可以做如下检查：

 * 检查本地的 `public SSH key` 是否正确的贴到了 gerrit 页面上。
 * 本地有多个 `SSH key` 的时候，本地的 `private SSH key` 与服务器端的 `public SSH key` 是否是配套的。

kerberos 的问题可以参考如下：

 * 检查是否获得了有效的初始 ticket。linux 机器上，可以使用 `kinit` 命令获取 ticket ；`klist` 命令可以列出本地所有的 ticket，如：`HOST/gerrit.mydomain.tld@MYDOMAIN.TLD`。如果 ticket 过期了，需要重新生成。
 * 检查客户端是否开启了 kerberos 认证。OpenSSH 客户端需要设置 `GSSAPIAuthentication`，可以参考 [SSH 链接说明](user-upload.md) 的 kerberos 部分。

## Test SSH authentication

测试本地环境 SSH 认证是否通过：

```
  $ ssh -vv -p 29418 john.doe@git.example.com
```

如果通过，则有如下提示：

```
  ...

  debug1: Authentication succeeded (publickey).

  ...

  ****    Welcome to Gerrit Code Review    ****

  Hi John Doe, you have successfully connected over SSH.

  Unfortunately, interactive shells are disabled.
  To clone a hosted Git repository, use:

  git clone ssh://john.doe@git.example.com:29418/REPOSITORY_NAME.git

  ...
```


