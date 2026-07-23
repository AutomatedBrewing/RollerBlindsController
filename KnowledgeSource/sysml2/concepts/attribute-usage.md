---
type: SysML v2 Concept
title: Attribute Usage
description: An attribute usage is a usage of an attribute definition (or KerML data type) that is always referential and whose value is constrained to the range specified by its definition.
timestamp: 2026-07-01T00:00:00Z
---

An **attribute usage** is a usage of an attribute definition or KerML data type. It represents a data-valued feature of its owning element. Attribute usages are always referential (non-composite), meaning they do not own their values compositionally—values are referenced rather than contained.

The data values of an attribute usage are constrained to the range specified by its definition. When the owning element is an occurrence (item, part, action, etc.), the value of an attribute usage may vary over the lifetime of that occurrence, reflecting changing conditions of the occurrence over time.

Attribute usages can be typed by KerML primitive data types (`String`, `Boolean`, `Integer`, `Rational`, `Real`, `Complex`) or by SysML attribute definitions including enumeration definitions.

# Syntax

```sysml
// Attribute usage typed by a KerML primitive
attribute speed : Real;

// Attribute usage typed by an attribute definition
attribute reading : SensorReading;

// With explicit multiplicity
attribute samples : Real [1..*] ordered nonunique;

// With default value
attribute mass : Real default 1500.0;

// With fixed value
attribute monthsInYear : Natural = 12;
```

# Semantics

- An attribute usage is always referential, whether or not the `ref` keyword is explicitly included.
- The default multiplicity of an attribute usage is `[1..1]` under the standard conditions described in §7.6.3.
- Any usage nested in an attribute usage must also be referential.
- The base attribute usage is `attributeValues` from the `Attributes` library model (alias for `dataValues` from KerML `Base`).

# Rules

- An attribute usage may only be defined by attribute definitions or KerML data types.
- All nested usages of an attribute usage must be referential.
- The `ref` keyword is implicit and does not need to be explicitly stated.
- An attribute usage may have a feature value (fixed, initial, or default) using `=`, `:=`, or `default`.

# Examples

```sysml
part def Vehicle {
    attribute mass : Real;
    attribute maxSpeed : Real;
    attribute fuelCapacity : Real default 60.0;
    attribute serialNumber : String;
}

attribute def Coordinates {
    attribute latitude : Real;
    attribute longitude : Real;
    attribute altitude : Real;
}

item def GPSFix {
    attribute position : Coordinates;
    attribute timestamp : Integer;
}
```

# Relationships

- [attribute-definition.md](attribute-definition.md) — the definition that types this usage
- [enumeration-definition.md](enumeration-definition.md) — enumeration definitions can also type attribute usages
- [attribute.md](attribute.md) — general attribute concept

# Citations

[1] OMG SysML v2 Specification, §7.7
