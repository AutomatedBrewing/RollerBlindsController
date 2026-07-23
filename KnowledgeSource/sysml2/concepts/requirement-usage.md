---
type: SysML v2 Concept
title: Requirement Usage
description: A requirement usage is a kind of constraint usage that instantiates a requirement definition in a specific context, potentially refining the subject, parameters, assumed constraints, and required constraints inherited from its definition.
timestamp: 2026-07-01T00:00:00Z
---

A requirement usage is declared using the keyword `requirement` (without `def`). It is a usage of a single requirement definition and specializes constraint usage (§7.20). A requirement usage:

- Must be typed by exactly one requirement definition
- Can redefine the **subject** parameter to bind it to a concrete entity
- Can redefine or add **actor** and **stakeholder** parameters
- Can add further `assume` and `require` constraints to those inherited from the definition
- Can nest composite subrequirement usages (which become additional required constraints)
- Can be given a short name that serves as its requirement ID

A requirement usage can be placed inside a package, a part definition/usage, or another requirement definition/usage, establishing the context in which the requirement applies.

A design solution must satisfy the requirement and all of its member requirements and constraints.

The base usage from the `Requirements` library is `requirementChecks`.

# Syntax

```sysml
requirement <'v1.1'> vehicleMaximumMass : MaximumMass {
  doc /* The total mass of a Vehicle shall be no greater than its required mass. */
  subject vehicle : Vehicle;
  attribute :>> massActual   = vehicle.totalMass;
  attribute :>> massRequired = 2000[kg];
}
```

# Semantics

- A requirement usage is a constraint usage typed by exactly one requirement definition.
- It inherits all assumed and required constraints from its definition.
- Nested composite requirement usages in a requirement usage are automatically required constraints of the container.
- If no subject is declared in a subrequirement usage, its subject is bound to the containing requirement's subject.
- The containing package, part, or requirement provides the context for the usage.

# Rules

- Declared using keyword `requirement` (plus optional short name and definition type).
- A requirement usage must be defined by exactly one requirement definition.
- Subject redefinition uses `subject redefines <name> = <feature>`.
- Actor and stakeholder parameters are declared with `actor` / `stakeholder`.
- Informal text is provided by documentation comments in the body.

# Examples

```sysml
requirement def VehicleRequirementsGroup {
  subject vehicle : Vehicle;

  requirement driving : DrivingRequirement;
  requirement braking : BrakingRequirement;
  requirement engineRqts : EngineRequirementsGroup {
    subject engine = vehicle.engine;
  }
}
```

# Relationships

- [requirement.md](requirement.md) — general concept
- [requirement-definition.md](requirement-definition.md) — the definition being instantiated
- [satisfy.md](satisfy.md) — used to assert that this usage is satisfied
- [require-constraint.md](require-constraint.md) — required constraint inside a usage
- [constraint-usage.md](constraint-usage.md) — supertype

# Citations

[1] OMG SysML v2 Specification, §7.21.1, §7.21.2
