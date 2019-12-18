# Gerrit Code Review - End to end load tests

This document provides a description of a Gerrit load test scenario implemented using the [`Gatling`](http://gatling.io) framework.

Similar scenarios have been successfully used to compare performance of different Gerrit versions or study the Gerrit response
under different load profiles.

## What is Gatling?

Gatling is a load testing tool which provides out of the box support for the HTTP protocol. Documentation on how to write an
HTTP load test can be found [`here`](https://gatling.io/docs/current/http/http_protocol/).

However, in the scenario we are proposing, we are leveraging the [`Gatling Git extension`](https://github.com/GerritForge/gatling-git)
to run tests at Git protocol level.

Gatling is written in Scala, but the abstraction provided by the Gatling DSL makes the scenarios implementation easy even without any Scala knowledge.

Examples of scenarios can be found in the `e2e-tests` directory.

### How to run the load tests

#### Prerequisites

* [`Scala 2.12`](https://www.scala-lang.org/download/)

#### How to build

```
sbt compile
```

#### Setup

If you are running SSH commands the private keys of the users used for testing need to go in `/tmp/ssh-keys`.
The keys need to be generated this way (JSch won't validate them [otherwise](https://stackoverflow.com/questions/53134212/invalid-privatekey-when-using-jsch):

```
ssh-keygen -m PEM -t rsa -C "test@mail.com" -f /tmp/ssh-keys/id_rsa
```

*NOTE*: Don't forget to add the public keys for the testing user(s) to your git server

#### Input file

The ReplayRecordsScenario is fed by the data coming from the [src/test/resources/data/requests.json](/src/test/resources/data/requests.json) file.
Such file contains the commands and repo used during the load test.
Below an example:

```
[
  {
    "url": "ssh://admin@localhost:29418/loadtest-repo.git",
    "cmd": "clone"
```
  {
    "url": "http://localhost:8080/loadtest-repo.git",
    "cmd": "fetch"
  }
]
```

Valid commands are:
* fetch
* pull
* push
* clone

#### How to use the framework

Run all tests:
```
sbt "gatling:test"
```

Run a single test:
```
sbt "gatling:testOnly com.google.gerrit.scenarios.ReplayRecordsFromFeederScenario"
```

Generate the last report:
```
sbt "gatling:lastReport"
```

