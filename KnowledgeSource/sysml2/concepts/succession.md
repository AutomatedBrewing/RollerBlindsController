---
type: SysML v2 Concept
title: Succession
description: A succession is a relationship that asserts a time ordering between two occurrence usages, specifying that one occurrence must complete before another can start.
timestamp: 2026-07-01T00:00:00Z
---

A succession is a relationship between two occurrence usages that asserts a time ordering: the source occurrence must complete before the target occurrence can start. Within the body of an action definition or usage, successions specify the sequencing of sub-action usages.

A succession between action usages may additionally have a **guard condition**, represented as a Boolean expression. If the succession has a guard, then the time ordering of the source and target is only asserted when the guard condition evaluates to `true`. A conditional succession is called a **transition usage** in the context of state models.

Every action inherits the features `start` and `done` from the base action definition `Actions::Action`, representing the start and end snapshots of the action.

# Syntax

```sysml
// Basic succession (explicit form)
succession first action1 then action2;

// Guard condition
succession conditionalOnActive
    first initialize if isActive then monitor;

// Then shorthand (lexically chained)
first action1;
then action2;

// Then shorthand after a declaration
first action1;
then action action2;

// Multiple successions from a fork (both share fork1 as source)
fork fork1;
then action1;
then action2;

// else shorthand for conditional successions
decide ;
if level <= refillLevel then refill;
if level >= maxLevel then drain;
else continue;
```

# Semantics

The `first` keyword identifies the source of a succession and the `then` keyword identifies the target. The `then` shorthand finds the nearest lexically previous occurrence usage as the source. Multiple `then` declarations after a common source create multiple successions from that source.

For a succession with a guard, a transition usage is declared that evaluates the guard expression. If the guard is `true`, the succession is asserted. If `false`, the target action is not started.

# Rules

- A succession source must be an occurrence usage.
- A succession is not an occurrence usage, allowing multiple `then` declarations after a common source.
- Guard conditions are Boolean-valued expressions preceded by `if`.
- The `else` keyword may be used to indicate a succession taken if all preceding guards evaluate to `false`.
- The target of a conditional succession must be specified as a qualified name or feature chain.
- The base succession definition is from the KerML library.

# Examples

```sysml
first start;
then merge 'loop';
then action initialize;
then action monitor;
then action finalize;
then 'loop';

succession conditionalOnActive first initialize if isActive then monitor;
```

# Relationships

- [action.md](action.md) — successions sequence action usages
- [fork-node.md](fork-node.md) — fork nodes use multiple outgoing successions
- [join-node.md](join-node.md) — join nodes use multiple incoming successions
- [decision-node.md](decision-node.md) — decision nodes use guarded outgoing successions
- [merge-node.md](merge-node.md) — merge nodes use multiple incoming successions
- [transition.md](transition.md) — conditional successions are transition usages in state models

# Citations

[1] OMG SysML v2 Specification, §7.17.4, §7.17.5
