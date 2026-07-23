---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Use Case Activities
description: Full SysML v2 and arc42 mapping for SYSMOD product Use Case Activities (SM-PRD-14).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Use Case Activities (SM-PRD-14)

Use Case Activities specify the detailed functional decomposition of a System Use Case — the individual functions, their execution order, and the object flows between functions. The activity hierarchy (primary and secondary UCAs) forms a tree that is directly transformed into the Functional Architecture using the FAS method. This artifact bridges the gap between operational requirements (what the system must do) and architecture (how the system is structured).

## §1 SysMod Definition

**Product ID:** SM-PRD-14
**SYSMOD §:** 5.14
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.14 Model Use Case Activities](../../sysmod/methods/model-use-case-activities.md) (SM-MTH-14)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose
Use Case Activities decompose each System Use Case into a set of fine-grained, system-performed functions that together realize the use case behavior. They define: (1) what sub-functions exist, (2) in what order they execute, and (3) what data objects flow between them. The resulting activity models serve as the primary input for both the Functional Architecture (SM-PRD-18) via FAS and the Logical Architecture (SM-PRD-20) via allocation.

### Role in Process
Within the Analysis process (SM-PRC-1), Use Case Activities are created after System Use Cases (SM-PRD-12) and System Processes (SM-PRD-13) are established, and refined iteratively alongside Domain Knowledge (SM-PRD-15). They represent the most detailed functional specification of system behavior before architecture design begins.

### Inputs

| # | Artifact | ID | Description |
|---|----------|----|-------------|
| 1 | System Use Cases | SM-PRD-12 | Parent use case whose behavior this activity decomposes |
| 2 | System Processes | SM-PRD-13 | Ordering context showing which use cases are adjacent |
| 3 | Requirements | SM-PRD-10 | Functional requirements the activity must satisfy |
| 4 | Domain Knowledge | SM-PRD-15 | Data types for object flows (circular — enriches UCAs iteratively) |

### Outputs / Dependent Artifacts

| # | Artifact | ID | How Used |
|---|----------|----|----------|
| 1 | Domain Knowledge | SM-PRD-15 | New domain objects discovered during UCA modeling are added back |
| 2 | Functional Architecture | SM-PRD-18 | FAS transformation maps UCA sub-functions to functional elements |
| 3 | Logical Architecture | SM-PRD-20 | Logical components are allocated to UCA-derived functions |
| 4 | Scenarios | SM-PRD-22 | Scenario instances trace specific execution paths through UCAs |

### Dependencies
- **Requires:** SM-PRD-12 (parent use case must be defined before decomposition).
- **Requires:** SM-PRD-10 (requirements provide acceptance criteria for the activity).
- **Benefits from:** SM-PRD-13 (process ordering provides input/output context for the UCA).
- **Circular with:** SM-PRD-15 (domain objects needed for flows are refined iteratively).

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Concept | SysML v2 Element | Node ID | Rationale |
|----------------|-----------------|---------|-----------|
| Use Case Activity (primary) | `action def` | [SML-DEF-ActDef](../../sysml2/concepts/action-definition.md) | Activities are behavioral; `action def` models hierarchical behavior |
| Sub-function (action step) | Nested `action` usage | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Each function is a typed action usage within the parent activity |
| Object flow between functions | `flow` / item flow | [SML-USG-ItemFlow](../../sysml2/concepts/item-flow.md) | Typed data transfer between action step boundaries |
| Input data object | `in item` parameter | [SML-USG-ItemUSG](../../sysml2/concepts/item-usage.md) | Typed input to the overall activity |
| Output data object | `out item` parameter | [SML-USG-ItemUSG](../../sysml2/concepts/item-usage.md) | Typed output produced by the overall activity |
| Decision / conditional path | `if` / decision node | — | Conditional execution branches within the activity |
| Activity flow diagram | Action Flow Diagram | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Visualizes sub-functions and item flows; primary UCA diagram |
| UCA package | `package` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all UCA definitions per system |

### Modeling Pattern

```sysml
package VehicleSystem_UseCaseActivities {

  item def BrakePedalInput    { attribute travel : Real; attribute force : Real; }
  item def BrakingCommand     { attribute targetDeceleration : Real; }
  item def WheelSpeedData     { attribute speed : Real[4]; }
  item def BrakeApplicationResult {
    attribute achieved   : Boolean;
    attribute latency_ms : Real;
  }

  action def UCA_EmergencyBraking {
    doc /* Detailed activity for UC_03_EmergencyBraking */
    in  item pedalInput  : BrakePedalInput;
    out item brakeResult : BrakeApplicationResult;

    action detectPedalInput {
      in  item input    : BrakePedalInput;
      out item detected : Boolean;
    }
    action calculateBrakingForce {
      in  item speed : WheelSpeedData;
      out item cmd   : BrakingCommand;
    }
    action applyBrakes {
      in  item cmd    : BrakingCommand;
      out item result : BrakeApplicationResult;
    }

    flow detectPedalInput.detected to calculateBrakingForce;
    flow calculateBrakingForce.cmd to applyBrakes.cmd;
    flow applyBrakes.result        to brakeResult;
  }

  action def UCA_NormalDriving {
    doc /* Detailed activity for UC_02_NormalDriving */
    in  item speedData : WheelSpeedData;
    out item driveStatus : Boolean;

    action monitorSpeed  { in item s : WheelSpeedData; out item ok : Boolean; }
    action regulateSpeed { in item ok : Boolean; out item status : Boolean; }

    flow monitorSpeed.ok to regulateSpeed.ok;
    flow regulateSpeed.status to driveStatus;
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
  use_case_activities/
    <System>_UCActivities.sysml          ← All UCA action defs + item defs
    <System>_UCActivity_Diagrams.sysml   ← Action flow diagram views per UCA
```

---

## §3 arc42 Mapping

| arc42 Section | Node ID | Usage | Mandatory? |
|---------------|---------|-------|-----------|
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | Each Use Case Activity becomes a detailed runtime scenario; sub-functions map to interaction steps | **MANDATORY** |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | The UCA activity hierarchy informs Level 1 building blocks; primary UCA sub-functions map to candidate blocks | Optional |
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | Functional requirements satisfied by activities cited in the requirements overview | Optional |

**Placement guidance:** In ARC-06, each primary UCA maps to one detailed runtime scenario. The action flow (sub-functions and item flows) is rendered as a sequence diagram or activity diagram. Secondary UCAs become nested subscenarios or are referenced from the primary scenario's description.

---

## §4 Traceability

### Incoming Links

| From Node | ID | Relationship | Description |
|-----------|----|--------------|-------------|
| System Use Cases | SM-PRD-12 | `depends_on` | Each UCA decomposes exactly one System Use Case |
| System Processes | SM-PRD-13 | `depends_on` | Processes provide the ordering context for this UCA |
| Requirements | SM-PRD-10 | `refines` | Functional requirements are realized by UCA sub-functions |
| Domain Knowledge | SM-PRD-15 | `depends_on` | Item types used in flows originate from the domain model |

### Outgoing Links

| To Node | ID | Relationship | Description |
|---------|----|--------------|-------------|
| Domain Knowledge | SM-PRD-15 | `implements` | New data objects discovered in UCAs feed back to the domain model |
| Functional Architecture | SM-PRD-18 | `implements` | FAS maps UCA sub-functions to functional elements |
| Logical Architecture | SM-PRD-20 | `implements` | Logical components are allocated to UCA-derived functions |
| Scenarios | SM-PRD-22 | `refines` | Scenario instances trace specific execution paths through UCAs |
| ARC-06 Runtime View | ARC-06 | `documents` | Each UCA becomes a detailed runtime scenario in arc42 |

### Traceability Rules

1. Every System Use Case (SM-PRD-12) MUST have at least one corresponding `action def` in this package.
2. Every `action def` MUST have typed `in item` / `out item` parameters referencing SM-PRD-15 definitions.
3. Every sub-function `action` usage MUST have at least one `flow` connecting it to a neighboring action.
4. Every functional Requirement (SM-PRD-10) MUST be traceable to at least one UCA sub-function via `satisfy`.
5. arc42 ARC-06 MUST cite the SysML package path for each UCA entry.

---

## §5 Modeling Procedure

1. **Select the target use case** — retrieve the UC definition from SM-PRD-12; note its primary actor, trigger event, main success path, and post-condition.
2. **Identify sub-functions** — apply the SYSMOD activity identification heuristic: one function per major data transformation or state change; target 3–7 sub-functions per primary UCA.
3. **Define item types** — for each sub-function boundary, identify the data object flowing through; add missing types to SM-PRD-15 Domain Knowledge immediately.
4. **Create the primary `action def`** — write the `action def` with typed `in item` / `out item` parameters; add nested `action` usages for each sub-function.
5. **Add `flow` statements** — connect sub-function outputs to inputs using `flow`; use typed item flows where domain objects are fully specified in SM-PRD-15.
6. **Model branching and merging** — add `if`/decision nodes for conditional paths (e.g., error handling, alternative scenarios); ensure all paths converge to a defined `out item`.
7. **Create secondary UCAs** — for any sub-function complex enough to warrant further decomposition, define a secondary `action def` and reference it as the sub-function type.
8. **Generate Action Flow Diagram (SML-DGM-ActFlow)** — create one diagram view per primary UCA for stakeholder review; include the diagram in arc42 ARC-06 as the runtime scenario illustration.

---

*See also:* [OKF Ontology](../okf-ontology.md) · [System Processes cross-mapping](system-processes.md) (SM-PRD-13) · [Domain Knowledge cross-mapping](domain-knowledge.md) (SM-PRD-15) · [Functional Architecture cross-mapping](functional-architecture.md) (SM-PRD-18)
