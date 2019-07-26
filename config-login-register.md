## Initial Login

安装 gerrit 后，打开一个终端（如 shell）窗口，检查 ssh key 是否存在，可以在用户根目录的 .ssh 目录中查找两个文件：id_rsa 和 id_rsa.pub 。

```
  user@host:~$ ls .ssh
  authorized_keys  config  id_rsa  id_rsa.pub  known_hosts
  user@host:~$
```

如果有上面两个文件，可以忽略下面生成 ssh key 的操作。

如果没有找到上面两个文件，需要生成 rsa key。

### SSH key generation

*如果存在有效的 ssh key，那么不用再生成，因为新的 ssh key 会覆盖掉老的 ssh key ！*

```
  user@host:~$ ssh-keygen -t rsa
  Generating public/private rsa key pair.
  Enter file in which to save the key (/home/user/.ssh/id_rsa):
  Created directory '/home/user/.ssh'.
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again:
  Your identification has been saved in /home/user/.ssh/id_rsa.
  Your public key has been saved in /home/user/.ssh/id_rsa.pub.
  The key fingerprint is:
  00:11:22:00:11:22:00:11:44:00:11:22:00:11:22:99 user@host
  The key's randomart image is:
  +--[ RSA 2048]----+
  |     ..+.*=+oo.*E|
  |      u.OoB.. . +|
  |       ..*.      |
  |       o         |
  |      . S ..     |
  |                 |
  |                 |
  |          ..     |
  |                 |
  +-----------------+
  user@host:~$
```

### Registering your key in Gerrit

浏览器中打开 gerrit，如果 gerrit 安装在本机，具体的 gerrit 地址可以参考下面命令来查看：

```
  gerrit@host:~$ git config -f ~/gerrit_testsite/etc/gerrit.config gerrit.canonicalWebUrl
  http://localhost:8080/
  gerrit@host:~$
```

可以通过 gerrit 的 web 页面使用 email 注册一个新账户。

默认的认证方式是 OpenID。架构上，如果 gerrit 服务器放在了 proxy 的后面，并且还要使用 OpenID，那么需要在配置文件中添加相关的 proxy 设置。

```
  gerrit@host:~$ git config -f ~/gerrit_testsite/etc/gerrit.config --add http.proxy http://proxy:8080
  gerrit@host:~$ git config -f ~/gerrit_testsite/etc/gerrit.config --add http.proxyUsername username
  gerrit@host:~$ git config -f ~/gerrit_testsite/etc/gerrit.config --add http.proxyPassword password
```

相关的配置可以参考：[系统配置](config-gerrit.md) 的 `authentication` 部分和 `proxy` 部分。

第一个登录的用户会成为 gerrit 管理员，有着超级大的权限。

登录后，可以按照提示填写相关信息：

* 真实姓名 (用于在 gerrit 上显示)
* 注册邮箱 (不要忘记了在邮箱中确认)
* 选择一个 username 用来与 gerrit 交互，此 username 不能更改。
* 粘贴已存在或已生成的 RSA public key。

```
  user@host:~$ cat .ssh/id_rsa.pub
  ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1bidOd8LAp7Vp95M1b9z+LGO96OEWzdAgBPfZPq05jUh
  jw0mIdUuvg5lhwswnNsvmnFhGbsUoXZui6jdXj7xPUWOD8feX2NNEjTAEeX7DXOhnozNAkk/Z98WUV2B
  xUBqhRi8vhVmaCM8E+JkHzAc+7/HVYBTuPUS7lYPby5w95gs3zVxrX8d1++IXg/u/F/47zUxhdaELMw2
  deD8XLhrNPx2FQ83FxrjnVvEKQJyD2OoqxbC2KcUGYJ/3fhiupn/YpnZsl5+6mfQuZRJEoZ/FH2n4DEH
  wzgBBBagBr0ZZCEkl74s4KFZp6JJw/ZSjMRXsXXXWvwcTpaUEDii708HGw== John Doe@MACHINE
  user@host:~$
```

```
**重要：**
粘贴 key 的时候，复制的 key 不能有额外的空格或者回车，否则 key 不能正常使用。
```

验证 ssh 链接是否可以使用：

```
  user@host:~$ ssh user@localhost -p 29418
  The authenticity of host '[localhost]:29418 ([127.0.0.1]:29418)' can't be established.
  RSA key fingerprint is db:07:3d:c2:94:25:b5:8d:ac:bc:b5:9e:2f:95:5f:4a.
  Are you sure you want to continue connecting (yes/no)? yes
  Warning: Permanently added '[localhost]:29418' (RSA) to the list of known hosts.

  ****    Welcome to Gerrit Code Review    ****

  Hi user, you have successfully connected over SSH.

  Unfortunately, interactive shells are disabled.
  To clone a hosted Git repository, use:

  git clone ssh://user@localhost:29418/REPOSITORY_NAME.git

  user@host:~$
```

