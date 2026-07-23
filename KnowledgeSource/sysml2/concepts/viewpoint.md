---
type: SysML v2 Concept
title: Viewpoint
description: A viewpoint is either a viewpoint definition or a viewpoint usage, both being kinds of requirement that frame the concerns of one or more stakeholders regarding information about a modeled system and specify the requirements a view must satisfy to address those concerns.
timestamp: 2026-07-01T00:00:00Z
---

A viewpoint encompasses both viewpoint definitions and viewpoint usages. A viewpoint definition is a kind of requirement definition (§7.21) whose **subject is a view** — meaning the viewpoint specifies requirements that a view must satisfy. A viewpoint usage is a kind of requirement usage.

Viewpoints are typically structured to **frame stakeholder concerns** using `frame concern` (§7.21.3), and then specify required constraints that a view must meet to address those concerns.

A view satisfies a viewpoint when:
- A composite viewpoint usage is nested inside a view definition or usage (automatically asserted satisfied), or
- An explicit `satisfy` requirement usage is used to assert that a view satisfies a viewpoint

Viewpoints connect the stakeholder concern modeling (§7.21) with view modeling (§7.26).

# Syntax

```sysml
concern 'system breakdown' {
  stakeholder se  : 'Systems Engineer';
  stakeholder ivv : 'IV&V';
}
concern 'modularity' {
  stakeholder se : 'Systems Engineer';
}

viewpoint def 'System Structure Perspective' {
  frame 'system breakdown';
  frame 'modularity';
  require constraint {
    doc
    /* A system structure view shall show the hierarchical
     * part decomposition of a system, starting with a specified root part.
     */
  }
}

viewpoint 'vehicle structure perspective' : 'System Structure Perspective' {
  subject : Vehicle;
}
```

# Semantics

- A viewpoint definition specializes requirement definition; a viewpoint usage specializes requirement usage.
- The subject of a viewpoint is always a view.
- Framed concerns (§7.21.3) are automatically required constraints of the viewpoint.
- A view satisfies a viewpoint when a composite viewpoint usage is nested in the view, or via an explicit `satisfy` usage.

# Rules

- Declared with `viewpoint def` (definition) or `viewpoint` (usage).
- A viewpoint usage must be typed by exactly one viewpoint definition.
- The subject of a viewpoint must be a view.
- Framed concerns are subrequirements and are automatically required constraints.

# Examples

```sysml
viewpoint 'vehicle structure perspective' : 'System Structure Perspective' {
  subject : Vehicle;
}

view 'vehicle parts view' : 'Part Structure View' {
  // Explicit satisfaction of the viewpoint
  satisfy 'vehicle structure perspective';
  expose VehicleDesignModel::**;
  render asMyTreeDiagram;
}
```

# Relationships

- [viewpoint-definition.md](viewpoint-definition.md) — definition form
- [view.md](view.md) — a view is the subject of a viewpoint
- [view-definition.md](view-definition.md) — view definitions satisfy viewpoints
- [frame-constraint.md](frame-constraint.md) — framing concerns in a viewpoint
- [requirement.md](requirement.md) — supertype concept

# Citations

[1] OMG SysML v2 Specification, §7.26.1, §7.26.3
