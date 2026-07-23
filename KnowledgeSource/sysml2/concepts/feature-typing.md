---
type: SysML v2 Concept
title: Feature Typing
description: Feature typing is the specialization relationship that specifies the definition (type) of a usage, determining what kind of things are values of that usage.
timestamp: 2026-07-01T00:00:00Z
---

**Feature typing** is the specialization relationship that relates a **usage** to one or more **definitions** (its types). The definitions given as the types of a usage constrain what things can be values of the usage. A usage must be typed by definitions that are consistent with its kind (e.g., a part usage must be typed by a part definition, an action usage by an action definition, etc.).

If no type is explicitly specified for a usage, the usage is implicitly typed by the most general definition of its kind from the Systems Model Library.

In textual notation, feature typings are declared using the `:` symbol or the `defined by` keyword.

# Syntax

```sysml
// Single feature typing with ':':
part part1 : PartDef1;

// Multiple feature typings:
item x : A, B;

// Feature typing with 'defined by' keyword:
part part1 defined by PartDef1;

// Combined typing, subsetting, and redefinition:
item x : A, B :> f :>> g;
// Equivalent to:
item x defined by A defined by B subsets f redefines g;

// Implicit typing (no explicit type given):
part engine;  // implicitly typed by Parts::Part
```

# Semantics

- Feature typing relates a usage (the typed feature) to one or more definitions (the types).
- The definitions constrain what instances can be values of the usage.
- A usage may have more than one feature typing (multiple types), in which case values must be instances of all specified definitions.
- The type definitions given must be consistent with the kind of the usage being typed.
- If no feature typing is explicitly specified, the usage is implicitly typed by the most general definition of its kind from the Systems Model Library.
- A usage inherits the features of all its types (definitions) just as a specialized definition inherits features via subclassification.

# Rules

1. Feature typings are declared after `:` or `defined by` in the usage declaration.
2. Multiple types are listed as a comma-separated sequence.
3. Types must be consistent with the kind of the usage.
4. If no type is specified, the most general definition of the appropriate kind is used as an implicit type.
5. A usage inherits the features of all its types.

# Examples

```sysml
// Part usage typed by a part definition:
part vehicle : Vehicle;

// Item usage with multiple types:
item x : A, B;

// Port usage with explicit type:
port p1 : InterfaceDef;

// Implicitly typed usage:
part engine; // implicitly: part engine : Parts::Part;
attribute a; // implicitly: attribute a : Attributes::AttributeValue;
```

# Relationships

- [usage.md](usage.md) — feature typing is one of the specialization kinds for usages
- [definition.md](definition.md) — a definition serves as the type in a feature typing
- [subclassification.md](subclassification.md) — the analogous relationship between definitions
- [subsetting.md](subsetting.md) — subsetting and feature typing are both kinds of specialization for usages

# Citations

[1] OMG SysML v2 Specification, §7.6.3
