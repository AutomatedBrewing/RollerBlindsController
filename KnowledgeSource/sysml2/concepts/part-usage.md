---
type: SysML v2 Concept
title: Part Usage
description: A part usage is a kind of item usage that is a usage of one or more part definitions (or item definitions), representing a named structural component within a system context.
timestamp: 2026-07-01T00:00:00Z
---

A **part usage** is a kind of item usage that represents a structural component within a system context. It may be defined by part definitions, but may also be defined by item definitions that are not part definitions, allowing a part to be treated like an item in some contexts (e.g., when flowing through an assembly line) and as a part in other contexts (e.g., when installed and performing actions).

Part usages can be composite (owned by the containing part) or referential. Composite part usages form the structural decomposition of a system. Part usages may have ports, perform actions, exhibit states, and be connected to other parts.

# Syntax

```sysml
part def Vehicle {
    ref part driver[0..1] : Person;
    part engine : Engine;
    part wheels[4] : Wheel;
}

part vehicle1 : Vehicle;

// Part with ports
part fuelTank : FuelTank {
    port fuelOutPort : FuelingPort;
}

// Part performing an action
part controller {
    perform action controlLoop;
}
```

# Semantics

- A part usage is always directly or indirectly defined by at least one part definition (via the base `Part`).
- The default multiplicity of a part usage is `[1..1]` under the standard conditions.
- The base part usage is `parts` from the `Parts` library model.
- Part usages can have time slices, snapshots, and can be declared as individual.

# Rules

- A part usage must only be defined by item definitions (including part definitions) or KerML structures.
- The default multiplicity is `[1..1]` unless otherwise specified.
- Part usages are declared using the kind keyword `part` (without `def`).
- The `individual`, `timeslice`, or `snapshot` keyword may precede the part keyword.

# Examples

```sysml
part def Automobile {
    part body : Body;
    part powertrain {
        part engine : Engine;
        part transmission : Transmission;
    }
    part wheels[4] : Wheel;
    ref part driver[0..1] : Person;
}

// Part in an action context
part def Camera {
    perform action focus : Focus;
    perform action shoot : Shoot;
}
```

# Relationships

- [part-definition.md](part-definition.md) — the definition that types this usage
- [part.md](part.md) — general part concept
- [item-usage.md](item-usage.md) — part usages are a specialized kind of item usage
- [port-usage.md](port-usage.md) — port usages are connection points on part usages
- [connection-usage.md](connection-usage.md) — connections that link part usages

# Citations

[1] OMG SysML v2 Specification, §7.11
