---
type: SysML v2 Concept
title: Dependency
description: A dependency is a directed relationship between client (source) and supplier (target) elements, indicating that a change to a supplier may require a change to a client.
timestamp: 2026-07-01T00:00:00Z
---

A dependency is a kind of relationship between any number of **client** (source) elements and **supplier** (target) elements. It asserts that a change to a supplier element may result in a change to a client element.

Dependencies are useful for representing relationships between elements in an abstract way — for example, expressing that an upper layer of an architecture stack depends on a lower layer. A dependency can be extended to reflect more specialized relationships such as refinement, using user-defined keywords.

# Syntax

```sysml
// Named dependency with from/to:
dependency Use
from 'Application Layer' to 'Service Layer';

// Unnamed dependency (from can be omitted when no name is given):
dependency 'Service Layer'
to 'Data Layer', 'External Interface Layer';

// N-ary dependency:
dependency Package1, Package2
to Package3, Package4;

// Dependency with body (owned annotating elements):
dependency 'Service Layer'
to 'Data Layer', 'External Interface Layer' {
  /* 'Service Layer' is the client of this dependency,
   * not its name. */
}
```

# Semantics

- The client elements are the **sources** of the dependency; the supplier elements are the **targets**.
- A dependency implies that a change to a supplier element may require a change to a client element.
- If no short name or name is given, the `from` keyword may be omitted (the first names listed are clients).
- A dependency may have a body containing annotating elements (comments, documentation, metadata).

# Rules

1. The `dependency` keyword introduces the dependency.
2. Client elements are listed after `from`; supplier elements are listed after `to`.
3. Both client and supplier lists are comma-separated sequences of qualified names.
4. If the dependency has no name, `from` may be omitted.
5. A dependency may optionally have a body with annotation elements.

# Examples

```sysml
// Architecture stack dependency:
dependency Use
from 'Application Layer' to 'Service Layer';

// Service layer depends on data and interface layers:
dependency 'Service Layer'
to 'Data Layer', 'External Interface Layer';

// Multi-client, multi-supplier dependency:
dependency Package1, Package2
to Package3, Package4;
```

# Relationships

- [relationship.md](relationship.md) — dependency is a kind of relationship
- [element.md](element.md) — clients and suppliers are model elements
- [annotation.md](annotation.md) — a dependency body may contain annotating elements

# Citations

[1] OMG SysML v2 Specification, §7.3
