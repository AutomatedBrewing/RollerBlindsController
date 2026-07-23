---
type: SysML v2 Concept
title: Requirement Definition
description: A requirement definition is a kind of constraint definition that specifies stakeholder-imposed constraints a design solution must satisfy, serving as a reusable requirement template with subjects, actors, stakeholders, assumed constraints, and required constraints.
timestamp: 2026-07-01T00:00:00Z
---

A requirement definition is declared using the keyword `requirement def`. It is a specialization of constraint definition (§7.20) and therefore also a kind of behavior definition. A requirement definition may carry:

- A **subject** parameter (first `in` parameter) typed by the entity being constrained
- One or more **actor** parameters (part usages representing external roles)
- One or more **stakeholder** parameters (part usages representing concerned parties)
- **Assumed constraints** prefixed with `assume` or `assume constraint`
- **Required constraints** prefixed with `require` or `require constraint`
- Nested composite requirement usages (subrequirements), which are automatically required constraints
- A **short name** that acts as the requirement ID

A requirement definition acts as a template: usages of it can redefine features (e.g., bind the subject to a specific type or bind parameter values).

The base requirement definition from the `Requirements` library is `RequirementCheck`.

# Syntax

```sysml
requirement def <'req-id'> RequirementDefName {
  subject subj : SubjectType;
  actor   act  : ActorType;
  stakeholder sh : StakeholderType;

  attribute param1 : ValueType;

  assume constraint { /* assumption expression */ }
  require constraint { /* required expression */ }
}
```

# Semantics

- A requirement definition specializes constraint definition.
- The constraint expressed is: all assumed constraints true ⇒ all required constraints true.
- Nested composite requirement usages are automatically required constraints of the container.
- The subject parameter is always an `in` parameter and must be declared first.
- The informal text of the requirement is provided by documentation comments in the body.

# Rules

- Declared using `requirement def`.
- The short name (in angle brackets) of a requirement definition is its requirement ID.
- Subject parameter declared with keyword `subject` (not with explicit `in` direction).
- Actor and stakeholder parameters declared with keywords `actor` / `stakeholder`; they must be part usages.
- Subrequirements (nested requirement usages) implicitly inherit the subject of the containing definition if they omit their own subject declaration.

# Examples

```sysml
requirement def <'1.1'> MaximumMass {
  attribute massActual   : MassValue;
  attribute massRequired : MassValue;
  assume constraint { massRequired > 0[kg] }
  require constraint { massActual <= massRequired }
}

requirement def BrakingRequirement {
  subject vehicle     : Vehicle;
  actor   environment : 'Driving Environment';
  stakeholder driver  : Person;
  attribute maxBrakingDistance : DistanceValue;
  require constraint {
    doc /* Vehicle shall brake to zero within maxBrakingDistance. */
  }
}
```

# Relationships

- [requirement.md](requirement.md) — general concept encompassing definition and usage
- [requirement-usage.md](requirement-usage.md) — usage of a requirement definition
- [constraint-definition.md](constraint-definition.md) — supertype
- [require-constraint.md](require-constraint.md) — required constraint declared inside a definition
- [frame-constraint.md](frame-constraint.md) — framed concern inside a definition

# Citations

[1] OMG SysML v2 Specification, §7.21.1, §7.21.2
