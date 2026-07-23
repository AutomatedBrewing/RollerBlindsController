---
type: SysML v2 Concept
title: Viewpoint Definition
description: A viewpoint definition is a kind of requirement definition whose subject is a view, typically structured to frame stakeholder concerns and specify the requirements a view must satisfy to address those concerns.
timestamp: 2026-07-01T00:00:00Z
---

A viewpoint definition is declared with the keywords `viewpoint def`. It specializes requirement definition (§7.21) and restricts the subject to be a view. Its purpose is to capture the perspective of one or more stakeholders and specify what a view must show in order to address their concerns.

A viewpoint definition is typically structured by:
1. **Framing concerns** using `frame concern` (§7.21.3) — each framed concern identifies stakeholder groups and their interests
2. **Required constraints** using `require constraint` — specifying what the view must contain or present

A composite viewpoint usage nested inside a view definition or usage is automatically asserted to be satisfied by that view. Alternatively, `satisfy` can be used explicitly.

The base library elements are `Viewpoint` and `viewpoints` from the `Views` model library.

# Syntax

```sysml
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
```

Viewpoint with explicit subject:

```sysml
viewpoint def InterfaceViewpoint {
  subject vw : InterfaceView;
  stakeholder systemsEngineer : 'Systems Engineer';
  require constraint {
    doc /* The view shall show all interface connections between parts. */
  }
}
```

# Semantics

- Declared with `viewpoint def`.
- Specializes requirement definition (§7.21).
- The subject of a viewpoint must be a view.
- Framed concerns are subrequirements and are automatically required constraints.
- A view definition or usage that nests a composite viewpoint usage is automatically asserted to satisfy it.

# Rules

- Declared with `viewpoint def`.
- The subject must be a view.
- Framed concerns declared with `frame concern` or shorthand `frame`.
- Required constraints declared with `require constraint`.
- A viewpoint usage must be typed by exactly one viewpoint definition.

# Examples

```sysml
concern 'safety analysis' {
  stakeholder safetyEngineer : 'Safety Engineer';
}

viewpoint def 'Safety Perspective' {
  frame 'safety analysis';
  require constraint {
    doc /* The view shall show all safety-critical failure modes. */
  }
}
```

# Relationships

- [viewpoint.md](viewpoint.md) — general viewpoint concept
- [view-definition.md](view-definition.md) — a view definition satisfies a viewpoint definition
- [frame-constraint.md](frame-constraint.md) — framing concerns in the viewpoint
- [requirement-definition.md](requirement-definition.md) — supertype

# Citations

[1] OMG SysML v2 Specification, §7.26.3
