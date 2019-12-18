# Gerrit Code Review - /config/ REST API

This page describes the config related REST endpoints.
Please also take note of the general information on the
[REST API](rest-api.md).

## Config Endpoints

### Get Version
```
'GET /config/server/version'
```

Returns the version of the Gerrit server.

.Request
```
  GET /config/server/version HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  "2.7"
```

### Get Server Info
```
'GET /config/server/info'
```

Returns the information about the Gerrit server configuration.

.Request
```
  GET /config/server/info HTTP/1.0
```

As result a `ServerInfo` entity is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "accounts": {
      "visibility": "ALL"
    },
    "auth": {
      "auth_type": "LDAP",
      "use_contributor_agreements": true,
      "contributor_agreements": [
        {
          "name": "Individual",
          "description": "If you are going to be contributing code on your own, this is the one you want. You can sign this one online.",
          "url": "static/cla_individual.html"
        }
      ],
      "editable_account_fields": [
        "FULL_NAME",
        "REGISTER_NEW_EMAIL"
      ]
    },
    "download": {
      "schemes": {
        "anonymous http": {
          "url": "http://gerrithost:8080/${project}",
          "commands": {
            "Checkout": "git fetch http://gerrithost:8080/${project} ${ref} \u0026\u0026 git checkout FETCH_HEAD",
            "Format Patch": "git fetch http://gerrithost:8080/${project} ${ref} \u0026\u0026 git format-patch -1 --stdout FETCH_HEAD",
            "Pull": "git pull http://gerrithost:8080/${project} ${ref}",
            "Cherry Pick": "git fetch http://gerrithost:8080/${project} ${ref} \u0026\u0026 git cherry-pick FETCH_HEAD"
          },
          "clone_commands": {
            "Clone": "git clone http://gerrithost:8080/${project}",
            "Clone with commit-msg hook": "git clone http://gerrithost:8080/${project} \u0026\u0026 scp -p -P 29418 jdoe@gerrithost:hooks/commit-msg ${project}/.git/hooks/"
          }
        },
        "http": {
          "url": "http://jdoe@gerrithost:8080/${project}",
          "is_auth_required": true,
          "is_auth_supported": true,
          "commands": {
            "Checkout": "git fetch http://jdoe@gerrithost:8080/${project} ${ref} \u0026\u0026 git checkout FETCH_HEAD",
            "Format Patch": "git fetch http://jdoe@gerrithost:8080/${project} ${ref} \u0026\u0026 git format-patch -1 --stdout FETCH_HEAD",
            "Pull": "git pull http://jdoe@gerrithost:8080/${project} ${ref}",
            "Cherry Pick": "git fetch http://jdoe@gerrithost:8080/${project} ${ref} \u0026\u0026 git cherry-pick FETCH_HEAD"
          },
          "clone_commands": {
            "Clone": "git clone http://jdoe@gerrithost:8080/${project}",
            "Clone with commit-msg hook": "git clone http://jdoe@gerrithost:8080/${project} \u0026\u0026 scp -p -P 29418 jdoe@gerrithost:hooks/commit-msg ${project}/.git/hooks/"
          }
        },
        "ssh": {
          "url": "ssh://jdoe@gerrithost:29418/${project}",
          "is_auth_required": true,
          "is_auth_supported": true,
          "commands": {
            "Checkout": "git fetch ssh://jdoe@gerrithost:29418/${project} ${ref} \u0026\u0026 git checkout FETCH_HEAD",
            "Format Patch": "git fetch ssh://jdoe@gerrithost:29418/${project} ${ref} \u0026\u0026 git format-patch -1 --stdout FETCH_HEAD",
            "Pull": "git pull ssh://jdoe@gerrithost:29418/${project} ${ref}",
            "Cherry Pick": "git fetch ssh://jdoe@gerrithost:29418/${project} ${ref} \u0026\u0026 git cherry-pick FETCH_HEAD"
          },
          "clone_commands": {
            "Clone": "git clone ssh://jdoe@gerrithost:29418/${project}",
            "Clone with commit-msg hook": "git clone ssh://jdoe@gerrithost:29418/${project} \u0026\u0026 scp -p -P 29418 jdoe@gerrithost:hooks/commit-msg ${project}/.git/hooks/"
          }
        }
      },
      "archives": [
        "tgz",
        "tar",
        "tbz2",
        "txz"
      ]
    },
    "gerrit": {
      "all_projects": "All-Projects",
      "all_users": "All-Users"
      "doc_search": true
    },
    "sshd": {},
    "suggest": {
      "from": 0
    },
    "user": {
      "anonymous_coward_name": "Name of user not set"
    }
  }
```

### Check Consistency
```
'POST /config/server/check.consistency'
```

Runs consistency checks and returns detected problems.

Input for the consistency checks that should be run must be provided in
the request body inside a `ConsistencyCheckInput` entity.

.Request
```
  POST /config/server/check.consistency HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "check_accounts": {},
    "check_account_external_ids": {}
  }
```

As result a `ConsistencyCheckInfo` entity is returned that contains detected consistency problems.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "check_accounts_result": {
      "problems": [
        {
          "status": "ERROR",
          "message": "Account \u00271000024\u0027 has no external ID for its preferred email \u0027foo.bar@example.com\u0027"
        }
      ]
    }
    "check_account_external_ids_result": {
      "problems": [
        {
          "status": "ERROR",
          "message": "External ID \u0027uuid:ccb8d323-1361-45aa-8874-41987a660c46\u0027 belongs to account that doesn\u0027t exist: 1000012"
        }
      ]
    }
  }
```


### Reload Config
```
'POST /config/server/reload'
```

Reloads the gerrit.config configuration.

Not all configuration value can be picked up by this command. Which config
sections and values that are supported is documented here:
[Configuration](config-gerrit.md)

_The output shows only modified config values that are picked up by Gerrit
and applied._

If a config entry is added or removed from gerrit.config, but still brings
no effect due to a matching default value, no output for this entry is shown.

.Request
```
  POST /config/server/reload HTTP/1.0
```

As result a `ConfigUpdateInfo` entity is returned that
contains information about how the updated config entries were handled.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "rejected": [],
    "applied": [
      {
        "config_key": "addreviewer.maxAllowed",
        "old_value": "20",
        "new_value": "15"
      }
    ]
  }
```


### Confirm Email
```
'PUT /config/server/email.confirm'
```

Confirms that the user owns an email address.

The email token must be provided in the request body inside an `EmailConfirmationInput` entity.

.Request
```
  PUT /config/server/email.confirm HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "token": "Enim+QNbAo6TV8Hur8WwoUypI6apG7qBPvF+bw==$MTAwMDAwNDp0ZXN0QHRlc3QuZGU="
  }
```

The response is "`204 No Content`".

If the token is invalid or if it's the token of another user the
request fails and the response is "`422 Unprocessable Entity`".


### List Caches
```
'GET /config/server/caches/'
```

Lists the caches of the server. Caches defined by plugins are included.

The caller must be a member of a group that is granted one of the
following capabilities:

* `View Caches`
* `Maintain Server`
* `Administrate Server`

As result a map of `CacheInfo` entities is returned.

The entries in the map are sorted by cache name.

.Request
```
  GET /config/server/caches/ HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "accounts": {
      "type": "MEM",
      "entries": {
        "mem": 4
      },
      "average_get": "2.5ms",
      "hit_ratio": {
        "mem": 94
      }
    },
    "adv_bases": {
      "type": "MEM",
      "entries": {},
      "hit_ratio": {}
    },
    "change_kind": {
      "type": "DISK",
      "entries": {
        "space": "0.00k"
      },
      "hit_ratio": {}
    },
    "changes": {
      "type": "MEM",
      "entries": {},
      "hit_ratio": {}
    },
    "conflicts": {
      "type": "DISK",
      "entries": {
        "mem": 2,
        "disk": 3,
        "space": "2.75k"
      },
      "hit_ratio": {
        "mem": 0,
        "disk": 100
      }
    },
    "diff": {
      "type": "DISK",
      "entries": {
        "mem": 177,
        "disk": 253,
        "space": "170.97k"
      },
      "average_get": "1.1ms",
      "hit_ratio": {
        "mem": 67,
        "disk": 100
      }
    },
    "diff_intraline": {
      "type": "DISK",
      "entries": {
        "mem": 1,
        "disk": 1,
        "space": "0.37k"
      },
      "average_get": "6.8ms",
      "hit_ratio": {
        "mem": 0
      }
    },
    "git_tags": {
      "type": "DISK",
      "entries": {
        "space": "0.00k"
      },
      "hit_ratio": {}
    },
    groups": {
      "type": "MEM",
      "entries": {
        "mem": 27
      },
      "average_get": "183.2us",
      "hit_ratio": {
        "mem": 12
      }
    },
    "groups_bymember": {
      "type": "MEM",
      "entries": {},
      "hit_ratio": {}
    },
    "groups_byname": {
      "type": "MEM",
      "entries": {},
      "hit_ratio": {}
    },
    "groups_bysubgroup": {
      "type": "MEM",
      "entries": {},
      "hit_ratio": {}
    },
    "groups_byuuid": {
      "type": "MEM",
      "entries": {
        "mem": 25
      },
      "average_get": "173.4us",
      "hit_ratio": {
        "mem": 13
      }
    },
    "groups_external": {
      "type": "MEM",
      "entries": {},
      "hit_ratio": {}
    },
    "permission_sort": {
      "type": "MEM",
      "entries": {
        "mem": 16
      },
      "hit_ratio": {
        "mem": 96
      }
    },
    "plugin_resources": {
      "type": "MEM",
      "entries": {
        "mem": 2
      },
      "hit_ratio": {
        "mem": 83
      }
    },
    "project_list": {
      "type": "MEM",
      "entries": {
        "mem": 1
      },
      "average_get": "18.6ms",
      "hit_ratio": {
        "mem": 0
      }
    },
    "projects": {
      "type": "MEM",
      "entries": {
        "mem": 35
      },
      "average_get": "8.6ms",
      "hit_ratio": {
        "mem": 99
      }
    },
    "prolog_rules": {
      "type": "MEM",
      "entries": {
        "mem": 35
      },
      "average_get": "103.0ms",
      "hit_ratio": {
        "mem": 99
      }
    },
    "quota-repo_size": {
      "type": "DISK",
      "entries": {
        "space": "0.00k"
      },
      "hit_ratio": {}
    },
    "sshkeys": {
      "type": "MEM",
      "entries": {
        "mem": 1
      },
      "average_get": "3.2ms",
      "hit_ratio": {
        "mem": 50
      }
    },
    "web_sessions": {
      "type": "DISK",
      "entries": {
        "mem": 1,
        "disk": 2,
        "space": "0.78k"
      },
      "hit_ratio": {
        "mem": 82
      }
    }
  }
```

It is possible to get different output formats by specifying the `format` option:

* `LIST`:

Returns the cache names as JSON list.

The cache names are lexicographically sorted.

.Request
```
  GET /config/server/caches/?format=LIST HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    "accounts",
    "adv_bases",
    "change_kind",
    "changes",
    "conflicts",
    "diff",
    "diff_intraline",
    "git_tags",
    "groups",
    "groups_bymember",
    "groups_byname",
    "groups_bysubgroup",
    "groups_byuuid",
    "groups_external",
    "permission_sort",
    "plugin_resources",
    "project_list",
    "projects",
    "prolog_rules",
    "quota-repo_size",
    "sshkeys",
    "web_sessions"
  ]
```

* `TEXT_LIST`:

Returns the cache names as a UTF-8 list that is base64 encoded. The
cache names are delimited by '\n'.

The cache names are lexicographically sorted.

.Request
```
  GET /config/server/caches/?format=TEXT_LIST HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: text/plain; charset=UTF-8

  YWNjb3VudHMKYW...ViX3Nlc3Npb25z
```

E.g. this could be used to flush all caches:

```
  for c in $(curl --user jdoe:TNAuLkXsIV7w http://gerrit/a/config/server/caches/?format=TEXT_LIST | base64 -D)
  do
    curl --user jdoe:TNAuLkXsIV7w -X POST http://gerrit/a/config/server/caches/$c/flush
  done
```

### Cache Operations
```
'POST /config/server/caches/'
```

Executes a cache operation that is specified in the request body in a `CacheOperationInput` entity.

#### Flush All Caches

.Request
```
  POST /config/server/caches/ HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "operation": "FLUSH_ALL"
  }
```

.Response
```
  HTTP/1.1 200 OK
```

#### Flush Several Caches At Once

.Request
```
  POST /config/server/caches/ HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "operation": "FLUSH",
    "caches": [
      "projects",
      "project_list"
    ]
  }
```

.Response
```
  HTTP/1.1 200 OK
```

### Get Cache
```
'GET /config/server/caches/{cache-name}'
```

Retrieves information about a cache.

The caller must be a member of a group that is granted one of the
following capabilities:

* `View Caches`
* `Maintain Server`
* `Administrate Server`

As result a `CacheInfo` entity is returned.

.Request
```
  GET /config/server/caches/projects HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "name": "projects",
    "type": "MEM",
    "entries": {
      "mem": 35
    },
    "average_get": " 8.6ms",
    "hit_ratio": {
      "mem": 99
    }
  }
```

### Flush Cache
```
'POST /config/server/caches/{cache-name}/flush'
```

Flushes a cache.

The caller must be a member of a group that is granted one of the following capabilities:

* `Flush Caches` (any cache   except "web_sessions")
* `Maintain Server` (any cache   including "web_sessions")
* `Administrate Server`   (any cache including "web_sessions")

.Request
```
  POST /config/server/caches/projects/flush HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
```

### Get Summary
```
'GET /config/server/summary'
```

Retrieves a summary of the current server state.

The caller must be a member of a group that is granted the `Administrate Server` capability.

The following options are supported:

* `jvm`:

Includes a JVM summary.

* `gc`:

Requests a Java garbage collection before computing the information
about the Java memory heap.

.Request
```
  GET /config/server/summary?jvm HTTP/1.0
```

As result a `SummaryInfo` entity is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "task_summary": {
      "total": 2,
      "sleeping": 2
    },
    "mem_summary": {
      "total": "341.06m",
      "used": "57.16m",
      "free": "283.90m",
      "buffers": "0.00k",
      "max": "1.67g",
    }
    "thread_summary": {
      "cpus": 8,
      "threads": 44,
      "counts": {
        "HTTP": {
          "RUNNABLE": 3,
          "TIMED_WAITING": 2
        },
        "SSH-Interactive-Worker": {
          "WAITING": 1
        },
        "Other": {
          "WAITING": 10,
          "RUNNABLE": 2,
          "TIMED_WAITING": 25
        },
        "SshCommandStart": {
          "WAITING": 1
        }
      }
    },
    "jvm_summary": {
      "vm_vendor": "Oracle Corporation",
      "vm_name": "Java HotSpot(TM) 64-Bit Server VM",
      "vm_version": "23.25-b01",
      "os_name": "Mac OS X",
      "os_version": "10.8.5",
      "os_arch": "x86_64",
      "user": "gerrit",
      "host": "GERRIT",
      "current_working_directory": "/Users/gerrit/site",
      "site": "/Users/gerrit/site"
    }
  }
```

### List Capabilities
```
'GET /config/server/capabilities'
```

Lists the capabilities that are available in the system. There are two
kinds of capabilities: core and plugin-owned capabilities.

As result a map of `CapabilityInfo` entities is returned.

The entries in the map are sorted by capability ID.

.Request
```
  GET /config/server/capabilities/ HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "accessDatabase": {
      "id": "accessDatabase",
      "name": "Access Database"
    },
    "administrateServer": {
      "id": "administrateServer",
      "name": "Administrate Server"
    },
    "createAccount": {
      "id": "createAccount",
      "name": "Create Account"
    },
    "createGroup": {
      "id": "createGroup",
      "name": "Create Group"
    },
    "createProject": {
      "id": "createProject",
      "name": "Create Project"
    },
    "emailReviewers": {
      "id": "emailReviewers",
      "name": "Email Reviewers"
    },
    "flushCaches": {
      "id": "flushCaches",
      "name": "Flush Caches"
    },
    "killTask": {
      "id": "killTask",
      "name": "Kill Task"
    },
    "priority": {
      "id": "priority",
      "name": "Priority"
    },
    "queryLimit": {
      "id": "queryLimit",
      "name": "Query Limit"
    },
    "runGC": {
      "id": "runGC",
      "name": "Run Garbage Collection"
    },
    "streamEvents": {
      "id": "streamEvents",
      "name": "Stream Events"
    },
    "viewCaches": {
      "id": "viewCaches",
      "name": "View Caches"
    },
    "viewConnections": {
      "id": "viewConnections",
      "name": "View Connections"
    },
    "viewPlugins": {
      "id": "viewPlugins",
      "name": "View Plugins"
    },
    "viewQueue": {
      "id": "viewQueue",
      "name": "View Queue"
    }
  }
```

### List Tasks
```
'GET /config/server/tasks/'
```

Lists the tasks from the background work queues that the Gerrit daemon
is currently performing, or will perform in the near future.

Gerrit contains an internal scheduler, similar to cron, that it uses to
queue and dispatch both short and long term tasks.

Tasks that are completed or canceled exit the queue very quickly once
they enter this state, but it can be possible to observe tasks in these
states.

End-users may see a task only if they can also see the project the task
is associated with. Tasks operating on other projects, or that do not
have a specific project, are hidden.

The caller must be a member of a group that is granted one of the
following capabilities:

* `View Queue`
* `Maintain Server`
* `Administrate Server`

As result a list of `TaskInfo` entities is returned.

The entries in the list are sorted by task state, remaining delay and command.

.Request
```
  GET /config/server/tasks/ HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "id": "1e688bea",
      "state": "SLEEPING",
      "start_time": "2014-06-11 12:58:51.991000000",
      "delay": 3453,
      "command": "Reload Submit Queue"
    },
    {
      "id": "3e6d4ffa",
      "state": "SLEEPING",
      "start_time": "2014-06-11 12:58:51.508000000",
      "delay": 3287966,
      "command": "Log File Compressor"
    }
  ]
```

### Get Task
```
'GET /config/server/tasks/{task-id}'
```

Retrieves a task from the background work queue that the Gerrit daemon
is currently performing, or will perform in the near future.

End-users may see a task only if they can also see the project the task
is associated with. Tasks operating on other projects, or that do not
have a specific project, are hidden.

The caller must be a member of a group that is granted one of the
following capabilities:

* `View Queue`
* `Maintain Server`
* `Administrate Server`

As result a `TaskInfo` entity is returned.

.Request
```
  GET /config/server/tasks/1e688bea HTTP/1.0
```

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "id": "1e688bea",
    "state": "SLEEPING",
    "start_time": "2014-06-11 12:58:51.991000000",
    "delay": 3453,
    "command": "Reload Submit Queue"
  }
```

### Delete Task
```
'DELETE /config/server/tasks/{task-id}'
```

Kills a task from the background work queue that the Gerrit daemon
is currently performing, or will perform in the near future.

The caller must be a member of a group that is granted one of the
following capabilities:

* `Kill Task`
* `Maintain Server`
* `Administrate Server`

End-users may see a task only if they can also see the project the task
is associated with. Tasks operating on other projects, or that do not
have a specific project, are hidden.

Members of a group granted one of the following capabilities may view all tasks:

* `View Queue`
* `Maintain Server`
* `Administrate Server`

.Request
```
  DELETE /config/server/tasks/1e688bea HTTP/1.0
```

.Response
```
  HTTP/1.1 204 No Content
```

### Get Top Menus
```
'GET /config/server/top-menus'
```

Returns the list of additional top menu entries.

.Request
```
  GET /config/server/top-menus HTTP/1.0
```

As response a list of the additional top menu entries as `TopMenuEntryInfo` entities is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  [
    {
      "name": "Top Menu Entry",
      "items": [
        {
          "url": "http://gerrit.googlecode.com/",
          "name": "Gerrit",
          "target": "_blank"
        }
      ]
    }
  ]
```

### Get Default User Preferences
```
'GET /config/server/preferences'
```

Returns the default user preferences for the server.

.Request
```
  GET /a/config/server/preferences HTTP/1.0
```

As response a `PreferencesInfo` is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "changes_per_page": 25,
    "download_command": "CHECKOUT",
    "date_format": "STD",
    "time_format": "HHMM_12",
    "diff_view": "SIDE_BY_SIDE",
    "size_bar_in_change_table": true,
    "mute_common_path_prefixes": true,
    "publish_comments_on_push": true,
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
        "url": "#/q/has:edit",
        "name": "Edits"
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
    "email_strategy": "ENABLED"
  }
```

### Set Default User Preferences

```
'PUT /config/server/preferences'
```

Sets the default user preferences for the server.

The new user preferences must be provided in the request body as a `PreferencesInput` entity.

To be allowed to set default preferences, a user must be a member of a group that is granted the `Administrate Server` capability.

.Request
```
  PUT /a/config/server/preferences HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "changes_per_page": 50
  }
```

As response a link:rest-api-accounts.html#preferences-info[
PreferencesInfo] is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "changes_per_page": 50,
    "download_command": "CHECKOUT",
    "date_format": "STD",
    "time_format": "HHMM_12",
    "diff_view": "SIDE_BY_SIDE",
    "size_bar_in_change_table": true,
    "mute_common_path_prefixes": true,
    "publish_comments_on_push": true,
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
        "url": "#/q/has:edit",
        "name": "Edits"
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
    "email_strategy": "ENABLED"
  }
```

### Get Default Diff Preferences

```
'GET /config/server/preferences.diff'
```

Returns the default diff preferences for the server.

.Request
```
  GET /a/config/server/preferences.diff HTTP/1.0
```

As response a `DiffPreferencesInfo` is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "context": 10,
    "tab_size": 8,
    "line_length": 100,
    "cursor_blink_rate": 0,
    "intraline_difference": true,
    "show_line_endings": true,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "auto_hide_diff_table_header": true,
    "theme": "DEFAULT",
    "ignore_whitespace": "IGNORE_NONE"
  }
```

### Set Default Diff Preferences

```
'PUT /config/server/preferences.diff'
```

Sets the default diff preferences for the server.

The new diff preferences must be provided in the request body as a `DiffPreferencesInput` entity.

To be allowed to set default diff preferences, a user must be a member of a group that is granted the `Administrate Server` capability.

.Request
```
  PUT /a/config/server/preferences.diff HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "context": 10,
    "tab_size": 8,
    "line_length": 80,
    "cursor_blink_rate": 0,
    "intraline_difference": true,
    "show_line_endings": true,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "auto_hide_diff_table_header": true,
    "theme": "DEFAULT",
    "ignore_whitespace": "IGNORE_NONE"
  }
```

As response a link:rest-api-accounts.html#diff-preferences-info[
DiffPreferencesInfo] is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "context": 10,
    "tab_size": 8,
    "line_length": 80,
    "cursor_blink_rate": 0,
    "intraline_difference": true,
    "show_line_endings": true,
    "show_tabs": true,
    "show_whitespace_errors": true,
    "syntax_highlighting": true,
    "auto_hide_diff_table_header": true,
    "theme": "DEFAULT",
    "ignore_whitespace": "IGNORE_NONE"
  }
```

### Get Default Edit Preferences

```
'GET /config/server/preferences.edit'
```

Returns the default edit preferences for the server.

.Request
```
  GET /a/config/server/preferences.edit HTTP/1.0
```

As response a `EditPreferencesInfo` is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "tab_size": 8,
    "line_length": 100,
    "indent_unit": 2,
    "cursor_blink_rate": 0,
    "show_tabs": true,
    "syntax_highlighting": true,
    "match_brackets": true,
    "auto_close_brackets": true,
    "theme": "DEFAULT",
    "key_map_type": "DEFAULT"
  }
```

### Set Default Edit Preferences

```
'PUT /config/server/preferences.edit'
```

Sets the default edit preferences for the server.

The new edit preferences must be provided in the request body as a `EditPreferencesInput` entity.

To be allowed to set default edit preferences, a user must be a member
of a group that is granted the `Administrate Server` capability.

.Request
```
  PUT /a/config/server/preferences.edit HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {
    "tab_size": 8,
    "line_length": 80,
    "indent_unit": 2,
    "cursor_blink_rate": 0,
    "show_tabs": true,
    "syntax_highlighting": true,
    "match_brackets": true,
    "auto_close_brackets": true,
    "theme": "DEFAULT",
    "key_map_type": "DEFAULT"
  }
```

As response a `EditPreferencesInfo` is returned.

.Response
```
  HTTP/1.1 200 OK
  Content-Type: application/json; charset=UTF-8

  )]}'
  {
    "tab_size": 8,
    "line_length": 80,
    "indent_unit": 2,
    "cursor_blink_rate": 0,
    "show_tabs": true,
    "syntax_highlighting": true,
    "match_brackets": true,
    "auto_close_brackets": true,
    "theme": "DEFAULT",
    "key_map_type": "DEFAULT"
  }
```


### Index a set of changes

This endpoint allows Gerrit admins to index a set of changes with one request
by providing a IndexChangesInput entity.

Using this endpoint Gerrit admins can also index change(s) which are not visible to them.

.Request
```
  POST /config/server/index.changes HTTP/1.0
  Content-Type: application/json; charset=UTF-8

  {changes: ["foo~101", "bar~202"]}
```

.Response
```
  HTTP/1.1 200 OK
  Content-Disposition: attachment
```


## IDs

### {cache-name}
The name of the cache.

If the cache is defined by a plugin the cache name must include the
plugin name: "<plugin-name>-<cache-name>".

Gerrit core caches can optionally be prefixed with "gerrit":
"gerrit-<cache-name>".

### {task-id}
The ID of the task (hex string).


## JSON Entities

### AccountsConfigInfo
The `AccountsConfigInfo` entity contains information about Gerrit
configuration from the `accounts` section.

|Field Name           |Description
| :------| :------|
|`visibility`         |`Visibility setting for accounts`.

### AuthInfo
The `AuthInfo` entity contains information about the authentication configuration of the Gerrit server.

|Field Name                   ||Description
| :------| :------| :------|
|`type`                       ||The `authentication type` that is configured on the server. Can be `OPENID`, `OPENID_SSO`, `OAUTH`,`HTTP`, `HTTP_LDAP`, `CLIENT_SSL_CERT_LDAP`, `LDAP`, `LDAP_BIND`,`CUSTOM_EXTENSION` or `DEVELOPMENT_BECOME_ANY_ACCOUNT`.
|`use_contributor_agreements` |not set if `false`|Whether `contributor agreements` are required.
|`contributor_agreements`     |not set if `use_contributor_agreements` is `false`|List of contributor agreements as `ContributorAgreementInfo` entities.
|`editable_account_fields`    ||List of account fields that are editable. Possible values are `FULL_NAME`, `USER_NAME` and `REGISTER_NEW_EMAIL`.
|`login_url`                  |optional|The `login URL`. Only set if `authentication type` is `HTTP` or `HTTP_LDAP`.
|`login_text`                 |optional|The `login text`. Only set if `authentication type` is `HTTP` or `HTTP_LDAP`.
|`switch_account_url`         |optional|The `URL to switch accounts`.
|`register_url`               |optional|The `register URL`. Only set if `authentication type` is `LDAP`,`LDAP_BIND` or `CUSTOM_EXTENSION`.
|`register_text`              |optional|The `register text`. Only set if `authentication type` is `LDAP`,`LDAP_BIND` or `CUSTOM_EXTENSION`.
|`edit_full_name_url`         |optional|The `URL to edit the full name`. Only set if `authentication type` is `LDAP`, `LDAP_BIND` or `CUSTOM_EXTENSION`.
|`http_password_url`          |optional|The `URL to obtain an HTTP password`. Only set if `authentication type` is `CUSTOM_EXTENSION`.
|`git_basic_auth_policy`      |optional|The `policy` to authenticate Git over HTTP and REST API requests when `authentication type` is `LDAP`. Can be `HTTP`, `LDAP` or `HTTP_LDAP`.

### CacheInfo
The `CacheInfo` entity contains information about a cache.

|Field Name           ||Description
| :------| :------| :------|
|`name`               |not set if returned in a map where the cache name is used as map key|The cache name. If the cache is defined by a plugin the cache name includes the plugin name: "<plugin-name>-<cache-name>".
|`type`               ||The type of the cache (`MEM`: in memory cache, `DISK`: disk cache).
|`entries`            ||Information about the entries in the cache as a `EntriesInfo` entity.
|`average_get`        |optional|The average duration of getting one entry from the cache. The value is returned with a standard time unit abbreviation (`ns`: nanoseconds, `us`: microseconds, `ms`: milliseconds, `s`: seconds).
|`hit_ratio`          ||Information about the hit ratio as a `HitRatioInfo` entity.

### CacheOperationInput
The `CacheOperationInput` entity contains information about an operation that should be executed on caches.

|Field Name           ||Description
| :------| :------| :------|
|`operation`          ||The cache operation that should be executed:`FLUSH_ALL`: Flushes all caches, except the `web_sessions` cache.`FLUSH`: Flushes the specified caches.
|`caches`             |optional|A list of cache names. This list defines the caches on which the specified operation should be executed. Whether this list must be
specified depends on the operation being executed.

### CapabilityInfo
The `CapabilityInfo` entity contains information about a capability.

|Field Name           |Description
| :------| :------|
|`id`                 |capability ID
|`name`               |capability name

### ChangeConfigInfo
The `ChangeConfigInfo` entity contains information about Gerrit
configuration from the `change` section.

|Field Name           ||Description
| :------| :------| :------|
|`allow_blame`        |not set if `false`|`Whether blame on side by side diff is allowed`.
|`large_change`       ||`Number of changed lines from which on a change is considered as a large change`.
|`reply_label`        ||`Label name for the reply button`
|`reply_tooltip`      ||`Tooltip for the reply button`
|`update_delay`       ||`How often in seconds the web interface should poll for updates to the currently open change`
|`submit_whole_topic` |not set if `false`|`A configuration if the whole topic is submitted`
|`disable_private_changes` |not set if `false`|Returns true if private changes are disabled.
|`exclude_mergeable_in_change_info` |not set if `false`|Value of the configuration parameter that controls whether the mergeability bit in ChangeInfo will never be set.

### CheckAccountExternalIdsInput
The `CheckAccountExternalIdsInput` entity contains input for the
account external ID consistency check.

Currently this entity contains no fields.

### CheckAccountExternalIdsResultInfo
The `CheckAccountExternalIdsResultInfo` entity contains the result of
running the account external ID consistency check.

|Field Name|Description
| :------| :------|
|`problems`|A list of `ConsistencyProblemInfo` entities.

### CheckAccountsInput
The `CheckAccountsInput` entity contains input for the account consistency check.

Currently this entity contains no fields.

### CheckAccountsResultInfo
The `CheckAccountsResultInfo` entity contains the result of running the account consistency check.

|Field Name|Description
| :------| :------|
|`problems`|A list of `ConsistencyProblemInfo` entities.

### CheckGroupsInput
The `CheckGroupsInput` entity contains input for the group consistency check.

Currently this entity contains no fields.

### CheckGroupsResultInfo
The `CheckGroupsResultInfo` entity contains the result of running the group consistency check.

|Field Name|Description
| :------| :------|
|`problems`|A list of `ConsistencyProblemInfo` entities.

### ConsistencyCheckInfo
The `ConsistencyCheckInfo` entity contains the results of running consistency checks.

|Field Name                         ||Description
| :------| :------| :------|
|`check_accounts_result`            |optional|The result of running the account consistency check as a `CheckAccountsResultInfo` entity.
|`check_account_external_ids_result`|optional|The result of running the account external ID consistency check as a `CheckAccountExternalIdsResultInfo` entity.
|`check_groups_result`              |optional|The result of running the group consistency check as a `CheckGroupsResultInfo` entity.

### ConsistencyCheckInput
The `ConsistencyCheckInput` entity contains information about which consistency checks should be run.

|Field Name                  ||Description
| :------| :------| :------|
|`check_accounts`            |optional|Input for the account consistency check as `CheckAccountsInput` entity.
|`check_account_external_ids`|optional|Input for the account external ID consistency check as `CheckAccountExternalIdsInput` entity.
|`check_groups`              |optional|Input for the group consistency check as `CheckGroupsInput` entity.

### ConsistencyProblemInfo
The `ConsistencyProblemInfo` entity contains information about a consistency problem.

|Field Name|Description
| :------| :------|
|`status`  |The status of the consistency problem. Possible values are `ERROR` and `WARNING`.
|`message` |Message describing the consistency problem.

### ConfigUpdateInfo
The entity describes the result of a reload of gerrit.config.

If a changed config value is missing from the `applied` and the `rejected`
lists there are no guarantees to whether they have or have not taken effect.

|Field Name|Description
| :------| :------|
|`applied` |A list of `ConfigUpdateEntryInfos` describing the applied configuration changes. Every config value change representation present in this list is guaranteed to have taken effect.
|`rejected` |A list of `ConfigUpdateEntryInfos` describing the rejected configuration changes. Every config value change representation present in this list is guaranteed not to have taken effect.

### ConfigUpdateEntryInfo
The entity describes an updated config value.

|Field Name|Description
| :------| :------|
|`config_key` |The config key that contains the value.
|`old_value`  |The old config value. Missing if value was not previously configured.
|`new_value`  |The new config value, picked up after reload.

### DownloadInfo
The `DownloadInfo` entity contains information about supported download options.

|Field Name |Description
| :------| :------|
|`schemes`  |The supported download schemes as a map which maps the scheme name to a of `DownloadSchemeInfo` entity.
|`archives` |List of supported archive formats. Possible values are `tgz`, `tar`,`tbz2` and `txz`.

### DownloadSchemeInfo
The `DownloadSchemeInfo` entity contains information about a supported download scheme and its commands.

|Field Name          ||Description
| :------| :------| :------|
|`url`               ||The URL of the download scheme, where '${project}' is used as placeholder for the project name.
|`is_auth_required`  |not set if `false`|Whether this download scheme requires authentication.
|`is_auth_supported` |not set if `false`|Whether this download scheme supports authentication.
|`commands`          ||Download commands as a map which maps the command name to the download command. In the download command '${project}' is used as placeholder for the project name, and '${ref}' is used as placeholder for the (change) ref.Empty, if accessed anonymously and the download scheme requires authentication.
|`clone_commands`    ||Clone commands as a map which maps the command name to the clone command. In the clone command '${project}' is used as placeholder for the project name and '${project-base-name}' as name for the project base name (e.g. for a project 'foo/bar' '${project}' is a placeholder for 'foo/bar' and '${project-base-name}' is a placeholder for 'bar').Empty, if accessed anonymously and the download scheme requires authentication.

### EmailConfirmationInput
The `EmailConfirmationInput` entity contains information for confirming an email address.

|Field Name |Description
| :------| :------|
|`token`    |The token that was sent by mail to a newly registered email address.

### EntriesInfo
The `EntriesInfo` entity contains information about the entries in a cache.

|Field Name ||Description
| :------| :------| :------|
|`mem`      |optional|Number of cache entries that are held in memory.
|`disk`     |optional|Number of cache entries on the disk. For non-disk caches this value is not set; for disk caches it is only set if there are entries in the cache.
|`space`    |optional|The space that is consumed by the cache on disk. The value is returned with a unit abbreviation (`k`: kilobytes, `m`: megabytes,`g`: gigabytes). Only set for disk caches.

### GerritInfo
The `GerritInfo` entity contains information about Gerrit
configuration from the `gerrit` section.

|Field Name          ||Description
| :------| :------| :------|
|`all_projects_name` ||Name of the `root project`
|`all_users_name`    ||Name of the `project in which meta data of all users is stored`
|`doc_search`        ||Whether documentation search is available.
|`doc_url`           |optional|Custom base URL where Gerrit server documentation is located.(Documentation may still be available at /Documentation relative to the Gerrit base path even if this value is unset.)
|`edit_gpg_keys`     |not set if `false`|Whether to enable the web UI for editing GPG keys.
|`report_bug_url`    |optional|`URL to report bugs`

### HitRatioInfo
The `HitRatioInfo` entity contains information about the hit ratio of a cache.

|Field Name ||Description
| :------| :------| :------|
|`mem`      ||Hit ratio for cache entries that are held in memory (0 \<= value \<= 100).
|`disk`     |optional|Hit ratio for cache entries that are held on disk (0 \<= value \<= 100).Only set for disk caches.

### IndexChangesInput
The `IndexChangesInput` contains a list of numerical changes IDs to index.

|Field Name         ||Description
| :------| :------| :------|
|`changes`   ||List of change-ids


### JvmSummaryInfo
The `JvmSummaryInfo` entity contains information about the JVM.

|Field Name                 ||Description
| :------| :------| :------|
|`vm_vendor`                ||The vendor of the virtual machine.
|`vm_name`                  ||The name of the virtual machine.
|`vm_version`               ||The version of the virtual machine.
|`os_name`                  ||The name of the operating system.
|`os_version`               ||The version of the operating system.
|`os_arch`                  ||The architecture of the operating system.
|`user`                     ||The user that is running Gerrit.
|`host`                     |optional|The host on which Gerrit is running.
|`current_working_directory`||The current working directory.
|`site`                     ||The path to the review site.

### MemSummaryInfo
The `MemSummaryInfo` entity contains information about the current memory usage.

|Field Name     ||Description
| :------| :------| :------|
|`total`        ||The total size of the memory. The value is returned with a unit abbreviation (`k`: kilobytes, `m`: megabytes, `g`: gigabytes).
|`used`         ||The size of used memory. The value is returned with a unit abbreviation (`k`: kilobytes, `m`: megabytes, `g`: gigabytes).
|`free`         ||The size of free memory. The value is returned with a unit abbreviation (`k`: kilobytes, `m`: megabytes, `g`: gigabytes).
|`buffers`      || The size of memory used for JGit buffers. The value is returned with a unit abbreviation (`k`: kilobytes, `m`: megabytes, `g`: gigabytes).
|`max`          ||The maximal memory size. The value is returned with a unit abbreviation (`k`: kilobytes, `m`: megabytes, `g`: gigabytes).
|`open_files`   |optional|The number of open files.

### PluginConfigInfo
The `PluginConfigInfo` entity contains information about Gerrit extensions by plugins.

|Field Name    ||Description
| :------| :------| :------|
|`has_avatars` |not set if `false`|Whether an avatar provider is registered.

### ReceiveInfo
The `ReceiveInfo` entity contains information about the configuration of git-receive-pack behavior on the server.

|Field Name        ||Description
| :------| :------| :------|
|`enableSignedPush`|optional|Whether signed push validation support is enabled on the server; see the `global configuration` for details.

### ServerInfo
The `ServerInfo` entity contains information about the configuration of the Gerrit server.

|Field Name                ||Description
| :------| :------| :------|
|`accounts`                ||Information about the configuration from the `accounts` section as `AccountsConfigInfo` entity.
|`auth`                    ||Information about the authentication configuration as `AuthInfo` entity.
|`change`                  ||Information about the configuration from the `change` section as `ChangeConfigInfo` entity.
|`download`                ||Information about the configured download options as `DownloadInfo` entity information about Gerrit
|`gerrit`                  || Information about the configuration from the `gerrit` section as `GerritInfo` entity.
|`note_db_enabled`         |not set if `false`|Whether the NoteDb storage backend is fully enabled.
|`plugin`                  ||Information about Gerrit extensions by plugins as `PluginConfigInfo` entity.
|`receive`                 |optional|Information about the receive-pack configuration as a `ReceiveInfo` entity.
|`sshd`                    |optional|Information about the configuration from the `sshd` section as `SshdInfo` entity. Not set if SSHD is disabled.
|`suggest`                 ||Information about the configuration from the `suggest` section as `SuggestInfo` entity.
|`user`                    ||Information about the configuration from the `user` section as `UserConfigInfo` entity.
|`default_theme`           |optional|URL to a default PolyGerrit UI theme plugin, if available.Located in `/static/gerrit-theme.html` by default.

### SshdInfo
The `SshdInfo` entity contains information about Gerrit
configuration from the `sshd` section.

This entity doesn't contain any data, but the presence of this (empty)
entity in the `ServerInfo` entity means that SSHD is
enabled on the server.

### SuggestInfo
The `SuggestInfo` entity contains information about Gerrit
configuration from the `suggest` section.

|Field Name |Description
| :------| :------|
|`from`     |The `number of characters` that a user must have typed before suggestions are provided.

### SummaryInfo
The `SummaryInfo` entity contains information about the current state of the server.

|Field Name     ||Description
| :------| :------| :------|
|`task_summary` ||Summary about current tasks as a `TaskSummaryInfo` entity.
|`mem_summary`  ||Summary about current memory usage as a `MemSummaryInfo` entity.
|`thread_summary`  ||Summary about current threads as a `ThreadSummaryInfo` entity.
|`jvm_summary`  |optional|Summary about the JVM `JvmSummaryInfo` entity.Only set if the `jvm` option was set.

### TaskInfo
The `TaskInfo` entity contains information about a task in a background work queue.

|Field Name   ||Description
| :------| :------| :------|
|`id`         ||The ID of the task.
|`state`      ||The state of the task, can be `DONE`, `CANCELLED`, `RUNNING`, `READY`,`SLEEPING` and `OTHER`.
|`start_time` ||The start time of the task.
|`delay`      ||The remaining delay of the task.
|`command`    ||The command of the task.
|`remote_name`|optional|The remote name. May only be set for tasks that are associated with a project.
|`project`    |optional|The project the task is associated with.

### TaskSummaryInfo
The `TaskSummaryInfo` entity contains information about the current tasks.

|Field Name     ||Description
| :------| :------|
|`total`        |optional|Total number of current tasks.
|`running`      |optional|Number of currently running tasks.
|`ready`        |optional|Number of currently ready tasks.
|`sleeping`     |optional|Number of currently sleeping tasks.

### ThreadSummaryInfo
The `ThreadSummaryInfo` entity contains information about the current threads.

|Field Name     |Description
| :------| :------|
|`cpus`         |The number of available processors.
|`threads`      |The total number of current threads.
|`counts`       |Detailed thread counts as a map that maps a thread kind to a map that maps a thread state to the thread count. The thread kinds group the counts by threads that have the same name prefix (`H2`, `HTTP`,`IntraLineDiff`, `ReceiveCommits`, `SSH git-receive-pack`,`SSH git-upload-pack`, `SSH-Interactive-Worker`, `SSH-Stream-Worker`,`SshCommandStart`, `sshd-SshServer`). The counts for other threads are available under the thread kind `Other`. Counts for the following thread states can be included: `NEW`, `RUNNABLE`, `BLOCKED`, `WAITING`,`TIMED_WAITING` and `TERMINATED`.

### TopMenuEntryInfo
The `TopMenuEntryInfo` entity contains information about a top menu entry.

|Field Name           |Description
| :------| :------|
|`name`               |Name of the top menu entry.
|`items`              |List of `menu items`.

### TopMenuItemInfo
The `TopMenuItemInfo` entity contains information about a menu item in a top menu entry.

|Field Name ||Description
| :------| :------| :------|
|`url`      ||The URL of the menu item link.
|`name`     ||The name of the menu item.
|`target`   ||Target attribute of the menu item link.
|`id`       |optional|The `id` attribute of the menu item link.

### UserConfigInfo
The `UserConfigInfo` entity contains information about Gerrit
configuration from the `user` section.

|Field Name              |Description
| :------| :------|
|`anonymous_coward_name` |`Username` that is displayed in the Gerrit Web UI and in e-mail notifications if the full name of the user is not set.



