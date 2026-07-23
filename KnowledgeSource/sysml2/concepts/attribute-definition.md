---
type: SysML v2 Concept
title: Attribute Definition
description: An attribute definition defines a set of data values such as numbers, quantitative values with units, qualitative values such as text strings, or structured data values.
timestamp: 2026-07-01T00:00:00Z
---

An **attribute definition** defines a class of data values, including primitive values like integers and booleans, quantity values with units, text strings, and structured data composed of nested attributes. It is declared using the keyword `attribute def` (kind keyword `attribute`).

Attribute definitions may specialize other attribute definitions or KerML data types. This allows attribute definitions to inherit features from their generalizations and to further restrict the range of data values they define. An enumeration definition is a specialized kind of attribute definition that restricts values to a discrete enumerated set.

The Kernel Data Type Library provides base primitive types (`String`, `Boolean`, `Integer`, `Rational`, `Real`, `Complex`) that can be used directly as types for attribute usages. The SysML Quantities and Units Domain Library provides base attribute definitions for scalar, vector, and tensor quantity values with associated unit kinds.

# Syntax

```sysml
// Simple attribute definition
attribute def SensorRecord {
    ref part sensor : Sensor;
    attribute reading : Real;
}

// Attribute definition specializing another
attribute def SpeedValue :> ScalarQuantityValue;
```

# Semantics

- An attribute definition classifies data values; its instances are data values.
- All features owned by or inherited by an attribute definition must be referential.
- The base attribute definition is `AttributeValue` from the `Attributes` library model (alias for `DataValue` from KerML `Base`).
- Attribute definitions can be used as types for attribute usages, as definitions for enumeration definitions, or as base types for further specialization.

# Rules

- An attribute definition may only specialize other attribute definitions (including enumeration definitions) or KerML data types.
- Any usage nested in an attribute definition must be referential.
- The keywords `abstract` and `variation` may be used with attribute definitions as with other definitions.

# Examples

```sysml
attribute def Temperature :> ScalarQuantityValue;

attribute def EngineParameters {
    attribute rpm : Integer;
    attribute temperature : Temperature;
    attribute oilPressure : Real;
}
```

# Relationships

- [attribute-usage.md](attribute-usage.md) — usages typed by an attribute definition
- [enumeration-definition.md](enumeration-definition.md) — specialized kind of attribute definition
- [attribute.md](attribute.md) — general concept encompassing definitions and usages

# Citations

[1] OMG SysML v2 Specification, §7.7
