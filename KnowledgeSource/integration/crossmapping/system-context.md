---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Context
description: Full SysML v2 and arc42 mapping for SYSMOD product System Context (SM-PRD-11).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Context (SM-PRD-11)

The System Context defines the boundary of the system under development and identifies all external actors — humans, external systems, environmental effects, and environmental impacts — that interact with the system. In SysML v2, the system context is a `part def` annotated as «systemContext» that contains the system of interest and all actor instances connected via typed `port def` interfaces. This product is the primary input to arc42 ARC-03 (Context and Scope) and provides the structural boundary that constrains all downstream design products.

## §1 SysMod Definition

**Product ID:** SM-PRD-11
**SYSMOD §:** 5.11
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.11 Identify the System Context](../../sysmod/methods/identify-system-context.md) (SM-MTH-11)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose

The System Context establishes what is inside the system boundary (the system of interest) and what is outside (external actors and environments). It makes explicit all interfaces between the system and the outside world, enabling interface requirements (SM-PRD-10) to be validated against the context model and providing the structural actor framework for use case identification (SM-PRD-12).

### Role in Process

Within the Analysis process (SM-PRC-1), the System Context integrates information from Requirements (SM-PRD-10) and Base Architecture (SM-PRD-07). Every external interface implied by a requirement must appear as a typed connection in the context model. The context model then serves as the structural framework for use cases (SM-PRD-12) — each use case involves at least one actor defined here.

### Inputs

| # | Input Product | ID | Description |
|---|---------------|----|-------------|
| 1 | Requirements | SM-PRD-10 | Interface requirements determine which external actors must appear in the context |
| 2 | Base Architecture | SM-PRD-07 | Pre-defined structural elements anchor the system boundary and platform-level connections |

### Outputs / Dependent Artifacts

| # | Dependent Product | ID | Relationship |
|---|-------------------|----|--------------|
| 1 | System Use Cases | SM-PRD-12 | Every use case actor must be defined in this context model |
| 2 | Logical Architecture | SM-PRD-20 | Logical Architecture root element inherits the context boundary definition |

### Dependencies

System Context depends on SM-PRD-10 (Requirements) for the complete set of interface requirements that determine which external actors must be identified, and SM-PRD-07 (Base Architecture) for the fixed structural elements that define the system boundary. The Stakeholders product (SM-PRD-08) provides the human actor categories that populate the context with typed actors.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| System context (top container) | `part def <System>Context` with `@ContextMeta` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Container `part def` holding the system and all actors; «systemContext» stereotype via metadata annotation |
| System of interest | `part system : <SystemType>` inside context `part def` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | The system under development is an internal part within the context block |
| Human actor («user») | `part def <ActorName>` with `@ActorMeta { category = "user" }` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Human users modeled as `part def` with actor category metadata |
| External system («externalSystem») | `part def <ExtSysName>` with `@ActorMeta { category = "externalSystem" }` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | External systems as `part def`; imported from stakeholders package where already defined |
| Environmental effect («environmentalEffect») | `part def <EffectName>` with `@ActorMeta { category = "environmentalEffect" }` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Physical or environmental conditions that act on the system |
| Environmental impact («environmentalImpact») | `part def <ImpactName>` with `@ActorMeta { category = "environmentalImpact" }` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | System outputs that affect the environment (noise, heat, emissions) |
| Typed interface port | `port def <Name>Port { in item ...; out item ...; }` | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Typed ports define interface contracts between the system and each actor |
| Interface connection | `connect <actor>.<port> to system.<port>` inside context `part def` | [SML-USG-ConnUSG](../../sysml2/concepts/connection-usage.md) | Explicit directional wiring between actor ports and system ports |
| Data flow item type | `flow def <FlowName> { attribute ...; }` | [SML-DEF-FlowDef](../../sysml2/concepts/flow.md) | Typed item flows describing the data or material exchanged across each interface |
| Context diagram | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Block-diagram view showing all actors connected to the system boundary |

### Modeling Pattern

```sysml
package VehicleSystem_Context {

  metadata def ActorMeta {
    attribute category    : String; // user | externalSystem | environmentalEffect | environmentalImpact
    attribute description : String;
  }

  // === Data Flow Type Definitions ===
  flow def CANMessage {
    attribute id      : Integer;
    attribute payload : Real[0..8];
  }

  flow def SteeringCommand {
    attribute angle  : Real; // degrees, range -540 to +540
    attribute torque : Real; // Nm
  }

  flow def HapticSignal {
    attribute intensity : Real; // 0.0 to 1.0
    attribute pattern   : String;
  }

  // === Port Definitions ===
  port def DriverInterfacePort {
    in  item steeringInput  : SteeringCommand;
    in  item brakeInput     : BrakePedalSignal;
    out item hapticFeedback : HapticSignal;
    out item displayOutput  : DashboardDisplay;
  }

  port def CANFDBusPort {
    in  item canRxMessage : CANMessage;
    out item canTxMessage : CANMessage;
  }

  port def PowerInputPort {
    in item supplyVoltage : ElectricalPower;
  }

  port def DiagnosticsPort {
    out item faultCode : OBDFaultCode;
    in  item diagRequest : DiagCommand;
  }

  // === External Actor Definitions ===
  part def VehicleDriver {
    @ActorMeta {
      category    = "user";
      description = "Primary human operator of the vehicle control system";
    }
    port controlInterface : DriverInterfacePort;
  }

  part def EngineControlUnit {
    @ActorMeta {
      category    = "externalSystem";
      description = "External ECU managing engine torque; communicates via CAN FD at 5 Mbit/s";
    }
    port canBusPort : CANFDBusPort;
  }

  part def VehiclePowerSystem {
    @ActorMeta {
      category    = "externalSystem";
      description = "12 V board net providing power to the VCS; 15 A maximum continuous";
    }
    port powerPort : PowerInputPort;
  }

  part def DiagnosticsTool {
    @ActorMeta {
      category    = "externalSystem";
      description = "OBD-II diagnostic tool used by service technicians";
    }
    port diagPort : DiagnosticsPort;
  }

  part def RoadSurface {
    @ActorMeta {
      category    = "environmentalEffect";
      description = "Road friction and surface conditions affecting wheel traction behavior";
    }
  }

  // === System Context Block ===
  part def VehicleControlSystemContext {
    part system      : VehicleControlSystem;
    part driver      : VehicleDriver;
    part engineECU   : EngineControlUnit;
    part powerSystem : VehiclePowerSystem;
    part diagTool    : DiagnosticsTool;
    part roadSurface : RoadSurface;

    connect driver.controlInterface  to system.driverInterface;
    connect system.canBusPort        to engineECU.canBusPort;
    connect powerSystem.powerPort    to system.powerInputPort;
    connect system.diagnosticsPort   to diagTool.diagPort;
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
└── context/
    ├── <System>_Context.sysml         # Context part def, actor part defs, port defs, flow defs
    └── <System>_ContextDiagram.sysml  # Definition Diagram (context diagram view for stakeholder review)
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory? | Content Mapped from SM-PRD-11 |
|---|---|---|---|
| [Context and Scope](../../arc42/sections/context-and-scope.md) | ARC-03 | **Mandatory** | Business context diagram (all actors + connections) AND technical context table (interface protocol/format details per connection) |
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | Recommended | External actors in context model cross-referenced with stakeholder table entries |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | Optional | The system of interest (`part system`) in the context block becomes the Level 1 whitebox in ARC-05 |

**ARC-03 Technical Context Table format:**

| Interface | Direction | External Partner | Protocol / Format | Linked Requirement |
|---|---|---|---|---|
| Driver Control Interface | Bidirectional | Vehicle Driver | Physical (pedal/wheel) + CAN control signals | REQ-IF-002 |
| CAN FD Bus | Bidirectional | Engine ECU | CAN FD @ 5 Mbit/s, ICD v1.2 message definitions | REQ-IF-001 |
| 12 V Power Supply | Inbound | Vehicle Power System | 12 V ±10%, 15 A max continuous | REQ-CN-001 |
| OBD-II Diagnostics | Bidirectional | Diagnostics Tool | ISO 15031 / SAE J1979 OBD-II protocol | REQ-IF-003 |
| Road Surface Feedback | Inbound (env effect) | Road Surface | Physical force / friction coefficient (environmental) | — |

---

## §4 Traceability

### Incoming Links

| Source Product | ID | Link Type | Description |
|---|---|---|---|
| Requirements | SM-PRD-10 | `depends_on` | Interface requirements specify which actors and connections must appear in the context model |
| Base Architecture | SM-PRD-07 | `depends_on` | Fixed structural elements (ECU, bus) anchor the system boundary topology |
| Stakeholders | SM-PRD-08 | `refines` | Human stakeholders become human actor `part def` entries; `part def` reused across packages |

### Outgoing Links

| Target Product | ID | Link Type | Description |
|---|---|---|---|
| System Use Cases | SM-PRD-12 | `refines` | Every use case actor must be defined as a `part def` in this context model |
| Logical Architecture | SM-PRD-20 | `implements` | Logical Architecture root respects this context boundary; actors become external boundary elements |
| arc42 ARC-03 | ARC-03 | `documents` | Context model directly populates the ARC-03 business and technical context |
| arc42 ARC-01 | ARC-01 | `documents` | External actors support the ARC-01 scope and stakeholder description |

### Traceability Rules

1. Every external actor `part def` in the context model MUST correspond to either a stakeholder in SM-PRD-08 or an interface requirement in SM-PRD-10.
2. Every interface requirement (REQ_IF_xxx) in SM-PRD-10 MUST have a corresponding `connect` statement and typed `port def` in the context model.
3. Every `connect` statement in the context `part def` MUST appear as a row in the ARC-03 Technical Context table.
4. Every actor `part def` used in a use case (SM-PRD-12) MUST be defined in this package or explicitly imported from it.
5. The system of interest (`part system : <Type>`) in the context `part def` MUST match the root `part def` used as the Logical Architecture boundary in SM-PRD-20.

---

## §5 Modeling Procedure

1. **Identify the system boundary.** Using SM-PRD-10 (interface requirements) and SM-PRD-07 (Base Architecture), determine precisely what is inside the system of interest and what is outside. Document the boundary decision explicitly in ARC-03 introduction text.
2. **Enumerate external actors by category.** From the stakeholders list (SM-PRD-08) and interface requirements (SM-PRD-10), list all entities that interact with the system. Classify each as: user, externalSystem, environmentalEffect, or environmentalImpact using SYSMOD's four actor categories.
3. **Define `ActorMeta` metadata.** Create `metadata def ActorMeta` with category and description fields. Every actor `part def` must be annotated with `@ActorMeta` so tooling can filter and categorize actors programmatically.
4. **Create a `part def` for each external actor.** For each enumerated actor, create a typed `part def` annotated with `@ActorMeta`. Reuse `part def` entries from the Stakeholders package (SM-PRD-08) where actors overlap with identified stakeholders — import rather than redefine.
5. **Define typed `port def` for each interface.** For each interface between the system and an external actor, create a `port def` specifying direction (`in`/`out`), item flow type, and implied protocol. This formalizes the interface contract between the system boundary and each actor.
6. **Define `flow def` for each distinct data type.** For each data, material, or energy type flowing across an interface, create a `flow def` with typed attributes (e.g., `attribute id : Integer`, `attribute payload : Real[0..8]`). Align flow types with Interface Control Documents where they exist.
7. **Assemble the context `part def`.** Create `part def <System>Context` containing the system as `part system` and all actor instances. Add `connect` statements for every interface using the defined `port def` types. Every actor must be connected — isolated actor `part` usages indicate a missing interface requirement.
8. **Draw the context Definition Diagram.** Create the SML-DGM-DefDiag showing all actors connected to the system. Present this diagram in stakeholder reviews as the primary deliverable — it becomes the ARC-03 business context diagram.
9. **Populate ARC-03.** Transfer the context diagram to arc42 as the business context diagram. Create the technical context table with one row per interface, specifying direction, partner, protocol/format, and the linked requirement ID.
10. **Validate completeness in three directions.** Check: (a) every interface requirement in SM-PRD-10 has a corresponding context connection; (b) every stakeholder in SM-PRD-08 who directly interacts with the system appears as an actor; (c) every `connect` statement has a typed `port def` with `flow def` item types that match the Interface Control Documents.

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [The Death of the Actor](../../sysmod/tools/death-of-actor.md) | Tool 11.1 | **Always** — use `part def` for actors (not SysML `actor` element) to enable ports and internal structure; SYSMOD actor stereotypes specialize `Block`/`part def` |
| [Proxy versus Full Port](../../sysmod/tools/proxy-versus-full-port.md) | Tool 11.4 | When deciding port type — use **proxy ports** (standard `port def`) exclusively; avoid full ports to keep all system parts as `part` usages |
