---
type: SysML v2 Concept
title: Message
description: A message is an abstract flow usage that specifies a transfer of payload between source and target occurrences without specifying how the payload is obtained from the source or delivered to the target.
timestamp: 2026-07-01T00:00:00Z
---

A message is a kind of flow usage declared using the keyword `message`. It specifies that some transfer happens between source and target ends and can optionally constrain the payload type, but does not specify how the payload is obtained from the source or delivered to the target. Messages are typically used to model abstract logical interactions between part usages, which may be realized in a more detailed model using streaming or succession flows.

A message is always abstract, whether or not the `abstract` keyword is included explicitly. A message declaration may identify source and target events at which a transfer may be initiated and received, using the keywords `from` and `to`. Alternatively, if source and target event identification is omitted, the message declaration may include a feature value.

# Syntax

```sysml
// Message with payload type
message of ControlSignal from controller.sendControl to engine.receiveControl;

// Named message with payload name and type
message msg1 from part1.ev1 to part2.ev2;

// Unnamed message with only payload type
message of item1 : Item1 from part1.ev1 to part2.ev2;
```

# Semantics

A message specifies only that a transfer of a given payload type can occur from a source event occurrence to a target event occurrence. It does not prescribe the mechanism by which the payload is transferred. Messages are used in high-level interaction models (e.g., sequence diagrams) and may be refined into streaming or succession flows in detailed behavior models.

# Rules

- A message is always abstract (even without the `abstract` keyword).
- If explicit defining flow usages are declared for a message, they must be abstract and have no end features.
- A message does not explicitly identify the interacting source and target occurrences (only the source and target events).
- The keyword `message` is used instead of `flow` to declare a message.
- The base flow usage for a message is `messages` from the `Flows` library model.

# Examples

```sysml
part def Vehicle {
    attribute def ControlSignal;
    part controller { event occurrence sendControl; }
    part engine { event occurrence receiveControl; }
    message of ControlSignal from controller.sendControl to engine.receiveControl;
}

occurrence {
    part part1 : Part1 { event occurrence ev1; }
    part part2 : Part2 { event occurrence ev2; }
    message msg1 from part1.ev1 to part2.ev2;
}
```

# Relationships

- [flow.md](flow.md) — a message is an abstract kind of flow usage
- [item-flow.md](item-flow.md) — item flows are concrete flows that realize messages
- [send-action.md](send-action.md) — send/accept actions provide an alternative messaging mechanism

# Citations

[1] OMG SysML v2 Specification, §7.16
