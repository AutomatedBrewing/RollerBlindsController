---
type: SysML v2 Concept
title: Item Usage
description: An item usage is a usage of one or more item definitions (or KerML structures) representing an instance or collection of identifiable objects that may be acted upon within a system context.
timestamp: 2026-07-01T00:00:00Z
---

An **item usage** is a usage of one or more item definitions. It represents an individual item, or a collection of items, within a specific modeling context. Item usages are used to model inputs and outputs of actions (such as water, fuel, electrical signals, or data), items flowing through a system, or items stored by a system.

Item usages can be composite (owned by the containing occurrence) or referential. They may have attributes, states, and nested item usages. Since parts are specialized items, part usages are also item usages.

# Syntax

```sysml
item fuel1 : Fuel;

item def Fuel {
    attribute pressure : PressureValue;
    ref item impurities[0..*] : Material;
}

// Item usages in an action context
action def Process {
    in item rawMaterial : Material;
    out item processedGood : Product;
}
```

# Semantics

- An item usage represents one or more identifiable objects within a given modeling context.
- Item usages can be composite (contained) or referential (referenced).
- The default multiplicity of an item usage is `[1..1]` under the standard conditions.
- The base item usage is `items` from the `Items` library model.
- Item usages can flow through connections and be stored within parts.

# Rules

- An item usage must only be defined by item definitions (of any kind) or KerML structures.
- The default multiplicity is `[1..1]` unless otherwise specified.
- Item usages can have time slices, snapshots, and can be declared as individual.

# Examples

```sysml
part def FuelSystem {
    item fuelReserve : Fuel;
    ref item externalFuelSource[0..1] : FuelSupply;
}

action def WaterTreatment {
    in item dirtyWater : Water;
    out item cleanWater : Water;
    item byproducts[0..*] : Waste;
}

// Items with multiplicity
item passengers[0..300] : Person;
```

# Relationships

- [item-definition.md](item-definition.md) — the definition that types this usage
- [item.md](item.md) — general item concept
- [part-usage.md](part-usage.md) — part usages are a specialized kind of item usage
- [occurrence.md](occurrence.md) — item usages are a kind of occurrence usage

# Citations

[1] OMG SysML v2 Specification, §7.10
