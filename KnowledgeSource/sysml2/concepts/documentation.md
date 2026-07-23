---
type: SysML v2 Concept
title: Documentation
description: Documentation is a distinguished kind of comment that documents exactly its owning element and is introduced with the keyword doc.
timestamp: 2026-07-01T00:00:00Z
---

**Documentation** is a special kind of comment used to document the annotated element. Unlike a general comment, the **documenting element** (the annotated element) of a documentation annotation is always the **owning element** of the documentation — that is, the element within whose body the `doc` declaration appears.

Documentation is notated similarly to a regular comment, but uses the keyword `doc` rather than `comment`. A documentation annotation always annotates a single element (its owner), and it can optionally have a name or short name.

A **locale** can also be specified for documentation (e.g., `locale "fr_BE"`) placed immediately before the body, to identify the language of the documentation text.

# Syntax

```sysml
// Documentation within a part definition:
part X {
  doc X_Comment
  /* This is a documentation comment about X. */

  doc /* This is more documentation about X. */
}

// Documentation with a locale:
part Y {
  doc locale "fr_BE"
  /* Ceci n'est pas une pipe. */
}
```

# Semantics

- A documentation comment uses the keyword `doc` instead of `comment`.
- The annotated element of a documentation is always the element that owns the documentation.
- A documentation can optionally have a short name and/or name.
- The body text is written between `/* ... */` delimiters, processed as a regular comment body.
- The locale string (if present) identifies the language/territory/encoding of the documentation body.

# Rules

1. Documentation is introduced with the `doc` keyword.
2. The annotated element of documentation is always its owning element; no `about` clause is used.
3. A single element may have multiple documentation annotations.
4. The `locale` keyword followed by a string literal may optionally precede the body.

# Examples

```sysml
// Two documentation annotations on the same element:
part X {
  doc X_Comment
  /* This is a documentation comment about X. */

  doc /* This is more documentation about X. */
}

// Documentation on a package:
package P9 {
  doc P9_Doc
  /* This is documentation about package P9. */
}

// Localized documentation:
part Z {
  doc locale "en_US"
  /* This is US English documentation. */
}
```

# Relationships

- [comment.md](comment.md) — documentation is a distinguished kind of comment
- [annotation.md](annotation.md) — documentation is an annotating element attached via an annotation relationship
- [namespace.md](namespace.md) — documentation can be declared within any namespace body
- [element.md](element.md) — documentation always annotates its owning element

# Citations

[1] OMG SysML v2 Specification, §7.4.2
