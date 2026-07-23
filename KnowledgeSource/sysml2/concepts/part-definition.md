---
type: SysML v2 Concept
title: Part Definition
description: A part definition is a kind of item definition that represents a modular unit of structure such as a system, system component, or external entity that may directly or indirectly interact with the system and may perform actions.
timestamp: 2026-07-01T00:00:00Z
---

A **part definition** is a kind of item definition that classifies modular structural units of a system. Part definitions represent systems, subsystems, components, or external entities that may interact with the system. A part can represent any level of abstraction—from a purely logical component to a physical component with a part number.

Part definitions are used to model different kinds of system components: hardware components, software components, facilities, organizations, or users. A system is modeled as a composite part definition that contains nested part usages.

Since a part definition is a kind of item definition, it inherits all item semantics including temporal extent, spatial extent, attributes, states, and the ability to flow through connections.

# Syntax

```sysml
part def Vehicle {
    ref part driver[0..1] : Person;
    part engine : Engine;
    part wheels[4] : Wheel;
    port fuelPort : FuelPort;
}

// Abstract part definition
abstract part def Sensor {
    attribute precision : Real;
    attribute range : Real;
}

// Part definition specializing another
part def TemperatureSensor :> Sensor {
    attribute calibrationOffset : Real = 0.0;
}
```

# Semantics

- A part definition classifies objects that have temporal extent and can perform actions.
- Part definitions inherit all occurrence and item definition semantics.
- The base part definition is `Part` from the `Parts` library model.
- A part definition is always (implicitly if not explicitly) defined by at least one part definition (through the base `Part`).

# Rules

- A part definition is declared using the kind keyword `part` with the `def` suffix.
- A part definition is a kind of item definition, which is a kind of occurrence definition.
- Part usages must only be defined by item definitions (including part definitions) or KerML structures.
- The `individual` keyword may precede `part def` to declare an individual part definition.

# Examples

```sysml
item def Person;

part def Vehicle {
    ref part driver[0..1] : Person;
    part engine : Engine;
    part wheels[4] : Wheel;
}

part def ElectricVehicle :> Vehicle {
    part battery : Battery;
    part motor : ElectricMotor;
    redefines engine : ElectricMotor;
}
```

# Relationships

- [part-usage.md](part-usage.md) — usages typed by a part definition
- [part.md](part.md) — general part concept
- [item-definition.md](item-definition.md) — part definitions are a specialized kind of item definition
- [port-definition.md](port-definition.md) — port definitions define connection points on parts

# Citations

[1] OMG SysML v2 Specification, §7.11
