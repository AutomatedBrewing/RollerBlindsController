---
type: SysML v2 Concept
title: Interface
description: An interface in SysML v2 is the general concept covering both interface definitions and interface usages, representing connections whose ends are restricted to ports, enabling specification and reuse of compatible connection patterns between parts.
timestamp: 2026-07-01T00:00:00Z
---

An **interface** in SysML v2 covers both interface definitions and interface usages. An interface is simply a connection whose ends are all ports. As such, it facilitates the specification and reuse of compatible connection patterns between parts.

Interfaces are used to model standardized interaction contracts between parts. For example, a `Power` interface between an `Appliance` and `WallPower` defines the power port on one end and the outlet port on the other. This interface can be reused to connect many different appliances to wall power.

Interfaces can also model physical interactions where the port features are constrained by conservation laws (e.g., Kirchhoff's Laws for electrical interfaces, with voltage as the across variable and current as the through variable).

When a send action sends a transfer via a port at one end of a binary interface, the port at the other end automatically becomes the target of the transfer.

# Syntax

```sysml
port def FuelingPort {
    out fuel : Fuel;
}

interface def FuelingInterface {
    end fuelOutPort : FuelingPort;
    end fuelInPort : ~FuelingPort;
}

interface fuelLine : FuelingInterface
    connect fuelTank.fuelingPort to engine.fuelingPort;

// Shorthand (no interface definition needed)
interface fuelTank.fuelingPort to engine.fuelingPort;
```

# Semantics

- An interface is a connection whose ends must be port usages.
- Interfaces enable automatic transfer routing: a send on one port targets the port at the other end.
- If a port is connected by multiple interfaces, an outgoing transfer targets exactly one of the other-end ports.
- Interface definitions can contain constraints (e.g., for across/through variable conservation).
- The base interface definition is `Interface` (or `BinaryInterface`) from the `Interfaces` library.

# Rules

- Interface ends must be port usages.
- Interface definitions and usages must only be defined by interface definitions.
- Binary interfaces use `BinaryInterface` as their base; only ports at the two ends.
- Transfers via ports happen across interfaces, not across other connection types.

# Examples

```sysml
port def ElectricalPort {
    attribute voltage : VoltageValue;
    attribute current : CurrentValue;
}

interface def ElectricalInterface {
    end positive : ElectricalPort;
    end negative : ~ElectricalPort;
}

interface powerLine : ElectricalInterface
    connect powerSupply.outPort to load.inPort;
```

# Relationships

- [interface-definition.md](interface-definition.md) — the definition side of interfaces
- [interface-usage.md](interface-usage.md) — the usage side of interfaces
- [port.md](port.md) — interface ends are ports
- [connection.md](connection.md) — interfaces are a specialized kind of connection

# Citations

[1] OMG SysML v2 Specification, §7.14
