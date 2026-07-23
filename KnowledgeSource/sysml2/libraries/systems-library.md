---
type: SysML v2 Library
title: Systems Library
description: The Systems Library defines the complete set of SysML v2 base types for structural, behavioral, constraint, requirement, flow, state, case, and view modeling constructs used in systems engineering.
timestamp: 2026-07-01T00:00:00Z
---

The Systems Library is the primary SysML v2 standard library that systems engineers work with directly. It defines the base types (`part def`, `action def`, `item def`, etc.) that all user-defined SysML models specialize. Each file in the library is a `standard library package` written in `.sysml` syntax and sits in the Systems Library directory. The library also includes `SysML.sysml`, which provides a reflective model of the SysML abstract syntax expressed as `metadata def` elements. All base types ultimately trace back to the Kernel Semantic Library.

# Contents

- **SysML** (`SysML.sysml`) — A reflective model of the SysML abstract syntax. Defines `metadata def` elements for every SysML construct (e.g., `ActionDefinition`, `PartUsage`, `RequirementDefinition`), enabling programmatic access to and annotation of SysML abstract syntax elements.
- **Actions** (`Actions.sysml`) — Defines `Action` as the base class of all action definitions, plus specialized action types: `AssignmentAction`, `AcceptAction`, `SendAction`, `ControlAction` (Merge, Decision, ForLoop, WhileLoop, IfAction), and composite action flow constructs.
- **Parts** (`Parts.sysml`) — Defines `Part` (the root of all part definitions) with `ownedPorts`, `performedActions`, `ownedActions`, and `exhibitedStates`.
- **Items** (`Items.sysml`) — Defines `Item` as the base type for things that can flow through systems, with `start` and `done` snapshots.
- **Attributes** (`Attributes.sysml`) — Defines `AttributeValue` as the base for all attribute definitions.
- **Ports** (`Ports.sysml`) — Defines `Port` (base type for port definitions) and `PortUsage`.
- **Connections** (`Connections.sysml`) — Defines `Connection` and `ConnectionUsage` for structural connections between parts.
- **Flows** (`Flows.sysml`) — Defines `FlowConnection`, `FlowConnectionUsage`, `MessageAction`, and item/message flow constructs.
- **Interfaces** (`Interfaces.sysml`) — Defines `Interface` and `InterfaceUsage` for interface definitions between port-bearing elements.
- **Allocations** (`Allocations.sysml`) — Defines `Allocation` and `AllocationUsage` for allocation relationships.
- **States** (`States.sysml`) — Defines `StateAction` (the base of all state machine definitions), `StateTransition`, and state-related control constructs.
- **Constraints** (`Constraints.sysml`) — Defines `ConstraintCheck` as the base for all constraint definitions.
- **Requirements** (`Requirements.sysml`) — Defines `RequirementCheck` (the root of all requirement definitions), with `subject`, `actor`, `stakeholder`, `requirementId`, and satisfaction relationships.
- **Calculations** (`Calculations.sysml`) — Defines `Calculation` as the base for calculation definitions.
- **Cases** (`Cases.sysml`) — Defines `Case` as the base for analysis, verification, and use-case definitions, with `subject` and objective parameters.
- **AnalysisCases** (`AnalysisCases.sysml`) — Defines `AnalysisCase` and `AnalysisCaseUsage` specializing `Case`.
- **VerificationCases** (`VerificationCases.sysml`) — Defines `VerificationCase` for formal verification.
- **UseCases** (`UseCases.sysml`) — Defines `UseCase` for actor-based use-case modeling.
- **Views** (`Views.sysml`) — Defines `ViewDefinition`, `ViewUsage`, `ViewpointDefinition`, and `RenderingDefinition`.
- **StandardViewDefinitions** (`StandardViewDefinitions.sysml`) — Defines standard viewpoints for SysML v2 diagrams.
- **Metadata** (`Metadata.sysml`) — Defines `MetadataUsage` base types for annotating model elements.

# Key Types

| Type | Kind | Description |
|---|---|---|
| `Part` | abstract part def | Root base type for all PartDefinitions. |
| `Item` | abstract item def | Base type for flowing items and structural elements. |
| `Action` | abstract action def | Root for all ActionDefinitions. |
| `AttributeValue` | abstract attribute def | Root for all AttributeDefinitions. |
| `Port` | abstract port def | Base type for port definitions. |
| `Connection` | abstract connection def | Base type for connection definitions. |
| `FlowConnection` | connection def | Typed item flows between ports. |
| `Interface` | abstract interface def | Base type for interface definitions. |
| `Allocation` | abstract allocation def | Root for allocation relationships. |
| `StateAction` | abstract action def | Root for state machine definitions. |
| `ConstraintCheck` | abstract constraint def | Root for constraint definitions. |
| `RequirementCheck` | abstract requirement def | Root for all requirement definitions. |
| `Calculation` | abstract calc def | Root for calculation definitions. |
| `Case` | abstract case def | Root for analysis, verification, use-case definitions. |
| `AnalysisCase` | analysis case def | Specialization of Case for analysis. |
| `VerificationCase` | verification case def | Specialization of Case for verification. |
| `UseCase` | use case def | Actor-based use-case modeling. |
| `ViewDefinition` | view def | Defines a SysML view. |

# Usage

All user-defined SysML v2 models implicitly specialize types from the Systems Library. For explicit specialization:

```sysml
part def Engine :> Parts::Part { ... }
action def StartEngine :> Actions::Action { ... }
requirement def SpeedRequirement :> Requirements::RequirementCheck { ... }
```

The reflective `SysML.sysml` model is used in metadata-based language extensions:

```sysml
private import SysML::*;
metadata def MyAnnotation :> SysML::Systems::PartUsage { ... }
```

# Source

`c:\workspace\KnowledgeExtractor\Input\Sysml_2\SysML-v2-Pilot-Implementation\sysml.library\Systems Library\`

Key files: `SysML.sysml`, `Parts.sysml`, `Actions.sysml`, `Items.sysml`, `Attributes.sysml`, `Ports.sysml`, `Connections.sysml`, `Flows.sysml`, `Interfaces.sysml`, `States.sysml`, `Constraints.sysml`, `Requirements.sysml`, `Calculations.sysml`, `Cases.sysml`, `AnalysisCases.sysml`, `VerificationCases.sysml`, `UseCases.sysml`, `Allocations.sysml`, `Views.sysml`, `StandardViewDefinitions.sysml`, `Metadata.sysml`

# Related Libraries

- [Kernel Semantic Library](./kernel-semantic-library.md)
- [Kernel Function Library](./kernel-function-library.md)
- [Kernel Data Type Library](./kernel-data-type-library.md)
- [Quantities and Units Library](./quantities-units-library.md)
- [Analysis Domain Library](./analysis-domain-library.md)

# Citations

[1] OMG SysML v2 Specification, §9
