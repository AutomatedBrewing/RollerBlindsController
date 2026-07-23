---
type: SysML v2 Concept
title: Import
description: An import is a relationship that allows one namespace to bring memberships from another namespace into its own scope.
timestamp: 2026-07-01T00:00:00Z
---

An **import** relationship allows one namespace to import memberships from another namespace. The imported member elements become **unowned** members of the importing namespace (in addition to remaining members of the imported namespace). This lets members of the imported namespace be referenced within the importing namespace without qualifying them with the imported namespace's name.

There are three forms of import based on the suffix used:
- **Membership import** (no suffix): imports a single identified membership.
- **Namespace import** (`::*`): imports all visible memberships of the identified namespace.
- **Recursive import** (`::**` suffix): imports the above and then recursively imports from all owned namespace members of the imported namespace.

The **visibility** of an import determines whether the imported memberships become `public`, `protected`, or `private` relative to the importing namespace. The default is `private`.

# Syntax

```sysml
// Membership import (single element):
package P2 {
  private import P1::A;
  private import P1::C; // Imported with alias name "C".
}

// Namespace import (all visible members of P1):
package P3 {
  private import P1::*;
}

// Recursive import (P4 and all its owned namespace members):
package P5 {
  private import P4::**;
}

// Recursive namespace import (members of P4 and owned namespaces, not P4 itself):
package P6 {
  private import P4::*::**;
}

// Public import with annotation body:
package P7 {
  public import P1::A {
    /* The imported membership is visible outside P7. */
  }
  private import P4::* {
    doc /* None of the imported memberships are visible outside of P7. */
  }
}
```

# Semantics

- Imported memberships become unowned members of the importing namespace.
- A **membership import** (no suffix): the identified membership becomes an imported membership; if the identified membership is an alias, the element is imported with that alias name.
- A **namespace import** (`::*`): all visible memberships of the imported namespace become imported memberships.
- A **recursive import** (`::**`): imports as above, then recursively imports from owned namespace members, with limitations: (1) only continues with namespaces that are owned members of the imported namespace, and (2) inherited-via-implicit-specialization memberships are not recursively imported.
- `private` import (default): imported memberships are private to the importing namespace.
- `protected` import: like private, unless the importer is a definition or usage (then visible in specializations).
- `public` import: imported memberships are public for the importing namespace.

# Rules

1. Import visibility must be explicitly declared as `public`, `protected`, or `private` (default is `private` in abstract syntax).
2. A membership import (no suffix) imports the single membership identified by the qualified name.
3. A namespace import (`::*`) imports all visible memberships of the identified namespace.
4. Recursive import (`::**`) adds recursive processing of owned namespace members.
5. An import owned by a root namespace must be `private`.
6. An import may optionally have a body containing annotating elements.

# Examples

```sysml
// Re-importing an alias:
package P2 {
  private import P1::C; // Imports with alias name "C".
  package Q {
    import C; // "C" is re-imported from P2 into Q.
  }
}

// Recursive import equivalence:
package P5 {
  private import P4::**;
  // Equivalent to:
  // private import P4;
  // private import P4::*;
  // private import P4::Q::*;
}
```

# Relationships

- [namespace.md](namespace.md) — imports are owned by namespaces
- [membership.md](membership.md) — imports produce unowned memberships in the importing namespace
- [package.md](package.md) — packages use imports, and packages may have filter conditions that restrict imports

# Citations

[1] OMG SysML v2 Specification, §7.5.3
