---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Functional Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product Functional Architecture (SM-PRD-18).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Functional Architecture (SM-PRD-18)

The Functional Architecture provides a technology-independent functional description of the system using functional elements (FEs) that transform typed input flows into typed output flows. It is derived from Use Case Activities (SM-PRD-14) using the FAS (Functional Architectures for Systems) method. Although not a mandatory SYSMOD core product, the Functional Architecture is a highly valuable intermediate artifact that bridges analysis and the Logical / Physical architecture design phases.

## §1 SysMod Definition

**Product ID:** SM-PRD-18
**SYSMOD §:** 5.18
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)
**Creating Method:** [4.17 Model the Functional Architecture](../../sysmod/methods/model-functional-architecture.md) (SM-MTH-17)
**Responsible Role:** [System Architect](../../sysmod/roles/system-architect.md)

### Purpose
The Functional Architecture describes the system as a network of technology-independent functional elements, each with typed input and output ports through which domain objects flow. It serves two primary engineering purposes: (1) it provides a clean functional interface contract independent of technology choices, enabling parallel hardware and software design streams; (2) it is the primary source for functional allocation to logical and product components (SM-PRD-20, SM-PRD-21).

### Role in Process
In the Architecture process (SM-PRC-2), the Functional Architecture is produced after the Analysis products (SM-PRD-14, SM-PRD-15) are complete. The FAS method systematically transforms Use Case Activity sub-functions into Functional Elements. The resulting Functional Architecture then drives the Logical Architecture (SM-PRD-20) through formal allocation relationships.

### Inputs

| # | Artifact | ID | Description |
|---|----------|----|-------------|
| 1 | Use Case Activities | SM-PRD-14 | Sub-functions become functional elements; object flows become typed port interfaces |
| 2 | Domain Knowledge | SM-PRD-15 | Flow definitions and item types used to type functional ports and connections |
| 3 | System Architecture (abstract) | SM-PRD-17 | Taxonomic supertype context; FunctionalArchitecture specializes it |
| 4 | Requirements | SM-PRD-10 | Non-functional requirements constrain functional interface and element design |

### Outputs / Dependent Artifacts

| # | Artifact | ID | How Used |
|---|----------|----|----------|
| 1 | Logical Architecture | SM-PRD-20 | Functional elements are allocated to logical components via `allocation` |
| 2 | Scenarios | SM-PRD-22 | Functional interaction sequences provide runtime scenario content |
| 3 | arc42 Solution Strategy | ARC-04 | Functional decomposition rationale described as the core architectural strategy |
| 4 | arc42 Building Block View | ARC-05 | Functional elements become Level 1 building blocks |

### Dependencies
- **Requires:** SM-PRD-14 (Use Case Activities) — FEs are derived from UCA sub-functions via FAS.
- **Requires:** SM-PRD-15 (Domain Knowledge) — port types derive from domain flow definitions.
- **Benefits from:** SM-PRD-10 (Requirements) — non-functional constraints qualify functional interface design.
- **Related tool:** [FAS — Functional Architectures for Systems](../../sysmod/tools/functional-architectures-for-systems.md)

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Concept | SysML v2 Element | Node ID | Rationale |
|----------------|-----------------|---------|-----------|
| Functional Element (FE) | `part def` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Each FE is a structural element with typed interface ports |
| FE input / output port | `port def` | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Typed interaction point; typed by a `flow def` or `item def` from SM-PRD-15 |
| Functional connection | `connection def` | [SML-DEF-ConnDef](../../sysml2/concepts/connection-definition.md) | Connects output port of one FE to input port of another FE |
| Typed flow channel | `flow def` | [SML-DEF-FlowDef](../../sysml2/concepts/flow.md) | Specifies the data type carried by a functional connection |
| FE behavior | `action def` | [SML-DEF-ActDef](../../sysml2/concepts/action-definition.md) | The internal behavior performed by a functional element |
| Composite FA | `part def FunctionalArchitecture :> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Top-level assembly containing all FE `part` usages and connections |
| FA structure diagram | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Shows FE composition and typed port connections |
| FA behavior diagram | Action Flow Diagram | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Shows data flow between FEs as an action activity |
| FA package | `package` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all FA definitions per system |

### Modeling Pattern

```sysml
package VehicleSystem_FunctionalArchitecture {

  // ── Import domain knowledge ───────────────────────────────────────────────
  import VehicleSystem_DomainKnowledge::*;
  import SystemArchitecture_Taxonomy::*;

  // ── Port definitions (typed by flow defs from Domain Knowledge) ──────────
  port def SpeedSensorPort     { in  item data : WheelSpeedData; }
  port def SpeedDataPort       { out item data : WheelSpeedData; }
  port def BrakingCommandPort  { in  item cmd  : BrakingCommand; }
  port def SafetyCommandPort   { out item cmd  : BrakingCommand; }
  port def ActuatorCommandPort { out item cmd  : BrakingCommand; }

  // ── Functional Elements ───────────────────────────────────────────────────
  part def FE_SensorProcessing {
    doc /* Collects raw sensor data and filters/normalizes it for downstream use */
    in  port sensorIn     : ~SpeedSensorPort;
    out port processedOut : SpeedDataPort;
  }

  part def FE_SafetyMonitoring {
    doc /* Monitors system health; enforces safety limits; overrides commands if needed */
    in  port dataIn    : ~SpeedDataPort;
    out port safetyCmd : SafetyCommandPort;
  }

  part def FE_BrakeControl {
    doc /* Translates braking decisions into actuator commands */
    in  port cmdIn       : ~BrakingCommandPort;
    out port actuatorOut : ActuatorCommandPort;
  }

  // ── Composite Functional Architecture ────────────────────────────────────
  part def FunctionalArchitecture :> SystemArchitecture {
    doc /* Top-level functional assembly of the Vehicle Control System (SM-PRD-18) */

    part sensorProc : FE_SensorProcessing;
    part safetyMon  : FE_SafetyMonitoring;
    part brakeCtrl  : FE_BrakeControl;

    connection c1 : SpeedDataFlow  connect sensorProc.processedOut to safetyMon.dataIn;
    connection c2 : BrakingFlow    connect safetyMon.safetyCmd     to brakeCtrl.cmdIn;
  }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  functional/
    <System>_FunctionalArchitecture.sysml    ← part defs (FEs), port defs, connections
    <System>_FA_Diagrams.sysml               ← definition + action flow diagram views
```

---

## §3 arc42 Mapping

| arc42 Section | Node ID | Usage | Mandatory? |
|---------------|---------|-------|-----------|
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Functional decomposition rationale: why these FEs were chosen, FAS method application, technology-independence principle | **MANDATORY** |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | Level 1 building blocks correspond to Functional Elements; ports and connections describe Level 1 interfaces | Optional |
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | Functional FE interactions in specific scenarios (from SM-PRD-22) rendered as FE-level sequence diagrams | Optional |
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | Functional interface patterns (port stereotypes, flow typing conventions) documented as cross-cutting design rules | Optional |

**Placement guidance:** In ARC-04, document the FAS method application: list the UCAs used as input, describe how sub-functions were clustered into FEs, and state the rationale for the number and grouping of FEs chosen. In ARC-05, each `part def` FE becomes one Level 1 block diagram entry with its typed ports shown.

---

## §4 Traceability

### Incoming Links

| From Node | ID | Relationship | Description |
|-----------|----|--------------|-------------|
| Use Case Activities | SM-PRD-14 | `depends_on` | FEs are derived from UCA sub-functions via FAS transformation |
| Domain Knowledge | SM-PRD-15 | `depends_on` | Port types and flow definitions typed by domain entities |
| System Processes | SM-PRD-13 | `depends_on` | Process ordering informs FE collaboration sequences |
| System Architecture (abstract) | SM-PRD-17 | `depends_on` | FunctionalArchitecture specializes the abstract supertype |

### Outgoing Links

| To Node | ID | Relationship | Description |
|---------|----|--------------|-------------|
| Logical Architecture | SM-PRD-20 | `implements` | Functional elements are allocated to logical components |
| Scenarios | SM-PRD-22 | `implements` | FE interactions become runtime scenario content |
| ARC-04 Solution Strategy | ARC-04 | `documents` | Functional decomposition rationale documented as core strategy |
| ARC-05 Building Block View | ARC-05 | `documents` | FEs become Level 1 building blocks with typed interfaces |

### Traceability Rules

1. Every `part def` Functional Element MUST trace to at least one UCA sub-function in SM-PRD-14.
2. Every `port def` MUST be typed by a `flow def` or `item def` from SM-PRD-15 (Domain Knowledge).
3. Every `connection` in the composite FA MUST be typed by a `flow def` or `connection def`.
4. The `FunctionalArchitecture part def` MUST carry `:> SystemArchitecture` from SM-PRD-17.
5. arc42 ARC-04 MUST identify the input UCAs and the clustering rationale for each FE.
6. Every FE MUST be allocated to at least one logical component in SM-PRD-20 via `allocation`.

---

## §5 Modeling Procedure

1. **Prepare the FAS input matrix** — list all UCA sub-functions from SM-PRD-14 in a table with columns: sub-function name, input item types, output item types, parent UCA source reference.
2. **Cluster sub-functions into Functional Elements** — apply FAS clustering rules: group sub-functions that share the same principal data type, implement the same physical transformation principle, or will naturally co-locate in the physical realization.
3. **Define `part def` FEs** — create one `part def` per functional element cluster; add a `doc` string describing the FE's single responsibility and its primary input-to-output transformation.
4. **Define port types** — for each FE boundary (interface), create a `port def` typed by the appropriate `flow def` from SM-PRD-15; use conjugate ports (`~PortDef`) for consuming ends to enforce directional consistency.
5. **Add `flow def` connection types** — ensure every inter-FE `connection` is typed by a `flow def`; derive flow types from SM-PRD-15 `item def` and `flow def` definitions.
6. **Assemble the composite `FunctionalArchitecture`** — create the top-level `part def` with `:> SystemArchitecture`; add `part` usages for each FE; add typed `connection` elements linking output ports to input ports.
7. **Generate diagrams** — create SML-DGM-DefDiag (structure showing parts and ports) and SML-DGM-ActFlow (data flow across FEs); review with stakeholders for completeness and correctness.
8. **Document in arc42** — write ARC-04 Solution Strategy citing the FAS method, the UCA sources, and the rationale for each FE cluster; create Level 1 building block descriptions in ARC-05 with typed interface descriptions.

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Functional Architectures for Systems (FAS)](../../sysmod/tools/functional-architectures-for-systems.md) | Tool 11.2 | **Primary method** — use FAS clustering heuristics (step 2) to group UCA sub-functions into functional elements; provides a systematic, repeatable derivation technique |
| [Zigzag Pattern](../../sysmod/tools/zigzag-pattern.md) | Tool 11.6 | **Steps 1–3** — when clustering functional elements, recognize that technical grouping choices embed implicit architectural decisions; make these explicit as Base Architecture constraints (SM-PRD-07) or requirements (SM-PRD-10) |
| [Coupling of System Architectures](../../sysmod/tools/coupling-system-architectures.md) | Tool 11.7 | **After step 7** — decide before moving to SM-PRD-20 whether functional-to-logical coupling will be via `allocation def` (loose) or `part def :>` specialization (strong) |

---

*See also:* [OKF Ontology](../okf-ontology.md) · [System Architecture cross-mapping](system-architecture.md) (SM-PRD-17) · [Use Case Activities cross-mapping](use-case-activities.md) (SM-PRD-14) · [FAS tool](../../sysmod/tools/functional-architectures-for-systems.md)
