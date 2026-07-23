---
type: SysML v2 Concept
title: Merge Node
description: A merge node is a control node action usage that has one or more incoming successions and one outgoing succession, allowing the connected action to start when any one incoming action has completed.
timestamp: 2026-07-01T00:00:00Z
---

A merge node is a special kind of action usage declared using the keyword `merge`. It is a concrete specialization of the abstract action usage `ControlAction` from the `Actions` library model, specifically defined as `Actions::MergeAction`.

A merge node has one or more incoming successions and one outgoing succession. The action connected to the outgoing succession cannot start until **any one** of the actions connected to an incoming succession has completed. This contrasts with a join node, which requires all incoming actions to complete.

A merge node can only be declared within the body of an action definition or usage.

# Syntax

```sysml
// Merge node combining results from two branches
merge merge1;

action action3;
then merge1;

action action4;
then merge1;

merge1;
then terminate;
```

# Semantics

A merge node joins multiple alternative incoming control flows into a single outgoing flow. It is typically used to bring together the branches of a decision node. After any one of the incoming actions completes, the merge node becomes ready and the outgoing action may start.

A merge node implicitly subsets `Actions::Action::merges` and inherits the definition `Actions::MergeAction`.

# Rules

- Declared using the keyword `merge` within an action body.
- Must have one or more incoming successions.
- Must have exactly one outgoing succession.
- Incoming successions to a merge node must have source multiplicity `0..1` and subset the `incomingHBLink` feature inherited from `ControlPerformances::MergePerformance`.
- A control node is always composite; the `ref` keyword is never used.
- A control node body may only contain annotating elements.

# Examples

```sysml
first join1 then decision1;
decide decision1;
then action3;
then action4;

action action3;
then merge1;

action action4;
then merge1;

merge merge1;
then terminate;
```

# Relationships

- [decision-node.md](decision-node.md) — decision nodes typically precede merge nodes
- [fork-node.md](fork-node.md) — fork nodes split; merge nodes join alternatives
- [join-node.md](join-node.md) — join nodes require all incoming paths to complete
- [succession.md](succession.md) — merge nodes are connected via successions
- [action.md](action.md) — control nodes are a kind of action usage

# Citations

[1] OMG SysML v2 Specification, §7.17.3
