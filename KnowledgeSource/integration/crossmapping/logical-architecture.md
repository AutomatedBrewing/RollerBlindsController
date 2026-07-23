---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Logical Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product Logical Architecture (SM-PRD-20).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Logical Architecture (SM-PRD-20)

The Logical Architecture specifies the architectural and technical concepts of the system at a high abstraction level, using general technical elements (e.g., "Control Unit", "Communication Bus", "Sensor Interface") that are reusable across product families. It bridges the gap between the Functional Architecture (SM-PRD-18) and the concrete Product Architecture (SM-PRD-21) by introducing typed logical components and their interfaces without yet committing to specific hardware or software implementations. The Logical Architecture is a concrete child of the Physical Architecture (SM-PRD-19).

## §1 SysMod Definition

**Product ID:** SM-PRD-20  
**SYSMOD §:** 5.20  
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)  
**Creating Method:** [4.18 Model the Logical Architecture](../../sysmod/methods/model-logical-architecture.md) (SM-MTH-18)  
**Responsible Role:** [System Architect](../../sysmod/roles/system-architect.md)

### Purpose

The Logical Architecture provides the first concrete physical architecture by decomposing the system into general technical concepts (logical components) with well-defined interfaces. It captures architectural decisions at a technology-independent level, enabling: (1) reuse of logical designs across product variants, (2) clean allocation of functional elements to structural elements, and (3) a stable architectural contract between the system architect and the subsystem designers. The Logical Architecture is the primary subject of architectural reviews before hardware and software selection is finalized.

### Role in Process

In the Architecture process (SM-PRC-2), Method 4.18 (Model the Logical Architecture) is executed after the Base Architecture (SM-PRD-07) has been established and the Functional Architecture (SM-PRD-18) is sufficiently stable. The System Architect: (1) identifies logical components by grouping related functional elements, (2) defines typed ports and interfaces, (3) establishes connections between components, (4) allocates functional elements to logical components, and (5) validates the architecture using Scenarios (SM-PRD-22). The Logical Architecture then serves as the generalization source for the Product Architecture (SM-PRD-21).

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Functional Architecture | SM-PRD-18 | Source of functional elements (`action def`) to be allocated to logical components |
| 2 | Base Architecture | SM-PRD-07 | Foundation; Logical System may specialize Base System via `part def LogicalX :> BaseX` |
| 3 | Requirements | SM-PRD-10 | Technical constraints determine component capabilities and interface specifications |
| 4 | System Context | SM-PRD-11 | External interface definitions at the system boundary |
| 5 | Domain Knowledge | SM-PRD-15 | Technology domain knowledge informs the choice of logical component types |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Product Architecture | SM-PRD-21 | Concretizes the Logical Architecture; each logical component is specialized or allocated to a product component |
| 2 | Scenarios | SM-PRD-22 | Trace execution paths through logical architecture instances to verify correctness |
| 3 | Test Architecture | SM-PRD-24 | Uses the Logical Architecture as the specification of what is being tested |
| 4 | System States | SM-PRD-23 | States are exhibited on logical components; logical components appear as state-bearing parts |

### Dependencies

- **SM-PRD-18 (Functional Architecture):** Must be substantially complete before logical components can be identified through functional grouping. Each `action def` must map to exactly one logical component via `allocation def`.
- **SM-PRD-07 (Base Architecture):** Strong coupling uses `part def LogicalX :> BaseX`; loose coupling uses `allocation def`. The coupling strategy must be decided before modeling begins.
- **SM-PRD-10 (Requirements):** Interface specifications (port types, throughput, protocols) must be traceable to requirements. Requirement satisfaction is modelled with `satisfy`.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Logical component | `part def` (specializing `PhysicalArchitecture`) | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Each logical component is a typed, reusable structural element |
| Logical system assembly | `part def LogicalSystem :> BaseSystem` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Encapsulates the full set of logical components with their connections |
| Typed interface | `port def` | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Captures the typed protocol or data-flow contract at a component boundary |
| Component connection | `connection def` | [SML-DEF-ConnDef](../../sysml2/concepts/connection-definition.md) | Formalizes the link between two port instances |
| Interface specification | `interface def` | [SML-DEF-IfaceDef](../../sysml2/concepts/interface-definition.md) | Groups related port definitions into a reusable interface contract |
| Functional allocation | `allocation def` | [SML-DEF-AllocDef](../../sysml2/concepts/allocation-definition.md) | Maps each `action def` from Functional Architecture to a logical component |
| Structural view | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Shows component hierarchy, ports, and connections |
| Dynamic allocation view | Action Flow Diagram | [SML-DGM-ActFlow](../../sysml2/diagrams/action-flow-diagram.md) | Shows how functions flow through the logical component network |
| Requirement satisfaction | `satisfy` | [SML-USG-Satisfy](../../sysml2/concepts/satisfy.md) | Links logical components to their satisfying requirements |

### Modeling Pattern

```sysml
package VehicleSystem_LogicalArchitecture {

  // Strong coupling: Logical System specializes Base System (SM-PRD-07)
  part def LogicalVehicleControlSystem :> BaseSystem {
    part ecuControl   : LogicalECU;
    part sensorHub    : LogicalSensorInterface;
    part actuatorCtrl : LogicalActuatorInterface;
    part commBus      : LogicalCommunicationBus;

    connect ecuControl.sensorPort   to sensorHub.dataOutPort;
    connect ecuControl.actuatorPort to actuatorCtrl.cmdInPort;
    connect sensorHub.busPort       to commBus.nodePort;
    connect actuatorCtrl.busPort    to commBus.nodePort;
  }

  part def LogicalECU {
    doc /* General logical control unit — reusable across product families */
    port sensorPort   : ~SensorDataPort;
    port actuatorPort : ActuatorCmdPort;
    attribute processingCapacity : String;
    attribute safetyIntegrityLevel : String;
  }

  part def LogicalSensorInterface {
    port dataOutPort : SensorDataPort;
    port busPort     : BusNodePort;
    attribute sensorType : String;
  }

  part def LogicalActuatorInterface {
    port cmdInPort : ~ActuatorCmdPort;
    port busPort   : BusNodePort;
    attribute actuatorType : String;
  }

  part def LogicalCommunicationBus {
    port nodePort : BusNodePort[0..*];
    attribute protocol : String;
    attribute bandwidth : Real;
  }

  port def SensorDataPort   { attribute dataRate : Real; }
  port def ActuatorCmdPort  { attribute cmdRate : Real; }
  port def BusNodePort      { attribute busAddress : Integer; }

  // Functional allocation: SM-PRD-18 → SM-PRD-20
  allocation def FunctionToLogicalComponent {
    doc /* Each functional element from SM-PRD-18 is allocated to exactly one logical component */
    allocate FE_SensorProcessing  to LogicalSensorInterface;
    allocate FE_BrakeControl      to LogicalActuatorInterface;
    allocate FE_SafetyMonitoring  to LogicalECU;
    allocate FE_CommunicationMgmt to LogicalCommunicationBus;
  }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  logical/
    <System>_LogicalArchitecture.sysml      ← Main logical architecture definition
    <System>_LogicalInterfaces.sysml        ← Port and interface definitions
    <System>_FunctionalAllocation.sysml     ← allocation def blocks (SM-PRD-18 → SM-PRD-20)
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | **Mandatory** | Logical decomposition approach; coupling strategy (specialization vs. allocation); rationale for component grouping |
| [Building Block View](../../arc42/sections/building-block-view.md) (Level 2) | ARC-05 | **Mandatory** | Logical components and their interfaces; internal structure of the logical system; port connections between components |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | **Mandatory** | Key decisions: which coupling strategy; how functional elements group into logical components; interface technology choices |
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | Recommended | Dynamic behavior of logical components traced via Scenarios (SM-PRD-22) |
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | Recommended | Allocation pattern from functional to logical; reuse strategy for logical components |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-19 | Physical Architecture [abstract] | `refines` | Logical Architecture is a concrete child of Physical Architecture |
| SM-PRD-07 | Base Architecture | `refines` | Logical System specializes (or is allocated from) Base System |
| SM-PRD-18 | Functional Architecture | `depends_on` | Functional elements are allocated to logical components |
| SM-PRD-10 | Requirements | `depends_on` | Requirements constrain logical component capabilities and interfaces |
| SM-PRD-11 | System Context | `depends_on` | External interfaces at the system boundary shape the outermost logical ports |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-21 | Product Architecture | `refines` | Product components specialize or are allocated from logical components |
| SM-PRD-22 | Scenarios | `implements` | Scenarios instantiate logical components to verify architecture correctness |
| SM-PRD-24 | Test Architecture | `implements` | Test Architecture uses logical component definitions as the specification of the SUT |
| SM-PRD-23 | System States | `implements` | Logical components exhibit state machines defined in SM-PRD-23 |
| ARC-04 | Solution Strategy | `documents` | Logical decomposition strategy is documented in ARC-04 |
| ARC-05 | Building Block View | `documents` | Logical components appear as Level 2 building blocks in ARC-05 |

### Traceability Rules

1. Every `action def` in SM-PRD-18 (Functional Architecture) MUST appear in exactly one `allocation def` mapping it to a logical component.
2. Every logical `part def` MUST specialize `PhysicalArchitecture` (directly or transitively via `LogicalSystem`).
3. Every `port def` in the Logical Architecture MUST trace to at least one interface requirement in SM-PRD-10.
4. Every logical component that appears in a Scenario (SM-PRD-22) MUST be present as a `part` in `LogicalVehicleControlSystem` (or the system-specific equivalent).
5. Every logical component MUST appear in ARC-05 (Level 2) with a brief description and its key interfaces listed.

---

## §5 Modeling Procedure

1. **Review the Functional Architecture (SM-PRD-18).** Extract the complete list of `action def` elements, identifying functional clusters that are cohesive and loosely coupled. These clusters become the logical components. Aim for 5–10 top-level logical components for a system of typical complexity.

2. **Identify the coupling strategy with the Base Architecture (SM-PRD-07).** If the Base Architecture already defines component types that the Logical Architecture refines, use strong coupling: `part def LogicalX :> BaseX`. If the Logical Architecture is independent, use loose coupling via `allocation def`. Document this decision in ARC-09.

3. **Define logical component types (`part def`).** For each identified cluster, create a `part def` with: (a) typed `port` usages for each interface, (b) `attribute` declarations for key non-functional properties (e.g., `safetyIntegrityLevel`, `processingCapacity`). Avoid specific values — those belong in Product Architecture (SM-PRD-21).

4. **Define port and interface types (`port def`, `interface def`).** For each distinct interface protocol or data flow, create a `port def` with direction (conjugate `~` for receiving end) and relevant attributes (e.g., `dataRate`, `protocol`). Group related ports into `interface def` when reuse across multiple components is expected.

5. **Assemble the logical system structure.** Create `part def LogicalSystem :> BaseSystem` (or the project-specific name), add `part` usages for all logical components, and establish `connect` statements for all required interactions. Validate that every external interface from SM-PRD-11 is represented as a port on the boundary of `LogicalSystem`.

6. **Create functional allocation blocks.** Create one or more `allocation def` blocks mapping each `action def` from SM-PRD-18 to its logical host component. Ensure the allocation is complete — every functional element has exactly one allocation target.

7. **Validate with Scenarios (SM-PRD-22).** Before finalizing, trace at least three representative Use Case Activities (SM-PRD-14) through the Logical Architecture. Each trace should produce a sequence of part interactions; missing interactions or ports reveal gaps in the architecture.

8. **Populate arc42.** Write the logical decomposition rationale in ARC-04 (Solution Strategy), add each logical component as a Level 2 building block in ARC-05 with a one-paragraph description and interface table, and record key architectural decisions in ARC-09 (e.g., coupling strategy, protocol choices).

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Coupling of System Architectures](../../sysmod/tools/coupling-system-architectures.md) | Tool 11.7 | **Before step 1** — decide whether to use strong coupling (`part def Logical :> Base`) or loose coupling (`allocation def`) between the Base Architecture and Logical Architecture; document the decision in ARC-09 |
| [Proxy versus Full Port](../../sysmod/tools/proxy-versus-full-port.md) | Tool 11.4 | **Step 4 (port definition)** — use proxy ports (`port def`) exclusively; bind proxy ports to internal structural parts via `connect`; avoids BOM ambiguity and keeps all structural parts as `part` usages |
| [Zigzag Pattern](../../sysmod/tools/zigzag-pattern.md) | Tool 11.6 | **Step 1 (component identification)** — recognize that deriving logical components from functional elements always surfaces new, lower-level requirements; capture these derived requirements in SM-PRD-10 and document the Base Architecture assumption behind them (ARC-02) |
