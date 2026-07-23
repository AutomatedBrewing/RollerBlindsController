---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Processes
description: Full SysML v2 and arc42 mapping for SYSMOD product System Processes (SM-PRD-13).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Processes (SM-PRD-13)

System Processes describe higher-level uses of the system showing the logical ordering of System Use Cases. A System Process is a special use case with flow- or event-oriented behavior covering lifecycle, mission, or operational scenarios. It provides the sequential and branching structure that relates individual use cases to coherent, end-to-end system operations.

## §1 SysMod Definition

**Product ID:** SM-PRD-13
**SYSMOD §:** 5.13
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.13 Identify System Processes](../../sysmod/methods/identify-system-processes.md) (SM-MTH-13)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose
System Processes aggregate and sequence System Use Cases into coherent end-to-end behavioral descriptions of system usage. They answer: "In which order do actors trigger which use cases, and under what conditions?" This enables systems engineers to verify completeness of the use case set and to identify missing transitions or gaps in operational coverage.

### Role in Process
In the Analysis process (SM-PRC-1), System Processes are produced after System Use Cases (SM-PRD-12) are identified. They establish the operational context for Use Case Activities (SM-PRD-14) by showing the sequence in which activities are expected to occur during real system deployment.

### Inputs

| # | Artifact | ID | Description |
|---|----------|----|-------------|
| 1 | System Use Cases | SM-PRD-12 | The set of atomic use cases to be ordered into processes |
| 2 | System Context | SM-PRD-11 | System boundary and external actor interactions |
| 3 | System Objectives | SM-PRD-06 | High-level goals that guide process composition |

### Outputs / Dependent Artifacts

| # | Artifact | ID | How Used |
|---|----------|----|----------|
| 1 | Use Case Activities | SM-PRD-14 | Each use case in a process receives a detailed activity model |
| 2 | Scenarios | SM-PRD-22 | Process instances used to trace specific scenario executions |
| 3 | Functional Architecture | SM-PRD-18 | Functional elements derived from process decomposition |

### Dependencies
- **Must have:** SM-PRD-12 (System Use Cases) — processes can only be defined once the atomic use cases are identified.
- **Should have:** SM-PRD-11 (System Context) — actor interactions inform process triggers and terminators.
- **Informs:** SM-PRD-14 (Use Case Activities) — processes define the ordering context for activity modeling.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Concept | SysML v2 Element | Node ID | Rationale |
|----------------|-----------------|---------|-----------|
| System Process | `action def` with `@ProcessMeta` | [SML-DEF-ActDef](../../sysml2/concepts/action-definition.md) | Processes are behavioral; `action def` models control/data flow |
| Use Case invocation within a Process | `perform <usecase>` | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | `perform` is the SysML v2 keyword for invoking a referenced action/use case as a step; it reuses the referenced definition without nesting it |
| Use Case embedded as sub-action | Nested `action` usage typed by `use case def` | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Alternative: inline the UC as a named action step when its parameters must be explicitly bound |
| Process ordering | `succession` constraint | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Captures mandatory sequencing between process steps; multiple outgoing `succession` edges model branching |
| Conditional branching | `decision` node + `succession [<guard>]` | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Decision node routes flow based on guard conditions |
| Process stereotype | `metadata def ProcessMeta` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Encodes process type (lifecycle/mission/operational) as metadata |
| Process flow visualization | Action Flow Diagram | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Shows the ordered use case sequence graphically |
| Process grouping | `package` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all process definitions for the system |

#### `perform` vs nested `action` — decision rule

| Situation | Use | Reason |
|-----------|-----|--------|
| Invoking an already-defined `use case def` or `action def` by reference, with no parameter binding needed | `perform <name> : <DefName>` | Lightweight — no inline sub-action body needed |
| Invoking an action and binding specific input/output parameters | Nested `action <name> : <DefName> { … }` | Enables `flow` and `binding` to connect parameters explicitly |
| Ordering use cases without repeating their internals | `perform` + `succession` | Standard SYSMOD process modeling pattern |

### Modeling Pattern

```sysml
package CoffeeMachine_Processes {

  import CoffeeMachine_UseCases::*;   // UC defs must be imported

  metadata def ProcessMeta {
    attribute processType : String; // lifecycle | mission | operational
  }

  // ── Lifecycle process: full power-on to power-off sequence ───────────────
  action def CoffeeMachineLifecycle {
    doc /* Full system lifecycle from cold start to shutdown */
    @ProcessMeta { processType = "lifecycle"; }

    // 'perform' references existing use case defs without embedding them
    perform action startup  : BrewSystemStartup;
    perform action standby  : EnterStandby;
    perform action brew     : BrewEspresso;
    perform action clean    : RunCleaningCycle;
    perform action shutdown : SystemShutdown;

    succession startup  then standby;
    succession standby  then brew;
    succession brew     then standby;        // loop back after each brew
    succession standby  then clean;
    succession clean    then standby;
    succession standby  then shutdown;
  }

  // ── Operational process: single-shot espresso mission ────────────────────
  action def SingleEspressoMission {
    doc /* Operational mission: one espresso from user request to delivery */
    @ProcessMeta { processType = "mission"; }

    // Nested action usage — parameters explicitly bound via flow
    action grindAndBrew : BrewEspresso {
      in  item waterIn  : WaterFlow  = waterSource.out;
      out item result   : EspressoShot;
    }
    action notify : NotifyUserReady;

    succession grindAndBrew then notify;
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
  processes/
    <System>_Processes.sysml           ← All process action defs + ProcessMeta
    <System>_ProcessDiagrams.sysml     ← Action flow diagram views per process
```

---

## §3 arc42 Mapping

| arc42 Section | Node ID | Usage | Mandatory? |
|---------------|---------|-------|-----------|
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | System processes as high-level operational runtime scenarios; each `action def` maps to one runtime scenario entry | **MANDATORY** |
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | Process names listed as "key operational scenarios" in the requirements overview | Optional |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Process ordering constraints can inform architectural decisions (e.g., sequential startup phase) | Optional |

**Placement guidance:** Each System Process (`action def`) becomes one subsection in ARC-06 Runtime View. The process type (lifecycle / mission / operational) indicates the scenario category. The `succession` ordering maps directly to the sequence or activity diagrams included in arc42.

---

## §4 Traceability

### Incoming Links

| From Node | ID | Relationship | Description |
|-----------|----|--------------|-------------|
| System Use Cases | SM-PRD-12 | `depends_on` | Processes are composed of ordered, typed use case steps |
| System Context | SM-PRD-11 | `depends_on` | Context defines actors and boundaries that trigger processes |
| System Objectives | SM-PRD-06 | `refines` | Processes operationalize objectives into behavioral sequences |

### Outgoing Links

| To Node | ID | Relationship | Description |
|---------|----|--------------|-------------|
| Use Case Activities | SM-PRD-14 | `implements` | Activities detail each use case step identified within processes |
| Scenarios | SM-PRD-22 | `refines` | Concrete scenario instances trace back to process definitions |
| Functional Architecture | SM-PRD-18 | `documents` | Functional elements derived from process activity decomposition |
| ARC-06 Runtime View | ARC-06 | `documents` | Each process becomes a runtime scenario in arc42 |

### Traceability Rules

1. Every System Process MUST reference at least two System Use Cases (SM-PRD-12) via `succession`.
2. Every System Use Case appearing in a process MUST have a corresponding Use Case Activity (SM-PRD-14).
3. Each `action def` process MUST carry a `@ProcessMeta` annotation with `processType` populated.
4. arc42 ARC-06 MUST contain one entry per process; the SysML package path MUST be cited.
5. Every System Use Case from SM-PRD-12 MUST appear in at least one process (no orphan use cases).

---

## §5 Modeling Procedure

1. **Collect System Use Cases** — retrieve all UC definitions from SM-PRD-12; list each with its trigger condition, primary actor, and post-condition.
2. **Identify process types** — classify each process as `lifecycle` (install/operate/decommission cycle), `mission` (operational goal from start to end), or `operational` (routine recurring scenario).
3. **Define process `action def` entries** — create one `action def` per identified process; annotate each with `@ProcessMeta { processType = "..." }`.
4. **Add use case steps using `perform`** — for each use case step, write `perform action <name> : <UCDef>`. Use a nested `action` usage only when you need to explicitly bind parameters (e.g., `in item x = source.out`). Import the use case package at the top of the process package.
5. **Add `succession` ordering** — connect action steps using `succession` to express mandatory ordering; use multiple outgoing `succession` edges for conditional branching paths; use `decision` nodes for explicit branching guards.
6. **Validate completeness** — cross-check that all System Use Cases from SM-PRD-12 appear in at least one process; flag and resolve orphan use cases.
7. **Generate Action Flow Diagrams** — create one SML-DGM-ActFlow view per process for stakeholder review.
8. **Register in arc42 ARC-06** — add one subsection per process to the Runtime View; include the process diagram and a brief textual description of the operational scenario.

---

*See also:* [OKF Ontology](../okf-ontology.md) · [System Use Cases cross-mapping](system-use-cases.md) (SM-PRD-12) · [Use Case Activities cross-mapping](use-case-activities.md) (SM-PRD-14)
