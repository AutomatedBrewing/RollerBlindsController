---
type: SysML v2 Concept
title: Port
description: A port in SysML v2 is the general concept covering both port definitions and port usages, providing connection points on parts or other occurrences that define what can be exchanged in interactions with other parts.
timestamp: 2026-07-01T00:00:00Z
---

A **port** in SysML v2 covers both port definitions and port usages. Ports are connection points that enable interactions between occurrences (most commonly parts). The features of a port specify what can be exchanged in interactions—items, attributes, and nested ports.

Port features may be **directed**, having one of the directions `in`, `out`, or `inout`. Flows nested in connections between ports model transfers between matching directed features. Two features match if they have conforming definitions and either both have no direction or have conjugate directions (`in` ↔ `out`, `inout` ↔ `inout`).

Each port definition implicitly has a **conjugated port definition** whose directed features have reversed directions (`in` and `out` swapped). A conjugated port usage automatically conforms to a usage of the original port definition, enabling standard connection patterns.

# Syntax

```sysml
port def FuelingPort {
    attribute flowRate : Real;
    out fuelOut : Fuel;
    in fuelReturn : Fuel;
}

part def FuelTank {
    port fuelOutPort : FuelingPort;
    port fuelInPort : ~FuelingPort;  // conjugated port usage
}
```

# Semantics

- Ports are kinds of occurrences; they have lifetimes.
- Port definitions and usages can contain nested port usages.
- All features of a port definition or usage (other than nested port usages) must be referential.
- Two ports conform if each feature of one has a matching feature on the other.
- Transfers can flow from `out` features of one port to matching `in` features of connected ports.

# Rules

- Port usages must only be defined by port definitions.
- The default multiplicity of a port usage is `[1..1]` under the standard conditions.
- All non-port features of a port definition or port usage must be referential (non-composite).
- Conjugated port definitions are implicitly created with names `'~PortName'`.

# Examples

```sysml
port def DataPort {
    in data : DataPacket;
    out acknowledgment : Ack;
}

part def Sensor {
    port dataOut : DataPort;
}

part def Controller {
    port dataIn : ~DataPort;  // conjugated: in becomes out, out becomes in
}
```

# Relationships

- [port-definition.md](port-definition.md) — the definition side of a port
- [port-usage.md](port-usage.md) — the usage side of a port
- [conjugated-port.md](conjugated-port.md) — the automatically created conjugate of a port definition
- [interface.md](interface.md) — interfaces connect ports
- [part.md](part.md) — ports are typically owned by parts

# Citations

[1] OMG SysML v2 Specification, §7.12
