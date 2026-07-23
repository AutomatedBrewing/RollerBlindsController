---
type: SysML v2 Concept
title: Package
description: A package is a kind of namespace used solely as a container for organizing model elements, with optional import filtering based on metadata.
timestamp: 2026-07-01T00:00:00Z
---

A **package** is a kind of namespace used solely as a container for other elements to organize a model. Unlike definitions and usages, a package has no modeling semantics beyond containment and visibility. A package can contain owned member elements such as other packages, definitions, and usages.

In addition to owning and importing members, a package can define **filter conditions** that restrict which elements are actually imported. Only elements satisfying all filter conditions become imported members of the package. This, combined with **recursive import** (`::**`), provides a general mechanism for specifying a package that automatically aggregates elements from across a model based on their metadata.

# Syntax

```sysml
// Simple package:
package Package1;

// Package with owned members:
package Package1 {
  package Package2;
  part def Part2;
  part part2 : Part2;
}

// Package with an alias member:
package Package1 {
  alias Package2Alias for Package2;
}
package Package2;

// Package with public and private imports:
package Package1 {
  public import Package2::*;
  private import Package3::*;
}

// Package with filter conditions:
package UpperLevelApprovals {
  public import DesignModel::**;
  filter @ApprovalMetadata::Approval and
    ApprovalMetadata::Approval::approved and
    ApprovalMetadata::Approval::level > 1;
}

// Package with a filter import (filter only applies to this import):
package UpperLevelApprovals {
  private import ApprovalMetadata::**;
  public import DesignModel::**[@Approval and approved and level > 1];
}
```

# Semantics

- A package is declared using the `package` keyword.
- Owned members are listed in the body between `{...}`.
- Visibility of memberships: `public` (default, visible outside), `protected` (like private except in definitions/usages), `private` (not visible outside).
- Filter conditions are Boolean-valued, model-level evaluable expressions using the `filter` keyword.
- Filter conditions apply to all imports in the package; a filter import scopes a filter to a specific import.
- Packages other than root-level packages cannot filter non-import memberships.

# Rules

1. A package is declared with the `package` keyword.
2. A package may have filter conditions declared with the `filter` keyword.
3. Filter conditions evaluate against candidate imported elements; only those satisfying all conditions are imported.
4. Only packages can have filter conditions (except view definitions/usages per §7.26).
5. Any kind of namespace may have filtered imports.

# Examples

```sysml
// Nested packages:
package Package1 {
  package Package2 {
    part def PartDef3;
  }
}

// Aggregating approved design elements:
package UpperLevelApprovals {
  public import DesignModel::**;
  filter @ApprovalMetadata::Approval and
    ApprovalMetadata::Approval::approved and
    ApprovalMetadata::Approval::level > 1;
}
```

# Relationships

- [namespace.md](namespace.md) — package is a kind of namespace
- [import.md](import.md) — packages use import relationships to bring in members from other namespaces
- [membership.md](membership.md) — packages relate to members through membership relationships
- [element.md](element.md) — packages contain model elements

# Citations

[1] OMG SysML v2 Specification, §7.5.1, §7.5.2, §7.5.4
