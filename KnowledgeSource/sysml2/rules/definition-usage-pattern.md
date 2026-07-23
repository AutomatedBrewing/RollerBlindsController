---
type: SysML v2 Rule
title: Definition-Usage Pattern
description: Every SysML v2 element is either a definition that classifies a kind of thing or a usage that applies a definition in a specific context.
timestamp: 2026-07-01T00:00:00Z
---

The definition-usage pattern is the fundamental modeling capability in SysML v2, providing a consistent foundation for attributes, occurrences, items, parts, ports, connections, interfaces, allocations, actions, states, calculations, constraints, requirements, concerns, cases, analysis cases, verification cases, use cases, views, viewpoints and renderings.

A definition element classifies a certain kind of element (e.g., a classification of attributes, parts, actions, etc.). A usage element is a usage of a definition element in a certain context. A usage must always be defined by at least one definition element that corresponds to its usage kind.

# Rule Statement

A usage must always be defined by at least one definition element that corresponds to its usage kind. For example, a part usage is defined by a part definition, and an action usage is defined by an action definition. If no definition is specified explicitly, then the usage is defined implicitly by the most general definition of the appropriate kind from the Systems Library. For example, a part usage is implicitly defined by the most general part definition `Part` from the model library package `Parts`.

# Rationale

The definition-usage separation enables reuse in different contexts: a single definition can serve as the type for multiple usages, each in its own context. A definition may have owned usage elements nested in it, referred to as its features. A usage may also have nested usage elements as features; in this case, the context for the nested usages is the containing usage.

# Examples

```
part def Vehicle {
    part engine : Engine;
    part transmission : Transmission;
}

// part usage "myVehicle" is defined by part definition Vehicle
part myVehicle : Vehicle;
```

A usage can also be contained directly in an owning package. In this case, the usage element is considered to be an implicit feature of the most general kernel type `Anything`, meaning it is essentially a generic feature that can be applied in any context or further specialized in specific contexts.

A usage may be referential or composite:
- A **referential** usage represents a simple reference between a featuring instance and one or more values.
- A **composite** usage indicates that the related instance is integral to the structure of the containing instance; if the containing instance is destroyed, any instances related by composite usages are also destroyed.

# Violations

- Declaring a part usage defined by an attribute definition (kind mismatch).
- Declaring a usage without any applicable definition when the most-general implicit definition cannot be inferred.
- Declaring a usage as composite when it is featured by a non-occurrence (attribute usages are always referential).

# Related Concepts

- [Specialization Rules](specialization-rules.md)
- [Multiplicity Bounds](multiplicity-bounds.md)
- [Feature Direction](feature-direction.md)

# Citations

[1] OMG SysML v2 Specification, §7.6.1 (Definition and Usage Overview)
[2] OMG SysML v2 Specification, §7.6.2 (Definitions)
[3] OMG SysML v2 Specification, §7.6.3 (Usages)
