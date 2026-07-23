---
type: SysML v2 Concept
title: Require Constraint
description: A require constraint is a composite constraint usage declared inside a requirement definition or usage with the keyword `require` or `require constraint`, designating that constraint as a required condition the requirement subject must satisfy.
timestamp: 2026-07-01T00:00:00Z
---

A require constraint is a composite constraint usage nested inside a requirement definition or usage that is prefixed with the keyword `require` (or `require constraint`). It designates one of the required conditions that must be true for the containing requirement to be satisfied (given that all assumed constraints hold).

The required constraints of a requirement, combined with the assumed constraints, form the logical implication that defines the requirement: if all assumptions are true, all required constraints must be true.

There are two declaration forms:

1. **Inline** (`require constraint { ... }`): declares a new constraint usage with an optional name and body expression.
2. **Reference** (`require <qualifiedName>`): references an existing constraint by name and relates it via reference subsetting.

Nested composite requirement usages are **automatically** treated as required constraints without needing the `require` keyword.

# Syntax

```sysml
// Inline require constraint (unnamed)
requirement def MaximumMass {
  attribute massActual   : MassValue;
  attribute massRequired : MassValue;
  require constraint { massActual <= massRequired }
}

// Named inline require constraint
requirement def BrakingRequirement {
  require constraint brakingConstraint {
    doc /* Vehicle shall brake to zero within maxBrakingDistance. */
  }
}

// Reference form
constraint massLimit {
  attribute mass : MassValue;
  attribute limit : MassValue;
  mass <= limit;
}
requirement def MassReq {
  require massLimit {
    :>> mass  = massActual;
    :>> limit = massRequired;
  }
}
```

# Semantics

- Declared with `require constraint` (or shorthand `require <name>`).
- The `require` keyword prefixes a composite constraint usage declaration.
- All require constraints in a requirement definition or usage are combined as: assumptions ⇒ all required constraints.
- Nested composite requirement usages inside a requirement are automatically required constraints (no `require` keyword needed).

# Rules

- Must appear in the body of a requirement definition or requirement usage.
- Shorthand `require <qualifiedName>` uses reference subsetting to identify the constraint.
- An unnamed inline form uses `require constraint { ... }`.
- A named inline form uses `require constraint <name> { ... }`.

# Examples

```sysml
requirement def MaximumMass {
  attribute massActual   : MassValue;
  attribute massRequired : MassValue;
  assume constraint { massRequired > 0[kg] }
  require constraint { massActual <= massRequired }
}
```

# Relationships

- [requirement.md](requirement.md) — the containing requirement
- [requirement-definition.md](requirement-definition.md) — where require constraint is declared
- [requirement-usage.md](requirement-usage.md) — where require constraint can also appear
- [constraint.md](constraint.md) — supertype of require constraint
- [frame-constraint.md](frame-constraint.md) — related: framing a concern is also a required constraint

# Citations

[1] OMG SysML v2 Specification, §7.21.2
