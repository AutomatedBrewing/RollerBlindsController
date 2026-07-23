---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Use Cases
description: Full SysML v2 and arc42 mapping for SYSMOD product System Use Cases (SM-PRD-12).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Use Cases (SM-PRD-12)

System Use Cases describe the discrete interactions between the system and its external actors that deliver value or fulfill a system function. In SysML v2, use cases are modeled as `use case def` elements with a `subject` typed by the system `part def`, actor references from the System Context, and behavioral properties (trigger, result, pre/postconditions) captured via `@UseCaseMeta` annotations. Use cases bridge the Requirements (SM-PRD-10) and the behavioral models of System Processes (SM-PRD-13) and Use Case Activities (SM-PRD-14).

## §1 SysMod Definition

**Product ID:** SM-PRD-12
**SYSMOD §:** 5.12
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.12 Identify System Use Cases](../../sysmod/methods/identify-system-use-cases.md) (SM-MTH-12)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose

System Use Cases capture the functional scope of the system as discrete or continuous actor-initiated interactions that produce observable, verifiable results. They provide the behavioral complement to the structural System Context (SM-PRD-11): the context defines who interacts with the system; use cases define what interactions occur. Each use case serves as the scope for detailed behavioral modeling in Use Case Activities (SM-PRD-14) and as a functional requirement grouping in arc42 ARC-01.

### Role in Process

System Use Cases are developed after the System Context (SM-PRD-11) is established and requirements (SM-PRD-10) are available. They provide the highest-level external-view functional decomposition of system behavior. Each use case drives one or more System Processes (SM-PRD-13) and is elaborated into action flows in Use Case Activities (SM-PRD-14). SYSMOD distinguishes «systemUseCase» (discrete, event-triggered) from «continuousUseCase» (ongoing function active during a system state).

### Inputs

| # | Input Product | ID | Description |
|---|---------------|----|-------------|
| 1 | Requirements | SM-PRD-10 | Functional requirements define the expected system interactions and acceptance criteria |
| 2 | System Context | SM-PRD-11 | Actor definitions provide the participant set for use case subject and actor references |
| 3 | Stakeholders | SM-PRD-08 | Stakeholder concerns confirm the value delivered by each use case |

### Outputs / Dependent Artifacts

| # | Dependent Product | ID | Relationship |
|---|-------------------|----|--------------|
| 1 | System Processes | SM-PRD-13 | Each use case maps to one or more system processes that realize it |
| 2 | Use Case Activities | SM-PRD-14 | Each use case is elaborated as an action flow diagram |

### Dependencies

System Use Cases depend on SM-PRD-10 (Requirements) for functional scope, SM-PRD-11 (System Context) for actor definitions, and SM-PRD-08 (Stakeholders) for validating that each use case delivers value to an identified stakeholder. The Base Architecture (SM-PRD-07) constrains which use cases are technically feasible given the fixed platform constraints.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| System use case («systemUseCase») | `use case def UC_<NN>_<Name>` | [SML-DEF-UCaseDef](../../sysml2/concepts/use-case-definition.md) | Discrete, event-triggered use case with subject, actors, and behavioral conditions |
| Continuous use case («continuousUseCase») | `use case def UC_<NN>_<Name>` with `@UseCaseMeta { type = "continuousUseCase" }` | [SML-DEF-UCaseDef](../../sysml2/concepts/use-case-definition.md) | Ongoing system function; type distinguished via metadata annotation |
| Use case subject (system under development) | `subject system : <SystemPartDef>` inside `use case def` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Binds the use case to the system of interest defined in the context model |
| Use case actor | `actor <actorName> : <ActorPartDef>` inside `use case def` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | References actor `part def` imported from System Context (SM-PRD-11) |
| Use case behavioral properties | `metadata def UseCaseMeta { ... }` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Captures trigger, result, preconditions, postconditions, type, and priority without extending SysML type system |
| Use case instantiation / scenario | `use case <instanceName> : UC_<NN>_<Name>` | [SML-USG-UCaseUSG](../../sysml2/concepts/use-case-usage.md) | Use case usage for instantiation in specific operational contexts or test scenarios |
| Use case diagram | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Displays all `use case def` elements with their subjects and connected actors |
| Requirement-to-use-case coverage trace | Requirements Diagram | [SML-DGM-ReqDiag](../../sysml2/diagrams/requirements-diagram.md) | Shows which requirements are addressed and verified by each use case |

### Modeling Pattern

```sysml
package VehicleSystem_UseCases {

  metadata def UseCaseMeta {
    attribute trigger        : String;
    attribute result         : String;
    attribute preconditions  : String[0..*];
    attribute postconditions : String[0..*];
    attribute type           : String;   // systemUseCase | continuousUseCase
    attribute priority       : String;   // mandatory | high | medium | low
  }

  // === Discrete Use Cases ===

  use case def UC_01_EmergencyBraking {
    doc /* Driver initiates emergency braking; system applies maximum braking force
           within safety limits and the 150 ms response time requirement. */
    subject system : VehicleControlSystem;
    actor   driver : VehicleDriver;
    @UseCaseMeta {
      trigger        = "Driver presses brake pedal > 80% travel";
      result         = "Vehicle decelerates at maximum safe rate; braking event written to log";
      preconditions  = ["System in OPERATIONAL state", "Vehicle speed > 0 km/h"];
      postconditions = ["Vehicle speed reduced or zero", "Braking event logged with timestamp"];
      type           = "systemUseCase";
      priority       = "mandatory";
    }
  }

  use case def UC_02_NormalBraking {
    doc /* Driver applies normal braking pressure; system modulates brake force
           proportionally while maintaining traction control and preventing wheel lock-up. */
    subject system : VehicleControlSystem;
    actor   driver : VehicleDriver;
    @UseCaseMeta {
      trigger        = "Driver presses brake pedal 10%–80% travel";
      result         = "Vehicle decelerates proportionally; no wheel lock-up detected";
      preconditions  = ["System in OPERATIONAL state"];
      postconditions = ["Vehicle speed reduced proportionally", "Traction maintained"];
      type           = "systemUseCase";
      priority       = "mandatory";
    }
  }

  use case def UC_03_SystemStartup {
    doc /* Driver activates ignition; system performs self-test, initializes subsystems,
           and transitions to OPERATIONAL state within the 5-second startup budget. */
    subject system : VehicleControlSystem;
    actor   driver : VehicleDriver;
    @UseCaseMeta {
      trigger        = "Ignition switch activated (key-on event)";
      result         = "System in OPERATIONAL state within 5 seconds; status displayed to driver";
      preconditions  = ["Supply voltage 10.8 V – 13.2 V", "No pre-existing critical faults"];
      postconditions = ["All subsystems initialized", "Startup self-test result logged"];
      type           = "systemUseCase";
      priority       = "mandatory";
    }
  }

  // === Continuous Use Cases ===

  use case def UC_04_ContinuousTractionControl {
    doc /* System continuously monitors wheel slip and adjusts engine torque request
           to the Engine ECU to maintain traction without requiring driver intervention. */
    subject system    : VehicleControlSystem;
    actor   engineECU : EngineControlUnit;
    @UseCaseMeta {
      trigger        = "Continuous — active when vehicle speed > 5 km/h and system OPERATIONAL";
      result         = "Wheel slip maintained below 5%; torque adjustment commands sent to Engine ECU";
      preconditions  = ["System in OPERATIONAL state", "Vehicle speed > 5 km/h"];
      postconditions = ["Traction maintained within specification at all times while active"];
      type           = "continuousUseCase";
      priority       = "high";
    }
  }

  use case def UC_05_ContinuousFaultMonitoring {
    doc /* System continuously monitors internal health parameters and reports
           fault codes to the OBD-II diagnostics interface within 100 ms of fault detection. */
    subject system : VehicleControlSystem;
    @UseCaseMeta {
      trigger        = "Continuous — active in all powered system states";
      result         = "Fault codes reported via OBD-II within 100 ms; driver warnings displayed as appropriate";
      preconditions  = ["System powered (ignition on or standby)"];
      postconditions = ["Fault log updated; active warnings reflected on dashboard"];
      type           = "continuousUseCase";
      priority       = "high";
    }
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
└── use_cases/
    ├── <System>_UseCases.sysml              # Top-level package with UseCaseMeta def
    ├── <System>_DiscreteUseCases.sysml      # UC_xx with type = "systemUseCase"
    └── <System>_ContinuousUseCases.sysml    # UC_xx with type = "continuousUseCase"
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory? | Content Mapped from SM-PRD-12 |
|---|---|---|---|
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) — Requirements Overview | ARC-01 | **Mandatory** | Use case table as functional scope: UC ID, name, actors, type, priority, covered requirement |
| [Context and Scope](../../arc42/sections/context-and-scope.md) | ARC-03 | **Mandatory** | Use cases define the functional interfaces between system and external actors; complements the structural context diagram |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Optional | Use cases that introduce significant architectural complexity (real-time constraints, safety) may reference ADRs |

**ARC-01 Use Case Table format:**

| UC ID | Use Case Name | Primary Actor | Type | Priority | Covers Requirement |
|---|---|---|---|---|---|
| UC-01 | Emergency Braking | Vehicle Driver | Discrete | mandatory | REQ-FN-001 |
| UC-02 | Normal Braking | Vehicle Driver | Discrete | mandatory | REQ-FN-002 |
| UC-03 | System Startup | Vehicle Driver | Discrete | mandatory | REQ-FN-003 |
| UC-04 | Continuous Traction Control | Engine ECU | Continuous | high | REQ-FN-004 |
| UC-05 | Continuous Fault Monitoring | — (internal) | Continuous | high | REQ-SF-001 |

---

## §4 Traceability

### Incoming Links

| Source Product | ID | Link Type | Description |
|---|---|---|---|
| Requirements | SM-PRD-10 | `depends_on` | Each use case must address at least one functional requirement; coverage validated by traceability matrix |
| System Context | SM-PRD-11 | `depends_on` | All actors referenced in use cases must be defined as `part def` in the System Context package |
| Stakeholders | SM-PRD-08 | `depends_on` | Each use case must deliver observable value to at least one identified stakeholder |

### Outgoing Links

| Target Product | ID | Link Type | Description |
|---|---|---|---|
| System Processes | SM-PRD-13 | `refines` | Each use case is decomposed into one or more system processes that realize its trigger-to-result flow |
| Use Case Activities | SM-PRD-14 | `refines` | Each use case is elaborated into an action flow diagram detailing internal system behavior |
| arc42 ARC-01 | ARC-01 | `documents` | Use case table populates the functional scope in ARC-01 Requirements Overview |
| arc42 ARC-03 | ARC-03 | `documents` | Use cases define the functional interfaces documented in ARC-03 Context and Scope |

### Traceability Rules

1. Every `use case def` MUST have `@UseCaseMeta` with all required fields populated (trigger, result, preconditions, postconditions, type, priority).
2. Every `use case def` MUST declare a `subject` typed by the system `part def` from the System Context (SM-PRD-11).
3. Every actor referenced in a `use case def` MUST be defined as a `part def` in the System Context package (SM-PRD-11) — no actor may be defined only in the use cases package.
4. Every functional requirement (REQ_FN_xxx) in SM-PRD-10 MUST be covered by at least one use case — verify this with a requirement coverage matrix before proceeding to SM-PRD-13.
5. Every `use case def` with `priority = "mandatory"` MUST be elaborated into a Use Case Activity (SM-PRD-14) before the analysis phase closes.
6. Every `use case def` MUST appear as a row in the ARC-01 use case table and be mentioned in the ARC-03 scope description.

---

## §5 Modeling Procedure

1. **Derive use case candidates from functional requirements.** Review all REQ_FN_xxx entries in SM-PRD-10. For each discrete functional requirement, identify the triggering event, initiating actor, and expected result. Each distinct combination of trigger, actor, and observable result is a separate use case candidate.
2. **Identify continuous use cases.** Review requirements for continuously active system functions: control loops, monitoring functions, communication maintenance. Mark these as `type = "continuousUseCase"` in `@UseCaseMeta`. Continuous use cases have no discrete trigger — they are active whenever the system is in a specified operational state.
3. **Validate actors against the System Context.** For each use case, verify that every actor reference corresponds to a `part def` defined in the System Context package (SM-PRD-11). If a new actor is implied by the use case, update the context model first before finalizing the use case definition.
4. **Create the `UseCaseMeta` metadata definition.** Establish `metadata def UseCaseMeta` with fields trigger, result, preconditions, postconditions, type, and priority in the top-level use cases package. This definition is shared across all sub-packages.
5. **Model each use case as a `use case def`.** Write a `doc` string narrating the interaction from the actor's perspective. Declare `subject` and `actor` references. Add `@UseCaseMeta` annotations with all required fields. Use the UC-NN-Name naming convention for consistent identification across the project.
6. **Specify preconditions and postconditions precisely.** For each use case, enumerate all preconditions (required system state, required actor state, data availability) and postconditions (observable system state changes, data written to logs, signals sent, displays updated). These directly drive test case design in SM-PRD-16.
7. **Assign priority to each use case.** Based on requirement priority (SM-PRD-10) and stakeholder priority (SM-PRD-08), assign each use case a priority (mandatory/high/medium/low). Mandatory use cases must be covered in the first development increment.
8. **Draw the use case Definition Diagram (SML-DGM-DefDiag).** Create a Definition Diagram showing all `use case def` elements with their subjects and connected actors. This is the SysML v2 equivalent of a UML use case diagram. Present this to stakeholders for functional scope confirmation.
9. **Populate ARC-01 use case table.** Transfer all use cases to the arc42 Introduction and Goals section as a functional scope table (UC ID, name, actors, type, priority, requirement reference). This table defines the functional scope of the system for architecture documentation consumers.
10. **Create a requirement-to-use-case coverage matrix.** Build a traceability table mapping each REQ_FN_xxx requirement to the use case(s) that cover it. Verify 100% coverage of all functional requirements before the analysis phase closes and work on SM-PRD-13 (System Processes) begins.

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [SAMS Method](../../sysmod/tools/sams-method.md) | Tool 11.10 | **At the start of use case identification** — run a SAMS storyboard workshop with stakeholders to visually discover use cases before writing formal definitions; storyboard snippets become `use case def` candidates |
