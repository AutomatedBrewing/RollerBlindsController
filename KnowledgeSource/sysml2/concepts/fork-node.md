---
type: SysML v2 Concept
title: Fork Node
description: A fork node is a control node action usage that has one incoming succession and one or more outgoing successions, initiating concurrent execution of all connected downstream actions simultaneously.
timestamp: 2026-07-01T00:00:00Z
---

A fork node is a special kind of action usage declared using the keyword `fork`. It is a concrete specialization of the abstract action usage `ControlAction` from the `Actions` library model, specifically defined as `Actions::ForkAction`.

A fork node has one incoming succession and one or more outgoing successions. The actions connected to the outgoing successions cannot start until the action connected to the incoming succession has completed. Once the incoming action completes, all downstream actions start concurrently.

A fork node can only be declared within the body of an action definition or usage.

# Syntax

```sysml
// Fork node starting two concurrent actions
fork fork1;
first fork1 then action1;
first fork1 then action2;

// Using 'then' shorthand (both successions share fork1 as source)
fork fork1;
then action1;
then action2;
```

# Semantics

A fork node splits a single incoming control flow into multiple concurrent outgoing flows. All downstream actions begin concurrently after the incoming action completes. A fork node is typically paired with a join node that synchronizes the concurrent branches.

A fork node implicitly subsets `Actions::Action::forks` and inherits the definition `Actions::ForkAction`.

# Rules

- Declared using the keyword `fork` within an action body.
- Must have exactly one incoming succession.
- Must have one or more outgoing successions.
- Outgoing successions from a fork node must have target multiplicity `1..1`.
- A control node is always composite; the `ref` keyword is never used.
- A control node body may only contain annotating elements.

# Examples

```sysml
// Both action1 and action2 proceed concurrently after fork1.
fork fork1;
first fork1 then action1;
first fork1 then action2;

action action1;
then join1;

action action2;
then join1;

// join1 is performed after both action1 and action2 have completed.
join join1;
```

# Relationships

- [join-node.md](join-node.md) — join nodes synchronize branches started by a fork
- [decision-node.md](decision-node.md) — decision nodes choose one branch; fork nodes split into all branches
- [merge-node.md](merge-node.md) — merge nodes collect alternative branches
- [succession.md](succession.md) — fork nodes are connected via successions
- [action.md](action.md) — control nodes are a kind of action usage

# Citations

[1] OMG SysML v2 Specification, §7.17.3
