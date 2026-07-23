---
type: SysML v2 Concept
title: Enum Value
description: An enum value (enumerated value) is an enumeration usage declared in the body of an enumeration definition that represents one of the discrete allowable values of that enumeration.
timestamp: 2026-07-01T00:00:00Z
---

An **enum value** (enumerated value) is an enumeration usage declared as a member of an enumeration definition's body. Each enumerated value represents one distinct, named data value from the finite set of values that the enumeration definition allows.

Enumerated values are implicitly defined by their owning enumeration definition and are treated as variants of the enclosing enumeration definition variation. The `enum` keyword before the name of an enumerated value may be omitted inside the body of an enumeration definition, since only enumeration usages are allowed in that position.

Enumerated values may have nested bindings to constrain inherited features when the owning enumeration definition specializes an attribute definition with nested usages.

# Syntax

```sysml
// Enumerated values with optional 'enum' keyword
enum def ConditionColor {
    enum red;      // explicit 'enum' keyword
    green;         // 'enum' keyword omitted (shorthand)
    yellow;
}

// Enumerated values with value bindings
enum def RiskLevel :> ConditionLevel {
    enum low    { :>> color = ConditionColor::green;  }
    enum medium { :>> color = ConditionColor::yellow; }
    enum high   { :>> color = ConditionColor::red;   }
}

// Enumerated values bound to specific quantity values
enum def DiameterChoices :> LengthValue {
    = 60 [mm];
    = 80 [mm];
    = 100 [mm];
}
```

# Semantics

- Each enumerated value is an instance of its owning enumeration definition.
- An enumerated value is a variant of the owning enumeration definition (which is a variation).
- Enumerated values may have nested feature bindings (`::>` or `:>>`) to set inherited attribute values.
- All value expressions bound to enumerated values within a single enumeration definition must produce distinct results.
- An enumerated value is implicitly defined by its owning enumeration definition and may not have any other explicitly declared definition.

# Rules

- Enumerated value declarations in an enumeration definition body may not include: direction keywords, `abstract`, `derived`, `readonly`, `variant`, `ref`, or similar property keywords from §7.6.3.
- An enumerated value need not have an explicitly declared definition (it is implicitly defined by its owning enum def).
- The `enum` keyword may be omitted for enumerated value declarations inside an enumeration definition body.

# Examples

```sysml
enum def Priority {
    low;
    medium;
    high;
    critical;
}

// Reference to an enumerated value
attribute currentPriority : Priority = Priority::high;
```

# Relationships

- [enumeration-definition.md](enumeration-definition.md) — the owning enumeration definition
- [enumeration.md](enumeration.md) — general enumeration concept
- [attribute-usage.md](attribute-usage.md) — enumerated values are a specialized kind of attribute usage

# Citations

[1] OMG SysML v2 Specification, §7.8
