---
type: SysML v2 Concept
title: View Definition
description: A view definition is a kind of part definition that specifies the filter conditions, rendering, and viewpoints to be satisfied by any view usage of that definition, providing a reusable template for generating view artifacts.
timestamp: 2026-07-01T00:00:00Z
---

A view definition is declared with the keywords `view def`. It specializes part definition (§7.11) and specifies:

- **Filter conditions** (`filter <expression>`) — Boolean-valued expressions selecting which model elements to include
- **Rendering** (`render <rendering-usage>`) — specifies how the filtered elements are presented as a view artifact
- **Viewpoints to satisfy** (nested viewpoint usages automatically asserted satisfied by any usage of this definition)

View usages inherit filter conditions and rendering from the view definition. A view usage may add conditions or redefine the rendering (the new rendering must be consistent with/specialization of the definition's rendering).

The base library element is `View` from the `Views` model library.

# Syntax

```sysml
view def 'Part Structure View' {
  import Views::*;
  filter @SysML::PartUsage;
  render asTreeDiagram;
}
```

With an embedded viewpoint to satisfy:

```sysml
view def 'Part Structure View' {
  // Any usage of this definition automatically satisfies this viewpoint.
  viewpoint vp : 'System Structure Perspective';
  filter @SysML::PartUsage;
  render asTreeDiagram;
}
```

# Semantics

- Declared with `view def`.
- Specializes part definition (§7.11).
- Filter conditions are Boolean model-level evaluable expressions (see KerML §7.4.9).
- A composite viewpoint usage nested inside a view definition is automatically asserted satisfied by the definition.
- View usages of this definition inherit the filter conditions and rendering.

# Rules

- Declared with `view def`.
- Filter conditions declared with `filter`; multiple conditions are ANDed.
- Rendering declared with `render`; must identify a rendering usage.
- A view usage must be typed by exactly one view definition.
- A nested viewpoint usage is automatically asserted to be satisfied by the view.

# Examples

```sysml
view def 'Interface View' {
  import Views::*;
  filter @SysML::ConnectionUsage;
  render asInterconnectionDiagram;
}
```

# Relationships

- [view.md](view.md) — general view concept
- [viewpoint-definition.md](viewpoint-definition.md) — viewpoints satisfied by this definition
- [render.md](render.md) — the rendering used by this view definition
- [part-definition.md](part-definition.md) — supertype

# Citations

[1] OMG SysML v2 Specification, §7.26.2
