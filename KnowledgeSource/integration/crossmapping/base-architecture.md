---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Base Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product Base Architecture (SM-PRD-07).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Base Architecture (SM-PRD-07)

The Base Architecture captures pre-set, non-negotiable structural and technological decisions that constrain all subsequent design work. It represents given platform choices, fixed interfaces, prescribed components, and mandatory constraints imposed before the analysis process begins. Every element of the Base Architecture becomes an architectural constraint in arc42 and a `constraint def` or fixed `part def` in SysML v2.

## §1 SysMod Definition

**Product ID:** SM-PRD-07
**SYSMOD §:** 5.7
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.7 Describe the Base Architecture](../../sysmod/methods/describe-base-architecture.md) (SM-MTH-07)
**Responsible Role:** [System Architect](../../sysmod/roles/system-architect.md)

### Purpose

The Base Architecture defines the architectural starting point imposed by stakeholders, standards, existing product families, or platform decisions made outside the current system development scope. It documents which structural and technological choices are fixed inputs — not design outputs — so that engineers working on Functional and Physical Architecture know what is already decided.

### Role in Process

Within the Analysis process (SM-PRC-1), the Base Architecture is created early to bound the solution space. It feeds directly into the System Context (SM-PRD-11), Logical Architecture (SM-PRD-20), and Product Architecture (SM-PRD-21), ensuring those products respect fixed constraints rather than rediscovering them during design.

### Inputs

| # | Input Product | ID | Description |
|---|---------------|----|-------------|
| 1 | Problem Statement | SM-PRD-04 | Defines the problem context and situational constraints |
| 2 | System Idea | SM-PRD-05 | Provides the envisioned solution concept |
| 3 | System Objectives | SM-PRD-06 | Establishes measurable goals that constrain architectural decisions |

### Outputs / Dependent Artifacts

| # | Dependent Product | ID | Relationship |
|---|-------------------|----|--------------|
| 1 | System Context | SM-PRD-11 | Generalizes or incorporates base structure as system boundary anchor |
| 2 | Logical Architecture | SM-PRD-20 | Specializes (`part def :>`) or allocates from Base Architecture |
| 3 | Product Architecture | SM-PRD-21 | Realizes physical constraints given by Base Architecture |

### Dependencies

The Base Architecture depends on SM-PRD-04 (Problem Statement) for constraint context, SM-PRD-05 (System Idea) for the envisioned solution approach, and SM-PRD-06 (System Objectives) for the measurable goals that validate architectural choices. It has no dependencies on downstream analysis products (SM-PRD-08 through SM-PRD-12).

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Base system structure (fixed platform) | `part def BaseSystem { ... }` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Top-level preset structure; `part def` captures fixed component decomposition |
| Pre-set hardware component | `part <name> : <Type>` inside `part def` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Fixed physical components allocated at base level |
| Mandatory constraint (voltage, timing, bus) | `constraint def <Name> { doc /.../ }` | [SML-DEF-ConstrDef](../../sysml2/concepts/constraint-definition.md) | Non-negotiable constraints encoded as formal constraint definitions |
| Fixed attribute (platform, bus type, frequency) | `attribute <name> : <Type> = <value>;` | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | Fixed values documented as typed attributes on the base `part def` |
| Given technical assignment | `allocation def <AllocName>` | [SML-DEF-AllocDef](../../sysml2/concepts/allocation-definition.md) | Pre-defined allocations between functions and platform components |
| Constraint rationale / provenance | `metadata def BaseConstraintMeta { ... }` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Captures source, rationale, and waiverability of each constraint |
| Structural diagram of base system | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Visualizes `part def` tree and constraint annotations for stakeholder review |

### Modeling Pattern

```sysml
package VehicleControlSystem_BaseArchitecture {

  metadata def BaseConstraintMeta {
    attribute source      : String;   // e.g., "Platform Decision 2024-Q1"
    attribute rationale   : String;
    attribute waiverable  : Boolean;
  }

  part def BaseSystem {
    attribute platform         : String = "ARM Cortex-M7";
    attribute communicationBus : String = "CAN FD";
    attribute supplyVoltage    : Real   = 12.0; // Volts nominal

    part ecu          : ElectronicControlUnit;
    part powerSupply  : PowerModule;
    part commsGateway : CANGateway;
  }

  part def ElectronicControlUnit {
    attribute clockSpeed : Real = 400.0; // MHz
    attribute flashSize  : Real = 2.0;   // MB
  }

  part def PowerModule {
    attribute outputVoltage : Real = 3.3; // V regulated
  }

  part def CANGateway {
    attribute busSpeed : Real = 5.0; // Mbit/s (CAN FD)
  }

  constraint def OperatingVoltageConstraint {
    doc /* Supply voltage must be 12 V nominal ±10% (10.8 V – 13.2 V) */
    @BaseConstraintMeta {
      source     = "HW Platform Spec v2.3 §4.1";
      rationale  = "Automotive 12 V board net standard";
      waiverable = false;
    }
  }

  constraint def BusProtocolConstraint {
    doc /* All intra-ECU communication shall use CAN FD at 5 Mbit/s */
    @BaseConstraintMeta {
      source     = "System Integration Standard §2.7";
      rationale  = "Legacy compatibility with existing ECU network";
      waiverable = false;
    }
  }

  allocation def ECUFunctionAllocation {
    doc /* Braking control function pre-allocated to ElectronicControlUnit */
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
└── base_architecture/
    └── <System>_BaseArchitecture.sysml   # Contains part defs, constraint defs, allocation defs, metadata defs
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory? | Content Mapped from SM-PRD-07 |
|---|---|---|---|
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | **Mandatory** | Every `constraint def` and fixed `attribute` becomes an architecture constraint; table with ID, constraint text, background, scope |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Each `allocation def` and platform choice documented as an ADR with context, decision, rationale, and consequences |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | Optional | Base system `part def` hierarchy provides seed for Level 1 whitebox description |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Optional | Platform and bus decisions summarize the technical strategy |

**ARC-02 Constraint Table format:**

| Constraint ID | Constraint | Background | Scope |
|---|---|---|---|
| BA-C-01 | Supply voltage 12 V ±10% | Automotive 12 V board net standard (HW Platform Spec v2.3) | All HW components |
| BA-C-02 | CAN FD at 5 Mbit/s | Integration with existing ECU network (Integration Standard §2.7) | All ECU-to-ECU interfaces |
| BA-C-03 | ARM Cortex-M7 platform | Pre-selected by product management | Main ECU compute node |

---

## §4 Traceability

### Incoming Links

| Source Product | ID | Link Type | Description |
|---|---|---|---|
| Problem Statement | SM-PRD-04 | `depends_on` | Base Architecture derived from the problem context and situational constraints |
| System Idea | SM-PRD-05 | `depends_on` | Solution concept informs which platform and bus choices are applicable |
| System Objectives | SM-PRD-06 | `depends_on` | Objectives validate that base constraints do not block goal achievement |

### Outgoing Links

| Target Product | ID | Link Type | Description |
|---|---|---|---|
| System Context | SM-PRD-11 | `refines` | System Context generalizes the base structure; external actors added around the base system |
| Logical Architecture | SM-PRD-20 | `implements` | Logical root specializes Base with `part def LogicalSystem :> BaseSystem` (strong) or allocates (loose) |
| Product Architecture | SM-PRD-21 | `implements` | Physical realization must satisfy all `constraint def` entries |
| arc42 ARC-02 | ARC-02 | `documents` | All Base Architecture constraints populate the Architecture Constraints section |
| arc42 ARC-09 | ARC-09 | `documents` | Platform and allocation decisions populate Architecture Decisions as ADRs |

### Traceability Rules

1. Every `constraint def` in the Base Architecture package MUST have a corresponding row in ARC-02.
2. Every `allocation def` in the Base Architecture MUST have a corresponding ADR in ARC-09.
3. If the Logical Architecture uses `part def LogicalSystem :> BaseSystem`, the link MUST be recorded as `implements` (strong coupling) in the cross-mapping ontology.
4. If the Logical Architecture uses `allocation` instead of generalization, record as `refines` (loose coupling) with rationale in ARC-09.
5. No Base Architecture element may be overridden by downstream products without a recorded waiver in ARC-09.

---

## §5 Modeling Procedure

1. **Collect given decisions.** Interview the System Architect and review platform specifications, product family standards, and integration standards to enumerate all pre-set structural and technological decisions. These are the inputs, not outputs, of system design.
2. **Classify each decision.** Assign each decision to one of: fixed component (→ `part def`), mandatory constraint (→ `constraint def`), given allocation (→ `allocation def`), or fixed property value (→ `attribute`).
3. **Create the base `part def`.** Define `part def BaseSystem` with all fixed `attribute` values (platform name, bus type, voltage, frequency) and nested `part` usages for each mandatory hardware component.
4. **Define `constraint def` for each hard constraint.** For every non-negotiable constraint (voltage range, timing budget, communication protocol), create a `constraint def` with a `doc` string and annotate with `@BaseConstraintMeta` capturing source document reference, rationale, and `waiverable = false`.
5. **Define `allocation def` entries.** For each pre-assigned function-to-hardware allocation, create an `allocation def` in the package. These represent externally mandated allocations that the Logical Architecture must respect.
6. **Create the `metadata def BaseConstraintMeta`.** Ensure every `constraint def` and `allocation def` is annotated with source reference, rationale, and waiverability flag to enable traceability audits and design reviews.
7. **Draw the Definition Diagram (SML-DGM-DefDiag).** Visualize the `part def` hierarchy with all constraints shown as notes or annotations. Present this diagram to stakeholders for sign-off before proceeding to downstream analysis.
8. **Populate ARC-02.** Transfer every `constraint def` to the arc42 Architecture Constraints section (ARC-02) using the standard table format: Constraint ID, constraint text, background/source, and scope.
9. **Write ADRs for platform and allocation decisions (ARC-09).** For each major platform or allocation decision, draft an Architecture Decision Record with context, decision, rationale, and consequences. Reference the corresponding `constraint def` or `allocation def` by name.
10. **Link to downstream products.** Decide — together with the Logical Architecture designer — whether `part def LogicalSystem :> BaseSystem` (strong coupling) or `allocation` (loose coupling) is appropriate, and record the decision with rationale in ARC-09 before SM-PRD-20 modeling begins.

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Variant Modeling](../../sysmod/tools/variant-modeling.md) | Tool 11.5 | **During step 2–3 (constraint classification)** — if the Base Architecture must accommodate multiple product variants, use VAMOS variation points (variation elements and variant usages) to model commonality and variability; each variant shares the `BaseSystem` common core but overrides variant-specific `attribute` values or `constraint def` bounds |
