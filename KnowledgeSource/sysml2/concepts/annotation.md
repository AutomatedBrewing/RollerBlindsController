---
type: SysML v2 Concept
title: Annotation
description: An annotation is a relationship between an annotating element and an annotated element that provides additional information about the annotated element.
timestamp: 2026-07-01T00:00:00Z
---

An **annotating element** is an element used to provide additional information about other elements. An **annotation** is the relationship between an annotating element and an **annotated element** being described.

An annotating element can annotate multiple annotated elements, and each element can have multiple annotations. Relationships may also be annotated — a relationship can be the target of an annotation relationship.

The three main kinds of annotating elements are:
1. **Comment** — provides textual descriptions (see `comment.md`)
2. **Documentation** — a distinguished kind of comment that documents its owning element (see `documentation.md`)
3. **Textual Representation** — provides a representation of the annotated element in a specific named language

It is also possible to annotate elements with user-defined metadata, allowing syntactic and semantic extension of SysML.

# Syntax

```sysml
// A comment annotating a specific element:
comment Comment1 about A, B
/* This is the comment body text. */

// Textual representation annotating a calc def:
calc def square {
  in attribute x : ScalarValues::Real;
  return : ScalarValues::Real;
  rep square language "Python"
  /*
   * def square(x:float) -> float:
   *   return x**2
   */
}

// Annotation of a named element within a namespace:
part part1 : Part1 {
  doc /* documentation-text */
  port p1 : P1;
  port p2 : P2;
}
```

# Semantics

- Annotating elements are model elements and may themselves be owned by the annotated element (via the annotation relationship).
- An annotating element can annotate more than one element simultaneously.
- Documentation is a special case: the annotated element is always the owning element of the documentation.
- A textual representation specifies a language name and a body conforming to that language.
- User-defined metadata annotations (see §7.27) enable both syntactic and semantic extension of SysML.

# Rules

1. An annotating element can annotate multiple annotated elements.
2. An element can have multiple annotations.
3. A documentation comment always annotates exactly one element — its owning element.
4. A textual representation is always owned by its represented element.
5. An annotating element may optionally be owned by the annotated element through the annotation relationship.

# Examples

```sysml
// Comment about two elements:
item A;
part B;
comment Comment1 about A, B
/* This is the comment body text. */

// Metadata annotation:
@Approval {
  approved = true;
  approver = "John Smith";
  level = 2;
}
```

# Relationships

- [comment.md](comment.md) — comment is a kind of annotating element
- [documentation.md](documentation.md) — documentation is a distinguished kind of comment
- [relationship.md](relationship.md) — annotation is a kind of relationship
- [element.md](element.md) — annotations describe other model elements

# Citations

[1] OMG SysML v2 Specification, §7.4.1
