---
type: SysML v2 Concept
title: Subclassification
description: Subclassification is the specialization relationship between definitions, where a specialized definition inherits the features of a more general definition.
timestamp: 2026-07-01T00:00:00Z
---

**Subclassification** is the relationship used to specialize one definition relative to one or more other (more general) definitions. A specialized (subclassifying) definition inherits all features of the more general (superclassified) definition and can add new features or redefine inherited ones.

A definition can specialize more than one other definition (**multiple subclassification**), inheriting features from each. Inherited feature names must be distinct from each other and from the specialized definition's own features; name conflicts can be resolved by redefinition.

In the textual notation, subclassification is declared using the `specializes` keyword or its shorthand `:>`.

# Syntax

```sysml
// Single subclassification:
part def Automobile specializes Vehicle;
part def Truck :> Vehicle;  // shorthand

// Multiple subclassification:
part def AmphibiousVehicle :> Vehicle, Boat;

// Subclassification in a definition body:
part def Part2S :> Part2 {
  attribute attribute2 : Attribute2;
  item item1 : Item1 [0..*];
}

// Equivalent using specializes keyword:
part def Part2S specializes Part2 {
  // ...
}
```

# Semantics

- A subclassification relationship relates a **specific** (sub) definition to a **general** (super) definition.
- The specific definition inherits all features of the general definition.
- A definition may have multiple subclassifications (specialize multiple general definitions).
- All inherited features must have names distinct from each other and from owned features.
- Name conflicts among inherited features must be resolved by redefining the conflicting features.
- An abstract definition cannot be instantiated directly; all instances must also instantiate a concrete specializing definition.
- Every definition implicitly has a subclassification to the corresponding base definition in the Systems Model Library (if not explicitly specialized).

# Rules

1. Subclassification is declared with `specializes` or `:>` in the definition declaration.
2. Multiple general definitions can be listed, separated by commas.
3. The specializing definition inherits all features of all listed general definitions.
4. Inherited feature name conflicts must be resolved by explicit redefinition.
5. A specializing definition may add new features, subset inherited features, or redefine inherited features.

# Examples

```sysml
// Subclassification hierarchy:
abstract part def Vehicle;
part def Automobile :> Vehicle;
part def Truck :> Vehicle;

// Concrete definition with added features:
part def Part2 {
  attribute attribute1 : Attribute1;
  perform action action1 : Action1;
}

part def Part2S :> Part2 {
  attribute attribute2 : Attribute2;
  item item1 : Item1 [0..*];
}
```

# Relationships

- [definition.md](definition.md) — subclassification relates definitions to more general definitions
- [subsetting.md](subsetting.md) — subsetting is the analogous relationship between usages
- [redefinition.md](redefinition.md) — redefinition resolves name conflicts among inherited features

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.2
