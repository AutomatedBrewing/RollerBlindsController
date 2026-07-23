---
type: SysML v2 Concept
title: Multiplicity
description: Multiplicity specifies the allowed number of values a usage may have for any instance of its featuring definition or usage, expressed as a range with lower and upper bounds.
timestamp: 2026-07-01T00:00:00Z
---

**Multiplicity** constrains the cardinality of a usage — the allowed number of values the usage may have for any given instance of its featuring definition or usage. It is expressed as a range with a **lower bound** and an **upper bound**, both of which must be natural numbers. The lower bound must be finite; the upper bound may be `*` (infinite), indicating an unbounded range.

If a multiplicity is not declared for a usage, the usage inherits multiplicity constraints from any subsetted or redefined usages. The effective default when no tighter constraint is inherited is `[0..*]`. However, a tighter default of `[1..1]` is implicitly used for attribute, item (non-connection), or port usages owned by definitions or usages (with no explicit subsettings or redefinitions).

# Syntax

```sysml
// Multiplicity given in square brackets after the usage name:
part wheels : Wheel [4];        // exactly 4
part wheels2 : Wheel [4..8];    // 4 to 8
part items : Item [0..*];       // zero or more (unbounded)
part items2 : Item [*];         // also zero or more (upper bound * implies lower 0)

// Multiplicity with non-unique and ordered modifiers:
item values : Real [0..*] nonunique ordered;

// Multiplicity placed after a specialization clause:
ref item mother : Person [1..1] subsets parent;

// Multiplicity using a named bound:
item def Person {
  attribute numberOfChildren : Natural;
  ref item children [0..numberOfChildren] : Person;
}

// Redefinition to constrain multiplicity:
item def ChildlessPerson specializes Person {
  ref item redefines children[0];
}
```

# Semantics

- A multiplicity range `[lowerBound..upperBound]` constrains the number of values to be between the bounds (inclusive).
- If only a single bound is given, it is used as both lower and upper bound, unless the value is `*` (in which case lower bound is 0).
- If the first bound in a two-bound range is `*`, the meaning is not defined.
- `*` as an upper bound indicates an unbounded range (includes all numbers ≥ lower bound).
- `nonunique` allows the same value to appear more than once; the default is unique.
- `ordered` allows values to be indexed from 1 to the number of values; the default is unordered.
- A usage without explicit multiplicity inherits constraints from subsetted/redefined usages.
- Default multiplicity is `[1..1]` for attribute, item, or port usages owned by definitions or usages with no explicit subsettings or redefinitions.
- The effective default if no tighter constraint is available is `[0..*]`.

# Rules

1. Multiplicity is written in square brackets `[...]` after the name part or after a specialization clause.
2. Only one multiplicity may be specified in a usage declaration.
3. Lower bound must be a finite natural number; upper bound may be `*`.
4. `nonunique` and `ordered` keywords may follow the multiplicity (or be used independently).
5. The bounds may be literals or references to usages (features).

# Examples

```sysml
// Fixed multiplicity:
part def Vehicle {
  part wheels : Wheel [4]; // exactly 4 wheels
}

// Range multiplicity:
part def Truck :> Vehicle {
  part wheels : Wheel [4..8]; // 4 to 8 wheels
}

// Unbounded multiplicity:
attribute entries [*] : ConfigEntry; // zero or more entries

// Variable bound:
item def Person {
  attribute numberOfChildren : Natural;
  ref item children [0..numberOfChildren] : Person;
}
```

# Relationships

- [usage.md](usage.md) — multiplicity constrains usages
- [subsetting.md](subsetting.md) — a subsetting usage may further constrain multiplicity
- [redefinition.md](redefinition.md) — a redefining usage may constrain multiplicity of the redefined usage

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.3
