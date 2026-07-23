---
type: SysML v2 Concept
title: Constraint Usage
description: A constraint usage is an occurrence usage typed by a constraint definition that evaluates a Boolean predicate, and can be asserted to be always true or always false within a model context.
timestamp: 2026-07-01T00:00:00Z
---

A constraint usage is an occurrence usage that is the usage of a constraint definition. A constraint usage is also a KerML Boolean expression, which allows it to be invoked using KerML invocation expression notation.

For a given set of input parameter values, a constraint usage is **satisfied** if its expression evaluates to `true` and **violated** otherwise. A constraint usage that is a feature of another definition or usage may directly reference features of its containing context.

An **assert constraint usage** asserts that the constraint must evaluate to `true` at all times. A **negated assert constraint usage** (with `not`) asserts it must evaluate to `false` at all times.

# Syntax

```sysml
// Regular constraint usage
constraint constraint1 : ConstraintDef1;

constraint constraint1 : ConstraintDef1 {
    /* members */
}

// Inline anonymous constraint
constraint { x < y }

// Assert constraint usage (must always be true)
assert constraint { computedMass >= 0[kg] }

// Negated assert (must always be false)
assert not constraint { computedMass < 0[kg] }

// Assert shorthand (relates by reference subsetting)
assert constraint1;

// Assert not shorthand
assert not negativeMass { :>> mass = computedMass; }
```

# Semantics

A constraint usage may directly reference features of its containing context (e.g., `{'bolt diameter' < 'hole diameter'}`), in which case it effectively constrains the values of those features without explicit parameters.

An assert constraint usage that evaluates to a value other than its asserted value (true by default, false if negated) is a logical inconsistency in the model. If a constraint is violated, tools can flag it as needing resolution.

# Rules

- A constraint usage must be defined by a single constraint definition or a KerML predicate.
- Declared using the keyword `constraint`.
- Assert constraint usages are declared using `assert constraint`; negated with `assert not constraint`.
- The shorthand `assert <name>` creates an assert constraint usage related to the named constraint by reference subsetting.
- `assert not <name>` creates a negated assert constraint usage.
- The base constraint usage is `constraints` from the `Constraints` model library.

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
    assert not constraint { computedMass < 0[kg] }
}
```

# Relationships

- [constraint-definition.md](constraint-definition.md) — the definition that types this constraint usage
- [constraint.md](constraint.md) — general concept of a constraint
- [calculation-usage.md](calculation-usage.md) — calculation usages produce typed results; constraints produce Boolean
- [occurrence.md](occurrence.md) — constraint usage is a kind of occurrence usage

# Citations

[1] OMG SysML v2 Specification, §7.20.2, §7.20.3
