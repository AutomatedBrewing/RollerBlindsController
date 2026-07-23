---
type: SysML v2 Library
title: Kernel Function Library
description: The Kernel Function Library defines the standard built-in functions for all primitive and collection value types used across KerML and SysML v2.
timestamp: 2026-07-01T00:00:00Z
---

The Kernel Function Library provides the complete set of predefined function packages that correspond to the built-in operators and expression forms of the KerML language. All files carry the `.kerml` extension and are declared as `standard library package` elements. The functions in this library are invoked implicitly when KerML/SysML v2 expression syntax is used (for example, `+`, `==`, `not`, indexing with `#`). Concrete SysML models rarely import from this library directly; instead they inherit these functions through the Systems Library.

# Contents

- **BaseFunctions** (`BaseFunctions.kerml`) — Equality (`==`, `!=`, `===`, `!==`), type-testing (`istype`, `hastype`, `@`), string conversion (`ToString`), sequence construction (`,`), filtering (`[`), and index access (`#`), and instance-set retrieval (`all`).
- **BooleanFunctions** (`BooleanFunctions.kerml`) — Logical operators `not`, `and`, `or`, `xor`, `implies` on `Boolean` values.
- **NumericalFunctions** (`NumericalFunctions.kerml`) — Abstract arithmetic operations (`+`, `-`, `*`, `/`, `**`, `%`) and comparison (`<`, `>`, `<=`, `>=`) on `NumericalValue`.
- **IntegerFunctions** (`IntegerFunctions.kerml`) — Integer arithmetic including bitwise and modulo operations.
- **NaturalFunctions** (`NaturalFunctions.kerml`) — Functions specific to `Natural` numbers.
- **RealFunctions** (`RealFunctions.kerml`) — Floating-point functions: `sqrt`, `abs`, `floor`, `round`, `log`, `exp`, and the constant `pi`.
- **RationalFunctions** (`RationalFunctions.kerml`) — Functions for `Rational` number types.
- **ComplexFunctions** (`ComplexFunctions.kerml`) — Complex number operations: real/imaginary part extraction, conjugate.
- **StringFunctions** (`StringFunctions.kerml`) — String operations: `size`, `substring`, `concat`, `matches`.
- **ScalarFunctions** (`ScalarFunctions.kerml`) — Functions applicable to all `ScalarValue` types including `min`, `max`, and comparison wrappers.
- **SequenceFunctions** (`SequenceFunctions.kerml`) — Collection-sequence operations: `size`, `isEmpty`, `notEmpty`, `includes`, `excludes`, `union`, `intersection`, `difference`, `equals`, `collect`, `select`, `reject`, `sortedBy`.
- **CollectionFunctions** (`CollectionFunctions.kerml`) — Functions over structured `Collection` data types: `contains`, `includes`, `asSet`, `asBag`, `asSequence`.
- **ControlFunctions** (`ControlFunctions.kerml`) — Higher-order control: `if`/`else`, `forAll`, `exists`, loop expressions.
- **DataFunctions** (`DataFunctions.kerml`) — Functions for `DataValue` copying and comparison.
- **OccurrenceFunctions** (`OccurrenceFunctions.kerml`) — Functions on `Occurrence` instances: `destroy`.
- **TrigFunctions** (`TrigFunctions.kerml`) — Trigonometric functions: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`.
- **VectorFunctions** (`VectorFunctions.kerml`) — Vector operations: dot product, cross product, norm, `isZeroVector`.

# Key Types

| Function Package | Key Operations |
|---|---|
| `BaseFunctions` | `==`, `!=`, `===`, `!==`, `istype`, `hastype`, `all`, `ToString` |
| `BooleanFunctions` | `not`, `and`, `or`, `xor`, `implies` |
| `NumericalFunctions` | `+`, `-`, `*`, `/`, `**`, `%`, `<`, `>`, `<=`, `>=` |
| `RealFunctions` | `sqrt`, `abs`, `floor`, `round`, `log`, `exp`, `pi` |
| `StringFunctions` | `size`, `concat`, `substring`, `matches` |
| `SequenceFunctions` | `size`, `isEmpty`, `includes`, `union`, `select`, `collect` |
| `ControlFunctions` | `if`, `forAll`, `exists` |
| `TrigFunctions` | `sin`, `cos`, `tan`, `asin`, `acos`, `atan` |
| `VectorFunctions` | dot product, cross product, `isZeroVector` |

# Usage

Functions in this library are used implicitly through KerML/SysML v2 expression syntax. For explicit use, import the relevant package:

```sysml
private import RealFunctions::sqrt;
private import SequenceFunctions::*;
private import ControlFunctions::forAll;
```

Example usage in a constraint:

```sysml
assert constraint { sqrt(a**2 + b**2) == c }
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Kernel Libraries\Kernel Function Library\`

Key files: `BaseFunctions.kerml`, `BooleanFunctions.kerml`, `NumericalFunctions.kerml`, `IntegerFunctions.kerml`, `RealFunctions.kerml`, `StringFunctions.kerml`, `SequenceFunctions.kerml`, `CollectionFunctions.kerml`, `ControlFunctions.kerml`, `TrigFunctions.kerml`, `VectorFunctions.kerml`, `OccurrenceFunctions.kerml`, `ScalarFunctions.kerml`, `DataFunctions.kerml`

# Related Libraries

- [Kernel Semantic Library](./kernel-semantic-library.md)
- [Kernel Data Type Library](./kernel-data-type-library.md)
- [Systems Library](./systems-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
