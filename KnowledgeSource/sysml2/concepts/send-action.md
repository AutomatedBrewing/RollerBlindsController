---
type: SysML v2 Concept
title: Send Action
description: A send action usage is an action usage that transfers a payload from a sender occurrence to a receiver occurrence.
timestamp: 2026-07-01T00:00:00Z
---

A send action usage is declared as an action usage implicitly defined by the action definition `SendAction` from the `Actions` library model. A `SendAction` has three input parameters:

1. A set of payload values.
2. A sender occurrence.
3. A receiver occurrence.

The behavior of a `SendAction` is to transfer the payload from the sender to the receiver.

In the textual notation, values for the three `SendAction` parameters are given after the action declaration part, identified by the keywords `send` (payload), `via` (sender), and `to` (receiver). If the declaration part is empty, the `action` keyword may be omitted.

# Syntax

```sysml
// Named send action with payload, sender, and receiver
action sendReading send getReading.reading via monitor to destination;

// Unnamed send action (keyword can be omitted)
send getReading.reading via monitor to destination;

// Sending via a port (sender is the port)
send getReading.reading via readingPort;

// Sending to an explicit destination
send getReading.reading to destination;
```

# Semantics

A send action usage can specify both a sender (`via`) and receiver (`to`), but generally gives only one or the other. When directly or indirectly a composite feature of a part definition or usage, the default sender (`via`) is the containing part — this is the **default sending context**.

If the send action usage is not in the composition hierarchy of a part definition or usage (or item definition or usage), the sending context is the highest-level containing action usage. A perform action usage is always referential, so the sending context for sub-actions of a perform action usage is the perform action usage itself, not the containing part.

When sending through a port, the port usage will usually be the sender (`via`), with the actual receiver determined by interface connections having the port usage as their source.

# Rules

- A send action usage must be an owned feature of an action definition/usage, the entry/do/exit action of a state, or the owned effect action of a transition usage.
- When sending via a port, the send action is allowed to also include an explicit receiver (`to`), but it must be another port connected to the sending port.
- Declared using the keyword `send` (plus optional `action` keyword).
- The base send action usage is `sendActions` from the `Actions` library model.

# Examples

```sysml
part def MonitorDevice {
    port readingPort;
    action monitoring {
        perform getReading { out reading : SensorReading; }
        send getReading.reading via readingPort;
    }
}

action sendPicture send {
    in picture :>> payload = shoot.picture;
    in :>> sender = camera.displayPort;
}
```

# Relationships

- [accept-action.md](accept-action.md) — accept actions receive the payload sent by send actions
- [action-usage.md](action-usage.md) — send action is a kind of action usage
- [message.md](message.md) — messages provide an abstract alternative to send/accept

# Citations

[1] OMG SysML v2 Specification, §7.17.7
