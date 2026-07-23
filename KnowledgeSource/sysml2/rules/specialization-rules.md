---
type: SysML v2 Rule
title: Specialization Rules
description: SysML v2 supports three kinds of specialization relationships — subclassification, subsetting, and redefinition — each with distinct semantics governing how definitions and usages inherit and override features.
timestamp: 2026-07-01T00:00:00Z
---

Definition and usage elements can be specialized using several different kinds of specialization relationships. Specialization enables reuse, inheritance, and context-specific modification of model elements.

# Rule Statement

## Subclassification (for Definitions)

A definition is specialized using the **subclassification** relationship. In textual notation, this is declared using the keyword `specializes` (or the symbol `:>`):

```
part def Truck specializes Vehicle;
part def Truck :> Vehicle;
```

Rules:
- The specialized definition inherits the features of the more general definition.
- A definition can specialize more than one other definition (multiple inheritance), inheriting features from each.
- All inherited feature names must be distinct from each other and from any owned features. Conflicts are resolved by redefining one or more conflicting features.
- A definition is declared `abstract` by placing the `abstract` keyword before its kind keyword. An abstract definition means all instances must also be instances of at least one concrete definition that directly or indirectly specializes it.

## Subsetting (for Usages)

A usage is specialized using **subsetting**. In textual notation, this is declared using the keyword `subsets` (or the symbol `:>`):

```
part part1S :> part1;
part part1S subsets part1;
```

Rules:
- A subsetting usage has a **subset of the values** of the subsetted usage.
- The subsetting usage may further constrain its definition and multiplicity.
- A usage inherits the features from its definition, and can add its own features and subset or redefine inherited features.

## Redefinition (for Usages)

Redefinition is a **kind of subsetting**. In textual notation, declared using `redefines` (or `:>>`):

```
part part2R : Part2R redefines part2;
part part2R : Part2R :>> part2;
```

Rules:
- A redefining usage **replaces** the redefined usage in the context of the redefining usage.
- Redefinition can restrict the type to a subclassification of the original type.
- A usage with an owned redefinition but no declared name has its effective name determined by the name of the redefined usage (effective name rule).
- Feature typing (`:`) specifies the definitions of a usage. Subsettings (`:>`) specify subsetted usages. Redefinitions (`:>>`) specify redefined usages.

## Implicit Specialization

If a definition or usage, as explicitly declared, does not directly or indirectly specialize the required base definition or usage from the Systems Model Library, then the declaration is considered to include an implicit subclassification or subsetting of the appropriate base definition or usage.

# Rationale

Specialization enables hierarchical model organization and contextual adaptation. Subclassification for definitions mirrors class inheritance. Subsetting and redefinition for usages allow usage hierarchies that can be independently refined in each usage context.

# Examples

```
part def Vehicle {
    part wheels : Wheel[4..8];
    part fuel : Fuel;
}

part def Truck :> Vehicle {
    // inherits wheels and fuel
    attribute cargoSize : Mass;
}

// Subsetting
part truck :> vehicle {
    part frontLeftWheel : Wheel[1] subsets wheels;
    part frontRightWheel : Wheel[1] subsets wheels;
}

// Redefinition with type restriction
part def FourCylinderEngine :> Engine {
    part redefines cylinders[4];
}
```

# Violations

- Declaring a subclassification between definitions of incompatible kinds.
- A subsetting usage having values that are not a subset of the subsetted usage's values.
- Widening the multiplicity in a redefinition beyond the bounds of the redefined usage.
- Declaring two owned features with the same name in the same namespace (including inherited feature name conflicts not resolved by redefinition).

# Related Concepts

- [Definition-Usage Pattern](definition-usage-pattern.md)
- [Multiplicity Bounds](multiplicity-bounds.md)
- [Feature Chains](feature-chains.md)

# Citations

[1] OMG SysML v2 Specification, §7.6.1 (Specialization subsection)
[2] OMG SysML v2 Specification, §7.6.2 (Definitions)
[3] OMG SysML v2 Specification, §7.6.3 (Usages)
[4] OMG SysML v2 Specification, §7.6.5 (Effective Names)
[5] OMG SysML v2 Specification, §7.6.8 (Implicit Specialization)
