---
type: SysML v2 Concept
title: For Loop Action
description: A for loop action usage is a structured control action that iterates over a sequence of values, assigning each value to a loop variable and performing a body clause once per value.
timestamp: 2026-07-01T00:00:00Z
---

A for loop action usage is an action usage implicitly defined by the `ForLoopAction` specialization of `LoopAction` from the `Actions` model. Its behavior is to first evaluate a sequence expression, then perform the body clause iteratively, assigning a loop variable to each value in the sequence for each iteration.

In the textual notation, the action declaration part is followed by the keyword `for`, which introduces a loop variable declaration, followed by the keyword `in` and a sequence expression, and after that a body clause.

The body clause is notated as an action usage with its body required to be given using curly braces `{...}`; a semicolon is not allowed for an empty body.

# Syntax

```sysml
// Named for loop with explicit body action
action dynamicScenario for power : PowerValue in powerProfile
action dynamicsStep {
    assign position := ComputeDynamics(position, power);
}

// Compact inline form
for power : PowerValue in powerProfile {
    assign position := ComputeDynamics(position, power);
}

// Using the .. operator for integer ranges
for i in 1..scenario->size() {
    assign positionList :=
        positionList->including(scenario.position#(i));
}
```

# Semantics

The sequence expression is evaluated once before the first iteration to produce a sequence of values. The body clause is then performed for each value in the sequence in order, with the loop variable assigned to the current value at the start of each iteration. The `..` operator can construct a sequence of `Integer` values between two bounds (inclusive).

# Rules

- Implicitly defined by `ForLoopAction`.
- The body clause body must use curly braces `{...}`; a semicolon is not allowed for an empty body.
- The `action` keyword may be omitted for the for loop itself and/or for the body clause, if they have no action declaration part.
- The loop variable is a reference to each element in the sequence for the duration of each iteration.

# Examples

```sysml
action actionWithLoop3 {
    in attribute n : Integer;
    out attribute y : Integer;

    first start;
    then assign y := 0;
    then action forLoop1 for i : Integer in 1..n {
        assign y := y + i;
    }
    then done;
}
```

# Relationships

- [action-usage.md](action-usage.md) — for loop is a kind of action usage
- [while-loop-action.md](while-loop-action.md) — another kind of loop action
- [if-action.md](if-action.md) — another structured control action

# Citations

[1] OMG SysML v2 Specification, §7.17.12
