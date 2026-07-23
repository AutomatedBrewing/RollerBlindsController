---
type: SysML v2 Concept
title: Satisfy
description: A satisfy requirement usage is a kind of assert constraint usage that asserts a specific requirement is satisfied when a given feature is bound to the requirement's subject parameter.
timestamp: 2026-07-01T00:00:00Z
---

A `satisfy requirement` usage asserts that a named requirement evaluates to true when a given **satisfying feature** is bound to the requirement's subject parameter. It is both a requirement usage and an assert constraint usage (§7.20.3), meaning it positively asserts satisfaction (rather than merely checking it).

The satisfying feature is specified after the keyword `by`. Other parameters or features of the requirement may also be bound in the body of the satisfy usage.

A satisfy requirement usage may be **negated** by placing `not` before `satisfy`, asserting that the entity does *not* satisfy the requirement.

When nested inside a definition or usage (without an explicit `by` clause), the containing definition/usage itself is implicitly the satisfying feature.

The shorthand form `satisfy <qualifiedName> by <feature>` omits the name and uses reference subsetting.

# Syntax

```sysml
// Longhand
satisfy requirement braking : BrakingRequirement by vehicle1 {
  :>> speedLimit         = 100[km/h];
  :>> maxBrakingDistance = 10[m];
}

// Shorthand
satisfy vehicleMaximumMass by vehicle1;

// Negated
not satisfy vehicleMaximumMass by vehicle2;

// Nested (implicit satisfying feature is the containing part)
part vehicle3 : Vehicle {
  satisfy rqts : VehicleRequirementsGroup;
}
```

# Semantics

- A satisfy requirement usage is declared with keyword `satisfy requirement` (or shorthand `satisfy`).
- It asserts that its referenced requirement evaluates to true with the satisfying feature bound to the subject.
- A negated satisfy (prefixed `not`) asserts the requirement is NOT satisfied by the given feature.
- When nested in a definition/usage without `by`, the enclosing definition/usage is the satisfying feature.
- The shorthand `satisfy <name>` uses reference subsetting to identify the requirement.

# Rules

- The subject parameter of a satisfy requirement usage must be bound to a satisfying feature.
- The satisfying feature is specified using keyword `by`.
- Negation is declared by placing `not` immediately before `satisfy`.
- Shorthand omits name and short name; the requirement is identified by qualified name after `satisfy`.

# Examples

```sysml
part vehicle1 : Vehicle;
satisfy requirement braking : BrakingRequirement by vehicle1 {
  :>> speedLimit         = 100[km/h];
  :>> maxBrakingDistance = 10[m];
}

part vehicle2 : ExperimentalVehicle;
not satisfy vehicleMaximumMass by vehicle2;
```

# Relationships

- [requirement.md](requirement.md) — the requirement being asserted satisfied
- [requirement-usage.md](requirement-usage.md) — satisfy is a specialization of requirement usage
- [constraint-usage.md](constraint-usage.md) — satisfy is a kind of assert constraint usage

# Citations

[1] OMG SysML v2 Specification, §7.21.1, §7.21.4
