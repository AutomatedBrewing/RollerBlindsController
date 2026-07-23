---
type: SysML v2 Concept
title: Constraint Definition
description: A constraint definition is a kind of occurrence definition that defines a logical predicate with an implicit Boolean result parameter, classifying constraint usages.
timestamp: 2026-07-01T00:00:00Z
---

A constraint definition is a kind of occurrence definition (see §7.9) that defines a logical predicate. Similar to a calculation definition (see §7.19), a constraint definition may have parameters with direction `in`. A constraint always has an implicit Boolean-valued result parameter with direction `out`. A constraint definition is also a KerML predicate.

A constraint definition or usage may have features that are calculation or action usages that carry out steps in computing the result. The final result is specified as a Boolean-valued expression, following the same body structure as a calculation definition.

# Syntax

```sysml
constraint def ConstraintDef1;

constraint def ConstraintDef1 {
    /* members */
}

// With parameters and result expression
constraint def IsFull {
    in tank : FuelTank;
    tank.fuelLevel == tank.maxFuelLevel
}

// With multiple parameters
constraint def ValidRange {
    in value : Real;
    in minVal : Real;
    in maxVal : Real;
    value >= minVal & value <= maxVal
}
```

# Semantics

A constraint definition classifies constraint usages. Its implicit Boolean result parameter is generally not redeclared, since its type (`Boolean`) is already determined. The body of a constraint definition may include a result expression (a Boolean-valued expression) at the end, without a semicolon.

Constraint definitions are not calculation definitions, but like calculation definitions, they are a kind of KerML function (a predicate is a kind of function). This allows constraint definitions to be invoked using KerML invocation expression notation.

# Rules

- Declared using the keyword `constraint def`.
- Directed usages in the body are owned parameters; direction `in` is typical.
- Every constraint definition has a Boolean result parameter (need not be redeclared).
- The body may include a Boolean-valued result expression at the end (without semicolon).
- A constraint definition must produce a Boolean result.
- The base constraint definition is `Constraint` from the `Constraints` model library.

# Examples

```sysml
constraint def IsFull {
    in tank : FuelTank;
    tank.fuelLevel == tank.maxFuelLevel
}

constraint def PositiveMass {
    in obj;
    obj.mass > 0[kg]
}
```

# Relationships

- [constraint.md](constraint.md) — general concept of a constraint
- [constraint-usage.md](constraint-usage.md) — usage typed by a constraint definition
- [calculation-definition.md](calculation-definition.md) — constraints are similar to calculations but Boolean-valued
- [occurrence.md](occurrence.md) — constraint definition is a kind of occurrence definition

# Citations

[1] OMG SysML v2 Specification, §7.20.2
