---
type: SysML v2 Concept
title: Render
description: A render (rendering definition or rendering usage) is a kind of part definition or part usage that specifies how a view artifact is to be rendered, used inside a view definition or usage to determine the presentation format of the filtered model content.
timestamp: 2026-07-01T00:00:00Z
---

A **rendering definition** is declared with keyword `rendering def` and is a kind of part definition (§7.11). A **rendering usage** is declared with keyword `rendering` (or specified inline via `render`) and is a kind of part usage. Together they specify how the content of a view is to be rendered as a view artifact.

A view definition or usage declares its rendering using the keyword `render` followed by a composite rendering usage declaration or a qualified name identifying a rendering usage. If `render` is followed by a qualified name, a reference subsetting relationship is established between the view rendering usage and the identified rendering usage.

The `Views` library model in the Systems Model Library provides a small set of standard rendering usages (e.g., `asTreeDiagram`, `asInterconnectionDiagram`). Conforming tools may provide additional tool-specific rendering libraries.

The base library elements are `Rendering` and `renderings` from the `Views` model library.

# Syntax

```sysml
// Rendering definition
rendering def TreeDiagramRendering {
  // Nested sub-renderings, styles, layout specifications, etc.
}

// Rendering usage declared in a view definition
view def 'Part Structure View' {
  filter @SysML::PartUsage;
  render asTreeDiagram;        // reference to a standard rendering usage
}

// Inline composite rendering usage
view 'vehicle parts view' : 'Part Structure View' {
  expose VehicleDesignModel::**;
  render asMyTreeDiagram;      // redefines the inherited rendering
}
```

# Semantics

- A rendering definition specializes part definition; a rendering usage specializes part usage.
- A rendering usage is declared with `rendering` or specified inline via `render <name>` in a view.
- `render <qualifiedName>` establishes a reference subsetting between the view's rendering usage and the identified rendering.
- If a view usage declares a rendering, it redefines the view definition's rendering; the new rendering must be consistent with (or a specialization of) the definition's rendering.
- Conforming tools provide libraries of standard rendering usages.

# Rules

- Rendering definitions declared with `rendering def`.
- Rendering usages declared with `rendering` or inline in a view using `render`.
- A rendering usage in a view usage must be consistent with / a specialization of the inherited rendering.

# Examples

```sysml
rendering def TableRendering {
  // Specifies tabular layout.
}

view def 'Attribute Table View' {
  filter @SysML::AttributeUsage;
  render asTable;
}
```

# Relationships

- [view.md](view.md) — rendering is declared inside a view
- [view-definition.md](view-definition.md) — rendering is declared in a view definition
- [part.md](part.md) — rendering is a kind of part
- [part-definition.md](part-definition.md) — rendering definition is a kind of part definition

# Citations

[1] OMG SysML v2 Specification, §7.26.1, §7.26.2, §7.26.4
