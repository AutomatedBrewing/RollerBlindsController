---
type: SysML v2 Concept
title: Flow
description: A flow is a flow usage that is an action usage representing the performance of a directed transfer of payload between interacting occurrences, classified by a flow definition.
timestamp: 2026-07-01T00:00:00Z
---

A flow definition is both a relationship and a kind of action definition that classifies transfers of some payload between interacting occurrences, such as parts and actions. A flow definition is a binary relationship between two ends: the **source**, from which the payload comes, and the **target**, to which the payload is delivered. The transferred payload can be anything (attribute value, item, part, etc.).

A flow usage is an action usage that is a usage of a flow definition, connecting usage elements such as part and action usages. It represents the performance of a transfer, as classified by its flow definition, between the values of the interacting usages, which must be occurrences. The transfer is directed from the first end (the source) to the second end (the target).

There are three kinds of flows:

1. **Message** — a flow usage specifying that some transfer happens between source and target ends without specifying how the payload is obtained or delivered.
2. **Streaming flow** — a flow usage that additionally identifies the output feature of the source from which the payload is obtained and the input feature of the target to which the payload is delivered.
3. **Succession flow** — a flow usage that is both a flow usage and a succession, adding the constraint that the transfer source must complete before the transfer starts, and the transfer must complete before the target can start.

# Syntax

```sysml
// Streaming flow (shorthand, no name or definition)
flow fuelTank.fuelOut to engine.fuelIn;

// Named streaming flow with definition and payload
flow fuelFlow : FuelFlow of flowingFuel : Fuel
    from fuelTank.fuelOut to engine.fuelIn;

// Succession flow
succession flow focus.image to shoot.image;
```

# Semantics

A flow usage connects an output feature of the source occurrence to an input feature of the target occurrence. A **streaming flow** allows transfer while both source and target actions are performing concurrently. A **succession flow** enforces that the source must finish before the transfer begins and the transfer must finish before the target can start.

The binding of action parameters does not model actual transfer of items that takes time; flows model such transfers explicitly.

# Rules

- A non-abstract flow definition is always binary, having exactly two end features.
- An abstract flow definition may have fewer than two end features.
- The payload of a flow definition can be constrained by redefining the `payload` feature.
- A flow usage must only be defined by flow definitions or KerML interactions.
- Similar specialization and inheritance rules apply to flow definitions and usages as to connection definitions and usages.

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
    flow fuelFlow : FuelFlow of flowingFuel : Fuel
        from fuelTank.fuelOut to engine.fuelIn;
}

action def TakePicture {
    action focus : Focus { out image : Image; }
    action shoot : Shoot { in image : Image; }
    succession flow focus.image to shoot.image;
}
```

# Relationships

- [item-flow.md](item-flow.md) — item flows carry typed items along connections
- [message.md](message.md) — a message is a special abstract kind of flow usage
- [action.md](action.md) — flows are action usages; source and target are typically action usages
- [succession.md](succession.md) — a succession flow is also a succession

# Citations

[1] OMG SysML v2 Specification, §7.16
