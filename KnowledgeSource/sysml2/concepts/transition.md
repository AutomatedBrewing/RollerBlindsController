---
type: SysML v2 Concept
title: Transition
description: A transition usage is a kind of action usage that connects a source state usage to a target state usage, enabling a change of active state when triggered by an event, guarded by a condition, and optionally performing an effect action.
timestamp: 2026-07-01T00:00:00Z
---

A transition usage is a kind of action usage that can be used within non-parallel states to connect a source state usage to a target state usage. It declares that it is possible to transition from a performance of the source state to a new performance of the target state.

A transition usage is implicitly defined by the action definition `StateTransitionAction` from the `States` library model. It is identified with the keyword `transition`. Source and target states are identified using `first` and `then`, respectively.

A transition usage may optionally have:
- An **accepter** (accept action usage): the trigger for the transition.
- A **guard condition** (Boolean expression after `if`): the transition is only enabled when the guard is `true`.
- An **effect action** (after `do`): performed if the transition is triggered.

# Syntax

```sysml
// Basic transition
transition off_on first off then on;

// With accepter
transition off_on
    first off
    accept TurnOn via commPort
    then on;

// With accepter and guard
transition off_on
    first off
    accept TurnOn via commPort
    if isEnabled
    then on;

// With accepter, guard, and effect
transition off_on
    first off
    if isEnabled
    accept TurnOn via commPort
    do action powerUp : PowerUp;
    then on;

// Shorthand (transition keyword and source omitted)
state off;
accept TurnOn via commPort
if isEnabled
do action powerUp : PowerUp;
then on;
```

# Semantics

A transition usage is triggered under the following conditions:
1. Only during a performance of its source state.
2. If it has a guard expression, it must evaluate to `true`.
3. If it has an accepter and the conditions above are met, it is triggered when the accepter accepts an incoming transfer.

When triggered, the transition executes as follows:
1. If the source state's do action is still running, it is interrupted.
2. If the source state has an exit action, it is performed.
3. If the transition has an effect action, it is performed.
4. If the target state has an entry action, it is performed.
5. If the target state has a do action, it is performed.

A transition to `done` indicates the source state is the final state of the containing state performance. A transition to a terminate action immediately terminates the containing state performance.

# Rules

- Declared using the keyword `transition` within a non-parallel state body.
- The source of a transition usage must be a state usage, but the target may be any action usage (including `done` or a terminate action).
- An entry action can have outgoing transitions, but they have the semantics of conditional successions.
- A transition usage with a source that is not a state usage is not allowed to have an accepter.
- Shorthand: `transition` keyword and source can be omitted; the source is the closest lexically previous state usage.
- No transitions are allowed between the concurrent substates of a parallel state.

# Examples

```sysml
state def OnOff2 {
    port commPort;
    entry ; then off;

    state off;
    state on;

    transition off_on
        first off
        accept TurnOn via commPort
        then on;

    transition on_off
        first on
        accept after 5[min]
        then off;
}
```

# Relationships

- [state-usage.md](state-usage.md) — transitions connect state usages
- [accept-action.md](accept-action.md) — accept actions serve as transition triggers
- [succession.md](succession.md) — transitions are a kind of conditional succession
- [state-definition.md](state-definition.md) — transitions appear within state definitions

# Citations

[1] OMG SysML v2 Specification, §7.18.3
