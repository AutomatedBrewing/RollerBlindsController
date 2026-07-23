---
type: SysML v2 Concept
title: Include Use Case
description: An include use case usage is a use case usage that is also a kind of perform action usage, declared inside a containing use case definition or usage to specify that the containing use case's behavior includes the behavior of the included use case.
timestamp: 2026-07-01T00:00:00Z
---

An include use case usage is declared with the keyword `include use case` (or shorthand `include`). It is simultaneously a **use case usage** and a **perform action usage** (§7.17.6). Its purpose is to incorporate the full behavior of another use case into the containing use case.

The included use case (the one being incorporated) is identified:
- By an explicit name in `include use case <name>` (the included use case is the usage itself)
- By reference subsetting using `references` or `::>` to point to a named use case usage
- By shorthand `include <qualifiedName>` (which uses reference subsetting implicitly)

The **subject** of the included use case is bound by default to the subject of the containing use case. The **actor** parameters of the included use case must generally be explicitly bound to actors of the containing use case.

# Syntax

```sysml
use case 'provide transportation' : 'Provide Transportation' {
  first start;

  // Shorthand: include use case identified by qualified name
  then include 'enter vehicle' {
    actor :>> driver     = 'provide transportation'::driver;
    actor :>> passengers = 'provide transportation'::passengers;
  }
  then include 'drive vehicle' {
    actor :>> driver      = 'provide transportation'::driver;
    actor :>> environment = 'provide transportation'::environment;
  }
  then include 'exit vehicle' {
    actor :>> driver     = 'provide transportation'::driver;
    actor :>> passengers = 'provide transportation'::passengers;
  }
  then done;
}
```

Full form with explicit reference subsetting:

```sysml
include use case driveStep references 'drive vehicle' {
  actor :>> driver = 'provide transportation'::driver;
}
```

# Semantics

- An include use case usage is a perform action usage whose action is a use case usage.
- The subject of the included use case is automatically bound to the subject of the containing use case.
- Actor parameters of the included use case should be explicitly bound to actors of the containing use case.
- The included use case is related to the include usage by a reference subsetting relationship.

# Rules

- Declared with `include use case` (longhand) or `include <qualifiedName>` (shorthand).
- Shorthand `include` omits name/short name; the included use case is identified by the qualified name after `include`.
- The subject of the included use case is bound by default to the containing use case's subject.
- Actor bindings must be declared explicitly for the included use case actors.
- The included use case subject definition must be compatible with (conformant to) the containing use case's subject.

# Examples

```sysml
use case 'provide transportation' : 'Provide Transportation' {
  first start;
  then include 'enter vehicle' {
    actor :>> driver     = 'provide transportation'::driver;
    actor :>> passengers = 'provide transportation'::passengers;
  }
  then done;
}
use case 'enter vehicle';
```

# Relationships

- [use-case.md](use-case.md) — the general use case concept
- [use-case-usage.md](use-case-usage.md) — include use case is a kind of use case usage
- [use-case-definition.md](use-case-definition.md) — contains include use case usages
- [perform-action.md](perform-action.md) — supertype (include use case is a perform action usage)

# Citations

[1] OMG SysML v2 Specification, §7.25.1, §7.25.3
