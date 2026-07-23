---
type: SysML v2 Concept
title: Verify
description: A verify requirement usage is a subrequirement declared inside the objective of a verification case that designates a specific requirement to be verified by the verification case.
timestamp: 2026-07-01T00:00:00Z
---

A `verify requirement` usage (or shorthand `verify`) appears inside the **objective** of a verification case definition or usage to indicate one or more requirements that the verification case is responsible for verifying. It is a subrequirement of the objective and is therefore automatically considered a required constraint of the objective.

The subject of a verify requirement usage is bound by default to the subject of the objective, which is itself bound to the subject of the containing verification case. This means the verification is always in terms of the same subject as the verification case.

The shorthand keyword `verify` (without `requirement`) uses reference subsetting to identify the requirement.

# Syntax

```sysml
verification def VehicleMassTest {
  subject testVehicle : Vehicle;

  objective vehicleMassVerificationObjective {
    // Shorthand: subject is automatically bound to testVehicle.
    verify vehicleMassRequirement;
  }
  // ...
}
```

# Semantics

- A verify requirement usage is a subrequirement (required constraint) of the objective in a verification case.
- Its subject is automatically bound to the subject of the objective (which is the verification case subject).
- Declared with keyword `verify requirement` (longhand) or `verify <qualifiedName>` (shorthand using reference subsetting).
- The verdict of the verification case evaluates whether the subject satisfies all verified requirements.

# Rules

- `verify` declarations appear only inside the `objective` body of a verification case.
- The subject of the verified requirement is bound to the verification case subject by default.
- Multiple `verify` statements in one objective designate multiple requirements to be verified.

# Examples

```sysml
verification def VehicleMassTest {
  subject testVehicle : Vehicle;

  objective vehicleMassVerificationObjective {
    verify vehicleMassRequirement;
  }

  action collectData {
    in part testVehicle : Vehicle = VehicleMassTest::testVehicle;
    out massMeasured :> ISQ::mass;
  }
  action evaluateData {
    in massProcessed :> ISQ::mass;
    out verdict : VerdictKind =
      PassIf(vehicleMassRequirement(vehicle = testVehicle,
                                    massActual = massProcessed));
  }
  return verdict : VerdictKind = evaluateData.verdict;
}
```

Graphical notation uses a `«verify»` dependency arrow from the verification case to the requirement.

# Relationships

- [verification-case.md](verification-case.md) — the verification case that contains this verify usage
- [verification-case-definition.md](verification-case-definition.md) — where verify appears
- [requirement-usage.md](requirement-usage.md) — supertype (verify is a requirement usage)
- [requirement.md](requirement.md) — the requirement being verified

# Citations

[1] OMG SysML v2 Specification, §7.24.1, §7.24.2
