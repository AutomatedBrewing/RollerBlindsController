---
type: SysML v2 Concept
title: Calculation Usage
description: A calculation usage is an action usage typed by a calculation definition that performs a specific computation, functioning as a KerML expression whose result is bound to the definition's result parameter.
timestamp: 2026-07-01T00:00:00Z
---

A calculation usage is an action usage that is a usage of a calculation definition. A calculation usage is also a KerML expression, which allows it to be invoked using KerML invocation expression notation and to appear anywhere an expression is valid.

A calculation usage inherits the parameters of its calculation definition(s) and can also define or redefine parameters. It always has a result parameter (inherited if not owned). The body of a calculation usage, like that of a calculation definition, may include a result expression at the end.

# Syntax

```sysml
calc calc1 : CalcDef1 {
    expression1
}

calc calc1 : CalcDef1 {
    /* members */
}

// With parameter redefinitions
calc computation : Dynamics {
    in initialState;
    in time;
    return result;
}

// Subsetting with result redefinition
calc vehicleComputation subsets computation {
    return : VehicleState;
}
```

# Semantics

A calculation usage may have any type of specialization relationship (feature typing, subsetting, or redefinition) with a calculation definition or usage. Rules for parameter redefinition are the same as for calculation definitions. The body may include a result expression at the end that computes the value for the result parameter.

Because a calculation usage is a KerML expression, it can appear in contexts requiring expression values.

# Rules

- Declared using the keyword `calc`.
- Directed usages in the body are owned parameters; the result parameter uses `return` or `out`.
- A calculation usage always has a result parameter (inherited if not owned).
- If a calculation usage has a specialization relationship with an action definition or usage (or KerML behavior/step), the parameter redefinition rules are the same as for a calculation definition.
- A result expression is written without a final semicolon.
- The base calculation usage is `calculations` from the `Calculations` library model.

# Examples

```sysml
calc computation : Dynamics {
    in initialState;
    in time;
    return result;
}
```

# Relationships

- [calculation-definition.md](calculation-definition.md) — the definition that types this usage
- [calculation.md](calculation.md) — general concept of a calculation
- [action-usage.md](action-usage.md) — calculation usage is a specialization of action usage

# Citations

[1] OMG SysML v2 Specification, §7.19.2
