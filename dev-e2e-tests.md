# Gerrit Code Review - End to end load tests

This document provides descriptions of Gerrit end-to-end (`e2e`) test scenarios implemented using
the [Gatling](https://gatling.io/) framework.
 

Similar scenarios have been successfully used to compare performance of different Gerrit versions
or study the Gerrit response under different load profiles. Although mostly for load, scenarios can
either be for [load or functional](https://gatling.io/load-testing-continuous-integration/)
(e2e) testing purposes. Functional scenarios may then reuse this framework and Gatling's usability
features such as its protocols (more below) and
[DSL](https://en.wikipedia.org/wiki/Domain-specific_language).

That cross test-scope reusability applies to both Gerrit core scenarios and non-core ones, such as
for Gerrit plugins or other potential extensions. End-to-end testing may then include scopes like
feature integration, deployment, smoke (and load) testing. These load and functional test scopes
should remain orthogonal to the unit and component (aka Gerrit `IT`-suffixed or `acceptance`) ones.
The term `acceptance` though may still be coined by organizations to target e2e functional testing.

## What is Gatling?

Gatling is mostly a load testing tool which provides out of the box support for the HTTP protocol.
Documentation on how to write an HTTP load test can be found
[here](https://gatling.io/docs/current/http/http_protocol/).
However, in the scenarios that were initially proposed, the
[Gatling Git extension](https://github.com/GerritForge/gatling-git) was
leveraged to run tests at the Git protocol level.
 
implementation easy even without any Scala knowledge. The online `End-to-end tests`
[presentation](https://www.gerritcodereview.com/presentations.html#list-of-presentations)
links posted on the homepage have more introductory information.

## IDE: IntelliJ
 
Examples of scenarios can be found in the `e2e-tests` directory. The files in that directory should
be formatted using the mainstream
[Scala plugin for IntelliJ](https://plugins.jetbrains.com/plugin/1347-scala).
The latter is not mandatory but preferred for `sbt` and Scala IDE purposes in this project.

So, Eclipse can also be used alongside as a development IDE; this is described below.

### Eclipse

1. Install the [Scala plugin for Eclipse](http://scala-ide.org/docs/user/gettingstarted.html).
2. Run `sbt eclipse` from the `e2e-tests` root directory.
3. Import the resulting `e2e-tests` eclipse file inside the Gerrit project, in Eclipse.
4. You should see errors in Eclipse telling you there are missing packages.
5. This is due to the sbt-eclipse plugin not properly linking the Gerrit Gatling e2e tests with
   Gatling Git plugin.
6. You then have to right-click on the root directory and choose the build path->link source option.
7. Then you have to browse to `.sbt/1.0/staging`, find the folder where gatling-git is contained,
   and choose that.
8. That last step should link the gatling-git plugin to the project; e2e tests should not show
   errors anymore.
9. You may get errors in the gatling-git directory; these should not affect Gerrit Gatling
   development and can be ignored.

## How to build the tests

An [sbt-based installation](https://www.scala-sbt.org/download.html)
of [Scala](https://www.scala-lang.org/download/) is required.
 
The `scalaVersion` used by `sbt` once installed is defined in the `build.sbt` file. That specific
version of Scala is automatically used by `sbt` while building:
 
```
sbt compile
```
 
The following warning, if present when executing `sbt` commands, can be removed by creating the
[related credentials file](https://www.scala-sbt.org/1.x/docs/Using-Sonatype.html#step+3%3A+Credentials)
locally. Dummy values for `user` and `password` in that file can be used initially.
 
```
warn: Credentials file ~/.sbt/sonatype_credentials does not exist
```

The other warning below can be safely ignored, so far. Running the proposed `sbt evicted` command
should only list `scala-java8-compat_2.12` as `[warn]`. The other dependency conflicts should show
as `[info]`. All of the listed conflicts get usually resolved seamlessly or so.

```
warn: There may be incompatibilities among your library dependencies; run 'evicted' to see detailed eviction warnings.
```

Every `sbt` command can include an optional log level
[argument](https://www.scala-sbt.org/1.x/docs/Howto-Logging.html#Change+the+logging+level+globally).
Below, `[info]` logs are no longer shown:

```
sbt --warn compile
```

### How to build using Docker
```
docker build . -t e2e-tests
```

## How to set-up
 
### SSH keys
 
If you are running SSH commands, the private keys of the users used for testing need to go in
`/tmp/ssh-keys`. The keys need to be generated this way (JSch won't validate them
[otherwise](https://stackoverflow.com/questions/53134212/invalid-privatekey-when-using-jsch)):
 
```
 mkdir /tmp/ssh-keys
 ssh-keygen -m PEM -t rsa -C "test@mail.com" -f /tmp/ssh-keys/id_rsa
```
 
The public key in `/tmp/ssh-keys/id_rsa.pub` has to be added to the test user(s) `SSH Keys` in
Gerrit. Now, the host from which the latter runs may need public key scanning to become known.
This applies to the local user that runs the forthcoming `sbt` testing commands. An example
assuming `localhost` follows:
 
```
ssh-keyscan -t rsa -p 29418 localhost > ~/.ssh/known_hosts
```

### Input file
 
The `CloneUsingBothProtocols` scenario is fed with the data coming from the
`src/test/resources/data/com/google/gerrit/scenarios/CloneUsingBothProtocols.json` file. Such a
file contains the commands and repository used during the e2e test. That file currently looks like
below. This scenario serves as a simple example with no actual load in it. It can be used to test
or validate the local setup. More complex scenarios can be further developed, under the
`com.google.gerrit.scenarios` package. The uppercase keywords are set through
`environment properties`.
 
```
 [
   {
     "url": "ssh://admin@HOSTNAME:SSH_PORT/_PROJECT",
     "cmd": "clone"
   },
   {
     "url": "HTTP_SCHEME://HOSTNAME:HTTP_PORT/_PROJECT",
     "cmd": "clone"
   }
 ]
```
 
 Valid commands are:
* `clone`
* `fetch`
* `pull`
* `push`

### Project and HTTP credentials

The example above assumes that the `loadtest-repo` project exists in the Gerrit under test. The
`CloneUsingBothProtocols` scenario already includes creating that project and deleting it once done
with it. That scenario class can be used as an example of how a scenario can compose itself
alongside other scenarios (here, `CreateProject` and `DeleteProject`).

The `HTTP Credentials` or password obtained from test user's `Settings` (in Gerrit) may be
required, in `src/test/resources/application.conf`, depending on the above commands used. That
file's `http` section shows which shell environment variables can be used to set those credentials.

Executing the `CloneUsingBothProtocols` scenario, as is, does require setting the http credentials.
That is because of the aforementioned create/delete project (http) scenarios composed within it.

### Environment properties

The `JAVA_OPTS` environment variable
[can optionally be used](https://gatling.io/docs/current/cookbook/passing_parameters)
to define non-default values for keys found in scenario `json` data files. That variable can
currently be set with either one or many of these supported properties, from the core framework:

* `-Dcom.google.gerrit.scenarios.hostname=localhost`
* `-Dcom.google.gerrit.scenarios.ssh_port=29418`
* `-Dcom.google.gerrit.scenarios.http_port=8080`
* `-Dcom.google.gerrit.scenarios.http_scheme=http`

Above, the properties can be set with values matching specific deployment topologies under test.
The name of the property corresponds to the uppercase keyword found in the json file. For example,
`hostname` above will set the value of `HOSTNAME` in the
`aforementioned example`.

The example values shown above are the currently coded default ones. For example, the `http` scheme
above could be replaced with `https`. The framework may support differing or more properties over time.

#### Replication delay

The `replication_delay` property allows test scenario steps to wait for that many seconds, prior to
expecting a done replication. Its default is `15` seconds and can be set using another value:

* `-Dcom.google.gerrit.scenarios.replication_delay=15`

There is a short time buffer added to this property. Now, the replication starts after replication
plugin's own `replicationDelay`, in seconds, and typically takes some more seconds to complete.
That whole replication time depends on the system under test. Therefore, this property here should
be set to a value high enough, so that the test checks for a done replication at the right time.

#### Automatic properties
 
The `example keywords` also include `_PROJECT`,
prefixed with an underscore, which means that its value gets automatically generated by the
scenario. Any property setting for it is therefore not applicable. Its usage differs from the
non-prefixed `PROJECT` keyword, in that sense. Using the latter instead in json files requires
setting this `JAVA_OPTS` property:

* `-Dcom.google.gerrit.scenarios.project=myOwnTestRepoProjectName`

Other automatic keys may be used and implemented, always prefixed with an underscore that tells so.

#### Plugin scenarios

Plugin or otherwise non-core scenarios can also use such properties. The core java package
`com.google.gerrit.scenarios` from the example above has to be replaced with the one under which
those scenario classes are. Such extending scenarios can also add extension-specific properties.

Examples of this can be found in these Gerrit plugins test code:

* `[gc-conductor](https://gerrit.googlesource.com/plugins/gc-conductor)`
* `[high-availability](https://gerrit.googlesource.com/plugins/high-availability)`
* `[multi-site](https://gerrit.googlesource.com/plugins/multi-site)`
* `[rename-project](https://gerrit.googlesource.com/plugins/rename-project)`

#### Power factor

The following core property can be optionally set depending on the runtime environment. The test
environments used as reference for scenarios development assume its default value, `1.0`. For
slower or more complex execution environments, the value can be increased this way for example:

* `-Dcom.google.gerrit.scenarios.power_factor=1.5`

This will make the scenario steps take half more time to expect proper completion. A value smaller
than the default, say `0.8`, will make scenarios wait somewhat less than how they were developed.
Scenario development is often done using locally running Gerrit systems under test, which are
sometimes dockerized.

#### Number of users

The `number_of_users` property can be used to scale scenario steps to run with the specified number
of concurrent users. The value of this property remains `1` by default. For example, this sets the
number of concurrent users to 10:

* `-Dcom.google.gerrit.scenarios.number_of_users=10`

This will make scenarios that support the `number_of_users` property to inject that many users
concurrently for load testing.

## How to run tests

Run all tests:
```
sbt "gatling:test"
```

Run a single test:
```
sbt "gatling:testOnly com.google.gerrit.scenarios.CloneUsingBothProtocols"
```

Generate the last report:
```
sbt "gatling:lastReport"
```
The `src/test/resources/logback.xml` file
[configures](http://logback.qos.ch/manual/configuration.html)
Gatling's logging level. To quickly enable
[detailed logging](https://gatling.io/docs/current/general/debugging#logback)
of `http` requests and responses, the `root level` can be set to `trace` in that file.

### How to run using Docker

```
docker run -it e2e-tests -s com.google.gerrit.scenarios.CloneUsingBothProtocols
```

### How to run non-core scenarios

Locally adding non-core scenarios, for example from Gerrit plugins, is as simple as copying such
files in. Copying is necessary over linking, unless running using Docker (above) is not required.
Docker does not support links for files it has to copy over through the Dockerfile (here, the
scenario files). Here is how to proceed for adding such external (e.g., plugin) scenario files in:

```
pushd e2e-tests/src/test/scala
cp -r (or, ln -s) scalaPackageStructure .
popd

pushd e2e-tests/src/test/resources/data
cp -r (or, ln -s) jsonFilesPackageStructure .
popd
```

The destination folders above readily git-ignore every non-core scenario file added under them. If
running using Docker, `e2e-tests/Dockerfile` may require another `COPY` line for the hereby added
scenarios. Aforementioned `sbt` or `docker` commands can then be used to run the added tests.
