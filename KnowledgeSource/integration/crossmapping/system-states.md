---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System States
description: Full SysML v2 and arc42 mapping for SYSMOD product System States (SM-PRD-23).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System States (SM-PRD-23)

System States describe the conditions and operating modes of the system or its parts that control behavioral responses to events. Each state specifies the system's reaction — a transition, an action, or both — when a triggering event occurs while in that state. States function as pre- and postconditions of functions and use case activities, providing the behavioral contract between the Functional Architecture (SM-PRD-18) and the structural Architecture (SM-PRD-20). System States can model the entire system lifecycle (e.g., Off → Initializing → Operational → Shutdown) or fine-grained component states (e.g., sensor calibration states).

## §1 SysMod Definition

**Product ID:** SM-PRD-23  
**SYSMOD §:** 5.23  
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)  
**Creating Method:** [4.21 Define System States](../../sysmod/methods/define-system-states.md) (SM-MTH-21)  
**Responsible Role:** [System Architect](../../sysmod/roles/system-architect.md)

### Purpose

System States provide the behavioral specification layer that complements the structural architecture. Their purposes are: (1) **Behavioral constraint** — define the valid conditions under which functions may or may not execute (state guards); (2) **Event-driven response** — specify what the system does when an event occurs in a given state (transition + action); (3) **Safety modeling** — model fail-safe and degraded operating modes essential to safety analysis; and (4) **Testability** — provide observable, verifiable states that test cases (SM-PRD-16) can use as pass/fail criteria. Without a state model, use case activities lack the guard conditions needed to specify when and whether they execute.

### Role in Process

In the Architecture process (SM-PRC-2), Method 4.21 (Define System States) is applied in parallel with or immediately after the Logical Architecture (SM-PRD-20) is established. The System Architect: (1) identifies the key operating modes from the Use Case Activities (SM-PRD-14) and system requirements (SM-PRD-10); (2) defines state hierarchy using `state def` specialization; (3) specifies state machines on relevant `part def` elements using `exhibit state`; (4) defines all transitions with trigger, guard, and effect. The resulting state model is used as a guard reference in Scenarios (SM-PRD-22) and Use Case Activities (SM-PRD-14).

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Use Case Activities | SM-PRD-14 | Activities reveal the modes that must exist; action guards specify which state must be active |
| 2 | System Use Cases | SM-PRD-12 | Use cases define the scope of state coverage; each use case has pre/postcondition states |
| 3 | Requirements | SM-PRD-10 | Operational mode requirements, safety mode requirements, and availability requirements define required states |
| 4 | Logical Architecture | SM-PRD-20 | `part def` elements that must exhibit state machines are identified from the Logical Architecture |
| 5 | Domain Knowledge | SM-PRD-15 | Safety standards (e.g., ISO 26262, IEC 61508) prescribe required fail-safe states |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Logical Architecture | SM-PRD-20 | State machines are exhibited on logical component `part def` elements; guards appear in connection conditions |
| 2 | Use Case Activities | SM-PRD-14 | Use case activity steps reference states as pre/postconditions and as action guards |
| 3 | Scenarios | SM-PRD-22 | Scenarios declare precondition and postcondition states; state transitions appear as scenario steps |
| 4 | Test Cases | SM-PRD-16 | Test cases verify that the system reaches expected states; states are pass/fail criteria |

### Dependencies

- **SM-PRD-14 (Use Case Activities):** Use case activity steps provide the first indication of which states the system must be in for each function to execute. States without corresponding use case steps are suspect.
- **SM-PRD-12 (System Use Cases):** Each use case must have a pre-state (system must be in state X for the use case to start) and a post-state (system is in state Y after the use case completes). These drive the state transition graph.
- **SM-PRD-10 (Requirements):** Safety-related requirements often mandate specific fail-safe states (e.g., "system shall enter SafeState within 100 ms of critical fault detection"). These directly define required states and transition timing.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| State (named operating mode) | `state def` | [SML-DEF-StateDef](../../sysml2/concepts/state-definition.md) | Defines the named, reusable state type in the system state taxonomy |
| State hierarchy (substates) | `state def SubState :> ParentState` | [SML-DEF-StateDef](../../sysml2/concepts/state-definition.md) | Specialization creates the hierarchical state taxonomy |
| State instance on a part | `state` (state usage) via `exhibit state` | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | Attaches a state machine instance to a specific `part def` |
| State machine body | `exhibit state <name> : <StateDef> { … }` | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | Body contains initial pseudo-state, state usages, and transition specifications |
| Transition | `transition <source> then <target>` or `accept <event> [<guard>] then <target>` | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | Defines the triggering event, optional guard condition, and target state |
| Entry/exit/do action | `entry`, `do`, `exit` within a state usage | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | Specifies actions executed on state entry, during residence, or on exit |
| State machine diagram | State Machine Diagram | [SML-DGM-StateDiag](../../sysml2/diagrams/state-diagram.md) | Graphical view of states, transitions, events, and guards |
| Guard condition | `[ <condition> ]` on transition | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | Boolean condition evaluated when the trigger event fires |
| Trigger event | `accept <EventDef>` | [SML-USG-ActUSG](../../sysml2/concepts/action-usage.md) | The event that triggers evaluation of the transition from the current state |

### Modeling Pattern

```sysml
package VehicleSystem_SystemStates {

  // State taxonomy — abstract supertypes for grouping
  state def VehicleOperationalState;
  state def SystemOffState      :> VehicleOperationalState;
  state def InitializingState   :> VehicleOperationalState;
  state def OperationalState    :> VehicleOperationalState;
  state def DegradedState       :> VehicleOperationalState;
  state def EmergencyState      :> VehicleOperationalState;
  state def ShutdownState       :> VehicleOperationalState;

  // Events that trigger transitions
  attribute def PowerOn;
  attribute def SelfTestOk;
  attribute def SelfTestFail;
  attribute def FaultDetected  { attribute severity : String; }
  attribute def FaultCleared;
  attribute def CriticalFault;
  attribute def ShutdownCommand;
  attribute def SafeStateReached;

  // State machine exhibited on the top-level logical component (SM-PRD-20)
  part def VehicleControlSystem {

    exhibit state systemLifecycle : VehicleOperationalState {

      entry; then SystemOff;   // Initial pseudo-state → first state

      state SystemOff : SystemOffState {
        doc /* System is powered off; no functions active */
        accept PowerOn
          then do action startupSequence
          then Initializing;
      }

      state Initializing : InitializingState {
        doc /* System performs self-test and initialises all subsystems */
        entry do action performSelfTest;
        accept SelfTestOk   then Operational;
        accept SelfTestFail then Emergency;
      }

      state Operational : OperationalState {
        doc /* All functions available; normal operating mode */
        accept FaultDetected [severity == "critical"] then Emergency;
        accept FaultDetected [severity == "minor"]    then Degraded;
        accept ShutdownCommand                        then Shutdown;
      }

      state Degraded : DegradedState {
        doc /* Non-critical fault active; reduced functionality available */
        entry do action activateDegradedProfile;
        accept FaultCleared  then Operational;
        accept CriticalFault then Emergency;
      }

      state Emergency : EmergencyState {
        doc /* Critical fault; system executes fail-safe actions immediately */
        entry do action executeFailSafe;
        accept SafeStateReached then Shutdown;
      }

      state Shutdown : ShutdownState {
        doc /* Controlled power-down sequence; no transitions out */
        entry do action cleanupAndPowerOff;
      }
    }
  }

  // Component-level state machine example: Sensor calibration states
  state def SensorCalibrationState;
  state def SensorUncalibrated  :> SensorCalibrationState;
  state def SensorCalibrating   :> SensorCalibrationState;
  state def SensorCalibrated    :> SensorCalibrationState;
  state def SensorFaulty        :> SensorCalibrationState;

  part def LogicalSensorInterface {
    exhibit state calibrationLifecycle : SensorCalibrationState {
      entry; then Uncalibrated;
      state Uncalibrated : SensorUncalibrated {
        accept StartCalibration then Calibrating;
      }
      state Calibrating : SensorCalibrating {
        entry do action runCalibrationRoutine;
        accept CalibrationSuccess then Calibrated;
        accept CalibrationFail    then Faulty;
      }
      state Calibrated : SensorCalibrated {
        accept SensorError then Faulty;
      }
      state Faulty : SensorFaulty {
        entry do action reportFault;
      }
    }
  }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  system_states/
    <System>_SystemStates.sysml            ← State def taxonomy and system-level state machine
    <System>_ComponentStates.sysml         ← Component-level state machines for key parts
    <System>_StateEvents.sysml             ← Event and trigger definitions used in transitions
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | **Mandatory** | System state machine as a lifecycle scenario; key state transitions illustrated with sequence diagrams; timing constraints on critical transitions |
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | **Mandatory** | System-wide state model overview; state naming conventions; state transition policies; rules for guard conditions |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | Recommended | Availability and safety quality scenarios expressed in terms of state transitions (e.g., "system reaches SafeState within 100 ms of fault detection") |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Key decisions: hierarchical vs. flat state model; orthogonal state regions; state machine granularity |
| [Risks and Technical Debts](../../arc42/sections/risks-and-technical-debts.md) | ARC-11 | Optional | Incomplete state coverage (untested transitions) documented as technical debt |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-14 | Use Case Activities | `depends_on` | Activities provide the guard conditions and mode-change triggers that define required states |
| SM-PRD-12 | System Use Cases | `depends_on` | Pre/postcondition states for each use case drive the state transition graph |
| SM-PRD-10 | Requirements | `depends_on` | Operational mode and safety requirements define mandatory states and transition timing |
| SM-PRD-20 | Logical Architecture | `depends_on` | `part def` elements in the Logical Architecture host the `exhibit state` state machines |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-20 | Logical Architecture | `implements` | State machines are exhibited on logical component `part def` elements |
| SM-PRD-14 | Use Case Activities | `implements` | State guards appear as preconditions in use case activity action steps |
| SM-PRD-22 | Scenarios | `implements` | Scenarios reference states as preconditions and postconditions |
| SM-PRD-16 | Test Cases | `implements` | Test cases verify observable state transitions as pass/fail criteria |
| ARC-06 | Runtime View | `documents` | System lifecycle state machine is documented in ARC-06 |
| ARC-08 | Cross-cutting Concepts | `documents` | System-wide state model and transition policies documented in ARC-08 |

### Traceability Rules

1. Every `state def` MUST be exhibited (`exhibit state`) on at least one `part def` in the Logical Architecture (SM-PRD-20) or Product Architecture (SM-PRD-21).
2. Every Use Case Activity (SM-PRD-14) MUST reference at least one precondition state and one postcondition state from SM-PRD-23.
3. Every state transition MUST have a named trigger event. Guard-only transitions without a trigger event are not permitted.
4. Every state reachable from the initial pseudo-state MUST have at least one outgoing transition (except terminal states, which MUST be explicitly documented as terminal).
5. Every safety-relevant state (e.g., Emergency, Degraded) MUST trace to at least one safety requirement in SM-PRD-10.
6. The state machine MUST be deterministic: for any state and any event, at most one transition MUST be enabled (guards must be mutually exclusive when multiple transitions share the same trigger).

---

## §5 Modeling Procedure

1. **Collect operating modes from Use Case Activities.** Review all Use Case Activities (SM-PRD-14) and extract every condition that the system must be in for an activity to execute, plus every resulting condition after the activity completes. These are candidate states. Also extract every event type mentioned as a trigger.

2. **Identify safety-mandated states.** Review requirements (SM-PRD-10) for operational mode requirements and safety standards. Add any fail-safe, degraded, or emergency states required by the applicable safety standard. Annotate these with their safety integrity level.

3. **Define the state taxonomy.** Group related states into a hierarchy using `state def SubState :> ParentState`. Create the abstract root state first (e.g., `state def VehicleOperationalState`), then specialize it into concrete states. The hierarchy makes the state machine readable and supports `instanceof` queries.

4. **Define trigger events.** Create `attribute def` declarations for each distinct event type that triggers a state transition. Include relevant attributes (e.g., `severity` on `FaultDetected`). This ensures events are typed and reusable across multiple state machines.

5. **Assign state machines to architectural parts.** For each `part def` in SM-PRD-20 (Logical Architecture) that has behavioral modes, add `exhibit state <machineName> : <RootStateDef> { … }`. Start with the top-level system `part def`, then add component-level state machines for key parts (sensors, actuators, communication buses).

6. **Specify each state body.** For every concrete state, define: (a) entry/exit/do actions (as `do action` references to named `action def` from SM-PRD-18); (b) all outgoing transitions with trigger event, guard condition, and target state; (c) a `doc` block explaining the state's semantics. Ensure guards are mutually exclusive when multiple transitions share the same trigger.

7. **Validate against Use Case Activities.** For each Use Case Activity step that references a state guard or mode transition, verify the required state and transition exist in the state model. Add missing states and transitions. Update the use case activity to reference the correct state names.

8. **Validate determinism.** For each state, enumerate all events and all guards. Verify that for any (state, event) pair, at most one guard is satisfiable at a time. Document any intentional non-determinism as a design decision in ARC-09.

9. **Document in arc42.** Add the system-level state machine diagram to ARC-06 (Runtime View) as the lifecycle scenario. Add the state naming convention, guard condition policy, and transition rules to ARC-08 (Cross-cutting Concepts). Record state model design decisions in ARC-09.
