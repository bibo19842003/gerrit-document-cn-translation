# Gerrit Code Review - Metrics

Gerrit 内部的运行情况的数据可以通过 plugin 发送给外部的监控系统。可以参考 [Plugins 开发说明](dev-plugins.md) 中的 `metrics` 部分。

## Metrics

下面是相关的一些度量数据的描述。

### General

* `build/label`: gerrit 相关软件的版本
* `events`: 被触发的 event

### Actions

* `action/retry_attempt_count`: 单位时间内超时重试的次数（0 为不重试）
* `action/retry_timeout_count`: 超时重试的次数
* `action/auto_retry_count`: 自动重试的次数
* `action/failures_on_auto_retry_count`: 自动重试时失败的次数

### Pushes

* `receivecommits/changes`: 单位时间内，change 状态更新（change 的创建，patch-set 更新，change 的自动合入）的数量。
* `receivecommits/latency`: 每个 change 状态更新时（change 的创建，patch-set 更新，change 的自动合入）的时长
* `receivecommits/push_latency`: 所有 change 状态更新时（change 的创建，patch-set 更新，change 的自动合入）的时长
* `receivecommits/timeout`: 用户 push 过程中，超时的次数

### Process

* `proc/birth_timestamp`: gerrit 线程开始启动的时间
* `proc/uptime`: Gerrit 进程运行的时长
* `proc/cpu/num_cores`: Java virtual machine 可使用的 CPU 数量。
* `proc/cpu/usage`: gerrit 进程使用 CPU 的时间
* `proc/cpu/system_load`: 近 1 分钟 System 的平均负载 
* `proc/num_open_fds`: 打开文件的数量
* `proc/jvm/memory/heap_committed`: 当前可以使用的 heap 的大小
* `proc/jvm/memory/heap_used`: heap 已使用的内存大小
* `proc/jvm/memory/non_heap_committed`: 当前可以使用的 non-heap 的大小
* `proc/jvm/memory/non_heap_used`: non-heap 已使用的内存大小
* `proc/jvm/memory/object_pending_finalization_count`: 剩余 object 的数量
* `proc/jvm/gc/count`: GC 对象的数量
* `proc/jvm/gc/time`: GC 使用的时长
* `proc/jvm/memory/pool/committed/<pool name>`: 提交到内存中的 pool 数量。
* `proc/jvm/memory/pool/max/<pool name>`: 内存中的 pool 数量上限。
* `proc/jvm/memory/pool/used/<pool name>`: 内存中已使用的 pool 数量。
* `proc/jvm/thread/num_live`: 当前活动线程的数量
* `proc/jvm/thread/num_daemon_live`: 当前 daemon 的线程数量
* `proc/jvm/thread/num_peak_live`: 从 Java virtual machine 启动开始或者 peak 重置后，Peak 线程的数量
* `proc/jvm/thread/num_total_started`: Java virtual machine 启动后，总共创建的线程的数量
* `proc/jvm/thread/num_deadlocked_threads`: 当前 deadlock 的线程数量

**NOTE:**
*关于 heap：*
*init 约等于 xms 的值，max 约等于 xmx 的值。used 是已经使用的内存大小，committed 是当前可使用的内存大小（包括已使用的），committed >= used。committed 不足时 jvm 向系统申请，若超过max则发生 OutOfMemoryError 错误。*
*Java 虚拟机有一个堆(Heap)，堆是运行时数据区域，所有类实例和数组的内存均从此处分配。堆是在 Java 虚拟机启动时创建的。在JVM中堆之外的内存称为非堆内存(Non-heap memory)。*

### Caches

* `caches/memory_cached`: Memory 条目的数量
* `caches/memory_hit_ratio`: Memory 条目使用的频率
* `caches/memory_eviction_count`: Memory 条目移除的数量
* `caches/disk_cached`: Disk 缓存条目的数量
* `caches/disk_hit_ratio`: Disk 缓存条目使用的频率
* `caches/refresh_count`: 缓存的刷新次数

磁盘缓存的度量需要耗费较多的性能，度量默认是关闭的，可以设置 `cache.enableDiskStatMetrics` 参数启动度量。

### Change

* `change/submit_rule_evaluation`: 估算 change 的 submit rules 需要的时间
* `change/submit_type_evaluation`: 估算 change 的 submit type 需要的时间

### Comments

* `ported_comments/as_patchset_level`: patchset-level comments 的数量
* `ported_comments/as_file_level`: file-level comments 的数量
* `ported_comments/as_range_comments`: line/range comments 的数量

### HTTP

#### Jetty

* `http/server/jetty/connections/connections`: 当前的 connection 数量
* `http/server/jetty/connections/connections_total`: connection 总的数量
* `http/server/jetty/connections/connections_duration_max`: connection 的最大时长
* `http/server/jetty/connections/connections_duration_mean`: connection 的平均时长
* `http/server/jetty/connections/connections_duration_stdev`: connection 的偏差时长
* `http/server/jetty/connections/received_messages`: 收到信息的总数量
* `http/server/jetty/connections/sent_messages`: 发送信息的总数量
* `http/server/jetty/connections/received_bytes`: 收到信息的总大小
* `http/server/jetty/connections/sent_bytes`: 发送信息的总大小
* `http/server/jetty/threadpool/active_threads`: 当前活动的线程
* `http/server/jetty/threadpool/idle_threads`: 闲置的线程数量
* `http/server/jetty/threadpool/reserved_threads`: 保留的线程数量
* `http/server/jetty/threadpool/max_pool_size`: 线程池的最大值
* `http/server/jetty/threadpool/min_pool_size`: 线程池的最小值
* `http/server/jetty/threadpool/pool_size`: 当前线程池的大小
* `http/server/jetty/threadpool/queue_size`: 对单一线程来说，请求队列的大小

#### LDAP

* `ldap/login_latency`: logins 的时长
* `ldap/user_search_latency`: 搜索用户帐号的时长
* `ldap/group_search_latency`: 查询群组成员的时长
* `ldap/group_expansion_latency`: 查询嵌套群组的时长

#### REST API

* `http/server/error_count`: REST API error 响应的数量
* `http/server/success_count`: REST API success 响应的数量
* `http/server/rest_api/count`: REST API 调用 view 的数量
* `http/server/rest_api/change_id_type`: REST API 调用 `change ID type` 的数量
* `http/server/rest_api/error_count`: REST API 调用 view 的报错数量
* `http/server/rest_api/server_latency`: REST API 调用 view 的时长
* `http/server/rest_api/response_bytes`: REST API response 的大小
* `http/server/rest_api/change_json/to_change_info_latency`: 单个 ChangeInfo 的响应时长
* `http/server/rest_api/change_json/to_change_infos_latency`: 所有 ChangeInfo 的响应时长
* `http/server/rest_api/change_json/format_query_results_latency`: 搜索 change 的时长
* `http/server/rest_api/ui_actions/latency`: UI 响应的时长

### Query

* `query/query_latency`: 成功搜索的整个过程的时长

### Core Queues

下面是 queue 的相关度量:

* default `WorkQueue`
* index batch
* index interactive
* receive commits
* send email
* ssh batch worker
* ssh command start
* ssh interactive worker
* ssh stream worker

每个 queue 提供了下面的度量:

* `queue/<queue_name>/pool_size`: 当前线程的数量
* `queue/<queue_name>/max_pool_size`: 线程池允许的最大线程数
* `queue/<queue_name>/active_threads`: 当前活动的线程数量
* `queue/<queue_name>/scheduled_tasks`: 排队的任务数量
* `queue/<queue_name>/total_scheduled_tasks_count`: 所有排队的任务数量
* `queue/<queue_name>/total_completed_tasks_count`: 已执行完的任务数量

### SSH sessions

* `sshd/sessions/connected`: 当前 SSH 链接的数量
* `sshd/sessions/created`: 创建新 SSH session 的速率
* `sshd/sessions/authentication_failures`: SSH 认证失败的速率

### Topics

* `topic/cross_project_submit`: cross-project 的 topic 的 change 提交的数量
* `topic/cross_project_submit_completed`: cross-project 的 topic 的 change 成功提交的数量

### JGit

* `jgit/block_cache/cache_used`: JGit 使用 cache 的大小
* `jgit/block_cache/open_files`: JGit 打开文件的数量
* `avg_load_time` : JGit Average time to load a cache entry for JGit block cache.
* `total_load_time` : Total time to load cache entries for JGit block cache.
* `eviction_count` : Cache evictions for JGit block cache.
* `eviction_ratio` : Cache eviction ratio for JGit block cache.
* `hit_count` : Cache hits for JGit block cache.
* `hit_ratio` : Cache hit ratio for JGit block cache.
* `load_failure_count` : Failed cache loads for JGit block cache.
* `load_failure_ratio` : Failed cache load ratio for JGit block cache.
* `load_success_count` : Successful cache loads for JGit block cache.
* `miss_count` : Cache misses for JGit block cache.
* `miss_ratio` : Cache miss ratio for JGit block cache.
* `cache_used_per_repository` : Bytes of memory retained per repository for the top N repositories having most data in the cache. The number N of reported repositories is limited to 1000.

### Git

* `git/upload-pack/request_count`: 所有 git-upload-pack 请求的数量
* `git/upload-pack/phase_counting`: 'Counting...' 阶段耗费的时长
* `git/upload-pack/phase_compressing`: 'Compressing...' 阶段耗费的时长
* `git/upload-pack/phase_writing`: 向客户端传递数据耗费的时长
* `git/upload-pack/pack_bytes`: 向客户端传递 pack 的大小
* `git/auto-merge/num_operations`: `auto merge` 的数量
* `git/auto-merge/latency`: `auto merge` 的时长

### BatchUpdate

* `batch_update/execute_change_ops`: change 批量更新（不包括 reindex 操作）的时长

### NoteDb

* `notedb/update_latency`: NoteDb 更新的时长
* `notedb/stage_update_latency`: Latency 阶段更新的延时
* `notedb/read_latency`: 读取 NoteDb 的延时
* `notedb/parse_latency`: 解析 NoteDb 的延时
* `notedb/external_id_cache_load_count`: external ID 被加载到缓存使用的延时
* `notedb/external_id_partial_read_latency`: 从先前状态生成 external ID 的缓存需要的延时
* `notedb/external_id_update_count`: external ID 更新的数量
* `notedb/read_all_external_ids_latency`: 从 NoteDb 读取所有 external ID 的延时
* `notedb/read_single_account_config_latency`: 从 NoteDb 读取单一用户配置的延时
* `notedb/read_single_external_id_latency`: 从 NoteDb 读取单一用户 external_id 的延时

### Permissions

* `permissions/permission_collection/filter_latency`: 通过 user 和 ref 来识别权限的时长
* `permissions/ref_filter/full_filter_count`: 所有要过滤 ref 的数量
* `permissions/ref_filter/skip_filter_count`: 在可以访问所有 ref 的情况下，要过滤的 ref 的数量

### Reviewer Suggestion

* `reviewer_suggestion/query_accounts`: 为评审人员提供建议时，搜索用户的时长
* `reviewer_suggestion/recommend_accounts`: 为评审人员提供建议时，推荐账户的时长
* `reviewer_suggestion/load_accounts`: 为评审人员提供建议时，加载用户的时长
* `reviewer_suggestion/query_groups`: 为评审人员提供建议时，搜索群组的时长

### Repo Sequences

* `sequence/next_id_latency`: 从 repo 序列中嗯请求 IDs 的时长

### Plugin

* `plugin/latency`: plugin 调用的时长.
* `plugin/error_count`: plugin 报错的数量

### Group

* `group/guess_relevant_groups_latency`: 推测相关群组的时长

### Replication Plugin

* `plugins/replication/replication_latency`: 推送到远端服务器所花费的时长
* `plugins/replication/replication_delay`: 等待启动推送的时长
* `plugins/replication/replication_retries`: 推送重试的次数

### License

* `license/cla_check_count`: 校验 CLA 请求的次数

