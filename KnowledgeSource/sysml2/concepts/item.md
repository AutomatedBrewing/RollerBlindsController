---
type: SysML v2 Concept
title: Item
description: An item in SysML v2 is an identifiable object with temporal (and possibly spatial) extent that may be acted on but does not necessarily perform actions itself, covering both item definitions and item usages.
timestamp: 2026-07-01T00:00:00Z
---

An **item** in SysML v2 encompasses both item definitions and item usages. Items represent identifiable objects that exist over time and may be acted upon, but do not necessarily perform actions themselves. Examples include physical materials (fuel, water), data signals, electrical signals, and physical components before assembly.

Items are a specialized kind of occurrence: they have temporal extent (a lifetime) and possibly spatial extent (a shape in 3D space). Items can have attributes, states, and nested item usages. All parts are items, but not all items are parts—a component can transition between being treated as an item (e.g., moving along an assembly line) and as a part (once assembled and actively performing functions).

# Syntax

```sysml
item def Fuel {
    attribute pressure : PressureValue;
    ref item impurities[0..*] : Material;
}

item fuel1 : Fuel;
```

# Semantics

- Item definitions classify identifiable objects with temporal extent.
- Item usages represent individual instances or collections of such objects.
- Items may have spatial extent; the Geometry Domain Library provides models for geometric shapes.
- Items can have enveloping shapes (bounding shapes that surround them).
- The base item definition is `Item` and the base usage is `items` from the `Items` library model.

# Rules

- An item definition is a kind of occurrence definition.
- An item usage must only be defined by item definitions (of any kind) or KerML structures.
- The default multiplicity of an item usage is `[1..1]` under the standard conditions.
- Parts are a specialized kind of items.

# Examples

```sysml
item def ElectricalSignal {
    attribute voltage : Real;
    attribute current : Real;
}

item def DataPacket {
    attribute payload : String;
    attribute timestamp : Integer;
}

part def FuelSystem {
    item def Fuel;
    ref item fuelSupply : Fuel;
}
```

# Relationships

- [item-definition.md](item-definition.md) — the definition side of items
- [item-usage.md](item-usage.md) — the usage side of items
- [occurrence.md](occurrence.md) — items are a specialized kind of occurrence
- [part.md](part.md) — parts are a specialized kind of item

# Citations

[1] OMG SysML v2 Specification, §7.10
