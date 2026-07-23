---
type: SysML v2 Concept
title: Join Node
description: A join node is a control node action usage that has one or more incoming successions and one outgoing succession, requiring all incoming actions to complete before the downstream action can start.
timestamp: 2026-07-01T00:00:00Z
---

A join node is a special kind of action usage declared using the keyword `join`. It is a concrete specialization of the abstract action usage `ControlAction` from the `Actions` library model, specifically defined as `Actions::JoinAction`.

A join node has one or more incoming successions and one outgoing succession. The action connected to the outgoing succession cannot start until **all** the actions connected to the incoming successions have completed. This contrasts with a merge node, which requires only any one incoming action to complete.

A join node can only be declared within the body of an action definition or usage.

# Syntax

```sysml
// Join node synchronizing two concurrent branches
first action1 then join1;
first action2 then join1;
join join1;

// Then continue after join
first join1 then decision1;
```

# Semantics

A join node synchronizes multiple concurrent control flows into a single outgoing flow. It is typically used to collect the concurrent branches started by a fork node. The downstream action can only start once all incoming actions have completed.

A join node implicitly subsets `Actions::Action::joins` and inherits the definition `Actions::JoinAction`.

# Rules

- Declared using the keyword `join` within an action body.
- Must have one or more incoming successions.
- Must have exactly one outgoing succession.
- Incoming successions to a join node must have source multiplicity `1..1`.
- A control node is always composite; the `ref` keyword is never used.
- A control node body may only contain annotating elements.

# Examples

```sysml
// Both action1 and action2 will proceed concurrently after fork1.
fork fork1;
first fork1 then action1;
first fork1 then action2;

action action1;
action action2;

// join1 will be performed after both action1 and action2 have completed.
first action1 then join1;
first action2 then join1;
join join1;

first join1 then decision1;
```

# Relationships

- [fork-node.md](fork-node.md) — fork nodes start the concurrent branches that join nodes synchronize
- [merge-node.md](merge-node.md) — merge nodes collect alternative (non-concurrent) branches
- [decision-node.md](decision-node.md) — decision nodes route to one of multiple branches
- [succession.md](succession.md) — join nodes are connected via successions
- [action.md](action.md) — control nodes are a kind of action usage

# Citations

[1] OMG SysML v2 Specification, §7.17.3
