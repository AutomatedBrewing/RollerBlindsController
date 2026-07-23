---
type: SysML v2 Diagram
title: Requirements Diagram
description: A Requirements Diagram shows requirement definitions and usages, the hierarchical decomposition of requirements, assumed and required constraints, and satisfy relationships between requirements and the design elements that fulfill them.
timestamp: 2026-07-01T00:00:00Z
---

The Requirements Diagram is the SysML v2 diagram type for capturing and tracing stakeholder-imposed constraints that a design solution must satisfy to be a valid solution. It shows the requirement hierarchy, the formal constraint expressions within requirements, and the satisfaction relationships to design elements.

A requirement definition is a kind of constraint definition that specifies stakeholder-imposed constraints. A requirement usage is a kind of constraint usage applied in some context.

# Purpose

Requirements diagrams are used to:
- Define and organize requirements hierarchically (decomposing requirements into nested sub-requirements).
- Show the subject, assumed constraints, and required constraints of each requirement.
- Show satisfy relationships linking design elements (parts, actions, etc.) to the requirements they fulfill.
- Show stakeholder and concern relationships.
- Show requirement IDs (short names) for traceability.
- Show framed concerns connecting stakeholder concerns to requirements.

# Notation

## Requirement Symbol

A requirement definition is shown as a rectangle with the `«requirement def»` stereotype:

```
«requirement def»
<R1> RequirementDef1
```

A requirement usage is shown with the `«requirement»` stereotype:

```
«requirement»
<r1> requirement1 : RequirementDef1
```

The short name in angle brackets (`<r1>`) serves as the requirement ID.

## Compartments

Requirement symbols may include the following compartments:

- **documentation** — informal "shall" text statements.
- **subject** — identifies the entity to which the requirement applies.
- **require constraints** — the required constraint usages.
- **assume constraints** — the assumed constraint usages.
- **satisfy requirements** — elements that satisfy the requirement.

Example:
```
«requirement»
requirement1 : RequirementDef1
  documentation
    /* ... */
  subject
    redefines s1 = mySubject
  require constraints
    require2
  assume constraints
    constraint1
```

## Satisfy Relationship

A satisfy relationship is shown as a directed arrow with the `«satisfy»` stereotype from the satisfying design element to the satisfied requirement:

```
«part»
part1 : Part1   ——«satisfy»——>   «requirement»
                                 requirement1
```

Textual notation:
```
part part1 : Part1 {
    satisfy requirement1;
}
// Or as a standalone statement:
satisfy requirement1 by part1;
```

A negated satisfy relationship asserts that an element does **not** satisfy a requirement.

## Assume and Require Links

- **«assume»** arrow: connects a requirement to one of its assumed constraints.
- **«require»** arrow: connects a requirement to one of its required constraints.
- **«frame»** arrow: connects a requirement to a concern it frames.

# Frame and Header

The diagram frame header for a requirements diagram typically uses the identifier `req`.

# Compartments

As described above, requirement symbols use documentation, subject, require constraints, assume constraints, and satisfy requirements compartments.

# Examples

```
requirement def <'1.1'> MaximumMass {
    doc /* The actual mass shall not exceed the required mass. */
    attribute massActual : MassValue;
    attribute massRequired : MassValue;
    assume constraint { massRequired > 0[kg] }
    require constraint { massActual <= massRequired }
}

requirement <'v1.1'> vehicleMaximumMass : MaximumMass {
    subject vehicle : Vehicle;
    attribute :>> massActual = vehicle.totalMass;
    attribute :>> massRequired = 2000[kg];
}

part myVehicle : Vehicle {
    satisfy vehicleMaximumMass;
}
```

# Related Concepts

- [Requirement Satisfaction](../rules/requirement-satisfaction.md)
- [Definition-Usage Pattern](../rules/definition-usage-pattern.md)
- [Constraint Diagram](constraint-diagram.md)

# Citations

[1] OMG SysML v2 Specification, §7.21.1 (Requirements Overview)
[2] OMG SysML v2 Specification, §7.21.2 (Requirement Definition and Usage)
[3] OMG SysML v2 Specification, Table 20 (Requirements – Representative Notation)
