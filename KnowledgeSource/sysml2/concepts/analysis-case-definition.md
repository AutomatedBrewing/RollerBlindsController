---
type: SysML v2 Concept
title: Analysis Case Definition
description: An analysis case definition is a kind of case definition that specifies an analysis to be performed on a subject, with an objective always bound to the result produced by the analysis rather than to the subject itself.
timestamp: 2026-07-01T00:00:00Z
---

An analysis case definition is declared with the keyword `analysis def`. It specializes case definition (§7.22) and constrains the objective binding: the objective's subject is always bound to the **result** of the analysis case (not the subject input parameter). This models the intent that the analysis produces a result that is then evaluated.

The result of an analysis case definition is specified using the `return` keyword. The analysis body specifies the calculations needed to produce that result.

The base library element is `AnalysisCase` from the `AnalysisCases` model library.

# Syntax

```sysml
analysis def FuelEconomyAnalysis {
  subject vehicle : Vehicle;
  return fuelEconomyResult : DistancePerVolumeValue;

  objective fuelEconomyAnalysisObjective {
    doc
    /* The objective is to determine whether the subject vehicle
     * can satisfy the fuel economy requirement.
     */
    requirement : FuelEconomyRequirement;
  }

  // Subactions / subcalculations here...
}
```

# Semantics

- Declared with `analysis def`.
- Specializes case definition (§7.22).
- The objective subject is always bound to the result of the analysis case.
- The analysis result is declared with `return`.
- The body specifies actions and calculations producing the result.

# Rules

- Declared with `analysis def`.
- An analysis case usage must be typed by exactly one analysis case definition.
- The objective subject must be bound to the result (this overrides the general case default which would bind to result anyway).

# Examples

```sysml
analysis def DynamicsAnalysis {
  subject vehicle : Vehicle;
  return trajectory : TrajectoryData;

  objective {
    doc /* Determine the vehicle trajectory and required engine power. */
  }
}
```

# Relationships

- [analysis-case.md](analysis-case.md) — general analysis case concept
- [case-definition.md](case-definition.md) — supertype
- [case.md](case.md) — general case concept
- [calculation.md](calculation.md) — supertype (analysis is a kind of calculation)

# Citations

[1] OMG SysML v2 Specification, §7.23.2
