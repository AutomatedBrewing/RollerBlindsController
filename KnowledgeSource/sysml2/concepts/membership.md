---
type: SysML v2 Concept
title: Membership
description: Membership is a relationship that relates a namespace to one of its member elements, optionally specifying the member's name and visibility within that namespace.
timestamp: 2026-07-01T00:00:00Z
---

**Membership** is a kind of relationship that relates a **namespace** to a **member element**. A membership can specify:
- The **name** by which the member element is known relative to the containing namespace.
- Whether the membership is **visible** outside the namespace (`public`, `protected`, or `private`).

A membership may be **owning** (the namespace owns the member) or **non-owning** (the element is only referenced, possibly under an alias name). An element can have at most one owning membership across all namespaces but may have multiple non-owning memberships (alias memberships).

An **alias membership** is a non-owning membership that introduces an alias name for an existing element relative to a namespace. The alias name is defined on the membership and may differ from the element's declared name. The same element may have multiple alias memberships in the same namespace, giving it multiple different names relative to that namespace.

# Syntax

```sysml
// Owned membership (element declared inside namespace body):
package Package0 {
  package Package1; // Package1 is an owned member of Package0
}

// Alias membership (non-owning):
package Package0 {
  alias Package1Alias for Package1;
}
package Package1;

// Alias with short name and body:
package P1 {
  item A;
  alias <C> CCC for B {
    doc /* Documentation of the alias. */
  }
  private alias D for B;
}
```

# Semantics

- Declaring an element within a namespace body creates an **owning membership**.
- An **alias** declaration creates a **non-owning membership** with a chosen alias name for an existing element.
- Visibility keywords (`public`, `protected`, `private`) precede the element declaration or `alias` keyword.
- `public` (default) means the membership is visible outside the namespace.
- `private` means the membership is not visible outside.
- `protected` is like `private` for non-definition/usage namespaces; for definitions and usages, it means the membership is also visible in specializations.
- An element can be a member of a namespace under multiple different alias names simultaneously.

# Rules

1. An element has at most one owning membership (across all namespaces).
2. An owning membership is created by declaring an element inside a namespace body.
3. A non-owning alias membership is declared with the `alias` keyword followed by an alias name and `for <qualifiedName>`.
4. The same element may have multiple alias memberships in the same namespace.
5. Default visibility for declared members is `public`.

# Examples

```sysml
// Owned member with visibility modifiers:
package P {
  public part def A;
  private attribute def B;
  part a : A; // public by default
}

// Alias for Package2 inside Package1:
package Package1 {
  alias Package2Alias for Package2;
}
package Package2;

// Multiple aliases for the same element:
package P1 {
  item A;
  item B;
  alias <C> CCC for B;
  private alias D for B;
}
```

# Relationships

- [namespace.md](namespace.md) — membership relates a namespace to its members
- [import.md](import.md) — import produces unowned (imported) memberships
- [element.md](element.md) — membership is a kind of relationship between namespace and member elements

# Citations

[1] OMG SysML v2 Specification, §7.5.1, §7.5.2
