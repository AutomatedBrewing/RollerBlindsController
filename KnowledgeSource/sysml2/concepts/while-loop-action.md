---
type: SysML v2 Concept
title: While Loop Action
description: A while loop action usage is a structured control action that repeatedly performs a body clause as long as a while condition is true and an optional until condition remains false.
timestamp: 2026-07-01T00:00:00Z
---

A while loop action usage is an action usage implicitly defined by the `WhileLoopAction` specialization of `LoopAction` from the `Actions` model. Its behavior is to repeatedly perform the body clause as long as the while expression evaluates to `true` and the until expression (if present) evaluates to `false`.

The while expression is evaluated before the first iteration. The until expression is not evaluated until after the first iteration (if the while expression evaluates to `true`).

The body clause is itself notated as an action usage, with its body required to be given using curly braces `{...}`; a semicolon is not allowed for an empty body.

# Syntax

```sysml
// Full form with while and until
action advance while t < endTime
action step {
    perform advanceState { :>> stateVector = systemState; :>> deltaT = dt; }
    then assign t := t + dt;
} until stateVector.position >= endPosition;

// Without action keyword
while not ready {
    assign ready := poll(device);
}

// 'loop' as shorthand for 'while true'
loop {
    assign charge := MonitorBattery();
    then if charge < 100 {
        action AddCharge;
    }
} until charge >= 100;
```

# Semantics

The `while` expression is evaluated before each iteration. If `true`, the body clause is performed. After the body clause completes (if the while expression was `true`), the `until` expression (if present) is evaluated. If the `until` expression is `true`, the loop terminates. The keyword `loop` is shorthand for `while true`, useful for non-terminating loops or loops terminated only by an `until` condition.

# Rules

- Implicitly defined by `WhileLoopAction`.
- The body clause body must use curly braces `{...}`; a semicolon is not allowed for an empty body.
- The `action` keyword may be omitted for the loop itself and/or the body clause if they have no action declaration part.
- `loop` is shorthand for `while true`.

# Examples

```sysml
action actionWithLoop2 {
    in attribute x : Integer;
    out attribute y : Integer;
    attribute increment : Integer = 1;

    first start;
    then assign y := 0;
    then action loop2 while x < 10 {
        assign y := 2*x;
        then assign x := x + increment;
    }
    then done;
}
```

# Relationships

- [action-usage.md](action-usage.md) — while loop is a kind of action usage
- [for-loop-action.md](for-loop-action.md) — another kind of loop action
- [if-action.md](if-action.md) — another structured control action

# Citations

[1] OMG SysML v2 Specification, §7.17.12
