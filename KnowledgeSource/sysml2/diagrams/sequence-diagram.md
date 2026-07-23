---
type: SysML v2 Diagram
title: Sequence Diagram
description: A Sequence Diagram (Interaction View) shows the time-ordered exchange of messages between part usages, representing occurrences as lifelines and message flows between them.
timestamp: 2026-07-01T00:00:00Z
---

The Sequence Diagram in SysML v2 is the interaction or sequence view, showing messages exchanged between occurrence usages (most commonly part usages) over time. It is the analog of the UML Sequence Diagram. Messages are modeled as flow usages (specifically message usages) between event occurrences on the participating parts.

A message specifies that some transfer happens between a source and target end, defining the payload that is to be transferred but not specifying how the payload is obtained from the source or delivered to the target. Messages are always abstract.

# Purpose

Sequence diagrams are used to:
- Show the time-ordered exchange of messages between parts or other occurrences.
- Illustrate interaction scenarios for use cases and system behaviors.
- Show how request-response patterns, events, and signals are exchanged.
- Show event occurrences on each participant's lifeline as source and target of messages.
- Complement action flow diagrams with a communications-centric perspective.

# Notation

## Lifelines

Each participating occurrence (typically a part usage) is shown as a vertical dashed line with a rectangle at the top containing the participant's name and type:

```
«part»
part1 : Part1
```

The lifeline extends downward, representing the time axis (time increases downward).

## Messages

A message is shown as a horizontal arrow between two lifelines, labeled with the message name and optional payload type. The arrow points from the sending part to the receiving part:

```
part1 : Part1  ——msg1——>  part2 : Part2
```

In textual notation, messages are declared with event occurrences on each participating part:

```
occurrence {
    part part1 : Part1 {
        event occurrence ev1;
    }
    part part2 : Part2 {
        event occurrence ev2;
    }
    message msg1 from part1.ev1 to part2.ev2;
}
```

The message payload type can be optionally declared:

```
message of Item1 from part1.ev1 to part2.ev2;
```

## Sequence / Ordering

The vertical position of message arrows on the lifelines represents their temporal ordering. Messages at the top occur before those lower down.

## Self-Messages

A message from a part to itself is shown as an arrow that leaves and returns to the same lifeline.

# Frame and Header

The diagram frame header for a sequence diagram typically uses the identifier `occurrence` or a context-specific identifier. The outer occurrence context groups the participants and messages.

# Compartments

In the sequence view, participants are shown as lifeline rectangles; their internal states or nested actions are not typically shown in compartments in this view. The message label may include the payload type using `of <Type>` notation.

# Examples

```
// Textual notation for a sequence scenario
occurrence {
    part part1 : Part1 {
        event occurrence ev1;
    }
    part part2 : Part2 {
        event occurrence ev2;
    }
    message msg1 from part1.ev1 to part2.ev2;
}
```

Request-response pattern:
```
part def DistributedSystem {
    item def Request;
    item def Response;
    part client {
        port clientPort;
        action clientBehavior {
            send new Request() via clientPort;
            then accept Response via clientPort;
        }
    }
    part server {
        port serverPort;
        action serverBehavior {
            accept Request via serverPort;
            then send new Response() via serverPort;
        }
    }
    interface client.clientPort to server.serverPort;
}
```

# Related Concepts

- [Flow Typing Rules](../rules/flow-typing-rules.md)
- [Action Flow Diagram](action-flow-diagram.md)
- [Feature Direction](../rules/feature-direction.md)

# Citations

[1] OMG SysML v2 Specification, §7.16.1 (Flows and Messages Overview), Message (in Sequence View)
[2] OMG SysML v2 Specification, §7.16.2 (Flow Definitions and Usages)
[3] OMG SysML v2 Specification, Table 14 (Flows and Messages – Representative Notation)
