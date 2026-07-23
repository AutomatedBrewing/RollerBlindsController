---
type: SysML v2 Concept
title: Case Definition
description: A case definition is a kind of calculation definition that specifies a calculation producing a result intended to achieve an objective regarding a given subject, and serves as the base concept for analysis case definitions, verification case definitions, and use case definitions.
timestamp: 2026-07-01T00:00:00Z
---

A case definition is declared using the keyword `case def`. It specializes calculation definition (§7.19) and provides the foundational structure for all kinds of cases in SysML v2. A case definition specifies:

- A **subject** parameter (first `in` parameter) identifying the entity the case concerns
- An **objective** declared as a requirement usage using keyword `objective`
- Zero or more **actor** parameters (part usages representing external entities)
- A body of subactions and subcalculations that achieve the objective

The base case definition from the `Cases` library is `Case`.

# Syntax

```sysml
case def CaseDefName {
  subject subj  : SubjectType;
  actor   actor1: ActorType;

  objective {
    doc /* Description of what the case must achieve. */
  }

  // Subactions / subcalculations achieving the objective
}
```

# Semantics

- A case definition is a specialization of calculation definition.
- The objective is a requirement usage whose subject is bound by default to the result of the case.
- The subject parameter is always `in`; it must be declared first using keyword `subject`.
- Actor parameters are part usages declared with keyword `actor`.
- Specializations (analysis def, verification def, use case def) override binding of the objective subject.

# Rules

- Declared with `case def`.
- Subject parameter must appear before other parameter declarations.
- Actor parameters declared with `actor`; must be part usages defined by part definitions.
- The `objective` keyword identifies the requirement that the case must satisfy.

# Examples

```sysml
case def FaultRecovery {
  subject system   : AutomationSystem;
  actor   engineer : Person;

  objective {
    doc
    /* The engineer determines the cause of the system fault
     * and resolves it returning the system to nominal operation.
     */
  }
}
```

# Relationships

- [case.md](case.md) — general case concept
- [case-usage.md](case-usage.md) — usage of a case definition
- [analysis-case-definition.md](analysis-case-definition.md) — specialization for analysis
- [verification-case-definition.md](verification-case-definition.md) — specialization for verification
- [use-case-definition.md](use-case-definition.md) — specialization for use cases
- [calculation.md](calculation.md) — supertype (calculation definition)

# Citations

[1] OMG SysML v2 Specification, §7.22.2
