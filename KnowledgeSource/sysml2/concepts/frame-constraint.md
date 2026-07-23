---
type: SysML v2 Concept
title: Frame Constraint
description: A frame constraint is a composite concern usage declared inside a requirement definition or usage with the keyword `frame` or `frame concern`, indicating that the requirement must address the framed stakeholder concern and automatically counting as a required constraint of the containing requirement.
timestamp: 2026-07-01T00:00:00Z
---

A frame constraint (framed concern usage) is declared in the body of a requirement definition or usage with the prefix keyword `frame concern` (or shorthand `frame`). It specifies that the containing requirement frames one or more stakeholder concerns, meaning all framed concerns must be addressed for the requirement to be satisfied.

A framed concern usage is a subrequirement of the containing requirement definition or usage, so it is automatically treated as a required constraint without needing an additional `require` keyword.

The shorthand `frame <qualifiedName>` uses reference subsetting to identify the concern. The concern definition's subject is automatically bound to the subject of the containing requirement.

# Syntax

```sysml
concern def BrakingConcern {
  subject     vehicle : Vehicle;
  stakeholder driver  : Person;
  attribute maxBrakingDistance : DistanceValue;
  require constraint {
    doc /* Vehicle shall brake to zero within maxBrakingDistance. */
  }
}

requirement def BrakingRequirement {
  subject vehicle     : Vehicle;
  actor   environment : 'Driving Environment';
  attribute maxBrakingDistance : DistanceValue;

  assume constraint {
    doc /* The environment conditions are poor. */
  }

  // Frame the concern; subject is automatically bound to "vehicle".
  frame concern brakingConcern : BrakingConcern {
    :>> maxBrakingDistance = BrakingRequirement::maxBrakingDistance;
  }
}
```

Shorthand using reference subsetting:

```sysml
requirement def BrakingRequirement {
  // ...
  frame brakingConcern;
}
```

# Semantics

- `frame concern` declares a composite concern usage (subrequirement) in a requirement.
- Because it is a subrequirement, it is automatically a required constraint of the containing requirement.
- The subject of the framed concern is bound by default to the containing requirement's subject.
- All framed concerns must be addressed for the containing requirement to be satisfied.

# Rules

- Must appear in the body of a requirement definition or requirement usage.
- Declared with `frame concern <name> : <ConcernDef>` (longhand) or `frame <qualifiedName>` (shorthand via reference subsetting).
- A framed concern is a subrequirement — it is automatically a required constraint without an additional `require`.

# Examples

```sysml
viewpoint def 'System Structure Perspective' {
  frame 'system breakdown';
  frame 'modularity';
  require constraint {
    doc /* A system structure view shall show hierarchical part decomposition. */
  }
}
```

# Relationships

- [requirement.md](requirement.md) — containing requirement that frames the concern
- [requirement-definition.md](requirement-definition.md) — where frame concern is declared
- [require-constraint.md](require-constraint.md) — framed concerns are also required constraints
- [viewpoint-definition.md](viewpoint-definition.md) — viewpoints commonly use frame concern

# Citations

[1] OMG SysML v2 Specification, §7.21.3
