---
type: SysML v2 Concept
title: Conjugated Port
description: A conjugated port is a port definition or usage whose directed features have directions conjugate to those of the original port definition, with in and out reversed and inout unchanged, automatically conforming to its original port.
timestamp: 2026-07-01T00:00:00Z
---

A **conjugated port** in SysML v2 is a port definition or usage with directed features that are the conjugate of those of an original port definition. The conjugate of direction `in` is `out` and vice versa, while `inout` is its own conjugate.

Every port definition implicitly declares a nested conjugated port definition. The name of the conjugated port definition is the name of the original port definition preceded by `~`, within the namespace of the original port definition. For example, a port definition `P` has a conjugated port definition `P::'~P'`.

A conjugated port usage is a shorthand notation for a port usage defined by a conjugated port definition. Instead of using the full qualified name of the conjugated port definition, the `~` symbol can be placed before the name of the original port definition in the type position.

Conjugated ports are fundamental to symmetric connection patterns: if one part has a port of type `P` (with `out fuel`), the connecting part can use a port of type `~P` (automatically having `in fuel`), ensuring the two ports conform to each other.

# Syntax

```sysml
port def FuelingPort {
    out fuelOut : Fuel;
    in fuelReturn : Fuel;
}

// Conjugated port usage shorthand
port fuelInPort : ~FuelingPort;
// Equivalent to:
port fuelInPort : FuelingPort::'~FuelingPort';

// Example of matching ports on two parts
part def FuelTank {
    port supplyPort : FuelingPort;  // out fuelOut, in fuelReturn
}
part def Engine {
    port fuelPort : ~FuelingPort;   // in fuelOut, out fuelReturn (conjugated)
}
```

# Semantics

- The conjugated port definition is implicitly declared nested in every port definition.
- Conjugated directions: `in` → `out`, `out` → `in`, `inout` → `inout`.
- A conjugated port usage automatically conforms to a usage of the original port definition.
- Two ports conform if each feature of one has a matching feature on the other (matching type and conjugate direction).

# Rules

- Every port definition has exactly one implicitly declared nested conjugated port definition.
- The name of the conjugated port definition is always `'~<OriginalName>'` in the namespace of the original.
- The `~` prefix in `port p : ~P;` is not part of a name and does not require quotes.
- If the original port definition name is an unrestricted name (e.g., `'P-1'`), the conjugated usage is `port p : ~'P-1'` (tilde outside quotes).

# Examples

```sysml
port def Pa {
    port p1 : P1;
    port p2 : P2;
    port p3 : P3;
}

part def Part1 {
    port pa : Pa;
}

part def Part2 {
    port pb : ~Pa;  // conjugated port usage; pb conforms to pa
}

// Interface definition using conjugated port
interface def InterfaceDef2 {
    end :>> source : Pa;
    end :>> target : ~Pa;
}
```

# Relationships

- [port-definition.md](port-definition.md) — the original port definition from which the conjugated port is derived
- [port-usage.md](port-usage.md) — conjugated port usages using the `~` shorthand
- [port.md](port.md) — general port concept
- [interface.md](interface.md) — interfaces often connect a port with its conjugated port

# Citations

[1] OMG SysML v2 Specification, §7.12
