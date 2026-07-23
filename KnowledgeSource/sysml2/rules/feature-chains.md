---
type: SysML v2 Rule
title: Feature Chains
description: A feature chain is a textual notation consisting of two or more qualified names separated by dot (.) symbols, where each name resolves to a usage and subsequent names are resolved using the previously resolved usage as the context namespace.
timestamp: 2026-07-01T00:00:00Z
---

A feature chain provides a way to navigate through nested usages in the model and to reference features that are more deeply nested than the current context. Unlike a simple qualified name (which uses `::` as a separator), a feature chain uses `.` as a separator and records the path of usages in the abstract syntax.

# Rule Statement

A feature chain is written as:

```
name1.name2.name3...
```

Rules for feature chains:

1. Each qualified name in a feature chain must resolve to a Usage (or, more generally, a KerML Feature).
2. The first qualified name in a feature chain is resolved in the **local namespace** as usual.
3. Subsequent qualified names are resolved using the previously resolved usage (feature) as the **context namespace**, but considering only **public** memberships.
4. Unlike a qualified name, the **path of usages** in the chain is recorded in the abstract syntax — not just the reference to the final usage. This means different paths to the same usage can be distinguished.
5. Feature chains can be used to specify the target for most kinds of relationships involving usages, including subsetting and redefinition.
6. Feature chains are particularly important when specifying the related features of a connection usage that are more deeply nested than the connection usage itself.

# Rationale

Feature chains are needed to reference deeply nested features that cannot be reached by a simple qualified name within the local namespace. The recorded path in the abstract syntax allows tools to unambiguously navigate through a specific structural decomposition, which is important for connections, flows, and bindings between deeply nested features.

# Examples

```
// Subsetting using a feature chain
item uncles subsets parents.siblings;

// Redefinition using a feature chain
item cousins redefines parents.siblings.children;

// Connection using feature chains to reach nested ports
connect vehicle.wheelAssembly.wheels to vehicle.road;

// Flow using feature chains
flow fuelTank.fuelOut to engine.fuelIn;
```

When a textual notation includes the identification of a usage, this can be done by using either a qualified name or a feature chain.

# Violations

- Using a non-public member in a feature chain after the first segment (only public memberships are accessible through chain navigation).
- Using a name in a feature chain that does not resolve to a Usage or KerML Feature.
- Confusing a feature chain (using `.`) with a qualified name (using `::`): the two notations resolve names differently and record different information in the abstract syntax.

# Related Concepts

- [Name Resolution](name-resolution.md)
- [Specialization Rules](specialization-rules.md)
- [Flow Typing Rules](flow-typing-rules.md)

# Citations

[1] OMG SysML v2 Specification, §7.6.6 (Feature Chains)
[2] OMG SysML v2 Specification, §7.13 (Connections), related features
