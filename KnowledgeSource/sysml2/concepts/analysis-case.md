---
type: SysML v2 Concept
title: Analysis Case
description: An analysis case is a kind of case whose objective is to carry out an analysis on a subject and return a result about that subject, where the objective is always about the result produced by the analysis.
timestamp: 2026-07-01T00:00:00Z
---

An analysis case encompasses both analysis case definitions and analysis case usages. The purpose of an analysis case is to analyze a given subject and return a result. The **objective** of an analysis case is always about the **result** returned by the case (not the subject directly), and the objective's subject is automatically bound to the result of the analysis.

Performing an analysis case may involve:
1. Analysis **actions** that perform calculations returning sub-results
2. External **solvers** that evaluate the analysis model
3. Sets of **simultaneous equations** modeled as constraint usages

A specialized kind of analysis case is the **trade-off analysis** (using `TradeStudy` from the Analysis Domain Library), which evaluates and compares alternatives based on an evaluation function.

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
  // ...
}
```

# Semantics

- An analysis case definition specializes case definition; an analysis case usage specializes case usage.
- The objective's subject is always bound to the **result** of the analysis case (not its subject parameter).
- The analysis produces a result that is then evaluated against the objective requirement.
- Trade-off analyses use `TradeStudy` from the Analysis Domain Library to compare alternatives.

# Rules

- Declared with `analysis def` (definition) or `analysis` (usage).
- The objective subject binding is fixed: it is always bound to the result of the analysis case.
- An analysis case usage must be typed by exactly one analysis case definition.

# Examples

```sysml
analysis engineTradeStudy : TradeStudy {
  subject : Engine = (engine4cyl, engine6cyl);
  objective : MaximizeObjective;

  calc :>> evaluationFunction {
    inpart anEngine : Engine :>> alternative;
    // rollup calculations...
    return :>> result : Real = EngineEvaluation(/* ... */);
  }
  returnpart :>> selectedAlternative : Engine;
}
```

# Relationships

- [analysis-case-definition.md](analysis-case-definition.md) — definition form
- [case.md](case.md) — supertype concept
- [case-definition.md](case-definition.md) — supertype definition
- [verification-case.md](verification-case.md) — related: verification of requirements
- [calculation.md](calculation.md) — supertype (analysis is a kind of calculation)

# Citations

[1] OMG SysML v2 Specification, §7.23.1
