---
type: SysML v2 Concept
title: State Usage
description: A state usage is a usage of a state definition that represents a particular state within a behavioral context, inheriting entry, do, and exit actions and participating in transitions.
timestamp: 2026-07-01T00:00:00Z
---

A state usage is a usage of a state definition. State usages are used to describe state-based behavior, where the execution of a particular state is triggered by events. A state usage can contain entry, do, and exit actions and may hierarchically contain nested state usages.

A state usage can be a feature of a part definition or usage, and a part can exhibit a state by referencing the state usage or by containing an owned state usage. In a non-parallel composite state, exactly one substate usage is active at any point in time after completion of the entry action. The initial substate is indicated by a succession from the entry action.

# Syntax

```sysml
state state1 : StateDef1;

state state1 : StateDef1 {
    /* members */
}

// With entry, do, exit actions
state state1 : StateDef1 {
    entry action1;
    do action2;
    exit action3;
}

// Hierarchical substates
state compositeState1 {
    entry ; then state1;
    state state1;
    transition
        first state1
        accept trigger1
        if guard1
        do action1
        then state2;
    state state2;
    then done;
}
```

# Semantics

A state usage inherits parameters from its state definition(s). Substates are exclusive by default (exactly one active at a time). The initial substate is entered on completion of the entry action, as indicated by a succession from the entry action to that substate.

# Rules

- Declared using the keyword `state` within an appropriate context.
- An action usage must only be defined by state definitions (or action definitions/KerML behaviors).
- At most one entry, one do, and one exit action may be declared.
- For a parallel state usage (`parallel` keyword before the body), substates execute concurrently; no transitions between them.
- The base state usage is `stateActions` from the `States` library model.

# Examples

```sysml
state state1 : StateDef1 [1..*] ordered nonunique;

state compositeState2 parallel {
    state state1 { entry ; then 'state1.1'; state 'state1.1'; }
    state state2 { entry ; then 'state2.1'; state 'state2.1'; }
}
```

# Relationships

- [state-definition.md](state-definition.md) — the definition that types this state usage
- [state.md](state.md) — general concept of a state
- [transition.md](transition.md) — transitions connect state usages
- [exhibit-state.md](exhibit-state.md) — parts exhibit state usages via exhibit state usages
- [action-usage.md](action-usage.md) — state usage is a specialization of action usage

# Citations

[1] OMG SysML v2 Specification, §7.18.2
