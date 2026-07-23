---
type: SysML v2 Concept
title: Element
description: An element is a constituent of a SysML model that has a unique identifier and may own other elements through relationships.
timestamp: 2026-07-01T00:00:00Z
---

An element is the fundamental building block of a SysML model. Every element has a unique identifier known as its **element ID**, which does not change after the element is created. An element may also have **alias IDs** assigned for tool-specific purposes. An element can be given a **name** and/or a **short name**; without at least one of these, the element cannot be referenced using the textual notation (though it may still appear in graphical diagrams).

Elements participate in ownership through relationships: an element's **owned elements** are the owned related elements of its owned relationships. The **owner** of an element is the owning related element of the element's owning relationship. An element that has no owner acts as the root of an ownership tree; deleting it cascades deletion to all owned elements and relationships.

# Syntax

```sysml
part <'1.2.4'> myName;
```

Names have two forms:
- **Basic name**: starts with a letter or underscore, followed by letters, digits, or underscores; reserved words are not allowed.
- **Unrestricted name**: any characters enclosed in single quotes (e.g., `'On/Off Switch'`).

```sysml
Vehicle
power_line
'+'
'circuits in line'
'On/Off Switch'
```

# Semantics

- Every element has a stable **element ID** throughout its lifetime.
- An element may optionally have a **name** and/or **short name**; the short name is delimited by `<` and `>`.
- An element may have **alias names** relative to one or more namespaces.
- The body of an element (in textual notation) is delimited by `{...}` and contains owned sub-elements.
- Deleting an element cascades deletion to all its owned relationships and, therefore, all its owned elements.

# Rules

1. An element's element ID does not change after creation.
2. A reserved word may not be used as a basic name.
3. An element with no owner is the root of an ownership tree; deleting the root deletes the entire tree.
4. An element declared within the body of a namespace is an owned member of that namespace.

# Examples

```sysml
// Element with a short name and a name:
part <'1.2.4'> myVehicle;

// Element with only a name:
attribute voltage;

// Element body with owned members:
part vehicle {
  part engine;
  part transmission;
}
```

# Relationships

- [relationship.md](relationship.md) — relationships are a special kind of element that relate two or more elements
- [namespace.md](namespace.md) — namespaces are elements that contain and name other elements
- [membership.md](membership.md) — membership relates a namespace to its member elements

# Citations

[1] OMG SysML v2 Specification, §7.2.2
