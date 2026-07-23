---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Product Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product Product Architecture (SM-PRD-21).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Product Architecture (SM-PRD-21)

The Product Architecture is the most concrete and detailed structural architecture in the SYSMOD system model — it represents the actual physical design of the system as it will be built. It concretizes the Logical Architecture (SM-PRD-20) by replacing general logical concepts with specific, vendor-qualified components bearing full attribute values (part numbers, dimensions, electrical specs). The next level of detail — software model, CAD geometry, circuit schematic — is explicitly out of scope in SYSMOD and is owned by domain-specific engineering disciplines.

## §1 SysMod Definition

**Product ID:** SM-PRD-21  
**SYSMOD §:** 5.21  
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)  
**Creating Method:** [4.19 Model the Product Architecture](../../sysmod/methods/model-product-architecture.md) (SM-MTH-19)  
**Responsible Role:** [System Architect](../../sysmod/roles/system-architect.md)

### Purpose

The Product Architecture translates the technology-neutral Logical Architecture into a fully specified, procurement-ready structural decomposition. Its purposes are: (1) provide the definitive bill-of-materials reference for all hardware and software components; (2) specify physical interface contracts (connectors, bus protocols, signal levels) that enable subsystem design; (3) serve as the integration reference for the Test Architecture (SM-PRD-24); and (4) anchor requirement satisfaction — every functional and non-functional requirement must be traceable to a specific product component attribute or interface.

### Role in Process

In the Architecture process (SM-PRC-2), Method 4.19 (Model the Product Architecture) is executed after the Logical Architecture (SM-PRD-20) has been validated by at least one round of Scenarios (SM-PRD-22). The System Architect concretizes each logical component into one or more product components, assigns full attribute values, selects physical connectors and bus protocols, and establishes physical connections. The Product Architecture is the final SYSMOD architecture deliverable before handover to subsystem design teams and test engineering.

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Logical Architecture | SM-PRD-20 | Each logical component is specialized or allocated to a product component |
| 2 | Requirements | SM-PRD-10 | Non-functional requirements drive attribute values (mass, power, speed, accuracy) |
| 3 | Domain Knowledge | SM-PRD-15 | Vendor catalogues, technology standards, and component libraries inform selection |
| 4 | Scenarios | SM-PRD-22 | Scenario traces reveal interface requirements not visible in the static structure |
| 5 | System Context | SM-PRD-11 | External interfaces must be realized as specific physical connectors and protocols |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Test Cases | SM-PRD-16 | Test Cases are executed against product components; acceptance criteria reference attribute values |
| 2 | Scenarios | SM-PRD-22 | Concrete scenarios use product component instances for detailed verification walkthroughs |
| 3 | Test Architecture | SM-PRD-24 | The Product Architecture defines the System Under Test (SUT); test equipment connects to product ports |

### Dependencies

- **SM-PRD-20 (Logical Architecture):** Primary input. Each `part def` in the Product Architecture MUST specialize or be allocated from a logical component. Strong coupling uses `part def ProductX :> LogicalX`; loose coupling uses `allocation def LogicalToProduct`.
- **SM-PRD-10 (Requirements):** All attribute values in product `part def` elements MUST be traceable to requirements via `satisfy`. Unmet requirements at this stage represent design gaps.
- **SM-PRD-22 (Scenarios):** Scenarios validated against the Logical Architecture may trigger revisions to the Product Architecture before it is finalized.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Concrete product component | `part def` with full `attribute` values | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Each product component is fully specified; values are final (vendor-qualified) |
| Product system assembly | `part def ProductSystem :> LogicalSystem` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Encapsulates product component instances; specializes logical system |
| Physical interface point | `port def` with protocol attributes | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Captures specific connector type, bus protocol, and electrical characteristics |
| Physical connection | `connection def` | [SML-DEF-ConnDef](../../sysml2/concepts/connection-definition.md) | Formalizes the wire/bus/link between two physical port instances |
| Logical-to-product allocation | `allocation def` | [SML-DEF-AllocDef](../../sysml2/concepts/allocation-definition.md) | Maps logical components to product components when strong coupling is not used |
| Requirement satisfaction | `satisfy` | [SML-USG-Satisfy](../../sysml2/concepts/satisfy.md) | Links product component attributes to the requirements they satisfy |
| Internal block structure | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Shows the internal block diagram of the product assembly |
| Component instances | `part` (part usage) | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Named instances of product `part def` types within the assembly |

### Modeling Pattern

```sysml
package VehicleSystem_ProductArchitecture {

  // Strong coupling: Product component specializes its Logical counterpart (SM-PRD-20)
  part def VCS_ECU_v2 :> LogicalECU {
    attribute vendor      : String  = "Bosch";
    attribute partNumber  : String  = "VCS-ECU-2024-A";
    attribute clockSpeed  : Real    = 400.0;  // MHz
    attribute flashMemory : Real    = 8.0;    // MB
    attribute ramMemory   : Real    = 1.0;    // MB
    attribute supplyVoltage : Real  = 12.0;   // V
    attribute operatingTempMin : Real = -40.0; // °C
    attribute operatingTempMax : Real = 85.0;  // °C

    port can1       : CANFDPort { attribute busSpeed : Real = 5.0; }   // Mbps
    port can2       : CANFDPort { attribute busSpeed : Real = 5.0; }
    port debugPort  : JTAGPort;
    port powerIn    : PowerPort { attribute nominalVoltage : Real = 12.0; }
  }

  part def VCS_BrakeSensor_FL :> LogicalSensorInterface {
    attribute vendor            : String = "Continental";
    attribute position          : String = "front-left";
    attribute measurementRange  : Real   = 300.0;  // km/h
    attribute accuracy          : Real   = 0.1;    // km/h
    attribute outputProtocol    : String = "CAN FD";

    port canPort    : CANFDPort;
    port powerIn    : PowerPort;
  }

  part def VCS_CANFDBus :> LogicalCommunicationBus {
    attribute busLength : Real    = 10.0;  // meters
    attribute terminationResistance : Real = 120.0; // Ohm
    port port1 : ~CANFDPort;
    port port2 : ~CANFDPort;
    port port3 : ~CANFDPort;
  }

  port def CANFDPort {
    attribute busSpeed    : Real;   // Mbps
    attribute frameFormat : String = "ISO 11898-1";
  }

  port def JTAGPort   { attribute pinCount : Integer = 20; }
  port def PowerPort  { attribute nominalVoltage : Real; attribute maxCurrent : Real; }

  // Product assembly — specializes the Logical System
  part def VehicleControlSystem_Product :> LogicalVehicleControlSystem {
    part mainECU  : VCS_ECU_v2;
    part sensorFL : VCS_BrakeSensor_FL;
    part canBus   : VCS_CANFDBus;

    connect mainECU.can1        to canBus.port1;
    connect sensorFL.canPort    to canBus.port2;
  }

  // Requirement satisfaction: attribute values satisfy non-functional requirements
  satisfy req REQ_PROC_001 by VCS_ECU_v2::clockSpeed;
  satisfy req REQ_TEMP_001 by VCS_ECU_v2::operatingTempMin;
  satisfy req REQ_TEMP_001 by VCS_ECU_v2::operatingTempMax;
}
```

### Recommended Package Structure

```
<System>_Architecture/
  product/
    <System>_ProductArchitecture.sysml       ← Main product part def assembly
    <System>_ProductComponents.sysml         ← Individual product part def elements
    <System>_ProductInterfaces.sysml         ← Concrete port def and connection def types
    <System>_LogicalToProductAllocation.sysml ← allocation def blocks (SM-PRD-20 → SM-PRD-21)
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Building Block View](../../arc42/sections/building-block-view.md) (Level 3) | ARC-05 | **Mandatory** | Concrete component specifications; full bill-of-materials structure; physical interfaces and connections |
| [Deployment View](../../arc42/sections/deployment-view.md) | ARC-07 | **Mandatory** | Hardware topology — nodes (ECUs, sensors, actuators), communication links, power distribution |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | **Mandatory** | Key concretization decisions: component selection rationale, coupling strategy (strong vs. loose), vendor choices |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Recommended | How the product architecture realizes the logical architecture; trade-off decisions made during concretization |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | Recommended | Quality scenarios verifiable at product level (e.g., response time, availability, environmental tolerance) |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-19 | Physical Architecture [abstract] | `refines` | Product Architecture is a concrete child of Physical Architecture |
| SM-PRD-20 | Logical Architecture | `refines` | Product components specialize or are allocated from logical components |
| SM-PRD-10 | Requirements | `depends_on` | Attribute values in product components must satisfy non-functional requirements |
| SM-PRD-22 | Scenarios | `depends_on` | Scenario revision feedback may trigger changes to product component interfaces |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-16 | Test Cases | `implements` | Test Cases test product components against their attribute specifications |
| SM-PRD-22 | Scenarios | `implements` | Concrete scenarios use product component instances as lifelines |
| SM-PRD-24 | Test Architecture | `implements` | Product Architecture defines the System Under Test for the Test Architecture |
| ARC-05 | Building Block View | `documents` | Product components appear as Level 3 building blocks in arc42 |
| ARC-07 | Deployment View | `documents` | Physical hardware topology with products nodes and links |

### Traceability Rules

1. Every product `part def` MUST specialize (directly or transitively) the corresponding logical `part def` from SM-PRD-20, OR be covered by an `allocation def LogicalToProduct`.
2. Every non-functional requirement in SM-PRD-10 MUST be satisfied by at least one `attribute` value or `port def` property in a product `part def`, expressed using `satisfy`.
3. Every product component MUST appear in ARC-05 (Level 3) with its vendor, part number, and key interface summary.
4. Every external interface in SM-PRD-11 MUST be realized as a specific physical port on the outermost `part def` of the product assembly, with protocol attributes populated.
5. The product assembly `part def` MUST contain at least one `part` usage for each logical component in the corresponding `LogicalSystem`.

---

## §5 Modeling Procedure

1. **Prepare the concretization baseline.** Open the validated Logical Architecture (SM-PRD-20). For each logical `part def`, create a corresponding product `part def` in `<System>_ProductComponents.sysml`. Decide per component whether to use strong coupling (`part def ProductX :> LogicalX`) or loose coupling (documented allocation). Record decisions in ARC-09.

2. **Assign concrete attribute values.** For each product `part def`, populate all `attribute` declarations with vendor-qualified values sourced from datasheets and SM-PRD-15 (Domain Knowledge). Include: vendor name, part number, all dimensions/speeds/tolerances that appear in SM-PRD-10 (Requirements). Leave no attribute unset that has a traceable requirement.

3. **Define physical interface types (`port def`).** Replace or specialize abstract logical port types with concrete physical port definitions. For each port, add: connector standard, bus protocol, signal levels, and timing attributes. Create `connection def` types for each physical link technology used (e.g., CAN FD, Ethernet, analog signal).

4. **Assemble the product system.** Create `part def <System>_Product :> Logical<System>` (or project-specific name). Add `part` usages for all product components and `connect` statements for all physical links. Verify that every port on every `part` usage has exactly one connection — unconnected ports must be documented as intentional open interfaces.

5. **Add requirement satisfaction.** For every non-functional requirement in SM-PRD-10, add a `satisfy` statement referencing the specific attribute or port property that fulfils it. Run a traceability query to identify any requirements without a `satisfy` — these are design gaps that must be resolved.

6. **Create logical-to-product allocation blocks.** For components using loose coupling, create `allocation def LogicalToProduct` blocks mapping each logical `part def` to its product `part def` counterpart. Ensure every logical component has at least one allocation target.

7. **Validate with Scenarios (SM-PRD-22).** Re-execute the scenario traces from SM-PRD-22 using product component instances. Verify that: (a) all message paths are physically realizable (ports exist), (b) all timing attributes are consistent with scenario timing requirements, and (c) no new components are needed.

8. **Populate arc42 sections.** Write Level 3 building blocks in ARC-05 (one sub-section per major product component with attributes table). Draw the deployment topology in ARC-07 (hardware nodes and communication links). Record concretization decisions in ARC-09.

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Variant Modeling](../../sysmod/tools/variant-modeling.md) | Tool 11.5 | **During step 1 (concretization baseline)** — if the system ships in multiple hardware configurations, use VAMOS variation points at the product level: a shared `ProductBase part def` with `variant` sub-defs for each configuration; variation points replace concrete `attribute` values with bound variant-specific values, keeping the common assembly structure identical across all configurations |
