---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Domain Knowledge
description: Full SysML v2 and arc42 mapping for SYSMOD product Domain Knowledge (SM-PRD-15).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Domain Knowledge (SM-PRD-15)

Domain Knowledge specifies all data entities and physical objects ("domain objects") that the system consumes and produces — effectively the concept model and data model of the system. It defines the shared vocabulary of typed items, value types, physical units, and enumerated constants used across all other analysis and architecture artifacts. Domain blocks are fully typed with ISO physical quantities from SysML's ISQ standard library.

## §1 SysMod Definition

**Product ID:** SM-PRD-15
**SYSMOD §:** 5.15
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.15 Model the Domain Knowledge](../../sysmod/methods/model-domain-knowledge.md) (SM-MTH-15)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose
Domain Knowledge captures the shared data vocabulary of the system under analysis. It ensures that all disciplines — systems engineers, software developers, hardware engineers — use precisely the same types and units when referring to system inputs and outputs. It is the single source of truth for item types referenced in Use Case Activities, Functional Architecture, Logical Architecture, and Product Architecture.

### Role in Process
In the Analysis process (SM-PRC-1), Domain Knowledge is produced concurrently with Use Case Activities (SM-PRD-14) in an iterative loop. As activities are modeled, new domain objects are discovered and added here. The completed domain knowledge model then feeds into all architecture phases (SM-PRC-2) where physical and logical components are typed using these definitions.

### Inputs

| # | Artifact | ID | Description |
|---|----------|----|-------------|
| 1 | Use Case Activities | SM-PRD-14 | Object flows in activities reveal the required item types |
| 2 | System Context | SM-PRD-11 | External interface definitions introduce boundary data types |
| 3 | Requirements | SM-PRD-10 | Functional requirements reference domain terms that need formalization |

### Outputs / Dependent Artifacts

| # | Artifact | ID | How Used |
|---|----------|----|----------|
| 1 | Use Case Activities | SM-PRD-14 | Item types used as action flow ports and parameters |
| 2 | Functional Architecture | SM-PRD-18 | Port types and flow definitions typed by domain entities |
| 3 | Logical Architecture | SM-PRD-20 | Logical interface types derived from domain definitions |
| 4 | Product Architecture | SM-PRD-21 | Physical interface types derived from domain definitions |
| 5 | arc42 Glossary | ARC-12 | All domain terms and definitions populate the architecture glossary |

### Dependencies
- **Circular with:** SM-PRD-14 (Use Case Activities) — domain objects are discovered iteratively during activity modeling.
- **Informed by:** SM-PRD-11 (System Context) — boundary objects (external interfaces) introduce initial domain terms.
- **Consistency required with:** SM-PRD-10 (Requirements) — requirements use domain vocabulary that must be formalized here.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Concept | SysML v2 Element | Node ID | Rationale |
|----------------|-----------------|---------|-----------|
| Domain data entity | `item def` | [SML-DEF-ItemDef](../../sysml2/concepts/item-definition.md) | Items model data/material flowing between system functions |
| Physical composite object | `part def` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Composite domain objects with structural sub-parts |
| Typed numeric property | `attribute def` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Value-typed properties with mandatory physical units |
| Enumerated state / mode | `enum def` | — | Discrete value sets (e.g., operating modes, brake types) |
| Typed flow channel | `flow def` | [SML-DEF-FlowDef](../../sysml2/concepts/flow.md) | Typed flow carriers for use in port and connection definitions |
| Domain model diagram | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | Visualizes domain entity relationships, attributes, and generalizations |
| Domain package | `package` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all domain definitions for the system |

### Modeling Pattern

```sysml
package VehicleSystem_DomainKnowledge {

  // ── Value types (with ISO physical quantities) ───────────────────────────
  attribute def Speed        { value : ISQ::Speed; }
  attribute def Acceleration { value : ISQ::Acceleration; }
  attribute def Force        { value : ISQ::Force; }
  attribute def Duration     { value : ISQ::Time; }

  // ── Enumerations ─────────────────────────────────────────────────────────
  enum def BrakingMode  { emergency, normal, abs }
  enum def SystemState  { off, standby, operational, fault }
  enum def RoadSurface  { dry, wet, icy, gravel }

  // ── Domain data entities (item defs) ────────────────────────────────────
  item def BrakingCommand {
    doc /* Command sent to the brake actuator subsystem */
    attribute targetDeceleration : Acceleration;
    attribute brakingMode        : BrakingMode;
  }

  item def WheelSpeedData {
    doc /* Raw speed readings from all four wheel sensors */
    attribute wheelSpeeds : Speed[4]; // front-left, front-right, rear-left, rear-right
    attribute timestamp   : Duration;
  }

  item def BrakePedalInput {
    doc /* Physical input from the driver's brake pedal */
    attribute travel : Real;  // normalized 0.0–1.0
    attribute force  : Force;
  }

  // ── Flow definitions (typed channels for port/connection typing) ─────────
  flow def BrakingFlow    { : BrakingCommand; }
  flow def SpeedDataFlow  { : WheelSpeedData; }
  flow def PedalInputFlow { : BrakePedalInput; }
}
```

### Recommended Package Structure

```
<System>_Analysis/
  domain_knowledge/
    <System>_DomainKnowledge.sysml     ← item defs, attribute defs, enum defs, flow defs
    <System>_DomainDiagrams.sysml      ← definition diagram views
```

---

## §3 arc42 Mapping

| arc42 Section | Node ID | Usage | Mandatory? |
|---------------|---------|-------|-----------|
| [Glossary](../../arc42/sections/glossary.md) | ARC-12 | All domain terms (`item def`, `enum def`, `attribute def`) are listed with plain-language definitions, units, and valid ranges | **MANDATORY** |
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | Data model overview: entity relationships, value typing conventions, unit standards, enumeration semantics | Optional |
| [Context and Scope](../../arc42/sections/context-and-scope.md) | ARC-03 | Boundary data types (items crossing the system boundary in ARC-03 context diagram) described using domain definitions | Optional |

**Placement guidance:** Each `item def` becomes one glossary entry in ARC-12, with its typed attributes listed. The `flow def` types are described in ARC-08 as the system's canonical data exchange formats. Boundary items from SM-PRD-11 appear in ARC-03 with types referencing this domain model.

---

## §4 Traceability

### Incoming Links

| From Node | ID | Relationship | Description |
|-----------|----|--------------|-------------|
| Use Case Activities | SM-PRD-14 | `depends_on` | Activities drive discovery of required item types (circular) |
| System Context | SM-PRD-11 | `depends_on` | Boundary data objects introduce initial domain vocabulary |
| Requirements | SM-PRD-10 | `refines` | Functional requirements reference domain terms formalized here |

### Outgoing Links

| To Node | ID | Relationship | Description |
|---------|----|--------------|-------------|
| Use Case Activities | SM-PRD-14 | `implements` | Item types used in action flow port and parameter definitions |
| Functional Architecture | SM-PRD-18 | `implements` | Port types and flow definitions derived from domain entities |
| Logical Architecture | SM-PRD-20 | `implements` | Logical interface types typed by domain definitions |
| Product Architecture | SM-PRD-21 | `implements` | Physical interface types typed by domain definitions |
| ARC-12 Glossary | ARC-12 | `documents` | Domain terms populate the architecture glossary |
| ARC-08 Cross-cutting Concepts | ARC-08 | `documents` | Data model described as a cross-cutting architectural concept |

### Traceability Rules

1. Every `item def` MUST carry a `doc` string with a plain-language definition suitable for arc42 ARC-12 verbatim inclusion.
2. Every `attribute def` used for physical quantities MUST reference an ISQ quantity type from the SysML standard library.
3. Every `flow def` MUST correspond to exactly one `item def` carried by that flow.
4. Every data object appearing in a Use Case Activity object flow (SM-PRD-14) MUST have a corresponding `item def` in this package.
5. No item type used in SM-PRD-18, SM-PRD-20, or SM-PRD-21 may exist outside this package without a cross-reference here.

---

## §5 Modeling Procedure

1. **Bootstrap from System Context** — extract all data objects crossing the system boundary from SM-PRD-11 (context diagram external interface labels); define these as the initial `item def` set.
2. **Iterate with Use Case Activities** — for each UCA sub-function boundary in SM-PRD-14, identify unnamed data objects; add them as `item def` entries with `doc` strings if not already present.
3. **Define value types** — for each numerical attribute, create a typed `attribute def` referencing the appropriate ISQ quantity (e.g., `ISQ::Speed`, `ISQ::Force`); note the SI unit and valid range in the `doc` string.
4. **Define enumerations** — for each discrete state, mode, or category, create an `enum def`; document each literal value with its engineering meaning.
5. **Create `flow def` entries** — for every item type used as a data flow between system functions, define a matching `flow def` to enable typed port and connection definitions in SM-PRD-18 and SM-PRD-20.
6. **Populate arc42 ARC-12 Glossary** — for each `item def` and `enum def`, write a plain-language glossary entry including the unit and valid range where applicable; copy the `doc` string as the starting point.
7. **Create Definition Diagram (SML-DGM-DefDiag)** — generate a diagram view showing domain entity relationships (associations, compositions, generalizations, attribute types).
8. **Validate cross-references** — verify that all item types referenced in SM-PRD-14, SM-PRD-18, SM-PRD-20, and SM-PRD-21 resolve to definitions in this package; log missing types as open items.

---

*See also:* [OKF Ontology](../okf-ontology.md) · [Use Case Activities cross-mapping](use-case-activities.md) (SM-PRD-14) · [Functional Architecture cross-mapping](functional-architecture.md) (SM-PRD-18)
