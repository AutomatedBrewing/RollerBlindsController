---
type: SysML v2 Concept
title: View
description: A view is either a view definition or a view usage, both being kinds of part that specify or instantiate how model content is exposed, filtered, and rendered into a view artifact to satisfy one or more viewpoints.
timestamp: 2026-07-01T00:00:00Z
---

A view encompasses both view definitions and view usages. A **view definition** is a kind of part definition (§7.11) that specifies filter conditions, a rendering, and viewpoints to be satisfied. A **view usage** is a kind of part usage that exposes a portion of the model (via `expose` relationships), applies filter conditions, and generates a rendered view artifact.

Key concepts:
- **Expose**: an `expose` relationship imports model elements into the view scope (protected visibility — exposed elements are visible within the view and its specializations but not publicly)
- **Filter**: a Boolean-valued expression selecting which exposed elements to include
- **Render**: specifies a rendering usage determining how the filtered elements are presented
- **View artifact**: the rendered output — a document, diagram, table, etc.

View usages can be nested to create composite view artifacts. Compartments and diagrams are both instances of view usages.

The base library elements are `View` and `views` from the `Views` model library.

# Syntax

```sysml
// View definition
view def 'Part Structure View' {
  import Views::*;
  filter @SysML::PartUsage;
  render asTreeDiagram;
}

// View usage
view 'vehicle parts view' : 'Part Structure View' {
  satisfy viewpoint1;
  expose VehicleDesignModel::**;
  filter not @SysML::ConnectionUsage;
  render asMyTreeDiagram;
}
```

# Semantics

- A view definition specializes part definition; a view usage specializes part usage.
- An `expose` relationship is a special import with protected visibility.
- Filter conditions are inherited from the view definition; a view usage can add more.
- If a view usage declares a rendering, it redefines the inherited rendering (must be consistent/specialized).
- Nested viewpoint usages inside a view definition or usage are automatically asserted to be satisfied by that view.
- Compartments and diagrams are view usages.

# Rules

- View definitions declared with `view def`; view usages with `view`.
- A view usage must be typed by exactly one view definition.
- `expose` uses the same syntax as `import` but with keyword `expose` and no visibility modifier.
- Filter conditions declared with `filter <Boolean-expression>`.
- Rendering declared with `render <rendering-usage>`.

# Examples

```sysml
view 'vehicle parts view' : 'Part Structure View' {
  expose VehicleDesignModel::**[not @SysML::ConnectionUsage];
  render asMyTreeDiagram;
}
```

# Relationships

- [view-definition.md](view-definition.md) — definition form
- [viewpoint.md](viewpoint.md) — viewpoints satisfied by views
- [render.md](render.md) — rendering specification in a view
- [part.md](part.md) — supertype (view is a kind of part)

# Citations

[1] OMG SysML v2 Specification, §7.26.1, §7.26.2
