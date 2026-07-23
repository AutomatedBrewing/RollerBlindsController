---
type: SysML v2 Library
title: Kernel Data Type Library
description: The Kernel Data Type Library defines the standard scalar, vector, and collection data types that underpin all typed values in KerML and SysML v2.
timestamp: 2026-07-01T00:00:00Z
---

The Kernel Data Type Library provides the concrete primitive and structured data types required by the KerML language. It contains three `.kerml` source files that define the hierarchy of scalar numeric and boolean types, multi-dimensional vector value types, and first-class collection container data types. These types are used pervasively throughout both the Kernel Function Library and the SysML Systems Library as the codomains of attributes and the domains of functions.

# Contents

- **ScalarValues** (`ScalarValues.kerml`) — Defines a hierarchy of primitive scalar data types all specializing `Base::DataValue`:
  - `ScalarValue` (abstract root)
  - `Boolean`
  - `String`
  - `NumericalValue` → `Number` → `Complex` → `Real` → `Rational` → `Integer` → `Natural` → `Positive`
- **VectorValues** (`VectorValues.kerml`) — Defines vector (multi-element) numeric value types:
  - `NumericalVectorValue` — abstract base for vectors of numerical values.
  - `ThreeVectorValue` — a concrete vector with exactly three numerical elements, used by the geometry and quantities libraries.
- **Collections** (`Collections.kerml`) — Defines structured collection data types:
  - `Collection` (abstract) — a `DataValue` containing an `elements` feature.
  - `OrderedCollection` — ordered, non-unique elements.
  - `UniqueCollection` — unique, non-ordered elements.
  - `Bag` — ordered, non-unique (multiset).
  - `Set` — unique, non-ordered.
  - `OrderedSet` — unique and ordered.
  - `Array` — fixed-dimensional tensor array; includes `dimensions` and `rank`.
  - `Matrix` — two-dimensional `Array`.

# Key Types

| Type | Specializes | Description |
|---|---|---|
| `Boolean` | `ScalarValue` | True/false values. |
| `String` | `ScalarValue` | Text values. |
| `Complex` | `Number` | Complex numeric values. |
| `Real` | `Complex` | Real-number values (floating point). |
| `Rational` | `Real` | Rational-number values. |
| `Integer` | `Rational` | Integer values (positive, negative, zero). |
| `Natural` | `Integer` | Non-negative integers; used for multiplicities. |
| `Positive` | `Natural` | Strictly positive integers. |
| `NumericalVectorValue` | `DataValue` | Abstract multi-element numeric vector. |
| `ThreeVectorValue` | `NumericalVectorValue` | Three-element vector for 3D quantities. |
| `Set` | `UniqueCollection` | Unordered collection of unique elements. |
| `OrderedSet` | `Set`, `OrderedCollection` | Ordered collection of unique elements. |
| `Array` | `OrderedCollection` | Multidimensional tensor container. |

# Usage

These types are typically used as the type of `attribute` features in SysML v2 models:

```sysml
attribute mass : ScalarValues::Real;
attribute flags : Collections::Set;
attribute velocity : VectorValues::ThreeVectorValue;
```

They are implicitly available through the Systems Library's transitive imports. For kernel-level work, import directly:

```sysml
private import ScalarValues::*;
private import Collections::Set;
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Kernel Libraries\Kernel Data Type Library\`

Files: `ScalarValues.kerml`, `VectorValues.kerml`, `Collections.kerml`

# Related Libraries

- [Kernel Semantic Library](./kernel-semantic-library.md)
- [Kernel Function Library](./kernel-function-library.md)
- [Quantities and Units Library](./quantities-units-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
