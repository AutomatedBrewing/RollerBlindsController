---
type: SysML v2 Concept
title: State
description: A state is an occurrence over time that defines conditions under which other actions can execute, with optional entry, do, and exit actions, and transitions to other states triggered by events.
timestamp: 2026-07-01T00:00:00Z
---

A state is classified by a state definition and used to describe state-based behavior, where the execution of a particular state is triggered by events. A state definition or usage can contain specially identified action usages that are performed while the state is activated:

- An **entry action** starts when the state is activated.
- A **do action** starts after the entry action completes and continues while the state is active.
- An **exit action** starts when the state is exited; the state becomes inactive once the exit action completes.

States can be decomposed into lower-level states to create a hierarchy. In a non-parallel state with substates, exactly one substate is active at any point in time after completion of the entry action.

A **parallel state** (declared with the `parallel` keyword) has substates that are performed concurrently. No transitions are allowed between substates of a parallel state.

# Syntax

```sysml
state def StateDef1;

state state1 : StateDef1;

state state1 : StateDef1 {
    entry action1;
    do action2;
    exit action3;
}

// Parallel state
state def VehicleStates parallel {
    state OperationalStates;
    state HealthStates;
}
```

# Semantics

States follow the same patterns as structural elements. A state definition classifies state performances; a state usage exhibits state-based behavior. When a state is activated, its entry action runs first, then the do action, and when a transition is triggered, the do action is interrupted, the exit action runs, then the transition effect action runs, and then the target state's entry action runs.

# Rules

- A state definition is declared like an action definition but using the keyword `state`.
- Entry, do, and exit actions can each be declared at most once in a state definition or usage.
- The initial substate is indicated by a succession from the entry action to that substate.
- A parallel state (with `parallel` keyword) has concurrently performed substates; no transitions between them.
- The base state definition and usage are `StateAction` and `stateActions` from the `States` library model.

# Examples

```sysml
state def OperationalStates {
    entry action initial;
    then off;

    state off;
    state starting;
    state on;
}
```

# Relationships

- [state-definition.md](state-definition.md) — the definition that classifies a state
- [state-usage.md](state-usage.md) — a usage of a state definition
- [transition.md](transition.md) — transitions connect states and trigger activations
- [exhibit-state.md](exhibit-state.md) — parts exhibit states via exhibit state usages
- [action.md](action.md) — state is a specialization of action

# Citations

[1] OMG SysML v2 Specification, §7.18
