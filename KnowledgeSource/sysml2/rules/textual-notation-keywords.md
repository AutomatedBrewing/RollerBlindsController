---
type: SysML v2 Rule
title: Textual Notation Reserved Keywords
description: SysML v2 defines a fixed set of reserved keywords that cannot be used as ordinary identifiers in textual notation, along with symbolic equivalents for certain keywords.
timestamp: 2026-07-01T00:00:00Z
---

The lexical structure of the SysML v2 textual notation defines reserved keywords that have special syntactic meaning. These keywords cannot be used as regular identifiers (names) in a model without quoting them as unrestricted names.

# Rule Statement

## Reserved Keywords

The following are the reserved keywords of SysML v2:

```
about abstract accept action actor after alias all allocate allocation analysis
and as assert assign assume at attribute bind binding by calc case comment
concern connect connection constant constraint crosses decide def default
defined dependency derived do doc else end entry enum event exhibit exit expose
false filter first flow for fork frame from hastype if implies import in include
individual inout interface istype item join language library locale loop merge
message meta metadata nonunique not null objective occurrence of or ordered out
package parallel part perform port private protected public redefines ref
references render rendering rep require requirement return satisfy send snapshot
specializes stakeholder standard state subject subsets succession terminate then
timeslice to transition true until use variant variation verification verify via
view viewpoint when while xor
```

## Symbolic Equivalents

The following special lexical terminals match either certain keywords or their symbolic equivalents:

| Symbol | Keyword Equivalent |
|--------|-------------------|
| `:` | `defined by` |
| `:>` | `specializes` or `subsets` |
| `::>` | `references` |
| `=>` | `crosses` |
| `:>>` | `redefines` |

## Lexical Conventions

- The lexical structure of the SysML textual notation is identical to that of the KerML textual notation, except for the SysML-specific reserved keywords and symbolic equivalents listed above.
- Tooling for the SysML textual notation should generally highlight keywords relative to other text (e.g., using boldface and/or distinctive coloring), though no specific highlighting is required.
- SysML textual notation documents are expected to be interchanged as plain text.
- To use a reserved keyword as a name (identifier), it must be enclosed in single quotes as an unrestricted name (e.g., `'if'`).

# Rationale

A fixed set of reserved keywords is necessary to unambiguously parse the SysML textual notation. The symbolic equivalents provide concise alternatives to verbose keyword phrases, enabling a notation style consistent with previous modeling languages (such as the colon for typing in UML).

# Examples

```
// Using keyword 'def' for definitions
part def Vehicle;

// Using symbol ':' instead of 'defined by'
part myVehicle : Vehicle;

// Using symbol ':>' instead of 'subsets'
part frontWheel :> wheels;

// Using symbol ':>>' instead of 'redefines'
part part2R : Part2R :>> part2;

// Using symbol ':>' instead of 'specializes' for definitions
part def Truck :> Vehicle;

// Using an unrestricted name to use a keyword as an identifier
attribute 'if' : Boolean;
```

# Violations

- Using a reserved keyword as an unquoted identifier (name).
- Using the symbol `:>` when `redefines` (`:>>`) is intended (these are different relationships).
- Confusing `::>` (references, cross-subsetting) with `::` (qualified name separator).

# Related Concepts

- [Definition-Usage Pattern](definition-usage-pattern.md)
- [Specialization Rules](specialization-rules.md)
- [Name Resolution](name-resolution.md)

# Citations

[1] OMG SysML v2 Specification, §8.2.2.1.2 (Lexical Structure)
