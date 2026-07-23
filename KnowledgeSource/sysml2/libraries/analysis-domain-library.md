---
type: SysML v2 Library
title: Analysis Domain Library
description: The Analysis Domain Library provides SysML v2 base types and metadata for trade-study analysis cases, sampled-function modeling, state-space representation, and analysis tool integration.
timestamp: 2026-07-01T00:00:00Z
---

The Analysis Domain Library is a SysML v2 domain library that extends the Systems Library with specialized constructs for systems analysis. It supplies abstract definitions for trade-off studies, numerical sampled-function models, state-space system representations, and metadata for integrating external analysis tools. All source files use `.sysml` syntax and reside in the `Domain Libraries/Analysis/` directory.

# Contents

- **TradeStudies** (`TradeStudies.sysml`) — Defines a framework for trade-off analysis:
  - `EvaluationFunction` — abstract `calc def` that takes an `alternative : Anything` and returns a `ScalarValue` representing its evaluated score.
  - `TradeStudyObjective` — abstract `requirement def` expressing the goal of selecting the best alternative from a set, given an `EvaluationFunction`.
  - `TradeStudy` — abstract `analysis case def` that executes a trade study by iterating over alternatives, evaluating them, and satisfying a `TradeStudyObjective`.
  - Specializations for `BestValueTradeStudy` (maximize/minimize a scalar score).
- **SampledFunctions** (`SampledFunctions.sysml`) — Defines types for modeling relationships as sampled (discrete) functions:
  - `SampledFunction` — an attribute definition mapping a domain of independent variable values to a range of dependent variable values stored as tabular samples.
  - `PiecewiseLinearFunction` — a piecewise-linear interpolation of sampled data.
- **StateSpaceRepresentation** (`StateSpaceRepresentation.sysml`) — Defines state-space system model representations:
  - `DynamicalSystem` — a part definition with state variables, inputs, and outputs following standard state-space matrix form (A, B, C, D matrices as quantity attributes).
  - `ContinuousSystem` / `DiscreteSystem` — specializations for continuous-time and discrete-time dynamical systems.
- **AnalysisTooling** (`AnalysisTooling.sysml`) — Provides metadata annotations for external analysis tool integration:
  - `ToolExecution` — metadata definition with `toolName : String` and `uri : String` for identifying the external tool implementing an action.
  - `ToolVariable` — metadata definition with a `name : String` for mapping model features to tool variables.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `EvaluationFunction` | abstract calc def | Evaluates a trade-study alternative, returning a `ScalarValue`. |
| `TradeStudyObjective` | abstract requirement def | Objective definition selecting the best alternative. |
| `TradeStudy` | abstract analysis case def | Top-level trade study case executing alternative evaluation. |
| `SampledFunction` | attribute def | Discrete tabular function relating input to output values. |
| `PiecewiseLinearFunction` | attribute def | Piecewise-linear interpolation of sampled data. |
| `DynamicalSystem` | part def | State-space system with state, input, and output variables. |
| `ContinuousSystem` | part def | Continuous-time specialization of `DynamicalSystem`. |
| `DiscreteSystem` | part def | Discrete-time specialization of `DynamicalSystem`. |
| `ToolExecution` | metadata def | Identifies the external analysis tool for an action. |
| `ToolVariable` | metadata def | Maps a model feature to a named tool variable. |

# Usage

Use `TradeStudies` to define trade-off analysis cases:

```sysml
private import TradeStudies::*;

analysis def EngineSelectionStudy :> TradeStudy {
    subject selectedAlternative : EngineConcept;
    in alternatives : EngineConcept[1..*];
    objective :> tradeStudyObjective : EngineObjective;
}
```

Use `AnalysisTooling` to annotate actions with external tool linkage:

```sysml
private import AnalysisTooling::ToolExecution;

#ToolExecution(toolName = "Matlab", uri = "matlab://models/sim1")
action def RunSimulation { ... }
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Domain Libraries\Analysis\`

Files: `TradeStudies.sysml`, `SampledFunctions.sysml`, `StateSpaceRepresentation.sysml`, `AnalysisTooling.sysml`

# Related Libraries

- [Systems Library](./systems-library.md)
- [Quantities and Units Library](./quantities-units-library.md)
- [Metadata Domain Library](./metadata-domain-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
