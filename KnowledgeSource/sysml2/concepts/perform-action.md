---
type: SysML v2 Concept
title: Perform Action
description: A perform action usage is an action usage that specifies that an action is performed by the owner of the perform action usage, referencing the action behavior defined in another context.
timestamp: 2026-07-01T00:00:00Z
---

A perform action usage is declared using the kind keyword `perform action` (or just `perform` with a qualified name) and specifies that an action is performed by the owner of the perform action usage. A perform action usage is always referential — the performed action behavior may be defined in a different context than that of the performer.

If the owner of the perform action usage is an occurrence, then the referenced action performance must be carried out entirely within the lifetime of the performing occurrence.

A perform action usage can be a feature of a part definition or usage (specifying that the referenced action is performed by the containing part during its lifetime) or of an action definition or usage (acting like a referential "call" of the performed action by the containing action).

# Syntax

```sysml
// In a part definition: part performs an action
partdef Vehicle {
    perform action powerVehicle references VehicleActions::providePower;
    abstract perform action moveVehicle; // Performed action is itself.
}

// Short form using just 'perform' with a qualified name
part vehicle : Vehicle {
    perform VehicleActions::move :> Vehicle::moveVehicle;
}

// In an action definition: calling another action
action initialization {
    in item device;
    perform Utility::startUpCheck {
        in component = device;
        out status;
    }
}
```

# Semantics

The performed action of a perform action usage is related to the perform action usage by a reference subsetting relationship, specified textually using the keyword `references` or the symbol `::>`. If the perform action usage has no such reference subsetting, then the performed action is the perform action usage itself.

The `ref` keyword may be used in the declaration, but a perform action usage is always referential whether or not `ref` is included.

When used inside a part, the perform action usage is not the sending context for sub-send-actions within a referenced perform action; the perform action usage itself is the sending/accepting context.

# Rules

- Declared using `perform action` or just `perform`.
- A perform action usage is always a referential (event occurrence) usage.
- If in a part definition or usage, the part is the performer.
- The performed action performance must occur within the lifetime of the performing occurrence.
- The base perform action usage is from the `Actions` library model.

# Examples

```sysml
part part1 : Part1 { perform action1; }
part part2 : Part2 { perform action2; }
```

# Relationships

- [action-usage.md](action-usage.md) — perform action is a kind of action usage
- [action.md](action.md) — the action being performed

# Citations

[1] OMG SysML v2 Specification, §7.17.6
