---
type: SysML v2 Concept
title: Requirement
description: A requirement is a stakeholder-imposed constraint that a design solution must satisfy, built from assumed and required sub-constraints and evaluated as true when all required constraints hold given the assumed constraints.
timestamp: 2026-07-01T00:00:00Z
---

A requirement is either a requirement definition or a requirement usage. Both are kinds of constraint (see §7.20), meaning they can be evaluated to true or false. A requirement is **satisfied** when it evaluates to true.

Every requirement has a **subject** — a distinguished `in` parameter identifying the entity on which the requirement is placed. If not explicitly declared, the subject defaults to type `Anything`. The constraint expressed by a requirement is a logical implication: if all **assumed constraints** are true, then all **required constraints** must be true.

A requirement definition may also carry **actor** parameters (entities external to the subject that are necessary for satisfaction) and **stakeholder** parameters (entities with concerns related to the requirement). Stakeholder concerns can be modeled explicitly as **concern** definitions/usages and **framed** inside a requirement.

A requirement definition can serve as a reusable template: specific usages can redefine its features (e.g., bind the subject to a concrete type or bind parameters to literal values).

# Syntax

```sysml
requirement def <'1.1'> MaximumMass {
  doc
  /*
   * Assuming the required mass is greater than 0,
   * the actual mass shall be less than or equal to the required mass.
   */
  attribute massActual   : MassValue;
  attribute massRequired : MassValue;
  assume constraint { massRequired > 0[kg] }
  require constraint { massActual <= massRequired }
}

requirement <'v1.1'> vehicleMaximumMass : MaximumMass {
  subject vehicle : Vehicle;
  attribute :>> massActual   = vehicle.totalMass;
  attribute :>> massRequired = 2000[kg];
}
```

# Semantics

- A requirement is a specialization of constraint; it evaluates to true when satisfied.
- The effective constraint is: `assume ⇒ require` (all assumed constraints true implies all required constraints true).
- A requirement always has a subject parameter (first `in` parameter), default type `Anything`.
- Composite requirement usages nested inside a requirement are automatically considered required constraints.
- If a nested subrequirement omits its subject, it is implicitly bound to the containing requirement's subject.

# Rules

- A requirement usage must be defined by exactly one requirement definition.
- The subject parameter must come before all other parameter declarations.
- Short names declared on a requirement definition or usage serve as the requirement ID.
- Stakeholder and actor parameters are declared with keywords `stakeholder` and `actor` (not with explicit direction).
- Actor/stakeholder parameters are part usages and must be defined by part definitions.

# Examples

```sysml
requirement def BrakingRequirement {
  subject vehicle     : Vehicle;
  actor   environment : 'Driving Environment';
  stakeholder driver  : Person;

  attribute speedLimit         : SpeedValue;
  attribute maxBrakingDistance : DistanceValue;

  assume constraint { doc /* The environment conditions are poor. */ }
  require constraint {
    doc /* The vehicle shall brake from initial speed to zero in < maxBrakingDistance. */
  }
}

requirement def VehicleRequirementsGroup {
  subject vehicle : Vehicle;
  requirement driving : DrivingRequirement;   // subject implicitly bound to vehicle
  requirement braking : BrakingRequirement;
  requirement engineRqts : EngineRequirementsGroup {
    subject engine = vehicle.engine;
  }
}
```

# Relationships

- [requirement-definition.md](requirement-definition.md) — the definition form
- [requirement-usage.md](requirement-usage.md) — the usage form
- [satisfy.md](satisfy.md) — asserts a requirement is satisfied by a feature
- [require-constraint.md](require-constraint.md) — designates a required constraint inside a requirement
- [frame-constraint.md](frame-constraint.md) — frames a concern inside a requirement
- [constraint.md](constraint.md) — supertype of requirement

# Citations

[1] OMG SysML v2 Specification, §7.21
