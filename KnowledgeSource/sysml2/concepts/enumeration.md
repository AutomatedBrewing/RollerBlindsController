---
type: SysML v2 Concept
title: Enumeration
description: An enumeration in SysML v2 is the general concept covering both enumeration definitions and enumeration usages, providing a mechanism to model attributes whose values are restricted to a discrete named set.
timestamp: 2026-07-01T00:00:00Z
---

An **enumeration** in SysML v2 covers both enumeration definitions and enumeration usages. An enumeration definition is a specialized kind of attribute definition whose instances are limited to a specific set of enumerated values. An enumeration usage is an attribute usage typed by a single enumeration definition.

Enumerations are used to model attributes that can only take on a finite discrete set of named values, such as status codes, color choices, priority levels, or risk assessments.

An enumeration definition is always treated as a variation, and its enumerated values (declared in the body) are its variants. Enumerations may specialize non-enumeration attribute definitions (allowing enumerated values to be bound to specific values of the parent type), but an enumeration definition must not specialize another enumeration definition.

# Syntax

```sysml
// Simple enumeration
enum def ConditionColor { red; green; yellow; }

// Enumeration specializing an attribute definition
enum def RiskLevel :> ConditionLevel {
    enum low  { :>> color = ConditionColor::green;  }
    enum medium { :>> color = ConditionColor::yellow; }
    enum high { :>> color = ConditionColor::red;   }
}

// Enumeration usage
enum assessedRisk : RiskLevel;
```

# Semantics

- An enumeration definition restricts instances to the discrete set of enumerated values declared in its body.
- An enumeration definition is implicitly a variation; its members are implicitly variants.
- An enumeration usage is always referential (as a kind of attribute usage).
- Even a plain attribute usage typed by an enumeration definition is semantically restricted to the enumerated values.

# Rules

- An enumeration definition must not specialize another enumeration definition.
- The body of an enumeration definition may only declare enumeration usages (the enumerated values).
- The `enum` keyword may be omitted for members declared inside an enumeration definition body.
- The keywords `abstract` and `variation` must not be used with an enumeration definition.
- Enumerated values may not have direction keywords, `abstract`, `derived`, etc.
- An enumerated value may not have any explicitly declared definition other than its owning enumeration definition.

# Examples

```sysml
enum def Priority { low; medium; high; critical; }

enum def DiameterChoices :> LengthValue {
    enum small  = 60 [mm];
    enum medium = 80 [mm];
    enum large  = 100 [mm];
}

attribute def Component {
    enum priority : Priority;
}
```

# Relationships

- [enumeration-definition.md](enumeration-definition.md) — the definition side of enumerations
- [enum-value.md](enum-value.md) — individual enumerated values
- [attribute-definition.md](attribute-definition.md) — parent concept that enumeration definitions specialize
- [attribute-usage.md](attribute-usage.md) — enumeration usages are a kind of attribute usage

# Citations

[1] OMG SysML v2 Specification, §7.8
