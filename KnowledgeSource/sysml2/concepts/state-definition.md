---
type: SysML v2 Concept
title: State Definition
description: A state definition is a kind of action definition that defines conditions under which other actions can execute, classifying state performances with optional entry, do, and exit actions.
timestamp: 2026-07-01T00:00:00Z
---

A state definition is a kind of action definition (see §7.17) that defines the conditions under which other actions can execute. State definitions classify state performances and are used to describe state-based behavior, where execution of any particular state is triggered by events.

A state definition may contain:
- An **entry action** (declared with `entry action`) that starts when the state is activated.
- A **do action** (declared with `do action`) that starts after entry completes and continues while the state is active.
- An **exit action** (declared with `exit action`) that starts when the state is exited.

State definitions can be specialized and hierarchically contain state usages. A state definition may be declared as a **parallel state** by adding the keyword `parallel` before the body.

# Syntax

```sysml
state def StateDef1;

state def StateDef1 {
    /* members */
}

// With entry, do, and exit actions
state def Exercising {
    entry action warmup : WarmUp;
    do action exercise : Exercise {
        action strengthTraining;
        then action cardioTraining;
    }
    exit action cooldown : Cooldown;
}

// Parallel state definition
state def VehicleStates parallel {
    state OperationalStates;
    state HealthStates;
}
```

# Semantics

A state definition is a classifier for state performances. Each state definition specifies entry/do/exit actions, substates, and transitions. A specialized state definition inherits all properties of its general state definition(s). The initial substate is indicated by a succession from the entry action.

# Rules

- Declared using the keyword `state def`.
- At most one entry, one do, and one exit action may be declared.
- The `entry`, `do`, and `exit` keywords can be used without any action keyword; if followed by a qualified name, this is shorthand for reference subsetting.
- If the keyword `parallel` is added, the state definition becomes a parallel state with concurrently performed substates; no transitions allowed between those substates.
- The base state definition is `StateAction` from the `States` library model.

# Examples

```sysml
state def Operating {
    entry assign stateCode := StateCodes::Operating;
    do send new ReadySignal() to Controller;
}

state def OperationalStates {
    entry action initial;
    then off;
    state off;
    state starting;
    state on;
}
```

# Relationships

- [state.md](state.md) — general concept of a state
- [state-usage.md](state-usage.md) — usage typed by a state definition
- [action-definition.md](action-definition.md) — state definition is a kind of action definition
- [transition.md](transition.md) — transitions connect substates within a state definition

# Citations

[1] OMG SysML v2 Specification, §7.18.2
