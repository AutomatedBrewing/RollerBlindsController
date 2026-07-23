---
type: SysML v2 Concept
title: Decision Node
description: A decision node is a control node action usage that has one incoming succession and one or more outgoing successions, allowing exactly one downstream action to start after the incoming action completes.
timestamp: 2026-07-01T00:00:00Z
---

A decision node is a special kind of action usage declared using the keyword `decide`. It is a concrete specialization of the abstract action usage `ControlAction` from the `Actions` library model, specifically defined as `Actions::DecisionAction`.

A decision node has one incoming succession and one or more outgoing successions. Exactly one of the actions connected to an outgoing succession can start after the action connected to the incoming succession has completed. Which downstream action is performed can be controlled by placing guards on the outgoing successions.

A decision node can only be declared within the body of an action definition or usage.

# Syntax

```sysml
// Decision node with guards on outgoing successions
decide decision1;
if level <= refillLevel then refill;
if level >= maxLevel then drain;
else continue;

// Or using then shorthand
then decide decision1;
then action3;
then action4;
```

# Semantics

A decision node joins a single incoming control flow and routes it to exactly one outgoing flow. Guards on the outgoing successions determine which branch is taken. If no guards are present, the choice is non-deterministic.

A decision node implicitly subsets `Actions::Action::decisions` and inherits the definition `Actions::DecisionAction`.

# Rules

- Declared using the keyword `decide` within an action body.
- Must have exactly one incoming succession.
- Must have one or more outgoing successions.
- Outgoing successions from a decide node must have target multiplicity `0..1` and subset the `outgoingHBLink` feature inherited from `ControlPerformances::DecisionPerformance`.
- A control node is always composite; the `ref` keyword is never used.
- A control node body may only contain annotating elements.

# Examples

```sysml
// Non-deterministic choice
decide decision1;
first decision1 then action3;
first decision1 then action4;

// Guarded choice
merge 'loop';
action checkLevel { out level; }
decide ;
if level <= refillLevel then refill;
if level >= maxLevel then drain;
else continue;
```

# Relationships

- [merge-node.md](merge-node.md) — merge nodes collect the branches a decision splits
- [fork-node.md](fork-node.md) — fork nodes split concurrently; decision nodes choose one branch
- [join-node.md](join-node.md) — join nodes synchronize concurrent branches
- [succession.md](succession.md) — decision nodes are connected via guarded successions
- [action.md](action.md) — control nodes are a kind of action usage

# Citations

[1] OMG SysML v2 Specification, §7.17.3
