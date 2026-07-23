---
type: SysML v2 Concept
title: Usage
description: A usage is a namespace element that represents the use of a definition in a specific context, inheriting features from its definition and possibly adding or specializing features.
timestamp: 2026-07-01T00:00:00Z
---

A **usage** is a namespace element that represents using a definition in a particular context. Every usage is typed by at least one **definition** corresponding to its kind (e.g., a part usage is typed by a part definition). If no definition is explicitly given, the usage is implicitly typed by the most general definition of the appropriate kind from the Systems Model Library.

A usage inherits the features of its definition(s) and can add its own features, subset inherited features, or redefine them. Usages declared within a definition body are **owned features** of that definition. Usages can themselves contain nested usages (features), forming hierarchical structure.

A usage may be **composite** (the default for owned features of occurrences) or **referential** (`ref`). A composite usage means the related instance is integral to the containing instance and cannot outlive it. A referential usage is a simple reference.

A usage has a **multiplicity** constraining the number of values it may have for any instance of its featuring definition or usage.

# Syntax

```sysml
// Usage typed by a definition:
part part1 : PartDef1;

// Usage with multiplicity:
part wheels : Wheel [4];
part wheels2 : Wheel [4..8];

// Usage with subsetting:
part part1S : PartDef1S [m] subsets part1;
// or equivalently:
part part1S : PartDef1S [m] :> part1;

// Usage with redefinition:
part part1R : PartDef1R [m] redefines part1;
// or:
part part1R : PartDef1R [m] :>> part1;

// Usage with multiple specializations:
item x : A, B :> f :>> g;

// Referential usage:
ref part road : Road;

// Abstract usage:
abstract part content;

// Usage with nested usages:
part vehicle : Vehicle {
  part wheelAssembly[2] {
    part axle : Axle;
    part wheel : Wheel;
  }
}

// Usage with direction:
in item fuelFlow : Fuel;
out attribute result : Real;
```

# Semantics

- A usage is typed by one or more definition elements (feature typings).
- A usage inherits features from all its definitions, plus features from subsetted or redefined usages.
- The **multiplicity** of a usage constrains the cardinality (number of values) for any featuring instance.
- A **composite** usage (`part`, `item`, etc., without `ref`) means values are destroyed with the featuring instance.
- A **referential** usage (`ref`) is a simple reference that does not imply ownership.
- A **directed** usage (`in`, `out`, `inout`) determines what is allowed to change the feature's values.
- A **derived** usage is expected to have a bound value expression that determines its value at all times.
- An **abstract** usage requires values to also be values of a concrete specializing usage.
- A **constant** usage has values that do not change during the existence of the featuring instance.
- A **variation** usage marks a design choice point; its `variant` usages are the available choices.

# Rules

1. A usage is declared using a kind-specific keyword (e.g., `part`, `item`, `action`).
2. Feature typings are declared after `:` or `defined by`.
3. Subsettings are declared after `:>` or `subsets`.
4. Redefinitions are declared after `:>>` or `redefines`.
5. Multiplicity is given in square brackets `[...]` after the name or after a specialization clause.
6. A tighter default multiplicity of `[1..1]` is implicitly declared for attribute, item, or port usages owned by definitions or usages (with no explicit subsettings or redefinitions).
7. If no multiplicity is declared, the effective default is `[0..*]` unless a tighter constraint is inherited.
8. A directed usage is always referential.

# Examples

```sysml
// Typed usage with multiplicity:
part vehicle : Vehicle {
  part wheels : Wheel [4];
  part engine : Engine;
}

// Subsetting and redefinition:
part def FourCylinderEngine :> Engine {
  part redefines cylinders[4];
}

// Referential and composite features in a container:
abstract part def Container {
  abstract ref item content : Base::Anything;
}
part def Tank :> Container {
  in item fuelFlow : Fuel;
  ref item fuel : Fuel :>> content;
}
```

# Relationships

- [definition.md](definition.md) — usages are typed by definitions
- [subsetting.md](subsetting.md) — a usage may subset another usage
- [redefinition.md](redefinition.md) — a usage may redefine another usage
- [feature-typing.md](feature-typing.md) — feature typing relates a usage to its definition(s)
- [multiplicity.md](multiplicity.md) — multiplicity constrains the cardinality of a usage
- [variability.md](variability.md) — variation and variant usages model design choices
- [namespace.md](namespace.md) — usage is a kind of namespace

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.3
