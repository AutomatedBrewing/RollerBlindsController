---
type: SysML v2 Concept
title: Subsetting
description: Subsetting is a specialization relationship between usages where the subsetting usage has a subset of the values of the subsetted usage, potentially further constraining definition and multiplicity.
timestamp: 2026-07-01T00:00:00Z
---

**Subsetting** is a specialization relationship between usages. A **subsetting usage** has a subset of the values of the **subsetted usage**. The subsetting usage may further constrain its definition (the types of its values) and its multiplicity (the number of its values).

Subsetting enables the reuse of usages across different contexts. Subsetting a usage is analogous to specializing a definition: the subsetting usage inherits the features and structure of the subsetted usage, and can add features, further constrain types, or redefine features.

In textual notation, subsetting is declared using the `subsets` keyword or its shorthand `:>`.

# Syntax

```sysml
// Subsetting with multiplicity and type constraint:
part part1S : PartDef1S [m] subsets part1;
// or equivalently:
part part1S : PartDef1S [m] :> part1;

// Subsetting within a body:
part part1S :> part1 {
  attribute attribute3 : Attribute3;
  part part3 : Part3 [0..*];
}
// or equivalently:
part part1S subsets part1 {
  // ...
}

// Subsetting to decompose a feature:
part def Vehicle {
  part wheels : Wheel [4..8];
}
part truck : Truck {
  part frontLeftWheel  : Wheel [1] subsets wheels;
  part frontRightWheel : Wheel [1] subsets wheels;
  part rearLeftWheel1  : Wheel [1] subsets wheels;
  part rearRightWheel1 : Wheel [1] subsets wheels;
  part rearLeftWheel2  : Wheel [0..1] subsets wheels;
  part rearRightWheel2 : Wheel [0..1] subsets wheels;
}
```

# Semantics

- A subsetting usage is constrained to have values that are also values of the subsetted usage.
- The subsetting usage may further restrict the **type** (definition) of its values relative to the subsetted usage.
- The subsetting usage may further restrict the **multiplicity** (cardinality) of its values.
- The subsetting usage inherits the features of the subsetted usage.
- A subsetting usage may add its own features and may further redefine inherited features.
- **Redefinition** is a special kind of subsetting (see `redefinition.md`).

# Rules

1. Subsetting is declared with `subsets` or `:>` followed by the qualified name (or feature chain) of the subsetted usage.
2. Multiple subsetted usages can be listed, separated by commas.
3. A subsetting usage has a subset of the values of each subsetted usage.
4. The subsetting usage may have a more specific type and/or lower multiplicity than the subsetted usage.
5. A redefinition is a kind of subsetting and appears in the abstract syntax as a subset of owned subsettings.

# Examples

```sysml
// Subsetting a package-level usage:
part part1 : Part1 {
  attribute attribute2 : Attribute2;
  part part2 : Part2 [0..*];
}
part part1S :> part1 {
  attribute attribute3 : Attribute3;
  part part3 : Part3 [0..*];
}

// Subsetting to represent named decomposition:
item def Person {
  ref item parent[2] : Person;
  ref item mother : Person[1..1] subsets parent;
  ref item father : Person[1..1] subsets parent;
}
```

# Relationships

- [usage.md](usage.md) — subsetting is a specialization relationship between usages
- [redefinition.md](redefinition.md) — redefinition is a special kind of subsetting
- [subclassification.md](subclassification.md) — the analogous relationship between definitions
- [multiplicity.md](multiplicity.md) — a subsetting usage may constrain multiplicity
- [feature-typing.md](feature-typing.md) — a subsetting usage may have a more specific type

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.3
