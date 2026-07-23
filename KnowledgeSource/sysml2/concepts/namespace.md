---
type: SysML v2 Concept
title: Namespace
description: A namespace is an element that contains and provides names for other elements, known as its members, through membership relationships.
timestamp: 2026-07-01T00:00:00Z
---

A **namespace** is a kind of element that can contain other elements and provide names for them. The elements contained in a namespace are its **member elements**. **Membership** is a kind of relationship that relates a namespace to its members; a membership can specify the name by which the member is known relative to that namespace and whether the membership is visible outside the namespace.

An element may be **owned** via its membership in a namespace. When a namespace is deleted, all owned members are also deleted. An element may also have a membership in a namespace without being owned by it — such a membership may introduce an **alias name** for the element relative to that namespace.

An **import** relationship allows one namespace to import memberships from another namespace. All kinds of SysML definitions and usages are also namespaces. A **root namespace** is a namespace with no owner; its owned members are **top-level elements**.

Qualified names use the `::` separator to address elements relative to a namespace. An unqualified name is resolved in the context of the enclosing namespace, taking into account imported and inherited memberships.

# Syntax

```sysml
// A package (a kind of namespace) containing owned members:
package Configurations {
  attribute def ConfigEntry {
    attribute key: String;
    attribute value: String;
  }

  item ConfigData {
    attribute entries[*]: ConfigEntry;
  }
}

// Using a qualified name to reference a member:
private import P4::Q::*;
```

# Semantics

- Members are related to the namespace via membership relationships.
- An owned membership means the namespace is the owner of the member element.
- A non-owning membership introduces an alias name for an existing element.
- Visibility (`public`, `protected`, `private`) determines accessibility from outside the namespace.
- Imported memberships become unowned members of the importing namespace.
- A root namespace has no owner; its top-level elements are globally accessible by unqualified name.
- The global namespace implicitly contains all root namespaces and all KerML/SysML model libraries.

# Rules

1. Each element has at most one owning membership (across all namespaces).
2. An element may have multiple non-owning memberships (aliases) in one or more namespaces.
3. A public membership is visible outside the namespace; a private membership is not.
4. Unqualified names within a namespace body are resolved considering imported and inherited memberships.
5. An import owned by a root namespace must be `private`.

# Examples

```sysml
// Namespace (package) with owned members:
package P {
  public part def A;
  private attribute def B;
  part a : A; // public by default
}

// Root namespace (no keyword — the file-level context is implicit):
doc /* This is a model in SysML textual notation. */
item def I;
attribute def A;
item i: I;
package P;
```

# Relationships

- [membership.md](membership.md) — membership relates a namespace to its members
- [import.md](import.md) — imports bring members from another namespace into this namespace
- [package.md](package.md) — package is a kind of namespace used solely as a container
- [definition.md](definition.md) — definitions are also namespaces
- [usage.md](usage.md) — usages are also namespaces

# Citations

[1] OMG SysML v2 Specification, §7.5.1
