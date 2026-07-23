---
type: SysML v2 Concept
title: Allocation Usage
description: An allocation usage is a usage of one or more allocation definitions, always binary, that asserts a specific mapping between a source usage element and a target usage element where the target realizes the intent of the source.
timestamp: 2026-07-01T00:00:00Z
---

An **allocation usage** is a usage of one or more allocation definitions. It is always binary (two ends) and represents a specific mapping between a source usage element and a target usage element—asserting that the target is responsible for realizing the intent of the source.

Allocation usages use the `allocate` keyword shorthand (instead of `connect` for regular connections). When the declaration part of an allocation usage is empty, the `allocation` keyword may be omitted entirely, leaving just `allocate source to target`.

Allocation usages can be nested within other allocation usages or within allocation definitions to provide sub-allocations that decompose a higher-level allocation into finer-grained pieces.

# Syntax

```sysml
// Named allocation usage
allocation systemToDevice : LogicalToPhysicalAllocation
    allocate logical ::> system to physical ::> device;

// Shorthand (anonymous, 'allocation' keyword omitted)
allocate part1 to part2;

// With sub-allocations
allocate part1 to part2 {
    allocate part1.action1 to part2.action2;
}

// In a compartment context
part part3 {
    allocate part1 to part3;
    allocate part3 to part2;
}
```

# Semantics

- An allocation usage is always binary (exactly two end features).
- The first end is the source (what needs to be realized); the second is the target (what realizes it).
- Nested allocation usages provide sub-allocations within the containing allocation.
- Allocation usages are instantiable connections and can be used in model navigation.
- The base allocation usage is `allocations` from the `Allocations` library model.

# Rules

- An allocation usage must only be defined by allocation definitions.
- Allocation usages are always binary.
- The shorthand keyword `allocate` replaces `connect` for allocation usages.
- When the declaration part is empty, `allocation` may be omitted (only `allocate` is needed).
- End features are always referential.

# Examples

```sysml
part system : LogicalSystem;
part device : PhysicalDevice;

allocation systemToDevice : LogicalToPhysicalAllocation
    allocate logical ::> system to physical ::> device;

// Action-to-part allocation
part part1 : Part1 { perform action1; }
part part2 : Part2 { perform action2; }

allocate part1 to part2 {
    allocate part1.action1 to part2.action2;
}

// Simple one-liner allocation
allocate logicalFunction to processorCore;
```

# Relationships

- [allocation-definition.md](allocation-definition.md) — the definition that types this allocation usage
- [allocation.md](allocation.md) — general allocation concept
- [connection-usage.md](connection-usage.md) — allocation usages are a specialized kind of connection usage

# Citations

[1] OMG SysML v2 Specification, §7.15
