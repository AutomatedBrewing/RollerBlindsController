---
type: SysML v2 Diagram
title: Definition Diagram
description: A Definition Diagram shows definition elements and their features, subclassification relationships between definitions, and the relationship between definitions and their usages.
timestamp: 2026-07-01T00:00:00Z
---

The Definition Diagram is the SysML v2 equivalent of the Block Definition Diagram (BDD) from SysML v1. It shows the definitions (classifiers) in a model, including part definitions, item definitions, action definitions, and other definition kinds, along with their features and specialization relationships.

Definitions and usages provide a consistent foundation for structural, behavioral, and constraint modeling in SysML v2. A definition element classifies a certain kind of element; a usage element is a usage of a definition in a specific context.

# Purpose

Definition diagrams are used to:
- Define the types (definitions) that structure a system model.
- Show subclassification hierarchies between definitions.
- Show the features (owned usages) of definitions.
- Show how usages are defined by (typed by) definitions.
- Show variation/variant relationships for product line modeling.

# Notation

## Definition Symbol

A definition is shown as a rectangle with a name compartment at the top. The stereotype label in guillemets (`«»`) identifies the definition kind:

```
«part def»
PartDef1
```

For an abstract definition:
```
«abstract part def»
PartDef1
```

For a variation definition:
```
«variation part def»
PartDef1
```

A short name (identifier) can be shown in angle brackets before the definition name:
```
«part def»
<PD2> PartDef2
```

## Subclassification

A subclassification relationship is shown as a solid line with a hollow triangular arrowhead pointing from the specialized definition to the general definition. In the name compartment, the general definition name follows the symbol `:>`:

```
«part def»
PartDef1S :> PartDef1
```

## Feature Compartments

Definitions can have compartments showing their owned and inherited features organized by kind:
- `attributes` — attribute usages
- `parts` — part usages
- `ports` — port usages
- `actions` — action usages
- `items` — item usages
- `connections` — connection usages
- `references` — reference usages

Inherited features are marked with the prefix `^`:
```
«part def»
Part2S
  attributes
    ^attribute1 : Attribute1   // inherited
    attribute2 : Attribute2    // owned
```

## Usage Symbol

A usage is shown as a rectangle with the stereotype label for its kind:

```
«part»
part1 : PartDef1
```

# Frame and Header

The diagram frame header for a definition diagram typically uses the identifier `def`.

# Compartments

The following compartments may appear in a definition or usage symbol:

- **Name compartment**: Contains the element name, optional short name, optional type (`:` TypeName), and optional specializations (`:>` or `:>>`).
- **Feature compartments**: Organized by usage kind (parts, attributes, ports, etc.).
- **Variants compartment**: Lists variant usages for variation definitions/usages.
- **Relationships compartment**: Shows relationships such as `defines`, `specializes`, `subsets`, `connect to`.

# Examples

```
«part def»
Vehicle
  attributes
    mass : MassValue
  parts
    engine : Engine [1]
    wheels : Wheel [4]

«part def»
Truck :> Vehicle
  attributes
    cargoSize : Mass
```

Feature Membership (composite vs. referential):
```
part def PartDef1 {
    part part2 : Part2 [0..*];       // composite (isComposite=true)
    ref part part3 : Part3 [0..*];   // referential (isComposite=false)
}
```

# Related Concepts

- [Definition-Usage Pattern](../rules/definition-usage-pattern.md)
- [Specialization Rules](../rules/specialization-rules.md)
- [Multiplicity Bounds](../rules/multiplicity-bounds.md)

# Citations

[1] OMG SysML v2 Specification, §7.6.1 (Definition and Usage Overview)
[2] OMG SysML v2 Specification, §7.6.2 (Definitions)
[3] OMG SysML v2 Specification, Table 4 (Definition and Usage – Representative Notation)
