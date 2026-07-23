---
type: SysML v2 Concept
title: If Action
description: An if action usage is a structured control action that evaluates a condition expression and performs a then-clause action if true, or optionally an else-clause action if false.
timestamp: 2026-07-01T00:00:00Z
---

An if action usage is an action usage implicitly defined by one of the action definitions `IfThenAction` or `IfThenElseAction` from the `Actions` model. Its behavior is to first evaluate the condition expression. If the result is `true`, the then-clause is performed; otherwise the else-clause is performed, if there is one.

In the textual notation, an if action usage consists of:
- An optional action declaration part
- The keyword `if` followed by a Boolean-valued condition expression
- A **then clause** action usage (body required in curly braces `{...}`)
- Optionally, the keyword `else` followed by an **else clause** action usage

If the if action usage does not include a declaration part, the leading `action` keyword can be omitted. If a clause has no declaration part, the `action` keyword can also be omitted.

# Syntax

```sysml
// If-then with action declaration parts
action test if speed < lowerLimit
    action increase : IncreaseSpeed { }
else
    action main : MaintainSpeed { }

// Inline form (no names)
if selectedSensor != null {
    assign reading := selectedSensor.reading;
} else {
    assign reading := undefinedValue;
}

// else-if chaining
if threat.level == high then {
    perform soundAlarm { in cause = threat; }
} else if threat.level == medium then {
    action sendNotification { in msg = threat; }
} else {
    action beginMonitoring { in target = threat; }
}
```

# Semantics

The condition expression is evaluated once when the if action usage starts. If it evaluates to `true`, the then-clause is performed; if it evaluates to `false` and an else-clause exists, the else-clause is performed. For an `else if` structure, the else-clause is itself an if action usage.

# Rules

- Only the basic form of action declaration can be used for clauses, except that the else-clause may itself be an if action usage (allowing else-if chains).
- Each clause body must be given using curly braces `{...}`; a semicolon is not allowed for an empty body.
- If the if action usage has no declaration part, the leading `action` keyword can be omitted.
- Defined by `IfThenAction` (no else) or `IfThenElseAction` (with else).

# Examples

```sysml
action {
    inout attribute a : Integer;
    action ifThenAction if a < 0 {
        assign a := -a;
    }
}

action {
    in attribute a : Integer;
    out attribute b : Integer;
    action ifThenElseAction if a >= 20 {
        assign b := 100;
    } else {
        assign b := 0;
    }
}
```

# Relationships

- [action-usage.md](action-usage.md) — if action is a kind of action usage
- [while-loop-action.md](while-loop-action.md) — another structured control action
- [for-loop-action.md](for-loop-action.md) — another structured control action
- [assign-action.md](assign-action.md) — commonly used inside if clause bodies

# Citations

[1] OMG SysML v2 Specification, §7.17.11
