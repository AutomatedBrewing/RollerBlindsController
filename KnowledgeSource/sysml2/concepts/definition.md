---
type: SysML v2 Concept
title: Definition
description: A definition is a namespace element that classifies a kind of thing in a SysML model and may be specialized by other definitions or typed by usages.
timestamp: 2026-07-01T00:00:00Z
---

A **definition** is a namespace element that classifies instances of a certain kind of thing in a system model (e.g., attributes, parts, actions, etc.). Every specific kind of definition uses a corresponding pair of keywords — a kind keyword followed by `def` (e.g., `part def`, `action def`, `attribute def`).

A definition may own **usage elements** (features) nested in its body, which describe the properties of instances of the definition. A definition can be **abstract**, meaning all instances must also be instances of at least one concrete (non-abstract) definition or usage that specializes it. A definition can **specialize** one or more other definitions via the **subclassification** relationship, inheriting their features.

Each definition implicitly specializes an appropriate base definition from the Systems Model Library (e.g., an `attribute def` implicitly subclassifies `AttributeValue`, a `part def` implicitly subclassifies `Part`). Every definition must ultimately specialize `Anything` from the Kernel Semantic Library.

# Syntax

```sysml
// Simple definition:
part def Vehicle;

// Abstract definition:
abstract part def Vehicle;

// Definition specializing another:
part def Automobile specializes Vehicle;
part def Truck :> Vehicle;  // :> is shorthand for specializes

// Definition with owned features:
item def Super {
  private package N {
    item def Sub specializes Super;
  }
  item f : N::Sub;
}

// Concrete definition with features:
part def Tank :> Container {
  in item fuelFlow : Fuel;
  ref item fuel : Fuel :>> content;
}
```

# Semantics

- A definition classifies a kind of thing; instances of the definition are the classified things.
- Definitions are also namespaces: they can contain owned members (features, sub-packages, etc.).
- An **abstract** definition requires all its instances to also be instances of at least one concrete specializing definition or usage.
- A **concrete** definition (not abstract) is one whose instances need not further specialize it.
- Features (usages) declared within the body of a definition are owned features of that definition.
- A definition inherits features from all definitions it specializes.
- Inherited features must have names distinct from each other and from owned features; conflicts are resolved by redefinition.

# Rules

1. A definition is declared with a kind keyword followed by `def`.
2. The `abstract` keyword before the kind keyword declares the definition as abstract.
3. Subclassification is declared using `specializes` or `:>` followed by comma-separated qualified names.
4. A body (between `{...}`) or a semicolon `;` (if empty) follows the declaration.
5. Every definition must directly or indirectly specialize the appropriate base definition from the Systems Model Library.
6. If not explicitly stated, the implicit specialization of the appropriate base definition is added automatically.

# Examples

```sysml
// Abstract and concrete definitions:
abstract part def Vehicle;
part def Automobile specializes Vehicle;
part def Truck :> Vehicle;

// Definition with owned features:
part def Vehicle {
  part engine : Engine;
  part wheels : Wheel[4];
  attribute mass : MassValue;
}

// Abstract definition with abstract feature:
abstract part def Container {
  abstract ref item content;
}
```

# Relationships

- [usage.md](usage.md) — a usage is typed by a definition
- [subclassification.md](subclassification.md) — subclassification is the specialization relationship between definitions
- [namespace.md](namespace.md) — definition is a kind of namespace
- [feature-typing.md](feature-typing.md) — feature typing relates a usage to its definition(s)

# Citations

[1] OMG SysML v2 Specification, §7.6.1, §7.6.2, §7.6.8
