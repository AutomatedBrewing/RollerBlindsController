---
type: SysML v2 Concept
title: Allocation Definition
description: An allocation definition is a kind of connection definition, always binary, that specifies a mapping relationship between a source element and a target element asserting that the target is responsible for realizing the intent of the source.
timestamp: 2026-07-01T00:00:00Z
---

An **allocation definition** is a kind of connection definition that is always binary (exactly two ends), even if abstract. It defines a class of allocations where a target element is responsible for realizing some or all of the intent of a source element.

Allocation definitions can be specialized to reflect project-specific or domain-specific allocation conventions. They can be further refined by nesting allocation usages inside them to provide finer-grained sub-allocations that decompose the top-level allocation.

Unlike regular connection definitions, allocation definitions are always binary—they cannot be n-ary. The source end identifies what needs to be realized; the target end identifies what does the realizing.

# Syntax

```sysml
allocation def LogicalToPhysicalAllocation {
    end part logical : LogicalSystem;
    end part physical : PhysicalDevice;
    // Sub-allocation for finer granularity
    allocate logical.component to physical.assembly;
}

// Abstract allocation definition (still binary)
abstract allocation def SystemAllocation;

// Specialized allocation definition
allocation def HardwareAllocation :> LogicalToPhysicalAllocation;
```

# Semantics

- An allocation definition is a kind of connection definition.
- Allocation definitions are always binary (exactly two ends), even if abstract.
- The first end is the source (what is being realized); the second is the target (what realizes it).
- Allocations are instantiable connections that can participate in model navigation.
- Specialized allocation definitions can reflect conventions for specific projects or domains.
- The base allocation definition is `Allocation` from the `Allocations` library model.

# Rules

- An allocation definition must always be binary (exactly two end features).
- An allocation definition is declared using the kind keyword `allocation` with the `def` suffix.
- Allocation usages must only be defined by allocation definitions.
- End features are always referential.
- Nested allocation usages may appear in the body of an allocation definition.

# Examples

```sysml
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

// Specialized allocation for a specific project
allocation def SoftwareToHardwareAllocation :> LogicalToPhysicalAllocation {
    redefines logical : SoftwareComponent;
    redefines physical : HardwareModule;
}
```

# Relationships

- [allocation-usage.md](allocation-usage.md) — usages of this allocation definition
- [allocation.md](allocation.md) — general allocation concept
- [connection-definition.md](connection-definition.md) — allocation definitions are a specialized kind of connection definition

# Citations

[1] OMG SysML v2 Specification, §7.15
