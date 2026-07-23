---
type: SysML v2 Concept
title: Interface Definition
description: An interface definition is a kind of connection definition whose ends are restricted to be port definitions, enabling the specification of reusable compatible connection patterns between parts via their ports.
timestamp: 2026-07-01T00:00:00Z
---

An **interface definition** is a kind of connection definition whose ends are restricted to port definitions (not just any part definitions). Interface definitions represent standardized interaction contracts between parts: they specify which port types can be connected and what can be exchanged through those connections.

Because all ends are ports, the `port` keyword is optional on end features of an interface definition (when no owned cross feature is declared). Interface definitions can contain flows to explicitly model the transfers between the connected ports, and may contain constraints (e.g., for modeling physical conservation laws like Kirchhoff's Laws for electrical components).

Every non-abstract interface definition is either binary (having exactly two port ends) or uses the `BinaryInterface` base. Binary interface definitions have special semantics for automatic transfer routing.

# Syntax

```sysml
port def FuelingPort {
    out fuel : Fuel;
}

interface def FuelingInterface {
    end fuelOutPort : FuelingPort;
    end fuelInPort : ~FuelingPort;
}

// Interface definition with nested flows
interface def Interface2 {
    end supplierP : Pa;
    end consumerP : ~Pa;
    flow supplierP.i1Out to consumerP.i1Out;
    flow consumerP.i2In to supplierP.i2In;
}
```

# Semantics

- An interface definition is a kind of connection definition; its ends must be port usages.
- The `port` keyword is optional on interface definition ends (when no owned cross feature is declared).
- The base interface definition is `Interface` from the `Interfaces` library; binary interfaces use `BinaryInterface`.
- Interface definitions can contain constraints to model physical interaction laws.
- Interface definitions can contain nested flow definitions to specify item transfers between ports.

# Rules

- All end features must be port usages (typed by port definitions).
- An interface definition is declared using the `interface` kind keyword with the `def` suffix.
- Interface usages must only be defined by interface definitions.
- The shorthand notations for connection usages also apply to interface usages.

# Examples

```sysml
port def Pa {
    port p1 : P1;
    port p2 : P2;
}

interface def SimpleInterface {
    end source : Pa;
    end target : ~Pa;
}

// Electrical interface with conservation constraints
port def ElectricalPort {
    attribute voltage : VoltageValue;
    attribute current : CurrentValue;
}

interface def ElectricalInterface {
    end pos : ElectricalPort;
    end neg : ~ElectricalPort;
    // Conservation: voltages equal, currents sum to zero
}
```

# Relationships

- [interface-usage.md](interface-usage.md) — usages of this interface definition
- [interface.md](interface.md) — general interface concept
- [connection-definition.md](connection-definition.md) — interface definitions are a specialized kind of connection definition
- [port-definition.md](port-definition.md) — port definitions used as interface ends

# Citations

[1] OMG SysML v2 Specification, §7.14
