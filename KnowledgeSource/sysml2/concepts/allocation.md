---
type: SysML v2 Concept
title: Allocation
description: An allocation in SysML v2 is the general concept covering both allocation definitions and allocation usages, representing a mapping relationship asserting that a target element is responsible for realizing the intent of a source element.
timestamp: 2026-07-01T00:00:00Z
---

An **allocation** in SysML v2 covers both allocation definitions and allocation usages. An allocation specifies that a target element is responsible for realizing some or all of the intent of a source element. Allocations represent abstract "mappings" across different structures and hierarchies within a system model.

As used by systems engineers, allocations support preliminary and tentative associations between model elements early in design—serving as a precursor to more detailed rigorous specifications. Common use cases include:
- Allocating logical functions (actions) to physical components (parts)
- Allocating software components to hardware
- Mapping requirements to design elements

Allocations are always binary (exactly two end features). They can be refined with nested allocation usages that provide finer-grained sub-allocations.

# Syntax

```sysml
allocation def LogicalToPhysical {
    end part logical : LogicalComponent;
    end part physical : PhysicalDevice;
}

allocation systemToDevice : LogicalToPhysical
    allocate logical ::> system to physical ::> device;

// Shorthand (keyword 'allocation' may be omitted)
allocate part1 to part2;

// With sub-allocations
allocate part1 to part2 {
    allocate part1.action1 to part2.action2;
}
```

# Semantics

- Allocations are always binary (two ends: source and target).
- The source element intends something; the target element realizes it.
- Allocations are instantiable connections and can be semantically related to other relationships.
- Allocations can be decomposed into nested sub-allocations.
- The base allocation definition is `Allocation` and usage is `allocations` from the `Allocations` library.

# Rules

- Allocation definitions and usages are always binary.
- Allocation usages must only be defined by allocation definitions.
- The shorthand keyword is `allocate` (instead of `connect` for connections).
- If the declaration part is empty, the keyword `allocation` may be omitted.

# Examples

```sysml
// Allocating an action to a part
part controller : Controller;
action def ControlLoop;

allocate ControlLoop to controller;

// Allocating a logical component to a physical device
part def LogicalSystem {
    part component : LogicalComponent;
}
part def PhysicalDevice {
    part assembly : PhysicalAssembly;
}
allocation def LogicalToPhysicalAllocation {
    end part logical : LogicalSystem;
    end part physical : PhysicalDevice;
    allocate logical.component to physical.assembly;
}
```

# Relationships

- [allocation-definition.md](allocation-definition.md) — the definition side of allocations
- [allocation-usage.md](allocation-usage.md) — the usage side of allocations
- [connection.md](connection.md) — allocations are a specialized kind of connection

# Citations

[1] OMG SysML v2 Specification, §7.15
