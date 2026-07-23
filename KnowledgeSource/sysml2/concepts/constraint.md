---
type: SysML v2 Concept
title: Constraint
description: A constraint is an occurrence that defines a logical predicate evaluated against bound parameter values, producing a Boolean result that is either satisfied (true) or violated (false).
timestamp: 2026-07-01T00:00:00Z
---

A constraint definition is a kind of occurrence definition that defines a logical predicate. A constraint always has an implicit Boolean-valued result parameter with direction `out`. A constraint usage is an occurrence usage that is the usage of a constraint definition.

A constraint definition or usage may have features that are calculation or action usages that carry out steps in computing the result. The final result is specified as a Boolean-valued expression. A constraint definition is also a KerML predicate, and a constraint usage is a KerML Boolean expression.

For a given set of input parameter values, a constraint usage is **satisfied** if its expression evaluates to `true` and **violated** otherwise.

An **assert constraint usage** asserts that the constraint must evaluate to `true` at all times. A **negated assert constraint usage** asserts the constraint must evaluate to `false` at all times.

# Syntax

```sysml
// Inline constraint
constraint { x < y }

// Named constraint with parameters
constraint def IsFull {
    in tank : FuelTank;
    tank.fuelLevel == tank.maxFuelLevel
}

// Assert constraint
assert constraint { computedMass >= 0[kg] }

// Assert negated constraint
assert not constraint { computedMass < 0[kg] }

// Shorthand assert
assert constraint1;

// Shorthand assert not
assert not negativeMass { :>> mass = computedMass; }
```

# Semantics

Constraints can directly reference features of their containing context. For example, `{'bolt diameter' < 'hole diameter'}` constrains the values of two features in the containing context without explicit parameters.

An assert constraint usage that evaluates other than its asserted value (`true` by default, `false` if negated) represents a logical inconsistency in the model. Asserted constraints are appropriate for invariants like physical laws that must always hold.

# Rules

- A constraint usage must be defined by a single constraint definition or a KerML predicate.
- Every constraint definition and usage has a Boolean-valued result parameter (not necessary to redeclare).
- Declared using the keyword `constraint` (or `constraint def` for definitions).
- Assert constraint usages are declared using `assert constraint`.
- A negated assert constraint usage uses `assert not constraint`.
- The shorthand `assert <name>` relates the constraint by reference subsetting.
- The base constraint definition and usage are `Constraint` and `constraints` from the `Constraints` model library.

# Examples

```sysml
constraint def IsFull {
    in tank : FuelTank;
    tank.fuelLevel == tank.maxFuelLevel
}

part def Vehicle {
    part fuelTank : FuelTank;
    constraint isFull : IsFull {
        in tank = fuelTank;
    }
}

part testObject {
    attribute computedMass : MassValue;
    assert constraint { computedMass >= 0[kg] }
}
```

# Relationships

- [constraint-definition.md](constraint-definition.md) — the definition that classifies a constraint usage
- [constraint-usage.md](constraint-usage.md) — a usage of a constraint definition
- [calculation.md](calculation.md) — constraints are similar to calculations but return Boolean
- [occurrence.md](occurrence.md) — constraint definition is a kind of occurrence definition

# Citations

[1] OMG SysML v2 Specification, §7.20
