---
type: SysML v2 Concept
title: Calculation
description: A calculation is an action usage that is typed by a calculation definition and computes a result value, functioning as a KerML expression that can be invoked with input parameters to produce an output.
timestamp: 2026-07-01T00:00:00Z
---

A calculation usage is an action usage that is a usage of a calculation definition. A calculation definition is a kind of action definition that has a distinguished parameter with direction `out` called the **result parameter** (usually the only `out` parameter). It specifies a reusable computation that returns a result.

In addition to parameters, a calculation definition or usage may have features that are calculation or action usages carrying out steps in the computation. The final result is specified as an expression in terms of the input parameters and any intermediate results. A calculation definition is also a KerML function, and a calculation usage is a KerML expression.

Calculation definitions are often used to define mathematical functions, in which case the defined computation should be **pure**: same inputs always produce same outputs, and no side effects.

# Syntax

```sysml
// Calculation definition
calc def Velocity {
    in v_i : VelocityValue;
    in a : AccelerationValue;
    in dt : TimeValue;
    return v_f : VelocityValue;
}

// Calculation usage
calc calc1 : CalcDef1 {
    expression1
}

// With inline result expression
calc def Average {
    in scores[1..*] : Rational;
    return : Rational;
    sum(scores) / size(scores)
}

// Equivalent using return feature value
calc def Average {
    in scores[1..*] : Rational;
    return : Rational = sum(scores) / size(scores);
}
```

# Semantics

A calculation definition or usage always has a result parameter, inherited if not owned. The result parameter can be declared using the keyword `return` instead of `out`. The body of a calculation may include a result expression at the end (written without a final semicolon), which is implicitly bound to the result parameter.

A calculation may also have the result bound explicitly using a feature value on the result parameter declaration; in this case, no result expression should be included in the body.

A **pure calculation** guarantees:
1. Same input values always produce the same result.
2. No side effects on occurrences outside the calculation's own performance.

# Rules

- Declared using the keyword `calc`.
- Directed usages in the body are owned parameters; the result parameter uses `return` or `out`.
- A calculation definition or usage always has a result parameter (inherited if not owned).
- If a calculation definition specializes other calculation definitions, its result parameter redefines the result parameters of those definitions.
- A result expression is written without a final semicolon.
- The base calculation definition and usage are `Calculation` and `calculations` from the `Calculations` library model.

# Examples

```sysml
calc computation : Dynamics {
    in initialState;
    in time;
    return result;
}

calc vehicleComputation subsets computation {
    return : VehicleState;
}
```

# Relationships

- [calculation-definition.md](calculation-definition.md) — the definition that types this calculation usage
- [calculation-usage.md](calculation-usage.md) — usage of a calculation definition
- [constraint.md](constraint.md) — constraints use a Boolean result; calculations produce typed results

# Citations

[1] OMG SysML v2 Specification, §7.19
