---
type: SysML v2 Concept
title: Relationship
description: A relationship is an element that relates two or more other elements, optionally directed from source elements to target elements.
timestamp: 2026-07-01T00:00:00Z
---

A relationship is a kind of element that relates two or more **related elements**. Relationships can be **binary** (exactly two related elements) or n-ary (more than two). The related elements of a relationship are ordered.

A relationship may designate certain related elements as **sources** with the rest as **targets**, making it a **directed** relationship. An **undirected** relationship designates all related elements as targets with no sources.

One of the related elements of a relationship may be the **owning related element**: if the owning related element is deleted, the relationship is also deleted. Some related elements may be **owned related elements**: if the relationship is deleted, all its owned related elements are also deleted.

A relationship may itself be the source or target of other relationships. In particular, a relationship may be annotated by being the target of an annotation relationship.

# Syntax

Relationships are generally shown using lines connecting the symbols for the related elements in graphical notation. In textual notation, each specific kind of relationship has its own keyword.

```sysml
// Example of a dependency (a kind of relationship):
dependency Use
from 'Application Layer' to 'Service Layer';
```

# Semantics

- Relationships are elements and therefore have element IDs and may have names.
- The **ownedRelationships** of an element are all relationships for which it is the owning related element.
- The **owned elements** of an element are the owned related elements of all its owned relationships.
- The **owningRelationship** of an element is the single relationship for which the element is an owned related element; an element can have at most one owning relationship.
- Deletion of the owning related element causes deletion of the relationship; deletion of the relationship causes deletion of all its owned related elements.

# Rules

1. Each element has at most one owning relationship.
2. If the owning related element of a relationship is deleted, the relationship is deleted.
3. If a relationship is deleted, all its owned related elements are also deleted.
4. Deletion cascades: deleting an element deletes all its owned relationships, which deletes their owned related elements, and so on.

# Examples

```sysml
// Subclassification is a directed relationship from specialized to general:
part def Truck :> Vehicle;

// Import is a relationship from a namespace to another namespace:
public import Package1::*;

// Annotation relationship: comment is the annotating element, Vehicle is annotated:
part def Vehicle {
  doc /* A Vehicle is a motorized transport. */
}
```

# Relationships

- [element.md](element.md) — a relationship is a special kind of element
- [dependency.md](dependency.md) — dependency is a specific kind of relationship
- [annotation.md](annotation.md) — annotation is a relationship between an annotating element and an annotated element
- [import.md](import.md) — import is a relationship from one namespace to another

# Citations

[1] OMG SysML v2 Specification, §7.2.3
