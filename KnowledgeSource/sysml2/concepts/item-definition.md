---
type: SysML v2 Concept
title: Item Definition
description: An item definition is a kind of occurrence definition that defines a class of identifiable objects that may be acted on over time but which do not necessarily perform actions themselves.
timestamp: 2026-07-01T00:00:00Z
---

An **item definition** is a kind of occurrence definition that classifies identifiable objects with temporal extent and, optionally, spatial extent. Item definitions are used for objects that exist and can be acted upon—such as fuel, electrical signals, data, or materials flowing through a system—but which do not necessarily perform actions on their own.

Item definitions are declared using the kind keyword `item` (or `item def`). Since all parts are items, part definitions are a specialized kind of item definition.

Items may also have spatial extent; the shape of an item is its boundary in three-dimensional space. The Geometry Domain Library provides basic geometric shapes for spatial modeling.

# Syntax

```sysml
item def Fuel {
    attribute pressure : PressureValue;
    ref item impurities[0..*] : Material;
}

item def ElectricalSignal {
    attribute voltage : Real;
    attribute frequency : Real;
}

item def DataPacket {
    attribute payload : String;
    attribute size : Integer;
}
```

# Semantics

- An item definition classifies a class of identifiable objects with temporal extent.
- Item definitions inherit all occurrence definition semantics (lifetimes, time slices, snapshots, individuals).
- Items may have attributes, states, and nested item usages.
- The base item definition is `Item` from the `Items` library model.
- An item that performs actions is normally modeled as a part definition.

# Rules

- An item definition is declared using the kind keyword `item` (with the `def` suffix).
- An item definition is a kind of occurrence definition.
- An item usage must only be defined by item definitions (of any kind) or KerML structures.
- Part definitions specialize item definitions.

# Examples

```sysml
item def Fuel {
    attribute pressure : PressureValue;
    ref item impurities[0..*] : Material;
}

item def Person;

// Part definition specializes item definition implicitly
part def Vehicle;
// Engine can be an item while being assembled, then a part when installed
item def EnginePart;
part def Engine :> EnginePart;
```

# Relationships

- [item-usage.md](item-usage.md) — usages typed by an item definition
- [item.md](item.md) — general item concept
- [occurrence.md](occurrence.md) — item definitions are a kind of occurrence definition
- [part-definition.md](part-definition.md) — part definitions are a specialized kind of item definition

# Citations

[1] OMG SysML v2 Specification, §7.10
