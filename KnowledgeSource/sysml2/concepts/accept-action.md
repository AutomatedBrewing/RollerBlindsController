---
type: SysML v2 Concept
title: Accept Action
description: An accept action usage is an action usage that accepts the transfer of a payload received by a given receiver occurrence and outputs that payload.
timestamp: 2026-07-01T00:00:00Z
---

An accept action usage is declared as an action usage implicitly defined by the action definition `AcceptAction` from the `Actions` library model. An `AcceptAction` has two parameters:

1. An output parameter for a set of payload values.
2. An input parameter giving a receiver occurrence.

The behavior of an `AcceptAction` is to accept the transfer of a payload received by the given receiver, and then output that payload.

When a send action performed in a source is matched with a compatible accept action in the destination, the transfer of values from source to destination is completed.

# Syntax

```sysml
// Named accept action with typed payload and receiver
action acceptReading accept reading : SensorReading via controller;

// Unnamed accept, just a type
accept SensorReading via controller;

// Without keyword when declaration part is empty
accept SensorReading;

// Change trigger: triggers when expression becomes true
accept when level > threshold;

// Absolute time trigger
accept at Iso8601DateTime("2024-02-01T00:00:00Z");

// Relative time trigger
accept after 30 [s];
```

# Semantics

The payload parameter declaration identifies the type of values accepted. If the payload parameter declaration has the form of a single qualified name (and optionally a multiplicity), the qualified name is the type (definition) of the payload parameter, not its name.

When directly or indirectly a composite feature of a part definition or usage, the default receiver (`via`) of the accept action is the containing part — this is the **default accepting context**. If not in a part composition hierarchy, the accepting context is the highest-level containing action usage.

Special triggers are supported:
- **Change trigger** (`when`): triggers when a Boolean expression changes from false to true.
- **Absolute time trigger** (`at`): triggers when the clock reaches a `TimeInstantValue`.
- **Relative time trigger** (`after`): triggers after a `DurationValue` has elapsed.

# Rules

- An accept action usage must be an owned feature of an action definition/usage, the entry/do/exit action of a state, or the owned accept/effect action of a transition usage.
- Declared using the keyword `accept` (plus optional `action` keyword).
- The base accept action usage is `acceptActions` from the `Actions` library model.

# Examples

```sysml
part def ControllerDevice {
    port sensorPort;
    action control {
        accept reading : SensorReading via sensorPort;
    }
}

action trigger1 accept scene : Scene via viewPort;
```

# Relationships

- [send-action.md](send-action.md) — send actions pair with accept actions to transfer payloads
- [action-usage.md](action-usage.md) — accept action is a kind of action usage
- [transition.md](transition.md) — accept actions are used as triggers in transition usages

# Citations

[1] OMG SysML v2 Specification, §7.17.8
