# Gerrit Code Review - Server Side Administrative Tools

服务器端的工具可以通过下面命令来运行 WAR 文件，如：
```
  $ java -jar gerrit.war <tool> [<options>]
```
工具如下:

## Tools

**[init](pgm-init.md)**
	初始化 gerrit

**[daemon](pgm-daemon.md)**
	Gerrit 的 HTTP, SSH 服务

**[prolog-shell](pgm-prolog-shell.md)**
	Prolog 交互式窗口

**[reindex](pgm-reindex.md)**
	重新构建 secondary index

**[SwitchSecureStore](pgm-SwitchSecureStore.md)**
	切换 SecureStore 接口

**[rulec](pgm-rulec.md)**
	编译 Prolog 规则到 jar 文件

**version**
	显示 war 文件的版本号

**[passwd](pgm-passwd.md)**
	设置 secure.config 文件中的密码

### Transition Utilities

**[LocalUsernamesToLowerCase](pgm-LocalUsernamesToLowerCase.md)**
	将用户名转换为小写

**[MigrateAccountPatchReviewDb](pgm-MigrateAccountPatchReviewDb.md)**
	AccountPatchReviewDb 的迁移

