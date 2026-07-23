---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Scenarios
description: Full SysML v2 and arc42 mapping for SYSMOD product Scenarios (SM-PRD-22).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Scenarios (SM-PRD-22)

A Scenario in SYSMOD describes how concrete instances of architecture parts collaborate to perform one specific execution path through a Use Case Activity (SM-PRD-14). The modeler performs a "virtual tour" through the system — instantiating named parts and tracing the sequence of messages and actions step by step — to verify that all required structural elements, ports, and connections exist. Scenarios are the primary mechanism for detecting architectural gaps and driving architecture revision in both the Logical (SM-PRD-20) and Product (SM-PRD-21) Architectures.

## §1 SysMod Definition

**Product ID:** SM-PRD-22  
**SYSMOD §:** 5.22  
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)  
**Creating Method:** [4.20 Revise an Architecture with Scenarios](../../sysmod/methods/revise-architecture-scenarios.md) (SM-MTH-20)  
**Responsible Role:** [System Architect](../../sysmod/roles/system-architect.md)

### Purpose

Scenarios serve two complementary purposes: (1) **Verification** — they verify that the current architecture is sufficient to execute the required use case activities by tracing every interaction step through named part instances; and (2) **Revision driver** — when a step in the scenario cannot be realised with the current architecture (missing part, port, or connection), the architecture must be revised. This makes scenarios the primary feedback loop in iterative architecture development. Every scenario corresponds to one specific path through one Use Case Activity.

### Role in Process

In the Architecture process (SM-PRC-2), Method 4.20 is applied iteratively during Logical Architecture development (SM-PRD-20) and again after the Product Architecture (SM-PRD-21) is drafted. The System Architect: (1) selects a Use Case Activity path from SM-PRD-14, (2) creates named part instances of architecture components, (3) traces the execution step by step, annotating each step with the responsible component, (4) identifies gaps (missing connections, ports, or components), and (5) revises the architecture accordingly. Scenarios are declared done when the trace completes without gaps. Completed scenarios feed directly into arc42 Runtime View (ARC-06).

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Logical Architecture | SM-PRD-20 | Provides the `part def` types that are instantiated as scenario participants |
| 2 | Use Case Activities | SM-PRD-14 | Each activity provides the execution paths; one scenario covers one specific path |
| 3 | System Use Cases | SM-PRD-12 | Use cases provide the scope and pre/post conditions for each scenario |
| 4 | Product Architecture | SM-PRD-21 | Optional — for late-stage scenarios using concrete product component instances |
| 5 | System States | SM-PRD-23 | State guards and state transitions serve as pre- and postconditions in scenarios |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Logical Architecture | SM-PRD-20 | Architecture revisions are triggered when scenario traces reveal gaps |
| 2 | Product Architecture | SM-PRD-21 | Product-level revisions triggered by concrete scenario traces |
| 3 | Test Architecture | SM-PRD-24 | Scenarios inform the test context structure; key scenarios become test case templates |
| 4 | Test Cases | SM-PRD-16 | Each completed scenario is a candidate test case specification |

### Dependencies

- **SM-PRD-20 (Logical Architecture):** Scenarios at logical level use logical component instances. The Logical Architecture must have `part def` elements with typed ports before scenario tracing can begin.
- **SM-PRD-14 (Use Case Activities):** Each scenario covers exactly one path through one activity. The activity decomposition must be complete enough to identify individual execution paths.
- **SM-PRD-23 (System States):** States appear in scenarios as preconditions (guard conditions on transitions) and postconditions (resulting state after the scenario completes).

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Scenario participant (part instance) | `part` (part usage) | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Named instances of architecture `part def` types — the "lifelines" of the scenario |
| System under test context | `part sut : LogicalSystem { … }` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Top-level part usage containing all participant instances |
| Execution step | `action` (action usage) within `action def` | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Each step in the scenario is an action performed by a specific participant |
| Step ordering | `succession` | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Defines the sequential ordering of actions; equivalent to sequence diagram ordering |
| Message between participants | `send action` / `accept action` | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Models asynchronous or synchronous message passing between components |
| Item flowing between parts | `flow` (item flow) | [SML-USG-ItemFlow](../../sysml2/concepts/item-flow.md) | Models data or items flowing along connections between parts |
| State guard (pre/postcondition) | `occurrence` reference | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | References a state usage as the required condition for a scenario step |
| Sequence diagram view | Sequence Diagram | [SML-DGM-SeqDiag](../../sysml2/diagrams/sequence-diagram.md) | Visualizes the scenario as a UML-style sequence of lifeline interactions |
| Action flow view | Action Flow Diagram | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Alternative view showing the execution flow through participant actions |

### Modeling Pattern

```sysml
package VehicleSystem_Scenarios {

  // Scenario context: named instances of Logical Architecture parts (SM-PRD-20)
  part sut : LogicalVehicleControlSystem {
    part ecuInstance      : LogicalECU;
    part sensorInstance   : LogicalSensorInterface;
    part actuatorInstance : LogicalActuatorInterface;
  }

  // SCEN-01: Emergency Braking — Normal Path
  // Covers: Use Case UC-03 "Emergency Braking", Path: normal / no fault
  // Precondition: VehicleSystem in Operational state (SM-PRD-23)
  // Postcondition: VehicleSystem remains in Operational state; speed reduced
  action def SCEN_01_EmergencyBrakingNormalPath {
    doc /* Virtual tour: braking pedal pressed → sensor detects → ECU processes →
         actuator applies braking force. All connections must exist in SM-PRD-20. */

    action s1 : detectBrakePedal {
      doc /* sensorInstance detects brake pedal input signal */
      // Gap check: sensorInstance must have an input port for pedal signal
    }
    action s2 : sendSensorData {
      doc /* sensorInstance sends SensorDataEvent via sensorDataPort to ecuInstance */
      // Gap check: sensorInstance.dataOutPort → ecuInstance.sensorPort must be connected
    }
    action s3 : processSensorSignal {
      doc /* ecuInstance receives SensorDataEvent and validates signal quality */
    }
    action s4 : calculateBrakingForce {
      doc /* ecuInstance computes required braking force based on vehicle speed and pedal position */
    }
    action s5 : sendActuatorCommand {
      doc /* ecuInstance sends ActuatorCmdEvent via actuatorPort to actuatorInstance */
      // Gap check: ecuInstance.actuatorPort → actuatorInstance.cmdInPort must be connected
    }
    action s6 : applyBrakingForce {
      doc /* actuatorInstance applies calculated braking force to brake actuator hardware */
    }

    succession s1 then s2 then s3 then s4 then s5 then s6;
  }

  // SCEN-02: Emergency Braking — Sensor Fault Path
  // Covers: Use Case UC-03 "Emergency Braking", Path: sensor failure
  // Precondition: VehicleSystem in Operational state
  // Postcondition: VehicleSystem transitions to DegradedState (SM-PRD-23)
  action def SCEN_02_EmergencyBrakingSensorFault {
    action s1 : detectBrakePedal { /* sensorInstance detects pedal */ }
    action s2 : detectSensorFault {
      doc /* ecuInstance detects missing or invalid sensor data within timeout */
    }
    action s3 : triggerDegradedMode {
      doc /* ecuInstance raises FaultDetected[severity="minor"] event */
      // Gap check: state transition from Operational → Degraded must exist in SM-PRD-23
    }
    action s4 : applyFailSafeBraking {
      doc /* actuatorInstance applies conservative fail-safe braking profile */
    }

    succession s1 then s2 then s3 then s4;
  }

  // Item flow view: data flowing between participants in SCEN-01
  flow sensorData : SensorDataEvent
    from sensorInstance.dataOutPort
    to   ecuInstance.sensorPort;

  flow actuatorCmd : ActuatorCmdEvent
    from ecuInstance.actuatorPort
    to   actuatorInstance.cmdInPort;
}
```

### Recommended Package Structure

```
<System>_Architecture/
  scenarios/
    <System>_Scenarios.sysml             ← All scenario definitions for this system
    <System>_ScenarioInstances.sysml     ← Part usages (named instances) for each scenario
    <System>_ItemFlows.sysml             ← Reusable item flow definitions across scenarios
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | **Mandatory** | One arc42 runtime scenario per key use case path; sequence diagram or flow diagram showing collaboration of building blocks |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | Recommended | Scenarios that reveal missing building blocks trigger updates to ARC-05 |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | Recommended | Scenarios with timing constraints contribute to quality scenarios (e.g., response time ≤ 100 ms) |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Scenarios that drive architectural revision decisions are referenced in ADRs |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-20 | Logical Architecture | `depends_on` | Scenarios instantiate logical `part def` types as named participants |
| SM-PRD-14 | Use Case Activities | `depends_on` | Each scenario covers one specific execution path from one activity |
| SM-PRD-12 | System Use Cases | `depends_on` | Use cases provide the scope, preconditions, and postconditions for scenarios |
| SM-PRD-23 | System States | `depends_on` | State guards appear as preconditions; state transitions appear as scenario steps |
| SM-PRD-21 | Product Architecture | `depends_on` | Optional — concrete scenarios use product component instances |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-20 | Logical Architecture | `refines` | Scenario gaps trigger architecture revision — scenarios drive SM-PRD-20 updates |
| SM-PRD-21 | Product Architecture | `refines` | Product-level scenarios drive SM-PRD-21 revision |
| SM-PRD-16 | Test Cases | `implements` | Completed scenarios are templates for SM-PRD-16 test case specifications |
| SM-PRD-24 | Test Architecture | `implements` | Key scenarios define the interaction patterns the Test Architecture must support |
| ARC-06 | Runtime View | `documents` | Each completed scenario is documented as a Runtime View entry in arc42 |

### Traceability Rules

1. Every completed scenario MUST reference exactly one Use Case Activity path from SM-PRD-14 in its `doc` comment.
2. Every action in a scenario MUST identify the responsible participant (`part` usage) and the port/connection used.
3. Every gap discovered during scenario tracing (missing part, port, or connection) MUST result in a documented revision to SM-PRD-20 or SM-PRD-21 — architecture changes are not optional.
4. Every key Use Case Activity (SM-PRD-14) MUST have at least one completed scenario covering its primary (happy-path) execution path.
5. Every completed scenario MUST be documented as at least one entry in ARC-06 (Runtime View).
6. Each scenario MUST declare its precondition state (from SM-PRD-23) and postcondition state in the `doc` block.

---

## §5 Modeling Procedure

1. **Select a Use Case Activity path.** Choose one Use Case Activity from SM-PRD-14. Identify a specific execution path through that activity — for example, the primary success path or the most safety-critical alternative path. One scenario covers exactly one path.

2. **Instantiate participants.** Open the Logical Architecture (SM-PRD-20). For each logical component that participates in the selected path, create a named `part` usage: `part ecuInstance : LogicalECU`. Group all participants under a top-level `part sut : LogicalSystem { … }` context.

3. **Trace the execution step by step.** For each step in the Use Case Activity path, add an `action` usage to the scenario `action def`. Annotate each action with: (a) the responsible participant, (b) the port used, and (c) any state guard (pre/postcondition from SM-PRD-23). Label steps clearly (s1, s2, …) and connect them with `succession`.

4. **Identify architectural gaps.** For each step, verify that the required connection exists in the Logical Architecture. Specifically: (a) Does the sending participant have the required output port? (b) Does the receiving participant have the required input port? (c) Is there a `connect` statement between these ports in `LogicalVehicleControlSystem`? Record every gap found.

5. **Revise the architecture.** For each gap identified in step 4, revise SM-PRD-20 (Logical Architecture) by adding the missing port, connection, or component. If the gap reveals a missing component (a function has no structural home), revise the functional allocation as well. Document the revision in ARC-09 (Architecture Decisions).

6. **Add item flow definitions.** For each data or item that flows between participants, define a `flow` statement specifying the item type, source port, and target port. This makes the data model explicit and enables completeness checking against SM-PRD-14 data flows.

7. **Validate state transitions.** For scenarios that involve state changes (e.g., fault handling, mode transitions), verify that the required state transitions exist in SM-PRD-23 (System States). If a required transition is missing, revise SM-PRD-23 accordingly.

8. **Document in arc42 Runtime View.** For each completed scenario, create a Runtime View entry in ARC-06. Include: (a) a sequence diagram or flow diagram showing the participant interactions, (b) the scenario name and ID, (c) the use case activity it covers, and (d) any architectural decisions made during the scenario trace.

9. **Repeat for alternative paths.** After the primary path scenario is complete, trace at least one alternative path per key use case (error path, abort path, degraded path). The architecture must support all paths — not just the happy path.
