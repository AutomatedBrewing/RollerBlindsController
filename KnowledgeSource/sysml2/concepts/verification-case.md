---
type: SysML v2 Concept
title: Verification Case
description: A verification case is a kind of case whose result is a verdict on whether the subject satisfies certain requirements, encompassing data collection, analysis, and evaluation steps that conclude with one of the verdict values pass, fail, inconclusive, or error.
timestamp: 2026-07-01T00:00:00Z
---

A verification case (definition or usage) models the process by which one or more requirements are verified against a subject (the "unit under test" or "unit under verification"). The objective of a verification case is always bound to the **subject** of the case (unlike an analysis case, where the objective is bound to the result).

The result of a verification case is a **verdict** with one of four values:
- `pass` — the subject satisfies the verified requirements
- `fail` — the subject does not satisfy the verified requirements
- `inconclusive` — a determination could not be made
- `error` — an error occurred during the verification

A typical verification case proceeds through three phases:
1. **Collect data** about the subject (using methods such as analysis, inspection, demonstration, or test)
2. **Analyze collected data**
3. **Evaluate** the results to produce the verdict

The `VerificationMethod` metadata definition can annotate a verification case with the method used (`inspect`, `analyze`, `demo`, or `test`).

# Syntax

```sysml
verification def VehicleMassTest {
  import VerificationCases::*;

  subject testVehicle : Vehicle;

  objective vehicleMassVerificationObjective {
    verify vehicleMassRequirement;
  }

  metadata VerificationMethod {
    kind = VerificationMethodKind::test;
  }

  action collectData {
    in part testVehicle : Vehicle = VehicleMassTest::testVehicle;
    out massMeasured :> ISQ::mass;
  }
  action processData {
    in massMeasured :> ISQ::mass = collectData.massMeasured;
    out massProcessed :> ISQ::mass;
  }
  action evaluateData {
    in massProcessed :> ISQ::mass = processData.massProcessed;
    out verdict : VerdictKind =
      PassIf(vehicleMassRequirement(
        vehicle    = testVehicle,
        massActual = massProcessed));
  }
  return verdict : VerdictKind = evaluateData.verdict;
}
```

# Semantics

- A verification case definition specializes case definition; a usage specializes case usage.
- The objective subject is always bound to the subject of the verification case.
- The result is a verdict of type `VerdictKind`.
- `verify` usages in the objective designate requirements to be verified.
- `PassIf` from `VerificationCases` library can be used to determine pass/fail from a Boolean value.

# Rules

- Declared with `verification def` (definition) or `verification` (usage).
- The objective subject must be bound to the verification case subject.
- Verified requirements are declared using `verify` inside the `objective` body.
- A verification case usage must be typed by exactly one verification case definition.

# Examples

```sysml
verification verification1 : VehicleMassTest {
  subject :>> testVehicle = vehiclePrototype;
}
```

# Relationships

- [verification-case-definition.md](verification-case-definition.md) — definition form
- [verify.md](verify.md) — requirement verification usage in the objective
- [case.md](case.md) — supertype concept
- [case-definition.md](case-definition.md) — supertype
- [metadata.md](metadata.md) — VerificationMethod annotation

# Citations

[1] OMG SysML v2 Specification, §7.24.1
