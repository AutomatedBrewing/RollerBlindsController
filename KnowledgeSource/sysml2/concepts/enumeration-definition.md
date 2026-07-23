---
type: SysML v2 Concept
title: Enumeration Definition
description: An enumeration definition is a kind of attribute definition whose instances are limited to a specific discrete set of enumerated values declared in its body.
timestamp: 2026-07-01T00:00:00Z
---

An **enumeration definition** is a specialized kind of attribute definition that restricts its instances to a specific, finite set of named values called enumerated values. It is declared using the kind keyword `enum` (shorthand for `enum def`).

An enumeration definition is always treated as a variation, and its declared member enumeration usages are its variants. The `abstract` and `variation` keywords may not be used explicitly with an enumeration definition since it is implicitly both.

An enumeration definition may specialize a non-enumeration attribute definition (e.g., a `LengthValue`). In this case, the enumerated values can be bound to specific values of the specialized attribute definition. However, an enumeration definition must never specialize another enumeration definition, because adding new enumerated values would be inconsistent with the specialization semantics (where instances of the subtype must be a subset of instances of the supertype).

# Syntax

```sysml
// Basic enumeration definition
enum def ConditionColor { red; green; yellow; }

// Enumeration specializing an attribute definition (not another enum)
attribute def ConditionLevel {
    attribute color : ConditionColor;
}
enum def RiskLevel :> ConditionLevel {
    enum low    { :>> color = ConditionColor::green;  }
    enum medium { :>> color = ConditionColor::yellow; }
    enum high   { :>> color = ConditionColor::red;   }
}

// Enumeration with value bindings (e.g., bound to a length)
enum def DiameterChoices :> LengthValue {
    = 60 [mm];
    = 80 [mm];
    = 100 [mm];
}
```

# Semantics

- An enumeration definition is a variation; its enumerated values are variants.
- The body may only contain enumeration usage declarations (the enumerated values).
- Each enumerated value is implicitly defined by its owning enumeration definition.
- All results of value expressions bound to enumerated values must be distinct.
- The base definition is accessible via the `Attributes` library model.

# Rules

- Must not specialize another enumeration definition.
- Body may only declare enumeration usages; no other member types are permitted.
- The `enum` keyword may be omitted for enumerated value declarations within the body.
- The keywords `abstract` and `variation` must not appear on the enumeration definition.
- Enumerated value declarations may not include direction keywords, `abstract`, `derived`, `variant`, etc.

# Examples

```sysml
enum def Priority { low; medium; high; critical; }

enum def TrafficLight { red; yellow; green; }

enum def EngineState { off; idle; running; fault; }
```

# Relationships

- [enum-value.md](enum-value.md) — the enumerated values declared inside an enumeration definition
- [enumeration.md](enumeration.md) — general enumeration concept
- [attribute-definition.md](attribute-definition.md) — parent concept; enumeration definitions specialize attribute definitions

# Citations

[1] OMG SysML v2 Specification, §7.8
