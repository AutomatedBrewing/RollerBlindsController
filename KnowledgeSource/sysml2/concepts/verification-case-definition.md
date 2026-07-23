---
type: SysML v2 Concept
title: Verification Case Definition
description: A verification case definition is a kind of case definition that specifies how to verify whether a subject satisfies certain requirements, with an objective always bound to the verification subject and a verdict result.
timestamp: 2026-07-01T00:00:00Z
---

A verification case definition is declared using the keyword `verification def`. It specializes case definition (§7.22) and enforces the rule that the **objective subject is always bound to the subject** of the verification case (not to the result). This models the intent that the verification case evaluates the subject against requirements.

The result of a verification case definition is a **verdict** (`pass`, `fail`, `inconclusive`, or `error`). The `PassIf` calculation from the `VerificationCases` library can map a Boolean to a `pass`/`fail` verdict.

The objective may contain `verify` usages (requirement verification usages) that designate the specific requirements to be verified.

The base library element is `VerificationCase` from the `VerificationCases` model library.

# Syntax

```sysml
verification def VerificationDefName {
  subject subj : SubjectType;
  actor   actor1 : ActorType;

  objective {
    doc /* Objective statement */
    verify requirement1;
  }

  // Verification actions: collect, analyze, evaluate...
  return verdict : VerdictKind;
}
```

# Semantics

- Declared with `verification def`.
- Specializes case definition (§7.22).
- The objective subject is always bound to the subject of the verification case.
- The result type is `VerdictKind` with values `pass`, `fail`, `inconclusive`, `error`.
- `verify <requirement>` in the objective identifies requirements the case verifies.
- `VerificationMethod` metadata can annotate the case with `inspect`, `analyze`, `demo`, or `test`.

# Rules

- Declared with `verification def`.
- An verification case usage must be typed by exactly one verification case definition.
- The objective subject must be bound to the verification case subject.
- Verified requirements use `verify` keyword in the objective body.

# Examples

```sysml
verification def VehicleMassTest {
  subject testVehicle : Vehicle;

  objective {
    verify vehicleMassRequirement;
  }

  action collectData { /* ... */ }
  action evaluateData { /* ... */ }

  return verdict : VerdictKind = evaluateData.verdict;
}
```

# Relationships

- [verification-case.md](verification-case.md) — general verification case concept
- [case-definition.md](case-definition.md) — supertype
- [verify.md](verify.md) — requirement verification usage in the objective
- [case.md](case.md) — general case concept

# Citations

[1] OMG SysML v2 Specification, §7.24.2
