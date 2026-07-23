---
type: SysML v2 Concept
title: Item Flow
description: An item flow is a flow usage that transfers items of a specific item definition type between the output feature of a source occurrence and the input feature of a target occurrence.
timestamp: 2026-07-01T00:00:00Z
---

An item flow is a specialization of a streaming flow usage in which the payload transferred between interacting occurrences is typed by an item definition. The item flow identifies the specific output feature of the source from which items are obtained and the specific input feature of the target to which items are delivered.

Item flows are declared using the keyword `flow` with an optional payload specification using the keyword `of`. The payload may be given a name and a type (definition), or just a type. The source output feature is identified after the keyword `from` and the target input feature after the keyword `to`.

# Syntax

```sysml
// Item flow with named payload typed by an item definition
flow fuelFlow : FuelFlow of flowingFuel : Fuel
    from fuelTank.fuelOut to engine.fuelIn;

// Shorthand: no name, definition, or payload — just feature-to-feature
flow fuelTank.fuelOut to engine.fuelIn;
```

# Semantics

A flow usage connects an output feature of a source occurrence to an input feature of a target occurrence. When the payload is constrained by an item definition (such as `Fuel`), the flow models the transfer of values of that type. The flow may be a **streaming flow** (concurrent transfer) or a **succession flow** (source completes before transfer begins, transfer completes before target starts).

# Rules

- A non-abstract flow definition must have exactly two end features.
- The payload type is declared by redefining the `payload` feature of the flow.
- A flow usage must only be defined by flow definitions or KerML interactions.
- The from-feature must be an output feature of the source; the to-feature must be an input feature of the target.

# Examples

```sysml
flow def FuelFlow {
    ref item :>> payload : Fuel;
    end tank : FuelTank;
    end eng : Engine;
}

part def Vehicle {
    part fuelTank : FuelTank { out fuelOut : Fuel; }
    part engine : Engine { in fuelIn : Fuel; }
    flow fuelTank.fuelOut to engine.fuelIn;
}
```

# Relationships

- [flow.md](flow.md) — item flow is a specialization of flow usage
- [message.md](message.md) — a message is an abstract flow not specifying source/target features
- [action.md](action.md) — item flows can connect action usages as source and target

# Citations

[1] OMG SysML v2 Specification, §7.16
