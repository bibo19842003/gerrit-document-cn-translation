# Gerrit Code Review - /access/ REST API

此文描述了链接权限相关的 API。API 概述请参考 [REST API](rest-api.md)。

## Access Rights Endpoints

### List Access Rights

```
'GET /access/?project={project-name}'
```

列出 project 的权限配置，需要指定具体的 `project` 参数。

返回的信息按 project 维度显示，每个 project 包括 ProjectAccessInfo 信息（具体信息可参考本文 ProjectAccessInfo 描述）。

_Request_
```
  GET /access/?project=MyProject&project=All-Projects HTTP/1.0
```

_Response_
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "All-Projects": {
      "revision": "edd453d18e08640e67a8c9a150cec998ed0ac9aa",
      "local": {
        "GLOBAL_CAPABILITIES": {
          "permissions": {
            "priority": {
              "rules": {
                "15bfcd8a6de1a69c50b30cedcdcc951c15703152": {
                  "action": "BATCH"
                }
              }
            },
            "streamEvents": {
              "rules": {
                "15bfcd8a6de1a69c50b30cedcdcc951c15703152": {
                  "action": "ALLOW"
                }
              }
            },
            "administrateServer": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                }
              }
            }
          }
        },
        "refs/meta/config": {
          "permissions": {
            "submit": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            },
            "label-Code-Review": {
              "label": "Code-Review",
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW",
                  "min": -2,
                  "max": 2
                },
                "global:Project-Owners": {
                  "action": "ALLOW",
                  "min": -2,
                  "max": 2
                }
              }
            },
            "read": {
              "exclusive": true,
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            },
            "push": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            }
          }
        },
        "refs/for/refs/*": {
          "permissions": {
            "pushMerge": {
              "rules": {
                "global:Registered-Users": {
                  "action": "ALLOW"
                }
              }
            },
            "push": {
              "rules": {
                "global:Registered-Users": {
                  "action": "ALLOW"
                }
              }
            }
          }
        },
        "refs/tags/*": {
          "permissions": {
            "createSignedTag": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            },
            "createTag": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            }
          }
        },
        "refs/heads/*": {
          "permissions": {
            "forgeCommitter": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            },
            "forgeAuthor": {
              "rules": {
                "global:Registered-Users": {
                  "action": "ALLOW"
                }
              }
            },
            "submit": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            },
            "editTopicName": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW",
                  "force": true
                },
                "global:Project-Owners": {
                  "action": "ALLOW",
                  "force": true
                }
              }
            },
            "label-Code-Review": {
              "label": "Code-Review",
              "rules": {
                "global:Registered-Users": {
                  "action": "ALLOW",
                  "min": -1,
                  "max": 1
                },
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW",
                  "min": -2,
                  "max": 2
                },
                "global:Project-Owners": {
                  "action": "ALLOW",
                  "min": -2,
                  "max": 2
                }
              }
            },
            "create": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            },
            "push": {
              "rules": {
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                },
                "global:Project-Owners": {
                  "action": "ALLOW"
                }
              }
            }
          }
        },
        "refs/*": {
          "permissions": {
            "read": {
              "rules": {
                "global:Anonymous-Users": {
                  "action": "ALLOW"
                },
                "53a4f647a89ea57992571187d8025f830625192a": {
                  "action": "ALLOW"
                }
              }
            }
          }
        }
      },
      "is_owner": true,
      "owner_of": [
        "GLOBAL_CAPABILITIES",
        "refs/meta/config",
        "refs/for/refs/*",
        "refs/tags/*",
        "refs/heads/*",
        "refs/*"
      ],
      "can_upload": true,
      "can_add": true,
      "can_add_tags": true,
      "config_visible": true,
      "groups": {
         "53a4f647a89ea57992571187d8025f830625192a": {
           "url": "#/admin/groups/uuid-53a4f647a89ea57992571187d8025f830625192a",
           "options": {},
           "description": "Gerrit Site Administrators",
           "group_id": 1,
           "owner": "Administrators",
           "owner_id": "53a4f647a89ea57992571187d8025f830625192a",
           "created_on": "2009-06-08 23:31:00.000000000",
           "name": "Administrators"
         },
         "global:Registered-Users": {
           "options": {},
           "name": "Registered Users"
         },
         "global:Project-Owners": {
           "options": {},
           "name": "Project Owners"
         },
         "15bfcd8a6de1a69c50b30cedcdcc951c15703152": {
           "url": "#/admin/groups/uuid-15bfcd8a6de1a69c50b30cedcdcc951c15703152",
           "options": {},
           "description": "Users who perform batch actions on Gerrit",
           "group_id": 2,
           "owner": "Administrators",
           "owner_id": "53a4f647a89ea57992571187d8025f830625192a",
           "created_on": "2009-06-08 23:31:00.000000000",
           "name": "Non-Interactive Users"
         },
         "global:Anonymous-Users": {
           "options": {},
           "name": "Anonymous Users"
         }
      }
    },
    "MyProject": {
      "revision": "61157ed63e14d261b6dca40650472a9b0bd88474",
      "inherits_from": {
        "id": "All-Projects",
        "name": "All-Projects",
        "description": "Access inherited by all other projects."
      },
      "local": {},
      "is_owner": true,
      "owner_of": [
        "refs/*"
      ],
      "can_upload": true,
      "can_add": true,
      "can_add_tags": true,
      "config_visible": true
    }
  }
```

## JSON Entities

### AccessSectionInfo

`AccessSectionInfo` ，描述了 ref 上的权限配置。

|Field Name           ||Description
| :------| :------| :------|
|`permissions`        ||ref 上的权限设置。具体权限的描述参考下文的 PermissionInfo。

### PermissionInfo

`PermissionInfo` ，权限分配的信息。

|Field Name     ||Description
| :------| :------| :------|
|`label`        |可选|打分项的名称。如果不是打分项权限，可以不用设置。
|`exclusive`    |如果是 `false`，则不用设置|权限是否设置为 exclusive
|`rules`        ||群组设置的权限情况，具体的信息可以参考下文的 PermissionRuleInfo

### PermissionRuleInfo

`PermissionRuleInfo` ，群组设置的权限情况。

|Field Name     ||Description
| :------| :------| :------|
|`action`       ||权限的设置状态，如 `ALLOW`,`DENY`,`BLOCK`。还有全局设置的 `INTERACTIVE`, `BATCH`。
|`force`        |如果是 `false`，则不显示|是否有 force 标识
|`min`          |打分范围是 `0..0`，或者未设置|打分范围的最小值
|`max`          |打分范围是 `0..0`，或者未设置|打分范围的最大值

### ProjectAccessInfo

`ProjectAccessInfo` ，project 维度的权限信息。

|Field Name           ||Description
| :------| :------| :------|
|`revision`           ||`refs/meta/config` 的 revision
|`inherits_from`      |`All-Project` 不显示|父 project 的名称
|`local`              ||当前 project 的 ref 的权限配置。相关信息可以参考 AccessSectionInfo
|`is_owner`           |如果是 `false`，则不显示|用户是否为当前 project 的 owner
|`owner_of`           ||用户管理 ref 的明细
|`can_upload`         |如果是 `false`，则不显示|用户是否可以进行 upload 操作
|`can_add`            |如果是 `false`，则不显示|用户是否有创建 ref 权限
|`can_add_tags`       |如果是 `false`，则不显示|用户是否有创建 tag 权限
|`config_visible`     |如果是 `false`，则不显示|当前用户是否可以访问 `refs/meta/config` 分支
|`groups`            ||群组的相关信息
|`configWebLinks`    ||权限配置文件历史记录的 URL 列表

