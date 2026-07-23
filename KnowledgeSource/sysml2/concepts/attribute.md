---
type: SysML v2 Concept
title: Attribute
description: An attribute in SysML v2 encompasses both attribute definitions and attribute usages, providing a mechanism to model data values such as numbers, strings, and structured data that characterize system elements.
timestamp: 2026-07-01T00:00:00Z
---

An **attribute** in SysML v2 is the general concept covering both the definition of data value types (attribute definitions) and the use of those types as features of system elements (attribute usages). Attributes model quantities, quality characteristics, physical properties, and other data-centric aspects of a system.

Attribute usages are always **referential** (non-composite), meaning they reference data values rather than owning them compositionally. The values of an attribute usage are data values—whether primitive (e.g., integers, booleans) or structured—that do not themselves change over time. However, when an attribute usage is owned by an occurrence, its value may vary over the lifetime of that occurrence (e.g., the position of a moving vehicle changes over time).

Attributes can be typed by primitive KerML data types (e.g., `String`, `Boolean`, `Integer`, `Rational`, `Real`, `Complex`) or by SysML attribute definitions, including enumeration definitions.

# Syntax

```sysml
attribute def SensorRecord {
    ref part sensor : Sensor;
    attribute reading : Real;
}

attribute attribute1 : SensorRecord;
```

# Semantics

- An attribute usage is always referential, whether or not the `ref` keyword is used.
- The default multiplicity of an attribute usage is `[1..1]` under the standard conditions.
- Any usage nested in an attribute definition or attribute usage must also be referential.
- The base attribute definition is `AttributeValue` from the `Attributes` library model, which is an alias for `DataValue` from the KerML `Base` library.
- The base attribute usage is `attributeValues` from the `Attributes` library model.

# Rules

- An attribute definition may only specialize other attribute definitions (including enumeration definitions) or KerML data types.
- An attribute usage may only be defined by attribute definitions or KerML data types.
- All nested usages in an attribute definition or attribute usage must be referential.
- The `ref` keyword is implicit for attribute usages (they are always referential).

# Examples

```sysml
// Attribute usage typed by a KerML primitive
attribute speed : Real;

// Structured attribute definition
attribute def Position {
    attribute x : Real;
    attribute y : Real;
    attribute z : Real;
}

// Attribute usage with explicit multiplicity
attribute readings : Real [1..*] ordered nonunique;
```

# Relationships

- [attribute-definition.md](attribute-definition.md) — the definition side of an attribute
- [attribute-usage.md](attribute-usage.md) — the usage side of an attribute
- [enumeration-definition.md](enumeration-definition.md) — specialized kind of attribute definition

# Citations

[1] OMG SysML v2 Specification, §7.7
