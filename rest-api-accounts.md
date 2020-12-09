# Gerrit Code Review - /accounts/ REST API

此文描述了帐号相关的 API。API 概述请参考 [REST API](rest-api.md)。

## Account Endpoints

### Query Account
```
'GET /accounts/'
```

当前帐号搜索可访问的用户。需要使用 `q` 参数，`n` 参数用来控制返回搜索结果的数量。

返回 AccountInfo 信息，请参考本文的 AccountInfo。

_Request_
```
  GET /accounts/?q=name:John+email:example.com&n=2 HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "_account_id": 1000096,
    },
    {
      "_account_id": 1001439,
      "_more_accounts": true
    }
  ]
```

如果搜索的结果超过了上限，那么最后一个搜索结果的后面会有 `_more_accounts: true` 的标识。

`S` 或 `start` 搜索参数可以从搜索列表中忽略一个帐号信息。

 `o` 此参数可以显示一些额外的字段信息，每个选项会减慢对客户端的搜索响应时间，因此默认不使用这些参数。可选字段如下：

* `DETAILS`: 包括 full-name, 首选 email, 用户名，帐号头像，状态，tags
* `ALL_EMAILS`: 包括所有的已注册的 email。执行命令需要全局设置中的 `Modify Account` 权限。

`suggest` 参数用来显示参考帐号的信息，并且需要和搜索参数 `q` 一起使用。`n` 的默认值是 10。返回的响应结果包含上面参数 `DETAILS` 和 `ALL_EMAILS` 的信息。

_Request_
```
  GET /accounts/?suggest&q=John HTTP/1.0
```

如果有全局设置中的 `Modify Account` 权限，那么会显示用户的备用 email。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "_account_id": 1000096,
      "name": "John Doe",
      "email": "john.doe@example.com",
      "username": "john"
      "display_name": "John D"
    },
    {
      "_account_id": 1001439,
      "name": "John Smith",
      "email": "john.smith@example.com",
      "username": "jsmith"
      "display_name": "John D"
    },
  ]
```

### Get Account

```
'GET /accounts/{account-id}'
```

返回 AccountInfo 信息，请参考本文的 AccountInfo。

_Request_
```
  GET /accounts/self HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "_account_id": 1000096,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "username": "john"
    "display_name": "Super John"
  }
```

### Create Account

```
'PUT /accounts/{username}'
```

创建新帐号。

请求的主体中需要包含 AccountInput 数据，请参考本文的 AccountInput。

_Request_
```
  PUT /accounts/john HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "name": "John Doe",
    "display_name": "Super John",
    "email": "john.doe@example.com",
    "ssh_key": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw==",
    "http_password": "19D9aIn7zePb",
    "groups": [
      "MyProject-Owners"
    ]
  }
```

响应的信息是 AccountInfo，请参考本文的 AccountInfo。

_Response_
```
  HTTP/1.1 201 Created
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "_account_id": 1000195,
    "name": "John Doe",
    "email": "john.doe@example.com"
  }
```

### Get Account Details

```
'GET /accounts/{account-id}/detail'
```

获取用户帐号的详细信息，具体信息可参考本文的 AccountDetailInfo 。

_Request_
```
  GET /accounts/self/detail HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "registered_on": "2015-07-23 07:01:09.296000000",
    "_account_id": 1000096,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "username": "john"
    "display_name": "Super John"
  }
```

### Get Account Name

```
'GET /accounts/{account-id}/name'
```

获取帐号的 full-name。

_Request_
```
  GET /accounts/self/name HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "John Doe"
```

如果帐号没有名称，则反回空字符串。

### Set Account Name

```
'PUT /accounts/{account-id}/name'
```

设置帐号的 full-name

新帐号名称需要请求的主体中包含 AccountNameInput 数据，请参考本文的 AccountNameInput。

_Request_
```
  PUT /accounts/self/name HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "name": "John F. Doe"
  }
```

新帐号名称的响应的结果如下：

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "John F. Doe"
```

如果名称被删除了，响应返回 "`204 No Content`" 。

某些领域不允许修改帐号名称，如果发送了修改请求，会有返回信息："`405 Method Not Allowed`"。

### Delete Account Name

```
'DELETE /accounts/{account-id}/name'
```

删除帐号名称

_Request_
```
  DELETE /accounts/self/name HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

### Get Account Status

```
'GET /accounts/{account-id}/status'
```

查看帐号的状态

_Request_
```
  GET /accounts/self/status HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "Available"
```

如果帐号没有状态信息，则返回空字符串。

### Set Account Status

```
'PUT /accounts/{account-id}/status'
```

设置帐号的状态。

状态的值请参考本文的 AccountStatusInput 。

_Request_
```
  PUT /accounts/self/status HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "status": "Out Of Office"
  }
```

响应返回的新状态如下：

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "Out Of Office"
```

如果用户名称被删除，则返回 "`204 No Content`".

### Get Username

```
'GET /accounts/{account-id}/username'
```

查询帐号的 username 

_Request_
```
  GET /accounts/self/username HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "john.doe"
```

如果帐号没有 username t信息，则返回 "`404 Not Found`"。

### Set Username

```
'PUT /accounts/{account-id}/username'
```

新的 username 信息请参考本文的 UsernameInput 。

设置 username 后，username 不能修改或删除。

_Request_
```
  PUT /accounts/self/username HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "username": "jdoe"
  }
```

响应为返回新的 username 。

### Set Display Name
```
'PUT /accounts/{account-id}/displayname'
```

新的 display name 信息请参考本文的 UsernameInput 。

_Request_
```
  PUT /accounts/self/displayname HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "display_name": "John"
  }
```

响应为返回新的 display name 。

### Get Active

```
'GET /accounts/{account-id}/active'
```

检查帐号是否是 active 状态。

_Request_
```
  GET /accounts/john.doe@example.com/active HTTP/1.0
```

如果帐号是 active 状态，则返回 `ok` 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
```

如果帐号状态是 inactive ，则返回 "`204 No Content`"。

### Set Active

```
'PUT /accounts/{account-id}/active'
```

设置帐号的状态为 active 。

_Request_
```
  PUT /accounts/john.doe@example.com/active HTTP/1.0
```

_Response_
```
  HTTP/1.1 201 Created
```

如果帐号的状态已经是 active ，则返回 "`200 OK`"。

### Delete Active

```
'DELETE /accounts/{account-id}/active'
```

设置帐号的状态为 inactive.

_Request_
```
  DELETE /accounts/john.doe@example.com/active HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

如果帐号的状态已经是 inactive ，则返回 "`409 Conflict`"。

### Set/Generate HTTP Password

```
'PUT /accounts/{account-id}/password.http'
```

设置用户的 HTTP 密码。

请求主体中的格式，请参考本文的 HttpPasswordInput 。

需要指定用户名。

_Request_
```
  PUT /accounts/self/password.http HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "generate": true
  }
```

响应为返回新 HTTP 密码。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "ETxgpih8xrNs"
```

如果 HTTP 密码已经被删除了，则返回 "`204 No Content`"。

### Delete HTTP Password

```
'DELETE /accounts/{account-id}/password.http'
```

删除用户的 HTTP 密码。

_Request_
```
  DELETE /accounts/self/password.http HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

### Get OAuth Access Token

```
'GET /accounts/{account-id}/oauthtoken'
```

返回先前的 oauth-token 。

_Request_
```
  GET /accounts/self/oauthtoken HTTP/1.1
```

响应中，返回的 oauth-token 信息请参考本文的 OAuthTokenInfo]。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

   )]}'
    {
      "username": "johndow",
      "resource_host": "gerrit.example.org",
      "access_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOi",
      "provider_id": "oauth-plugin:oauth-provider",
      "expires_at": "922337203775807",
      "type": "bearer"
    }
```

如果 oauth-token 不存在或已过期，则返回 "`404 Not Found`"。请求获取其他用户的 oauth-token ，如果被拒绝，会返回 "`403 Forbidden`"。

### List Account Emails

```
'GET /accounts/{account-id}/emails'
```

查看用户配置的 email 。

_Request_
```
  GET /accounts/self/emails HTTP/1.0
```

响应返回的 email 信息，参考本文的 EmailInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "email": "john.doe@example.com",
      "preferred": true
    },
    {
      "email": "j.doe@example.com"
    }
  ]
```

### Get Account Email

```
'GET /accounts/{account-id}/emails/{email-id}'
```

查看用户的 email 

_Request_
```
  GET /accounts/self/emails/john.doe@example.com HTTP/1.0
```

响应返回的 email 信息，参考本文的 EmailInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "email": "john.doe@example.com",
    "preferred": true
  }
```

### Create Account Email

```
'PUT /accounts/{account-id}/emails/{email-id}'
```

为用户注册一个新的 email。会向要注册的 email 发送一个验证邮件，`DEVELOPMENT_BECOME_ANY_ACCOUNT` 认证模式下不进行发送。development 模式下，email 会直接添加，不需要确认。管理员添加的时候，如果设置了 `no_confirmation` 参数，那么不需要邮件进行验证操作。如果 gerrit.config 配置了 `sendemail.allowrcpt`，除非设置了 `no_confirmation`，否则需要邮件的验证。

请求的主体中，email 的信息请参考本文的 EmailInput。

_Request_
```
  PUT /accounts/self/emails/john.doe@example.com HTTP/1.0
  Content-Type: application/json; charset=UTF-8
  Content-Length: 3

  {}
```

响应所返回的 email 信息，请参考本文的 EmailInfo 。

_Response_
```
  HTTP/1.1 201 Created
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "email": "john.doe@example.com",
    "pending_confirmation": true
  }
```

### Delete Account Email

```
'DELETE /accounts/{account-id}/emails/{email-id}'
```

删除用户的 email 

_Request_
```
  DELETE /accounts/self/emails/john.doe@example.com HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

### Set Preferred Email

```
'PUT /accounts/{account-id}/emails/{email-id}/preferred'
```

为用户设置首选的 email 

_Request_
```
  PUT /accounts/self/emails/john.doe@example.com/preferred HTTP/1.0
```

_Response_
```
  HTTP/1.1 201 Created
```

如果 email 已经是首选，则返回 "`200 OK`" 。

### List SSH Keys

```
'GET /accounts/{account-id}/sshkeys'
```

查看用户的 SSH keys

_Request_
```
  GET /accounts/self/sshkeys HTTP/1.0
```

响应会返回 SSH keys 的信息，具体信息可参考本文的 SshKeyInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "seq": 1,
      "ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw== john.doe@example.com",
      "encoded_key": "AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw==",
      "algorithm": "ssh-rsa",
      "comment": "john.doe@example.com",
      "valid": true
    }
  ]
```

### Get SSH Key

```
'GET /accounts/{account-id}/sshkeys/{ssh-key-id}'
```

查看用户的 SSH keys

_Request_
```
  GET /accounts/self/sshkeys/1 HTTP/1.0
```

响应会返回 SSH keys 的信息，具体信息可参考本文的 SshKeyInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "seq": 1,
      "ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw== john.doe@example.com",
      "encoded_key": "AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw==",
    "algorithm": "ssh-rsa",
    "comment": "john.doe@example.com",
    "valid": true
  }
```

### Add SSH Key

```
'POST /accounts/{account-id}/sshkeys'
```

为用户添加 SSH key 

SSH public key 在请求的主体中，不能换行，换句话说，只能是一行。

添加一个已存在的 SSH key，会显示成功，但不会添加进去。

_Request_
```
  POST /accounts/self/sshkeys HTTP/1.0
  Content-Type: text/plain

  ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw== john.doe@example.com
```

响应返回的 SshKeyInfo 信息，具体可参考本文的 SshKeyInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "seq": 2,
    "ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw== john.doe@example.com",
    "encoded_key": "AAAAB3NzaC1yc2EAAAABIwAAAQEA0T...YImydZAw==",
    "algorithm": "ssh-rsa",
    "comment": "john.doe@example.com",
    "valid": true
  }
```

### Delete SSH Key

```
'DELETE /accounts/{account-id}/sshkeys/{ssh-key-id}'
```

删除用户的 SSH key 。

_Request_
```
  DELETE /accounts/self/sshkeys/2 HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

### List GPG Keys

```
'GET /accounts/{account-id}/gpgkeys'
```

获取用户的 GPG keys 

_Request_
```
  GET /accounts/self/gpgkeys HTTP/1.0
```

响应返回的 GpgKeyInfo ，可参考本文的 GpgKeyInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "AFC8A49B": {
      "fingerprint": "0192 723D 42D1 0C5B 32A6  E1E0 9350 9E4B AFC8 A49B",
      "user_ids": [
        "John Doe \u003cjohn.doe@example.com\u003e"
      ],
      "key": "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: BCPG v1.52\n\nmQENBFXUpNcBCACv4paCiyKxZ0EcKy8VaWVNkJlNebRBiyw9WxU85wPOq5Gz/3GT\nRQwKqeY0SxVdQT8VNBw2sBe2m6eqcfZ2iKmesSlbXMe15DA7k8Bg4zEpQ0tXNG1L\nhceZDVQ1Xk06T2sgkunaiPsXi82nwN3UWYtDXxX4is5e6xBNL48Jgz4lbqo6+8D5\nvsVYiYMx4AwRkJyt/oA3IZAtSlY8Yd445nY14VPcnsGRwGWTLyZv9gxKHRUppVhQ\nE3o6ePXKEVgmONnQ4CjqmkGwWZvjMF2EPtAxvQLAuFa8Hqtkq5cgfgVkv/Vrcln4\nnQZVoMm3a3f5ODii2tQzNh6+7LL1bpqAmVEtABEBAAG0H0pvaG4gRG9lIDxqb2hu\nLmRvZUBleGFtcGxlLmNvbT6JATgEEwECACIFAlXUpNcCGwMGCwkIBwMCBhUIAgkK\nCwQWAgMBAh4BAheAAAoJEJNQnkuvyKSbfjoH/2OcSQOu1kJ20ndjhgY2yNChm7gd\ntU7TEBbB0TsLeazkrrLtKvrpW5+CRe07ZAG9HOtp3DikwAyrhSxhlYgVsQDhgB8q\nG0tYiZtQ88YyYrncCQ4hwknrcWXVW9bK3V4ZauxzPv3ADSloyR9tMURw5iHCIeL5\nfIw/pLvA3RjPMx4Sfow/bqRCUELua39prGw5Tv8a2ZRFbj2sgP5j8lUFegyJPQ4z\ntJhe6zZvKOzvIyxHO8llLmdrImsXRL9eqroWGs0VYqe6baQpY6xpSjbYK0J5HYcg\nTO+/u80JI+ROTMHE6unGp5Pgh/xIz6Wd34E0lWL1eOyNfGiPLyRWn1d0",
      "status": "TRUSTED",
      "problems": [],
    },
  }
```

### Get GPG Key

```
'GET /accounts/{account-id}/gpgkeys/{gpg-key-id}'
```

获取用户的 GPG keys 

_Request_
```
  GET /accounts/self/gpgkeys/AFC8A49B HTTP/1.0
```

响应返回的 GpgKeyInfo ，可参考本文的 GpgKeyInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "id": "AFC8A49B",
    "fingerprint": "0192 723D 42D1 0C5B 32A6  E1E0 9350 9E4B AFC8 A49B",
    "user_ids": [
      "John Doe \u003cjohn.doe@example.com\u003e"
    ],
    "key": "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: BCPG v1.52\n\nmQENBFXUpNcBCACv4paCiyKxZ0EcKy8VaWVNkJlNebRBiyw9WxU85wPOq5Gz/3GT\nRQwKqeY0SxVdQT8VNBw2sBe2m6eqcfZ2iKmesSlbXMe15DA7k8Bg4zEpQ0tXNG1L\nhceZDVQ1Xk06T2sgkunaiPsXi82nwN3UWYtDXxX4is5e6xBNL48Jgz4lbqo6+8D5\nvsVYiYMx4AwRkJyt/oA3IZAtSlY8Yd445nY14VPcnsGRwGWTLyZv9gxKHRUppVhQ\nE3o6ePXKEVgmONnQ4CjqmkGwWZvjMF2EPtAxvQLAuFa8Hqtkq5cgfgVkv/Vrcln4\nnQZVoMm3a3f5ODii2tQzNh6+7LL1bpqAmVEtABEBAAG0H0pvaG4gRG9lIDxqb2hu\nLmRvZUBleGFtcGxlLmNvbT6JATgEEwECACIFAlXUpNcCGwMGCwkIBwMCBhUIAgkK\nCwQWAgMBAh4BAheAAAoJEJNQnkuvyKSbfjoH/2OcSQOu1kJ20ndjhgY2yNChm7gd\ntU7TEBbB0TsLeazkrrLtKvrpW5+CRe07ZAG9HOtp3DikwAyrhSxhlYgVsQDhgB8q\nG0tYiZtQ88YyYrncCQ4hwknrcWXVW9bK3V4ZauxzPv3ADSloyR9tMURw5iHCIeL5\nfIw/pLvA3RjPMx4Sfow/bqRCUELua39prGw5Tv8a2ZRFbj2sgP5j8lUFegyJPQ4z\ntJhe6zZvKOzvIyxHO8llLmdrImsXRL9eqroWGs0VYqe6baQpY6xpSjbYK0J5HYcg\nTO+/u80JI+ROTMHE6unGp5Pgh/xIz6Wd34E0lWL1eOyNfGiPLyRWn1d0",
    "status": "TRUSTED",
    "problems": [],
  }
```

### Add/Delete GPG Keys

```
'POST /accounts/{account-id}/gpgkeys'
```

为用户添加或删除 GPG keys

请求的主体信息请参考本文的 TGpgKeysInput。GPG key 需要按照 ASCII-armored 格式来提供，并且 self-signed 需要与用户的已注册 email 或其他的身份标识信息相匹配。

_Request_
```
  POST /accounts/{account-id}/gpgkeys
  Content-Type: application/json

  {
    "add": [
      "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: GnuPG v1\n\nmQENBFXUpNcBCACv4paCiyKxZ0EcKy8VaWVNkJlNebRBiyw9WxU85wPOq5Gz/3GT\nRQwKqeY0SxVdQT8VNBw2sBe2m6eqcfZ2iKmesSlbXMe15DA7k8Bg4zEpQ0tXNG1L\nhceZDVQ1Xk06T2sgkunaiPsXi82nwN3UWYtDXxX4is5e6xBNL48Jgz4lbqo6+8D5\nvsVYiYMx4AwRkJyt/oA3IZAtSlY8Yd445nY14VPcnsGRwGWTLyZv9gxKHRUppVhQ\nE3o6ePXKEVgmONnQ4CjqmkGwWZvjMF2EPtAxvQLAuFa8Hqtkq5cgfgVkv/Vrcln4\nnQZVoMm3a3f5ODii2tQzNh6+7LL1bpqAmVEtABEBAAG0H0pvaG4gRG9lIDxqb2hu\nLmRvZUBleGFtcGxlLmNvbT6JATgEEwECACIFAlXUpNcCGwMGCwkIBwMCBhUIAgkK\nCwQWAgMBAh4BAheAAAoJEJNQnkuvyKSbfjoH/2OcSQOu1kJ20ndjhgY2yNChm7gd\ntU7TEBbB0TsLeazkrrLtKvrpW5+CRe07ZAG9HOtp3DikwAyrhSxhlYgVsQDhgB8q\nG0tYiZtQ88YyYrncCQ4hwknrcWXVW9bK3V4ZauxzPv3ADSloyR9tMURw5iHCIeL5\nfIw/pLvA3RjPMx4Sfow/bqRCUELua39prGw5Tv8a2ZRFbj2sgP5j8lUFegyJPQ4z\ntJhe6zZvKOzvIyxHO8llLmdrImsXRL9eqroWGs0VYqe6baQpY6xpSjbYK0J5HYcg\nTO+/u80JI+ROTMHE6unGp5Pgh/xIz6Wd34E0lWL1eOyNfGiPLyRWn1d0yZO5AQ0E\nVdSk1wEIALUycrH2HK9zQYdR/KJo1yJJuaextLWsYYn881yDQo/p06U5vXOZ28lG\nAq/Xs96woVZPbgME6FyQzhf20Z2sbr+5bNo3OcEKaKX3Eo/sWwSJ7bXbGLDxMf4S\netfY1WDC+4rTqE30JuC++nQviPRdCcZf0AEgM6TxVhYEMVYwV787YO1IH62EBICM\nSkIONOfnusNZ4Skgjq9OzakOOpROZ4tki5cH/5oSDgdcaGPy1CFDpL9fG6er2zzk\nsw3qCbraqZrrlgpinWcAduiao67U/dV18O6OjYzrt33fTKZ0+bXhk1h1gloC21MQ\nya0CXlnfR/FOQhvuK0RlbR3cMfhZQscAEQEAAYkBHwQYAQIACQUCVdSk1wIbDAAK\nCRCTUJ5Lr8ikm8+QB/4uE+AlvFQFh9W8koPdfk7CJF7wdgZZ2NDtktvLL71WuMK8\nPOmf9f5JtcLCX4iJxGzcWogAR5ed20NgUoHUg7jn9Xm3fvP+kiqL6WqPhjazd89h\nk06v9hPE65kp4wb0fQqDrtWfP1lFGuh77rQgISt3Y4QutDl49vXS183JAfGPxFxx\n8FgGcfNwL2LVObvqCA0WLqeIrQVbniBPFGocE3yA/0W9BB/xtolpKfgMMsqGRMeu\n9oIsNxB2oE61OsqjUtGsnKQi8k5CZbhJaql4S89vwS+efK0R+mo+0N55b0XxRlCS\nfaURgAcjarQzJnG0hUps2GNO/+nM7UyyJAGfHlh5\n=EdXO\n-----END PGP PUBLIC KEY BLOCK-----\n"
    ],
    "delete": [
      "DEADBEEF",
    ]
  }'
```

响应返回的 GpgKeyInfo 信息，具体可参考本文的 GpgKeyInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "AFC8A49B": {
      "fingerprint": "0192 723D 42D1 0C5B 32A6  E1E0 9350 9E4B AFC8 A49B",
      "user_ids": [
        "John Doe \u003cjohn.doe@example.com\u003e"
      ],
      "key": "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: BCPG v1.52\n\nmQENBFXUpNcBCACv4paCiyKxZ0EcKy8VaWVNkJlNebRBiyw9WxU85wPOq5Gz/3GT\nRQwKqeY0SxVdQT8VNBw2sBe2m6eqcfZ2iKmesSlbXMe15DA7k8Bg4zEpQ0tXNG1L\nhceZDVQ1Xk06T2sgkunaiPsXi82nwN3UWYtDXxX4is5e6xBNL48Jgz4lbqo6+8D5\nvsVYiYMx4AwRkJyt/oA3IZAtSlY8Yd445nY14VPcnsGRwGWTLyZv9gxKHRUppVhQ\nE3o6ePXKEVgmONnQ4CjqmkGwWZvjMF2EPtAxvQLAuFa8Hqtkq5cgfgVkv/Vrcln4\nnQZVoMm3a3f5ODii2tQzNh6+7LL1bpqAmVEtABEBAAG0H0pvaG4gRG9lIDxqb2hu\nLmRvZUBleGFtcGxlLmNvbT6JATgEEwECACIFAlXUpNcCGwMGCwkIBwMCBhUIAgkK\nCwQWAgMBAh4BAheAAAoJEJNQnkuvyKSbfjoH/2OcSQOu1kJ20ndjhgY2yNChm7gd\ntU7TEBbB0TsLeazkrrLtKvrpW5+CRe07ZAG9HOtp3DikwAyrhSxhlYgVsQDhgB8q\nG0tYiZtQ88YyYrncCQ4hwknrcWXVW9bK3V4ZauxzPv3ADSloyR9tMURw5iHCIeL5\nfIw/pLvA3RjPMx4Sfow/bqRCUELua39prGw5Tv8a2ZRFbj2sgP5j8lUFegyJPQ4z\ntJhe6zZvKOzvIyxHO8llLmdrImsXRL9eqroWGs0VYqe6baQpY6xpSjbYK0J5HYcg\nTO+/u80JI+ROTMHE6unGp5Pgh/xIz6Wd34E0lWL1eOyNfGiPLyRWn1d0"
      "status": "TRUSTED",
      "problems": [],
    }
    "DEADBEEF": {}
  }
```

### Delete GPG Key

```
'DELETE /accounts/{account-id}/gpgkeys/{gpg-key-id}'
```

删除用户的 GPG key 

_Request_
```
  DELETE /accounts/self/gpgkeys/AFC8A49B HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

### List Account Capabilities

```
'GET /accounts/{account-id}/capabilities'
```

查看用户的全局权限。

如果 account-id 参数配置的是 `self`，那么将返回当前用户的全局权限情况。

_Request_
```
  GET /accounts/self/capabilities HTTP/1.0
```

响应所返回的全局权限信息，具体可参考本文的 CapabilityInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "queryLimit": {
      "min": 0,
      "max": 500
    },
    "emailReviewers": true
  }
```

管理员使用 `basic authentication` 进行认证:

_Request_
```
  GET /a/accounts/self/capabilities HTTP/1.0
  Authorization: Basic ABCDECF..
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "administrateServer": true,
    "queryLimit": {
      "min": 0,
      "max": 500
    },
    "createAccount": true,
    "createGroup": true,
    "createProject": true,
    "emailReviewers": true,
    "killTask": true,
    "viewCaches": true,
    "flushCaches": true,
    "viewConnections": true,
    "viewPlugins": true,
    "viewQueue": true,
    "runGC": true
  }
```

_Get your own capabilities_
```
**get**/accounts/self/capabilities
```

可以使用参数 `q` 进行过滤，并且结果以降序方式排列。

_Request_
```
  GET /a/accounts/self/capabilities?q=createAccount&q=createGroup HTTP/1.0
  Authorization: Basic ABCDEF...
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "createAccount": true,
    "createGroup": true
  }
```

_Check if you can create groups_
```
**get**/accounts/self/capabilities?q=createGroup
```

### Check Account Capability

```
'GET /accounts/{account-id}/capabilities/{capability-id}'
```

查看用户是否有全局权限。

_Request_
```
  GET /a/accounts/self/capabilities/createGroup HTTP/1.0
```

如果用户有全局权限，则返回 `ok` 。

_Response_
```
  HTTP/1.1 200 OK

  ok
```

如果用户没有全局权限，则返回 "`404 Not Found`" 。

_Check if you can create groups_
```
**get**/accounts/self/capabilities/createGroup
```

### List Groups

```
'GET /accounts/{account-id}/groups/'
```

列出用户在哪些群组中。

_Request_
```
  GET /a/accounts/self/groups/ HTTP/1.0
```

结果的列表信息可以参考本文的 GroupInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "id": "global%3AAnonymous-Users",
      "url": "#/admin/groups/uuid-global%3AAnonymous-Users",
      "options": {
      },
      "description": "Any user, signed-in or not",
      "group_id": 2,
      "owner_id": "6a1e70e1a88782771a91808c8af9bbb7a9871389"
    },
    {
      "id": "834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7",
      "url": "#/admin/groups/uuid-834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7",
      "options": {
        "visible_to_all": true,
      },
      "group_id": 6,
      "owner_id": "834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7"
    },
    {
      "id": "global%3ARegistered-Users",
      "url": "#/admin/groups/uuid-global%3ARegistered-Users",
      "options": {
      },
      "description": "Any signed-in user",
      "group_id": 3,
      "owner_id": "6a1e70e1a88782771a91808c8af9bbb7a9871389"
    }
  ]
```

_List all groups that contain you as a member_
```
**get**/accounts/self/groups/
```

### Get Avatar

```
'GET /accounts/{account-id}/avatar'
```

获取用户的头像信息。

`size`（`s`）参数用来显示首选的头像的像素大小。

_Request_
```
  GET /a/accounts/john.doe@example.com/avatar?s=20 HTTP/1.0
```

响应会显示头像的 URL 信息。

_Response_
```
  HTTP/1.1 302 Found
  Location: https://profiles/avatar/john_doe.jpeg?s=20x20
```

### Get Avatar Change URL

```
'GET /accounts/{account-id}/avatar.change.url'
```

获取用户修改头像的 URL 。

_Request_
```
  GET /a/accounts/self/avatar.change.url HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: text/plain; charset=UTF-8

  https://profiles/pictures/john.doe
```

### Get User Preferences

```
'GET /accounts/{account-id}/preferences'
```

查看用户的 preferences

_Request_
```
  GET /a/accounts/self/preferences HTTP/1.0
```

返回的 preferences 信息，具体可参考本文的 [PreferencesInfo 

如果用户有管理员权限或 ModifyAccount 权限，那么可以查看其他用户的 preferences ；否则，只能查看自己的 preferences 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "changes_per_page": 25,
    "theme": "LIGHT",
    "date_format": "STD",
    "time_format": "HHMM_12",
    "diff_view": "SIDE_BY_SIDE",
    "size_bar_in_change_table": true,
    "mute_common_path_prefixes": true,
    "publish_comments_on_push": true,
    "work_in_progress_by_default": true,
    "default_base_for_merges": "FIRST_PARENT",
    "my": [
      {
        "url": "#/dashboard/self",
        "name": "Changes"
      },
      {
        "url": "#/q/has:draft",
        "name": "Draft Comments"
      },
      {
        "url": "#/q/is:watched+is:open",
        "name": "Watched Changes"
      },
      {
        "url": "#/q/is:starred",
        "name": "Starred Changes"
      },
      {
        "url": "#/groups/self",
        "name": "Groups"
      },
      change_table: []
    ]
  }
```

### Set User Preferences

```
'PUT /accounts/{account-id}/preferences'
```

设置用户的 preferences

请求主体中的 preferences 格式，具体可参考本文的 PreferencesInput 。

_Request_
```
  PUT /a/accounts/self/preferences HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "changes_per_page": 50,
    "theme": "DARK",
    "expand_inline_diffs": true,
    "date_format": "STD",
    "time_format": "HHMM_12",
    "size_bar_in_change_table": true,
    "diff_view": "SIDE_BY_SIDE",
    "mute_common_path_prefixes": true,
    "my": [
      {
        "url": "#/dashboard/self",
        "name": "Changes"
      },
      {
        "url": "#/q/has:draft",
        "name": "Draft Comments"
      },
      {
        "url": "#/q/is:watched+is:open",
        "name": "Watched Changes"
      },
      {
        "url": "#/q/is:starred",
        "name": "Starred Changes"
      },
      {
        "url": "#/groups/self",
        "name": "Groups"
      }
    ],
    "change_table": [
      "Subject",
      "Owner"
    ]
  }
```

响应所返回的 preferences ，具体可参考本文的 PreferencesInput 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "changes_per_page": 50,
    "theme": "DARK",
    "expand_inline_diffs": true,
    "date_format": "STD",
    "time_format": "HHMM_12",
    "size_bar_in_change_table": true,
    "diff_view": "SIDE_BY_SIDE",
    "publish_comments_on_push": true,
    "work_in_progress_by_default": true,
    "mute_common_path_prefixes": true,
    "my": [
      {
        "url": "#/dashboard/self",
        "name": "Changes"
      },
      {
        "url": "#/q/has:draft",
        "name": "Draft Comments"
      },
      {
        "url": "#/q/is:watched+is:open",
        "name": "Watched Changes"
      },
      {
        "url": "#/q/is:starred",
        "name": "Starred Changes"
      },
      {
        "url": "#/groups/self",
        "name": "Groups"
      }
    ],
    "change_table": [
      "Subject",
      "Owner"
    ]
  }
```

### Get Diff Preferences

```
'GET /accounts/{account-id}/preferences.diff'
```

显示用户的 preferences 的 diff 信息

_Request_
```
  GET /a/accounts/self/preferences.diff HTTP/1.0
```

返回的 preferences 的 diff 信息，具体可参考本文的 DiffPreferencesInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "context": 10,
    "ignore_whitespace": "IGNORE_ALL",
    "intraline_difference": true,
    "line_length": 100,
    "cursor_blink_rate": 500,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "tab_size": 8,
    "font_size": 12
  }
```

### Set Diff Preferences

```
'PUT /accounts/{account-id}/preferences.diff'
```

设置用户的 preferences 的 diff 信息

请求主体中的 preferences 的 diff 格式，具体可参考本文的 DiffPreferencesInput 。

_Request_
```
  PUT /a/accounts/self/preferences.diff HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "context": 10,
    "ignore_whitespace": "IGNORE_ALL",
    "intraline_difference": true,
    "line_length": 100,
    "cursor_blink_rate": 500,
    "show_line_endings": true,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "tab_size": 8,
    "font_size": 12
  }
```

返回的 preferences 的 diff 信息，具体可参考本文的 DiffPreferencesInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "context": 10,
    "ignore_whitespace": "IGNORE_ALL",
    "intraline_difference": true,
    "line_length": 100,
    "show_line_endings": true,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "tab_size": 8,
    "font_size": 12
  }
```

### Get Edit Preferences

```
'GET /accounts/{account-id}/preferences.edit'
```

显示用户的 preferences 的 edit 信息

_Request_
```
  GET /a/accounts/self/preferences.edit HTTP/1.0
```

返回的 preferences 的 edit 信息，具体可参考本文的 EditPreferencesInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json;charset=UTF-8

  )]}'
  {
    "tab_size": 4,
    "line_length": 80,
    "indent_unit": 2,
    "cursor_blink_rate": 530,
    "hide_top_menu": true,
    "show_whitespace_errors": true,
    "hide_line_numbers": true,
    "match_brackets": true,
    "line_wrapping": false,
    "indent_with_tabs": false,
    "auto_close_brackets": true
  }
```

### Set Edit Preferences

```
'PUT /accounts/{account-id}/preferences.edit'
```

设置用户的 preferences 的 edit 信息

请求主体中的 preferences 的 edit 格式，具体可参考本文的 EditPreferencesInfo 。

_Request_
```
  PUT /a/accounts/self/preferences.edit HTTP/1.0
  Content-Type: application/json;charset=UTF-8

  {
    "tab_size": 4,
    "line_length": 80,
    "indent_unit": 2,
    "cursor_blink_rate": 530,
    "hide_top_menu": true,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "hide_line_numbers": true,
    "match_brackets": true,
    "line_wrapping": false,
    "auto_close_brackets": true
  }
```

返回的 preferences 的 edit 信息，具体可参考本文的 EditPreferencesInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json;charset=UTF-8

  )]}'
  {
    "tab_size": 4,
    "line_length": 80,
    "cursor_blink_rate": 530,
    "hide_top_menu": true,
    "show_whitespace_errors": true,
    "hide_line_numbers": true,
    "match_brackets": true,
    "auto_close_brackets": true
  }
```

### Get Watched Projects

```
'GET /accounts/{account-id}/watched.projects'
```

查看用户所关注的 project

_Request_
```
  GET /a/accounts/self/watched.projects HTTP/1.0
```

返回关注的 project 列表，具体的信息可参考 ProjectWatchInfo 。project 按名称升序排列。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "project": "Test Project 1",
      "notify_new_changes": true,
      "notify_new_patch_sets": true,
      "notify_all_comments": true,
    },
    {
      "project": "Test Project 2",
      "filter": "branch:experimental",
      "notify_all_comments": true,
      "notify_submitted_changes": true,
      "notify_abandoned_changes": true
    }
  ]
```

### Add/Update a List of Watched Project Entities

```
'POST /accounts/{account-id}/watched.projects'
```

更新已关注的 project。请求的主体信息请参考本文的 ProjectWatchInfo 。

_Request_
```
  POST /a/accounts/self/watched.projects HTTP/1.0
  Content-Type: application/json;charset=UTF-8

  [
    {
      "project": "Test Project 1",
      "notify_new_changes": true,
      "notify_new_patch_sets": true,
      "notify_all_comments": true,
    }
  ]
```

响应返回的关注的 project 信息，请参考本文的 ProjectWatchInfo ，project 按名称升序排列。A

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "project": "Test Project 1",
      "notify_new_changes": true,
      "notify_new_patch_sets": true,
      "notify_all_comments": true,
    },
    {
      "project": "Test Project 2",
      "notify_new_changes": true,
      "notify_new_patch_sets": true,
      "notify_all_comments": true,
    }
  ]
```

### Delete Watched Projects

```
'POST /accounts/{account-id}/watched.projects:delete'
```

删除已关注的 project。请求的主体，请关注本文的 ProjectWatchInfo 。

_Request_
```
  POST /a/accounts/self/watched.projects:delete HTTP/1.0
  Content-Type: application/json;charset=UTF-8

  [
    {
      "project": "Test Project 1",
      "filter": "branch:master"
    }
  ]
```

_Response_
```
  HTTP/1.1 204 No Content
```

### Get Account External IDs

```
'GET /accounts/{account-id}/external.ids'
```

获取账户的 external 的 ids 。

_Request_
```
  GET /a/accounts/self/external.ids HTTP/1.0
```

响应主体的 ids ，具体信息请参考本文的 AccountExternalIdInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "identity": "username:john",
      "email": "john.doe@example.com",
      "trusted": true
    }
  ]
```

### Delete Account External IDs

```
'POST /accounts/{account-id}/external.ids:delete'
```

删除用户的 external 的 ids 相关信息。请求的主体中，需要以列表的形式体现 ids 的信息。

只能删除当前用户自己的 ids 。

_Request_
```
  POST /a/accounts/self/external.ids:delete HTTP/1.0
  Content-Type: application/json;charset=UTF-8

  [
    "mailto:john.doe@example.com"
  ]
```

_Response_
```
  HTTP/1.1 204 No Content
```

### List Contributor Agreements

```
'GET /accounts/{account-id}/agreements'
```

获取用户签署的贡献者声明。

_Request_
```
  GET /a/accounts/self/agreements HTTP/1.0
```

响应的主体会返回用户已签署的贡献者声明，具体信息可以参考本文的 ContributorAgreementInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "name": "Individual",
      "description": "If you are going to be contributing code on your own, this is the one you want. You can sign this one online.",
      "url": "static/cla_individual.html"
    }
  ]
```

### Delete Draft Comments

```
'POST /accounts/{account-id}/drafts:delete'
```

删除用户的 draft-comment 。请求中的 draft-comment 信息请参考本文的 DeleteDraftCommentsInput 。空的输入会删除所有 draft-comment 。 

只能删除当前用户自己的 draft-comment 。

_Request_
```
  POST /accounts/self/drafts.delete HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "query": "is:abandoned"
  }
```

响应返回主体的 draft-comment 信息，具体可参考本文的 DeletedDraftCommentInfo 。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

   )]}'
   [
     {
       "change": {
         "id": "myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940",
         "project": "myProject",
         "branch": "master",
         "change_id": "I8473b95934b5732ac55d26311a706c9c2bde9940",
         "subject": "Implementing Feature X",
         "status": "ABANDONED",
         "created": "2013-02-01 09:59:32.126000000",
         "updated": "2013-02-21 11:16:36.775000000",
         "insertions": 34,
         "deletions": 101,
         "_number": 3965,
         "owner": {
           "name": "John Doe"
         }
       },
       "deleted": [
         {
           "id": "TvcXrmjM",
           "path": "gerrit-server/src/main/java/com/google/gerrit/server/project/RefControl.java",
           "line": 23,
           "message": "[nit] trailing whitespace",
           "updated": "2013-02-26 15:40:43.986000000"
         }
       ]
     }
   ]
```

### Sign Contributor Agreement

```
'PUT /accounts/{account-id}/agreements'
```

签署贡献者声明。

请求主体的贡献者声明，请参考本文的 ContributorAgreementInput 。

_Request_
```
  PUT /accounts/self/agreements HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "name": "Individual"
  }
```

响应的主体会返回贡献者声明的名称。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  "Individual"
```

### Index Account

```
'POST /accounts/{account-id}/index'
```

secondary-index 中添加或更新帐号信息。

_Request_
```
  POST /accounts/1000096/index HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

## Default Star Endpoints

### Get Changes With Default Star

```
'GET /accounts/{account-id}/starred.changes'
```

获取用户关注的 change 。返回的信息请参考本文的 ChangeInfo 。

_Request_
```
  GET /a/accounts/self/starred.changes
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "id": "myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940",
      "project": "myProject",
      "branch": "master",
      "change_id": "I8473b95934b5732ac55d26311a706c9c2bde9940",
      "subject": "Implementing Feature X",
      "status": "NEW",
      "created": "2013-02-01 09:59:32.126000000",
      "updated": "2013-02-21 11:16:36.775000000",
      "starred": true,
      "stars": [
        "star"
      ],
      "mergeable": true,
      "submittable": false,
      "insertions": 145,
      "deletions": 12,
      "_number": 3965,
      "owner": {
        "name": "John Doe"
      }
    }
  ]
```

### Put Default Star On Change

```
'PUT /accounts/{account-id}/starred.changes/{change-id}'
```

用户关注 change。change 被关注后，会返回 `is:starred` 或 `starredby:USER` 相关的搜索结果。

_Request_
```
  PUT /a/accounts/self/starred.changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940 HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

### Remove Default Star From Change

```
'DELETE /accounts/{account-id}/starred.changes/{change-id}'
```

移除关注的 change 。

_Request_
```
  DELETE /a/accounts/self/starred.changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940 HTTP/1.0
```

_Response_
```
  HTTP/1.1 204 No Content
```

## Star Endpoints

### Get Starred Changes

```
'GET /accounts/{account-id}/stars.changes'
```

获取用户关注的 change 。与 change 的搜索 `GET /changes/?q=has:stars` 相同。响应返回的结果信息请参考 [ChangeInfo](rest-api-changes.md) 的 ChangeInfo 。

_Request_
```
  GET /a/accounts/self/stars.changes
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "id": "myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940",
      "project": "myProject",
      "branch": "master",
      "change_id": "I8473b95934b5732ac55d26311a706c9c2bde9940",
      "subject": "Implementing Feature X",
      "status": "NEW",
      "created": "2013-02-01 09:59:32.126000000",
      "updated": "2013-02-21 11:16:36.775000000",
      "stars": [
        "ignore",
        "risky"
      ],
      "mergeable": true,
      "submittable": false,
      "insertions": 145,
      "deletions": 12,
      "_number": 3965,
      "owner": {
        "name": "John Doe"
      }
    }
  ]
```

### Get Star Labels From Change

```
'GET /accounts/{account-id}/stars.changes/{change-id}'
```

获取 change 的星标。

_Request_
```
  GET /a/accounts/self/stars.changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940 HTTP/1.0
```

响应的主体，返回 change 上的星标。结果按首字母排序。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    "blue",
    "green",
    "red"
  ]
```

### Update Star Labels On Change

```
'POST /accounts/{account-id}/stars.changes/{change-id}'
```

更新 change 的星标。请求的主体中要指出添加或删除的星标，具体可以参考本文的 StarsInput。`has:stars` 会返回关注的 change 。

_Request_
```
  POST /a/accounts/self/stars.changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940 HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "add": [
      "blue",
      "red"
    ],
    "remove": [
      "yellow"
    ]
  }
```

响应的主体，返回 change 应用的星标。结果按首字母排序。

_Response_
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    "blue",
    "green",
    "red"
  ]
```

## IDs

### {account-id}

帐号唯一的标识。

如下:

* `self` 或 `me` 用户当前用户
* `account ID` ("18419")
* account ID 与 full-name 的组合 ("Full Name (18419)")
* full-name 与 email 的组合 "Full Name <email@example.com>"
* email ("email@example")
* full-name ("Full Name")
* username ("username")

所有情况下，不考虑当前用户不可见的用户。

所有情况下，`account ID` ，`self`/`me`, inactive 的账户不考虑。 inactive 的账户只能通过 `account ID` 进行关联。

如果输入的是 `account ID`，若系统中有这个帐号，那么会被识别为用户的帐号。（如果用户名恰好是数字 ID，那么此用户名不能被识别）。

如果标识符是无效的或者关联的是 inactive 帐号，那么返回报错信息中尽量避免歧义。

### {capability-id}
全局设置的实例。参考本文的 CapabilityInfo 。

### {email-id}
用户首选的 email

### {username}
username.

### {ssh-key-id}
SSH key 的序列号

### {gpg-key-id}
GPG key 标识。, `gpg --list-keys` 产生的 8 个 16进制字符，或 `gpg --list-keys --with-fingerprint` 产生的 40 个 16进制字符（忽略空格）。

## JSON Entities

### AccountDetailInfo

`AccountDetailInfo` ，账户的详细信息。

`AccountDetailInfo` 比 `AccountInfo` 多了一些字段，如下：

|Field Name          ||Description
| :------| :------| :------|
|`registered_on`     ||帐号注册的时间

### AccountExternalIdInfo

`AccountExternalIdInfo` ，账户的 external-id 相关信息。

|Field Name        ||Description
| :------| :------| :------|
|`identity`        ||账户的 external-id
|`email`           |可选|external-id 的 email
|`trusted`         |如果不显示，则为 `false`|external-id 是否可信
|`can_delete`      |如果不显示，则为 `false`|external-id 是否可删除

### AccountInfo

`AccountInfo` ，账户的基本信息

|Field Name        ||Description
| :------| :------| :------|
|`_account_id`     ||账户的数字 ID
|`name`            |可选|用户的 full-name。显示详细信息的时候，会显示此字段。
|`email`           |可选|用户首先的 email。显示详细信息的时候，会显示此字段。
|`secondary_emails`|可选|备用的 email。搜索时，使用 `ALL_EMAILS` 或 `suggest` 参数时，会显示此字段。
|`username`        |可选|用户的 username。显示详细信息的时候，会显示此字段。
|`avatars`         |可选|avatars 相关信息
|`_more_accounts`  |可选, 如果不显示，则为 `false`|由于搜索结果受限，标识还有未显示的搜索结果。只在最后一个帐号的后面显示。
|`status`          |可选|帐号的状态信息
|`inactive`        |如果不显示，则为 `false`|无论账户是否为 inactive
|`tags`            |可选, 如果不设置则为空|列出账户添加的 tag。参考[DETAILED_ACCOUNTS](rest-api-changes.md)

### AccountInput

`AccountInput` ，新建账户时，需要输入的信息。

|Field Name     ||Description
| :------| :------| :------|
|`username`     |可选|用户的 username。如果提供，需要与 API 的 URL 中的 username 一致。
|`name`         |可选|用户的 full-name。
|`display_name` |可选|用户的 display name
|`email`        |可选|用户的 email
|`ssh_key`      |可选|用户的 public SSH key
|`http_password`|可选|用户的 HTTP password
|`groups`       |可选|用户要加入的群组。需要明确具体的 `group ID`，可参考 [group IDs](rest-api-groups.md) 章节。

### AccountNameInput

`AccountNameInput` ，为用户设置名称

|Field Name ||Description
| :------| :------| :------|
|`name`     |可选|用户的 full-name。如果 full-name 未设置或设置为空，那么此字段处于被删除状态。

### AccountStatusInput

The `AccountStatusInput` ，设置用户状态。

|Field Name ||Description
| :------| :------| :------|
|`status`   |optional|用户新的状态。如果状态未设置或设置为空，那么此字段处于被删除状态。

### AvatarInfo
`AccountInfo` 描述了帐号 avatar 图片的信息。

|Field Name|Description
| :------| :------|
|`url`     |avatar 图片的 URL
|`height`  |avatar 图片的高度（单位为pixels）
|`width`   |avatar 图片的宽度（单位为pixels）

### CapabilityInfo

`CapabilityInfo` ，用户拥有全局设置权限的明细。

|Field Name          ||Description
| :------| :------| :------|
|`accessDatabase`    |如果不显示，则为 `false`|是否拥有 `Access Database` 权限
|`administrateServer`|如果不显示，则为 `false`|是否拥有 `Administrate Server` 权限
|`createAccount`     |如果不显示，则为 `false`|是否拥有 `Create Account` 权限
|`createGroup`       |如果不显示，则为 `false`|是否拥有 `Create Group` 权限
|`createProject`     |如果不显示，则为 `false`|是否拥有 `Create Project` 权限
|`emailReviewers`    |如果不显示，则为 `false`|是否拥有 `Email Reviewers` 权限
|`flushCaches`       |如果不显示，则为 `false`|是否拥有 `Flush Caches` 权限
|`killTask`          |如果不显示，则为 `false`|是否拥有 `[Kill Task` 权限
|`maintainServer`    |如果不显示，则为 `false`|是否拥有 `MaintainServer` 权限
|`priority`          |如果是 `INTERACTIVE`，那么不显示|用户使用的线程池，请参考 `Priority` 权限说明。
|`queryLimit`        ||返回搜索结果的上限
|`runAs`             |如果不显示，则为 `false`|是否拥有 `Run As` 权限
|`runGC`             |如果不显示，则为 `false`|是否拥有 `Run Garbage Collection` 权限
|`streamEvents`      |如果不显示，则为 `false`|是否拥有 `Stream Events` 权限
|`viewAllAccounts`   |如果不显示，则为 `false`|是否拥有 `View All Accounts` 权限
|`viewCaches`        |如果不显示，则为 `false`|是否拥有 `View Caches` 权限
|`viewConnections`   |如果不显示，则为 `false`|是否拥有 `View Connections` 权限
|`viewPlugins`       |如果不显示，则为 `false`|是否拥有 `View Plugins` 权限
|`viewQueue`         |如果不显示，则为 `false`|是否拥有 `View Queue` 权限

### ContributorAgreementInfo

`ContributorAgreementInfo` ，贡献者声明相关信息。

|Field Name                 | |Description
| :------| :------| :------|
|`name`                     | |声明的名称
|`description`              | |声明的描述
|`url`                      | |声明的 URL
|`auto_verify_group`|可选|群组中的用户登录后可以在线签署贡献者声明，如果不设置，则不能进行在线签署。

### ContributorAgreementInput

`ContributorAgreementInput` ，新的贡献者声明信息

|Field Name                 |Description
| :------| :------|
|`name`                     |声明的名称

### DeleteDraftCommentsInput

`DeleteDraftCommentsInput` ，待被删除的 draft-comment 

|Field Name                 ||Description
| :------| :------| :------|
|`query`                    |可选|[changes 搜索](user-search.md) 的条件。如果不显示，意味着匹配所有的 dratfs 状态的 change。

### DeletedDraftCommentInfo

`DeletedDraftCommentInfo` ，已被删除的 draft-comment 

|Field Name                 |Description
| :------| :------|
|`change`                   |被删除 comment 的 change
|`deleted`                  |删除的 comment

### DiffPreferencesInfo

`DiffPreferencesInfo` ，用户 `preferences` 的 `diff` 信息。

|Field Name                    ||Description
| :------| :------| :------|
|`context`                     ||patch 的差异处显示上下文的行数
|`expand_all_comments`         |如果不显示，则为 `false`|是否自动显示 inline-comments。
|`ignore_whitespace`           ||change 是否忽略空白。此处的有效值为：`IGNORE_NONE`, `IGNORE_TRAILING`,`IGNORE_LEADING_AND_TRAILING`, `IGNORE_ALL`。
|`intraline_difference`        |如果不显示，则为 `false`|intraline differences 是否高亮
|`line_length`                 ||每行的字符数量
|`cursor_blink_rate`           ||光标闪烁的频率，`0` 为不闪烁。
|`manual_review`               |如果不显示，则为 `false`|对于 patch 中的评审文件，阅读后不自动添加 'Reviewed' 的标识。
|`retain_header`               |如果不显示，则为 `false`|是否在 patch 上方显示 patch-set 号，用于在 patch-set 之间进行切换。
|`show_line_endings`           |如果不显示，则为 `false`|Windows 文件的行尾是否显示 “有虚线框的 '\r'”。
|`show_tabs`                   |如果不显示，则为 `false`|是否显示 tabs。
|`show_whitespace_errors`      |如果不显示，则为 `false`|是否忽略空白错误。
|`skip_deleted`                |如果不显示，则为 `false`|是否忽略删除的文件。
|`skip_uncommented`            |如果不显示，则为 `false`|是否忽略未添加 comment 的文件。
|`syntax_highlighting`         |如果不显示，则为 `false`|是否启用语法高亮。
|`hide_top_menu`               |如果不显示，则为 `false`|如果是 true ，则隐藏顶层菜单的头部和网站的头部。
|`auto_hide_diff_table_header` |如果不显示，则为 `false`|如果是 true ，当垂直滚动条超过半个页面时，自动隐藏 diff 表格的头部。
|`hide_line_numbers`           |如果不显示，则为 `false`|如果是 true ，则隐藏行号
|`tab_size`                    ||一个 tab 显示空格的数量。
|`font_size`                   ||diff 页面字体的大小
|`hide_empty_pane`             |如果不显示，则为 `false`|是否隐藏空白的窗格。添加行时，左边的窗格为空；删除行时，右边的窗格为空。
|`match_brackets`              |如果不显示，则为 `false`|是否高亮显示匹配的括号
|`line_wrapping`               |如果不显示，则为 `false`|是否启用换行

### DiffPreferencesInput

`DiffPreferencesInput` ，设置用户 `preferences` 的 `diff` 信息。如果字段内容为空，则不能更新。

|Field Name                    ||Description
| :------| :------| :------|
|`context`                     |optional|patch 的差异处显示上下文的行数
|`expand_all_comments`         |optional|是否自动显示 inline-comments。
|`ignore_whitespace`           |optional|change 是否忽略空白。此处的有效值为：`IGNORE_NONE`, `IGNORE_TRAILING`,`IGNORE_LEADING_AND_TRAILING`, `IGNORE_ALL`。
|`intraline_difference`        |optional|intraline differences 是否高亮
|`line_length`                 |optional|每行的字符数量
|`manual_review`               |optional|对于 patch 中的评审文件，阅读后不自动添加 'Reviewed' 的标识。
|`retain_header`               |optional|是否在 patch 上方显示 patch-set 号，用于在 patch-set 之间进行切换。
|`show_line_endings`           |optional|Windows 文件的行尾是否显示 “有虚线框的 '\r'”。
|`show_tabs`                   |optional|是否显示 tabs。
|`show_whitespace_errors`      |optional|是否忽略空白错误。
|`skip_deleted`                |optional|是否忽略删除的文件。
|`skip_uncommented`            |optional|是否忽略未添加 comment 的文件。
|`syntax_highlighting`         |optional|是否启用语法高亮。
|`hide_top_menu`               |optional|如果是 true ，则隐藏顶层菜单的头部和网站的头部。
|`auto_hide_diff_table_header` |optional|如果是 true ，当垂直滚动条超过半个页面时，自动隐藏 diff 表格的头部。
|`hide_line_numbers`           |optional|如果是 true ，则隐藏行号
|`tab_size`                    |optional|一个 tab 显示空格的数量。
|`font_size`                   |optional|diff 页面字体的大小
|`line_wrapping`               |optional|是否启用换行
|`indent_with_tabs`            |optional|是否启用 tab 缩进。

### EditPreferencesInfo

`EditPreferencesInfo` ，编辑用户的 preferences 相关信息。

|Field Name                    ||Description
| :------| :------| :------|
|`tab_size`                    ||一个 tab 对应空格的数量
|`line_length`                 ||每行显示的字符数量
|`indent_unit`                 ||自动缩进的时候，使用空格的数量
|`cursor_blink_rate`           ||光标闪烁的频率，`0` 为不闪烁。
|`hide_top_menu`               |如果不显示，则为 `false`|如果是 true ，则隐藏顶层菜单的头部和网站的头部。
|`show_tabs`                   |如果不显示，则为 `false`|是否显示 tabs。
|`show_whitespace_errors`      |如果不显示，则为 `false`|是否忽略空白错误。
|`syntax_highlighting`         |如果不显示，则为 `false`|是否启用语法高亮。
|`hide_line_numbers`           |如果不显示，则为 `false`|是否隐藏行号
|`match_brackets`              |如果不显示，则为 `false`|是否高亮显示匹配的括号
|`line_wrapping`               |如果不显示，则为 `false`|是否启用换行
|`indent_with_tabs`            |如果不显示，则为 `false`|是否启用 tab 缩进。
|`auto_close_brackets`         |如果不显示，则为 `false`|输入时，是否自动关闭括号和引号
|`show_base`                   |如果不显示，则为 `false`|在线编辑的时候，是否显示基础版本

### EmailInfo

`EmailInfo` ，用户的 email 信息

|Field Name ||Description
| :------| :------| :------|
|`email`    ||email 地址
|`preferred`|如果不显示，则为 `false`|email 是否为用户的首选的 email
|`pending_confirmation`|如果不显示，则为 `false`|如果是待验证的 email，则显示 `True` 

### EmailInput

The `EmailInput` ，新的 email 信息

|Field Name       ||Description
| :------| :------| :------|
|`email`          ||email 地址。如果提供 email 地址，需要与 API 的 URL 中的 email 一致。
|`preferred`      |如果不显示，则为 `false`|是否将新 email 设置成首选 email。此参数需要在设置了 `no_confirmation` 或认证方式为 `DEVELOPMENT_BECOME_ANY_ACCOUNT` 的时候才可以使用。
|`no_confirmation`|如果不显示，则为 `false`|对新邮箱不做验证。只有管理员允许使用此参数。

### GpgKeyInfo

The `GpgKeyInfo` ，GPG public key 的相关信息

|Field Name   ||Description
| :------| :------| :------|
|`id`         |map 中不显示|8 个 16 进制的字符。
|`fingerprint`|删除的 keys 不显示|40 个 16 进制的字符。
|`user_ids`   |删除的 keys 不显示|与 [OpenPGP User IDs](https://tools.ietf.org/html/rfc4880#section-5.11) 相关联的 public key。
|`key`        |删除的 keys 不显示|ASCII armored 格式的 key。
|`status`     |删除的 keys 不显示|服务器端检查 key 的结果，如 `BAD`, `OK`,`TRUSTED`。`BAD`，有严重问题，不能使用；`OK`，无问题，但系统并不信任其来源；`TRUSTED`，无问题，系统信任其来源。
|`problems`   |删除的 keys 不显示|检查 key 是否有效以及是否信任其来源。

### GpgKeysInput

`GpgKeysInput` ，添加或删除 GPG keys

|Field Name|Description
| :------| :------|
|`add`     |待添加的 ASCII armored 格式的 public key
|`delete`  |待删除 key 的 `{gpg-key-id}` 

### HttpPasswordInput

`HttpPasswordInput` ，用于设置 HTTP password 。

|Field Name     ||Description
| :------| :------| :------|
|`generate`     |如果不显示，则为 `false`|是否需要生成新的 HTTP password
|`http_password`|可选|新的 HTTP password。只有管理员在设置新 HTTP password 时会显示。如果此字段为空或者不设置，并且 `generate` 为 false 或不设置，那么 HTTP password 会被删除。

### OAuthTokenInfo

`OAuthTokenInfo` ，`OAuth token` 相关信息。

|Field Name      ||Description
| :------| :------| :------|
|`username`      ||`OAuth token` 的 owner
|`resource_host` ||Gerrit 服务器信息
|`access_token`  ||token 的实际值
|`provider_id`   |可选|`plugin-name:provider-name` 格式中，OAuth 提供者的标识
|`expires_at`    |可选|token 使用了多长时间，单位为毫秒
|`type`          ||`OAuth token` 的类型，总是 `bearer`

### PreferencesInfo

`PreferencesInfo` ，用户的 preferences 信息

|Field Name                     ||Description
| :------| :------| :------|
|`changes_per_page`             ||页面显示 change 的数量，有效值为：`10`, `25`, `50`, `100`。
|`theme`                        ||选择 theme，有效值为：`DARK` 和 `LIGHT`。
|`expand_inline_diffs`          |如果不显示，则为 `false`|是否用自动展开 diff 的方式来替代打开单独的页面查看 diff (只支持 PolyGerrit)
|`download_scheme`              |可选|下载命令的方式，比如 HTTP SSH
|`date_format`                  ||日期格式，有效值为 `STD`, `US`, `ISO`, `EURO`, `UK`
|`time_format`                  ||时间格式，有效值为 `HHMM_12`, `HHMM_24`
|`relative_date_in_change_table`|如果不显示，则为 `false`|是否在 change 的表格中显示时间
|`diff_view`                    ||diff view 的类似，有效值为 `SIDE_BY_SIDE`, `UNIFIED_DIFF`
|`size_bar_in_change_table`     |如果不显示，则为 `false`|是否在 change 的表格中使用彩色条来显示文件修改的行数
|`legacycid_in_change_table`    |如果不显示，则为 `false`|是否在 change 的表格中显示 change 号
|`mute_common_path_prefixes`    |如果不显示，则为 `false`|是否在待评审的文件列表中隐藏文件的路径
|`signed_off_by`                |如果不显示，则为 `false`|在线编辑创建 change 时，是否自动插入 Signed-off-by
|`my`                           ||顶级菜单 `MY` 的子列表
|`change_table`                 ||change 的表格中显示的列 (只支持 PolyGerrit)。默认值为空，默认由前端决定。
|`email_strategy`               ||是否启用 email 通知。`ENABLED`, 用户会收到系统发的 email；`CC_ON_OWN_COMMENTS`，用户会收到关于自己评论的 email；`ATTENTION_SET_ONLY`, 只有设置了 attention 的用户才会收到邮件;`DISABLED`，用户不会收到系统的 email 通知。有效值为 `ENABLED`, `CC_ON_OWN_COMMENTS`,`ATTENTION_SET_ONLY`，`DISABLED`。
|`default_base_for_merges`      ||change 页面中，merge 节点的 'Diff Against' 下拉菜单中的默认值。有效值为 `AUTO_MERGE` `FIRST_PARENT`
|`publish_comments_on_push`     |如果不显示，则为 `false`|是否在 push 的时候发布 `draft comment`。
|`work_in_progress_by_default`  |如果不显示，则为 `false`|是否将新生成的 change 设置为 WIP 状态。

### PreferencesInput

`PreferencesInput` ，设置用户 preferences 属性信息。字段内容如果为空，则不能更新。

|Field Name                     ||Description
| :------| :------| :------|
|`changes_per_page`             |可选|页面显示 change 的数量，有效值为：`10`, `25`, `50`, `100`。
|`theme`                        |可选|选择的主题类型，可选值为 `DARK` 和 `LIGHT`。
|`expand_inline_diffs`          |如果不显示，则为 `false`|是否用自动展开 diff 的方式来替代打开单独的页面查看 diff (只支持 PolyGerrit)
|`download_scheme`              |可选|下载命令的方式，比如 HTTP SSH
|`date_format`                  |可选|日期格式，有效值为 `STD`, `US`, `ISO`, `EURO`, `UK`
|`time_format`                  |可选|时间格式，有效值为 `HHMM_12`, `HHMM_24`
|`relative_date_in_change_table`|可选|是否在 change 的表格中显示时间
|`diff_view`                    |可选|diff view 的类似，有效值为 `SIDE_BY_SIDE`, `UNIFIED_DIFF`
|`size_bar_in_change_table`     |可选|是否在 change 的表格中使用彩色条来显示文件修改的行数
|`legacycid_in_change_table`    |可选|是否在 change 的表格中显示 change 号
|`mute_common_path_prefixes`    |可选|是否在待评审的文件列表中隐藏文件的路径
|`signed_off_by`                |可选|在线编辑创建 change 时，是否自动插入 Signed-off-by
|`my`                           |可选|顶级菜单 `MY` 的子列表
|`change_table`                 ||change 的表格中显示的列 (只支持 PolyGerrit)。默认值为空，默认由前端决定。
|`email_strategy`               |可选|是否启用 email 通知。`ENABLED`, 用户会收到系统发的 email；`CC_ON_OWN_COMMENTS`，用户会收到关于自己评论的 email；`ATTENTION_SET_ONLY`, 只有设置了 attention 的用户才会收到邮件;`DISABLED`，用户不会收到系统的 email 通知。有效值为 `ENABLED`, `CC_ON_OWN_COMMENTS`,`ATTENTION_SET_ONLY`，`DISABLED`。
|`default_base_for_merges`      |可选|change 页面中，merge 节点的 'Diff Against' 下拉菜单中的默认值。有效值为 `AUTO_MERGE` `FIRST_PARENT`

### QueryLimitInfo

`QueryLimitInfo` ，返回搜索结果的数量。

|Field Name          |Description
| :------| :------|
|`min`               |下限
|`max`               |上限

### SshKeyInfo

`SshKeyInfo` ，用户 SSH key 的相关信息。

|Field Name      ||Description
| :------| :------| :------|
|`seq`           ||SSH key 的序号
|`ssh_public_key`||完整的 public SSH key
|`encoded_key`   ||是否为加密的 key
|`algorithm`     ||SSH key 的算法
|`comment`       |可选|SSH key 的描述
|`valid`         ||SSH key 是否有效

### StarsInput

`StarsInput` ，向 change 中添加或移除星标。

|Field Name ||Description
| :------| :------| :------|
|`add`      |可选|向 change 中添加星标
|`remove`   |可选|从 change 中移除星标

### UsernameInput

`UsernameInput` ，设置账户的 username 。

|Field Name |Description
| :------| :------|
|`username` |account 的新 username

### DisplayNameInput
`DisplayNameInput` 包含的 display name 相关信息。

|Field Name     |Description
| :------| :------|
|`display_name` |新账户的 display name

### ProjectWatchInfo

`WatchedProjectsInfo` ，关注的 project 的相关信息。

|Field Name                 |        |Description
| :------| :------| :------|
|`project`                  |        |project 的名称
|`filter`                   |可选|过滤的字符串
|`notify_new_changes`       |可选|新 change 的时候发出邮件通知
|`notify_new_patch_sets`    |可选|新 patch-set 的时候发出邮件通知
|`notify_all_comments`      |可选|新 comment 的时候发出邮件通知
|`notify_submitted_changes` |可选|change 被合入的时候发出邮件通知
|`notify_abandoned_changes` |可选|change 被 abandon 的时候发出邮件通知

