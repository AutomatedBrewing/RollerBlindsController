---
type: SysML v2 Concept
title: Calculation Definition
description: A calculation definition is a kind of action definition that specifies a reusable computation with a distinguished result parameter, classifying calculation usages.
timestamp: 2026-07-01T00:00:00Z
---

A calculation definition is a kind of action definition (see §7.17) that has a distinguished parameter with direction `out` called the **result parameter** (usually the only `out` parameter). A calculation definition specifies a reusable computation that returns a result in the result parameter.

A calculation definition is also a KerML function, which allows it to be invoked using KerML invocation expression notation. Calculation definitions are often used to define mathematical functions, in which case the computation should be **pure** (deterministic, no side effects).

The body of a calculation definition is like the body of an action definition, with the optional addition of a **result expression** at the end (written without a final semicolon), whose result is implicitly bound to the result parameter.

# Syntax

```sysml
calc def CalcDef1;

calc def CalcDef1 {
    /* members */
}

// With parameters and result
calc def Velocity {
    in v_i : VelocityValue;
    in a : AccelerationValue;
    in dt : TimeValue;
    return v_f : VelocityValue;
}

// With result expression in body
calc def Average {
    in scores[1..*] : Rational;
    return : Rational;
    sum(scores) / size(scores)
}

// Specialization with parameter redefinition
calc def Dynamics {
    in initialState : DynamicState;
    in time : TimeValue;
    return : DynamicState;
}
calc def VehicleDynamics specializes Dynamics {
    in initialState : VehicleState;
    in time : TimeValue;
    return : VehicleState;
}
```

# Semantics

A calculation definition classifies calculation usages. Its result parameter redefines the result parameters of any calculation definitions it specializes, regardless of parameter position. The result of a result expression is implicitly bound to the result parameter.

A **pure calculation** satisfies:
1. Same input values always produce the same result.
2. No side effects outside the calculation's own performance.
All subcalculations and subactions of a pure calculation must also be pure.

# Rules

- Declared using the keyword `calc def`.
- The result parameter is declared using `return` (or `out`); every calculation definition always has a result parameter.
- If specializing multiple calculation definitions, the result parameter redefines the result parameters of all those definitions.
- A result expression is written at the end of the body without a semicolon.
- If a result expression is present, the body should not also include a feature value on the result parameter.
- The base calculation definition is `Calculation` from the `Calculations` library model.

# Examples

```sysml
calc def Average {
    in scores[1..*] : Rational;
    return : Rational = sum(scores) / size(scores);
}
```

# Relationships

- [calculation.md](calculation.md) — general concept of a calculation
- [calculation-usage.md](calculation-usage.md) — usage typed by a calculation definition
- [action-definition.md](action-definition.md) — calculation definition is a kind of action definition
- [constraint-definition.md](constraint-definition.md) — constraint definitions are also KerML functions with a Boolean result

# Citations

[1] OMG SysML v2 Specification, §7.19.2
