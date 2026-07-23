---
type: SysML v2 Concept
title: Comment
description: A comment is an annotating element that provides a textual description about one or more model elements.
timestamp: 2026-07-01T00:00:00Z
---

A **comment** is a kind of annotating element used to provide textual descriptions about other elements. Comments can be members of namespaces and, therefore, can be named. A member comment may describe the namespace that owns it, or it may describe different elements.

The body of a comment is written as text between `/*` and `*/` delimiters. A comment can annotate one or more explicitly identified elements (using the `about` clause), or implicitly annotates the containing namespace when no `about` clause is given.

A **locale** can be specified for a comment to identify the language (and optionally territory and encoding) of the body text, using the format `language[_territory][.codeset][@modifier]` conformant to ISO 15897.

# Syntax

```sysml
// Named comment about specific elements:
comment Comment1 about A, B
/* This is the comment body text. */

// Unnamed comment about containing namespace (keyword can be omitted):
package P {
  comment C /* This is a comment about P. */

  /* This is also a comment about P. */
}

// Comment with locale:
comment C_US_English locale "en_US"
/* This is US English comment text */
```

# Semantics

- The comment body is the text extracted from within `/* ... */` according to the KerML comment-body extraction rules.
- If a comment is an owned member of a namespace and has no `about` clause, the annotated element is implicitly the containing namespace.
- If a comment has no short name or name, and is owned by a namespace with no `about` clause, the `comment` keyword itself may be omitted.
- The body text of a comment may include markup (e.g., HTML), which a tool may render graphically.
- The locale string identifies the language/region/encoding of the comment body.

# Rules

1. The `comment` keyword introduces a comment declaration.
2. The `about` clause lists qualified names of annotated elements, separated by commas.
3. If no `about` clause is given and the comment is an owned namespace member, the annotated element is the containing namespace.
4. If no name and no `about` clause are given, the `comment` keyword may be omitted.
5. The `locale` keyword, followed by a string literal, optionally precedes the comment body.

# Examples

```sysml
// Comment about two separate elements:
item A;
part B;
comment Comment1 about A, B
/* This is the comment body text. */

// Named and unnamed comments in a package:
package P9 {
  item A;
  comment Comment1 about A
  /* This is a comment about item A. */

  comment Comment2
  /* This is a comment about package P9. */

  /* This is also a comment about package P9. */
}

// Localized comment:
comment C_French locale "fr_BE"
/* Ceci n'est pas une pipe. */
```

# Relationships

- [annotation.md](annotation.md) — comment is a kind of annotating element attached via an annotation relationship
- [documentation.md](documentation.md) — documentation is a distinguished kind of comment
- [namespace.md](namespace.md) — comments can be members of namespaces
- [element.md](element.md) — comments describe other model elements

# Citations

[1] OMG SysML v2 Specification, §7.4.2
