---
type: SysML v2 Concept
title: Case
description: A case is a general concept in SysML v2 representing a calculation that produces a result intended to achieve a specific objective regarding a given subject, serving as the basis for analysis cases, verification cases, and use cases.
timestamp: 2026-07-01T00:00:00Z
---

A case encompasses both case definitions and case usages. A case definition is a kind of calculation definition (§7.19) and a case usage is a kind of calculation usage. The case concept is general enough to be used directly, but more commonly it provides the foundation for three specialized kinds: **analysis cases** (§7.23), **verification cases** (§7.24), and **use cases** (§7.25).

Every case has:
- A **subject** — a distinguished `in` parameter identifying the entity the case concerns
- An **objective** — a requirement usage that the performance of the case must satisfy
- Optionally one or more **actor** parameters — part usages representing entities external to the subject

The body of a case specifies the subactions and subcalculations needed to achieve the objective. This may include collecting information about the subject, evaluating it, and producing a result.

The base library elements are `Case` (definition) and `cases` (usage) from the `Cases` model library.

# Syntax

```sysml
case def FaultRecovery {
  subject system : AutomationSystem;
  actor engineer : Person;

  objective {
    doc
    /* The engineer determines the cause of the system fault
     * and resolves it, returning the system to nominal operation.
     */
  }
}
```

# Semantics

- A case definition specializes calculation definition; a case usage specializes calculation usage.
- The subject parameter is the first `in` parameter.
- The objective is declared with keyword `objective` (a requirement usage with subject bound to the case result by default).
- Depending on the kind of case, the objective subject may be the case result (analysis case) or the case subject (verification/use case).
- Actor parameters represent external entities necessary to the case specification.

# Rules

- Declared with keyword `case def` (definition) or `case` (usage).
- A case usage must be typed by exactly one case definition.
- Subject parameter declared with keyword `subject`; must appear before other parameters.
- Actor parameters declared with keyword `actor`; must be part usages.
- The objective is declared with keyword `objective`.

# Examples

```sysml
case def FaultRecovery {
  subject system   : AutomationSystem;
  actor   engineer : Person;

  objective {
    doc /* Engineer resolves the fault and returns system to nominal operation. */
  }
}
```

# Relationships

- [case-definition.md](case-definition.md) — definition form
- [case-usage.md](case-usage.md) — usage form
- [analysis-case.md](analysis-case.md) — specialization for analysis
- [verification-case.md](verification-case.md) — specialization for verification
- [use-case.md](use-case.md) — specialization for use cases
- [calculation.md](calculation.md) — supertype of case

# Citations

[1] OMG SysML v2 Specification, §7.22
