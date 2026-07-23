---
type: SysML v2 Concept
title: Part
description: A part in SysML v2 is the general concept covering both part definitions and part usages, representing modular structural units such as systems, components, or external entities that may directly or indirectly interact with and perform actions in the system.
timestamp: 2026-07-01T00:00:00Z
---

A **part** in SysML v2 covers both part definitions and part usages. Parts are modular structural units of a system model that can directly or indirectly interact with the system and may perform actions. Parts represent system components at any level of abstraction—logical components, physical components with part numbers, hardware, software, facilities, organizations, or users.

A system is modeled as a composite part. Its part usages may have further composite structure (nested parts). Parts can have:
- **Attributes** representing performance, physical, and quality characteristics
- **Ports** defining connection points for interactions
- **Actions** that the part performs
- **States** that influence the part's behavior

Parts are a specialized kind of item; all parts are items, but not all items are parts.

# Syntax

```sysml
part def Vehicle {
    ref part driver[0..1] : Person;
    part engine : Engine;
    part wheels[4] : Wheel;
}

part vehicle1 : Vehicle;
```

# Semantics

- A part definition is a kind of item definition; part usages are kinds of item usages.
- The base part definition is `Part` and the base usage is `parts` from the `Parts` library model.
- Every part usage is always directly or indirectly defined by at least one part definition.
- Parts can represent purely logical components or physical components with part numbers.

# Rules

- A part definition is declared using the kind keyword `part` with the `def` suffix.
- A part usage must only be defined by item definitions (including part definitions) or KerML structures.
- The default multiplicity of a part usage is `[1..1]` under the standard conditions.

# Examples

```sysml
part def Automobile {
    part body : Body;
    part powertrain : Powertrain {
        part engine : Engine;
        part transmission : Transmission;
    }
    part wheels[4] : Wheel;
    port fuelPort : FuelPort;
}

// Part performing an action
part controller {
    perform action controlLoop;
}
```

# Relationships

- [part-definition.md](part-definition.md) — the definition side of a part
- [part-usage.md](part-usage.md) — the usage side of a part
- [item.md](item.md) — parts are a specialized kind of item
- [port.md](port.md) — ports are connection points on parts
- [connection.md](connection.md) — connections link parts together

# Citations

[1] OMG SysML v2 Specification, §7.11
