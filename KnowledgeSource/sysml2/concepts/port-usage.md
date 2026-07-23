---
type: SysML v2 Concept
title: Port Usage
description: A port usage is a kind of occurrence usage that is a usage of a port definition, representing a specific connection point on a part or other occurrence at which interactions with other occurrences can take place.
timestamp: 2026-07-01T00:00:00Z
---

A **port usage** is a usage of a port definition. It represents a specific connection point on an owning part or other occurrence. Port usages define the interaction interface of a structural element—they specify exactly what the element exchanges with other elements in the system.

A port usage may be connected to one or more other port usages via connections or interfaces. The features of the port usage (whether inherited from its definition or declared locally) specify what can be exchanged through those connections. Port usages may contain nested port usages.

A conjugated port usage is a shorthand for declaring a port usage typed by the conjugated port definition of another port definition, using the `~` prefix on the original port definition name.

# Syntax

```sysml
part def FuelTank {
    port fuelOutPort : FuelingPort;
    port fuelInPort : ~FuelingPort;  // conjugated port usage
}

// Port usage with local features
port def FuelingPort {
    out fuelOut : Fuel;
    in fuelReturn : Fuel;
}

// Nested port usages in a composite port
port def SystemBoundary {
    port dataPort : DataPort;
    port powerPort : PowerPort;
}

part def ComplexSystem {
    port boundary : SystemBoundary;
}
```

# Semantics

- A port usage is a kind of occurrence usage; ports participate in the occurrence lifecycle.
- The default multiplicity of a port usage is `[1..1]` under the standard conditions.
- All non-port features of a port usage must be referential (non-composite).
- Port usages can have nested port usages.
- The base port usage is `ports` from the `Ports` library model.
- A conjugated port usage using `~` notation is equivalent to using the full conjugated port definition name.

# Rules

- A port usage must only be defined by port definitions.
- All features other than nested port usages must be referential.
- Conjugated port usage: `port p : ~P;` is equivalent to `port p : P::'~P';`
- The `~` prefix for conjugated port usages does not need to be inside quotes, unlike the actual conjugated port definition name.

# Examples

```sysml
part def Sensor {
    port dataOutPort : DataPort;
    port powerInPort : ~PowerPort;
}

part def DataLogger {
    port dataInPort : ~DataPort;  // matches Sensor's dataOutPort
    port powerInPort : ~PowerPort;
}

// Part with multiple ports including nested ports
part def Hub {
    port externalPort : ExternalInterface {
        port data : DataPort;
        port control : ControlPort;
    }
    port internalPort : InternalInterface;
}
```

# Relationships

- [port-definition.md](port-definition.md) — the definition that types this port usage
- [port.md](port.md) — general port concept
- [conjugated-port.md](conjugated-port.md) — conjugated port usages and definitions
- [interface-usage.md](interface-usage.md) — interfaces connect port usages
- [part-usage.md](part-usage.md) — port usages are typically owned by part usages

# Citations

[1] OMG SysML v2 Specification, §7.12
