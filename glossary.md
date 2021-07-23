:linkattrs:
# Glossary

## Event

It refers to the [com.google.gerrit.server.events.Event](https://gerrit.googlesource.com/gerrit/+/refs/heads/master/java/com/google/gerrit/server/events/Event.java)
base abstract class representing any possible action that is generated or
received in a Gerrit instance. Actions can be associated with change set status
updates, project creations, indexing of changes, etc.

## Event broker

Distributes Gerrit Events to listeners if they are allowed to see them.

## Event dispatcher

Interface for posting events to the Gerrit event system. Implemented by default
by [com.google.gerrit.server.events.EventBroker](https://gerrit.googlesource.com/gerrit/+/refs/heads/master/java/com/google/gerrit/server/events/EventBroker.java).
It can be implemented by plugins and allows to influence how events are managed.

## Event hierarchy

Hierarchy of events representing anything that can happen in Gerrit.

## Event listener

API for listening to Gerrit events from plugins, without having any
visibility restrictions.

## Stream events

Command that allows a user via CLI or a plugin to receive in a sequential way
some events that are generated in Gerrit. The consumption of the stream by default
is available via SSH connection.
However, plugins can provide an alternative implementation of the event
brokering by sending them over a reliable messaging queueing system (RabbitMQ)
or a pub-sub (Kafka).

GERRIT
------
Part of link:index.html[Gerrit Code Review]

SEARCHBOX
---------
