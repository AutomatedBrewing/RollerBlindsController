---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Requirements
description: Full SysML v2 and arc42 mapping for SYSMOD product Requirements (SM-PRD-10).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Requirements (SM-PRD-10)

Requirements specify what the system must do and the qualities it must exhibit, without prescribing the solution. In SysML v2, requirements are modeled as `requirement def` types with nested `requirement` usages for hierarchical decomposition. `satisfy` links connect design elements to the requirements they fulfill; `verify` links connect test cases to the requirements they validate. Requirements trace to stakeholder concerns (SM-PRD-08) and inform use cases (SM-PRD-12), system context (SM-PRD-11), and logical architecture (SM-PRD-20).

## §1 SysMod Definition

**Product ID:** SM-PRD-10
**SYSMOD §:** 5.10
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.10 Model Requirements](../../sysmod/methods/model-requirements.md) (SM-MTH-10)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose

The Requirements product provides the complete, structured set of conditions the system must satisfy to be accepted by its stakeholders. It serves as the central hub of SYSMOD analysis: every design product (Logical Architecture, Product Architecture) must demonstrate satisfaction via `satisfy` links, and every test product (Test Cases SM-PRD-16) must demonstrate verification via `verify` links. Requirements are the primary contractual artifact between stakeholders and the development team.

### Role in Process

Requirements are the primary output of the Analysis process (SM-PRC-1) and the key input to all downstream design and verification activities. The Requirements product bridges stakeholder concerns (SM-PRD-08) — expressed as natural-language concerns — to formal, verifiable statements that guide the Functional Architecture (SM-PRD-18), Logical Architecture (SM-PRD-20), and Test Cases (SM-PRD-16).

### Inputs

| # | Input Product | ID | Description |
|---|---------------|----|-------------|
| 1 | Problem Statement | SM-PRD-04 | Problem context and operational need establishing the requirements universe |
| 2 | System Idea | SM-PRD-05 | Solution concept providing scope boundary for requirements |
| 3 | System Objectives | SM-PRD-06 | Measurable goals that requirements must collectively demonstrate |
| 4 | Stakeholders | SM-PRD-08 | Stakeholder concerns that are the authoritative source of all requirements |

### Outputs / Dependent Artifacts

| # | Dependent Product | ID | Relationship |
|---|-------------------|----|--------------|
| 1 | System Context | SM-PRD-11 | Interface requirements drive external actor identification in the context model |
| 2 | System Use Cases | SM-PRD-12 | Functional requirements expressed as use case triggers, results, and acceptance criteria |
| 3 | Use Case Activities | SM-PRD-14 | Functional requirements decomposed into activity-level behavioral flows |
| 4 | Test Cases | SM-PRD-16 | Each verifiable requirement must have at least one test case linked via `verify` |
| 5 | Logical Architecture | SM-PRD-20 | Each `part def` must `satisfy` the relevant requirements |

### Dependencies

Requirements depend on all upstream Analysis products: SM-PRD-04 for problem context, SM-PRD-05 for solution scope, SM-PRD-06 for measurable objectives, and SM-PRD-08 for stakeholder concerns. Additionally, SM-PRD-09 (Risks) generates risk-driven requirements that supplement the stakeholder-derived set.

---

## §2 SysML v2 Mapping

### Definition vs. Usage — Critical Distinction

> **`requirement def`** is a **reusable template** (a type/classifier). It defines the shape of a requirement — subject type, parameter attributes, formal constraints. It is **never a specific project requirement by itself**.
>
> **`requirement` (usage)** is the **concrete application** of a template in a specific context. It binds the subject to a concrete entity and sets parameter values. **This is the actual project requirement.**
>
> A common mistake is writing `requirement def REQ_FN_001 { doc /.../ }` for a project-specific requirement. This works syntactically but misuses the definition-usage pattern: a `requirement def` with no reusable parameters or formal `require constraint` body is just an unbound usage. Use `requirement` (usage) instead, typed by the appropriate category `requirement def` template.

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Requirement category template | `requirement def FunctionalReq { subject s : SystemType; }` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | **Reusable template** defining the subject type and formal constraint structure for an entire category; defined once, reused by all usages in that category |
| Specific project requirement | `requirement <'REQ-FN-001'> emergencyBraking : FunctionalReq { doc /.../ }` | [SML-USG-ReqUSG](../../sysml2/concepts/requirement-usage.md) | **Concrete project requirement**; typed by a category template; carries the `doc` text, `@RequirementMeta`, and subject binding for this specific requirement |
| Requirement group (container) | `requirement def SystemRequirements { subject s : SystemType; requirement r1 : FunctionalReq; ... }` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Groups related requirement usages under a shared subject; enables cross-package decomposition via subject rebinding |
| Hierarchical decomposition (same package) | nested `requirement` usages inside a parent `requirement def`; sub-requirements inherit subject | [SML-USG-ReqUSG](../../sysml2/concepts/requirement-usage.md) | In-package decomposition: child requirement inherits the parent subject if no explicit `subject` declaration |
| Cross-package decomposition | import parent package; nest subsystem requirement usages with `subject redefines s = parent.subsystemPart` | [SML-USG-ReqUSG](../../sysml2/concepts/requirement-usage.md) | Cross-file decomposition: import the system-level package; create a subsystem group `requirement def` that rebinds the subject to the relevant subsystem `part` usage |
| Formal constraint (parametric) | `require constraint { subject.value <= param }` inside `requirement def` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Formal machine-evaluable predicate; use when the requirement can be expressed as a Boolean expression over attributes |
| Requirement attributes | `metadata def RequirementMeta { ... }` applied with `@RequirementMeta { ... }` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Structured traceability metadata on each requirement usage: source stakeholder, priority, verification method, rationale |
| Design-to-requirement link | `satisfy reqUsageName` in design `part def` | [SML-USG-Satisfy](../../sysml2/concepts/satisfy.md) | `satisfy` targets the **requirement usage** (the specific project requirement), not the `requirement def` template |
| Test-to-requirement link | `verify` in verification case | [SML-USG-VCaseUSG](../../sysml2/concepts/verification-case-usage.md) | Links test cases (SM-PRD-16) to the requirement usages they verify |
| Requirements visualization | Requirements Diagram | [SML-DGM-ReqDiag](../../sysml2/diagrams/requirements-diagram.md) | Displays hierarchy, `satisfy`, and `verify` links for review and audit |

### Modeling Pattern

```sysml
// ─────────────────────────────────────────────────────────────────────────────
// File 1: VehicleSystem_ReqTemplates.sysml
// Purpose: Defines reusable requirement category templates (requirement def).
//          These are types — NOT specific requirements.
// ─────────────────────────────────────────────────────────────────────────────
package VehicleSystem_ReqTemplates {

  // The system under design — used as subject type in templates
  part def VehicleSystem;

  // ── Category templates ────────────────────────────────────────────────────
  // Each template defines the subject type and optional formal constraint body.
  // Usages in other packages will instantiate these with concrete doc text.

  requirement def FunctionalReq {
    subject sys : VehicleSystem;
  }

  requirement def PerformanceReq {
    subject sys : VehicleSystem;
    attribute targetValue : Real;         // usages bind this to a literal
    attribute unit        : String;
  }

  requirement def SafetyReq {
    subject sys : VehicleSystem;
    attribute integrityLevel : String;    // e.g., "ASIL-D"
  }

  requirement def InterfaceReq {
    subject sys : VehicleSystem;
  }

  // ── Traceability metadata schema ──────────────────────────────────────────
  metadata def RequirementMeta {
    attribute source             : String;  // "SM-PRD-08: <StakeholderName>"
    attribute priority           : String;  // mandatory | high | medium | low
    attribute verificationMethod : String;  // test | analysis | inspection | demonstration
    attribute rationale          : String;
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// File 2: VehicleSystem_Requirements.sysml
// Purpose: Concrete project requirements — requirement usages typed by templates.
//          This file IS the Requirements product (SM-PRD-10).
// ─────────────────────────────────────────────────────────────────────────────
package VehicleSystem_Requirements {
  import VehicleSystem_ReqTemplates::*;

  // ── System-level requirement group ────────────────────────────────────────
  // Container groups all system requirements under a shared subject.
  requirement def SystemRequirements {
    subject sys : VehicleSystem;

    // Functional requirement — specific, concrete usage
    requirement <'REQ-FN-001'> emergencyBraking : FunctionalReq {
      doc /* The system shall apply maximum braking force within 150 ms
             of detecting brake pedal travel greater than 80%. */
      @RequirementMeta {
        source             = "SM-PRD-08: VehicleDriver";
        priority           = "mandatory";
        verificationMethod = "test";
        rationale          = "Safety-critical response time for emergency maneuvers";
      }
    }

    // Performance requirement — binds the parametric constraint values
    requirement <'REQ-PF-001'> responseTime : PerformanceReq {
      doc /* The system shall respond to driver input within 200 ms under
             all nominal operating conditions. */
      attribute :>> targetValue = 200;
      attribute :>> unit        = "ms";
      @RequirementMeta {
        source             = "SM-PRD-08: VehicleDriver";
        priority           = "high";
        verificationMethod = "measurement";
        rationale          = "Derived from driver perception threshold per ISO 9241-9";
      }
    }

    // Safety requirement with in-package decomposition
    requirement <'REQ-SF-001'> safetyIntegrity : SafetyReq {
      doc /* The system shall achieve ASIL-D safety integrity for the braking function. */
      attribute :>> integrityLevel = "ASIL-D";
      @RequirementMeta {
        source             = "SM-PRD-08: SafetyAuthority";
        priority           = "mandatory";
        verificationMethod = "analysis";
        rationale          = "Regulatory compliance per ISO 26262 Part 3";
      }
      // ── In-package decomposition: child inherits subject from parent ──
      requirement <'REQ-SF-001-1'> faultDetection : FunctionalReq {
        doc /* The system shall detect any single-point fault within 10 ms. */
      }
      requirement <'REQ-SF-001-2'> safeState : FunctionalReq {
        doc /* The system shall transition to safe state within 50 ms of fault detection. */
      }
    }

    // Interface requirement
    requirement <'REQ-IF-001'> canInterface : InterfaceReq {
      doc /* The system shall communicate with the Engine ECU using CAN FD
             at 5 Mbit/s per Interface Control Document v1.2. */
      @RequirementMeta {
        source             = "SM-PRD-08: SupplierECUTeam; SM-PRD-07: BusProtocolConstraint";
        priority           = "mandatory";
        verificationMethod = "inspection";
        rationale          = "Pre-existing integration standard";
      }
    }
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// File 3: BrakingSubsystem_Requirements.sysml  (CROSS-PACKAGE DECOMPOSITION)
// Purpose: Subsystem-level requirements — subject rebound to subsystem part.
//          Lives in a separate file/package; imports system-level package.
// ─────────────────────────────────────────────────────────────────────────────
package BrakingSubsystem_Requirements {
  import VehicleSystem_ReqTemplates::*;
  import VehicleSystem_Requirements::*;

  part def BrakingSubsystem;  // or import from architecture package

  // ── Subsystem requirement group ───────────────────────────────────────────
  // Subject is rebound from VehicleSystem to BrakingSubsystem.
  requirement def BrakingSubsystemRequirements {
    subject bs : BrakingSubsystem;

    // Refines REQ-FN-001: applies specifically to the braking subsystem
    requirement <'REQ-FN-BS-001'> brakingActuation : FunctionalReq {
      subject redefines sys = bs;   // ← rebind subject to the subsystem part
      doc /* The braking actuator shall apply full clamping force within 80 ms
             of receiving the brake command signal. */
      @RequirementMeta {
        source             = "REQ-FN-001";   // traces back to system req
        priority           = "mandatory";
        verificationMethod = "test";
        rationale          = "Subsystem allocation of the 150 ms system budget";
      }
    }
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
└── requirements/
    ├── <System>_ReqTemplates.sysml          # requirement def templates + RequirementMeta def
    ├── <System>_Requirements.sysml          # system-level requirement usages (the actual reqs)
    ├── <Subsystem>_Requirements.sysml       # subsystem-level usages (per subsystem, cross-package)
    └── <System>_ReqDecomposition.sysml      # optional: explicit cross-level subject binding groups
```

> **Design rule:** `requirement def` files define **shapes** (templates). `requirement` (usage) files define **content** (specific project requirements). Never put project-specific `doc` text in a `requirement def` unless that def is itself the subject of reuse. `satisfy` and `verify` always target **requirement usages** — never bare `requirement def` names.

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory? | Content Mapped from SM-PRD-10 |
|---|---|---|---|
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) — Requirements Overview | ARC-01 | **Mandatory** | Top-level functional requirements summary table (ID, title, priority, source stakeholder) |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | **Mandatory** | Non-functional and quality requirements (performance, safety, security, reliability) as quality scenarios in the Quality Tree |
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | Recommended | Constraint requirements (`REQ_CN_xxx`) generate additional ARC-02 architecture constraint entries |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Optional | Requirements that force specific architectural decisions reference the corresponding ADR |

**ARC-01 Requirements Overview Table format:**

| Req ID | Title | Priority | Source Stakeholder |
|---|---|---|---|
| REQ-FN-001 | Emergency Braking Response ≤ 150 ms | mandatory | Vehicle Driver |
| REQ-SF-001 | ASIL-D Safety Integrity for Braking | mandatory | Safety Authority |
| REQ-PF-001 | Driver Response Time ≤ 200 ms | high | Vehicle Driver |
| REQ-IF-001 | CAN FD Interface with Engine ECU per ICD v1.2 | mandatory | Supplier ECU Team |

---

## §4 Traceability

### Incoming Links

| Source Product | ID | Link Type | Description |
|---|---|---|---|
| Problem Statement | SM-PRD-04 | `depends_on` | Operational need drives top-level functional requirements |
| System Idea | SM-PRD-05 | `depends_on` | Solution scope determines which requirements are in or out of scope |
| System Objectives | SM-PRD-06 | `depends_on` | Objectives provide measurable acceptance criteria for performance requirements |
| Stakeholders | SM-PRD-08 | `depends_on` | Each requirement traces to at least one stakeholder concern |
| Risks | SM-PRD-09 | `refines` | Critical and major risks generate safety and fault-tolerance requirements |

### Outgoing Links

| Target Product | ID | Link Type | Description |
|---|---|---|---|
| System Context | SM-PRD-11 | `refines` | Interface requirements drive the system boundary and external actor interface definitions |
| System Use Cases | SM-PRD-12 | `refines` | Functional requirements expressed as use case scope and acceptance criteria |
| Use Case Activities | SM-PRD-14 | `refines` | Functional requirements decomposed into activity-level behavioral flows |
| Test Cases | SM-PRD-16 | `refines` | Each verifiable requirement has at least one test case linked via `verify` |
| Logical Architecture | SM-PRD-20 | `implements` | Logical architecture elements `satisfy` requirements from this product |
| arc42 ARC-01 | ARC-01 | `documents` | Functional requirements overview populates the ARC-01 requirements table |
| arc42 ARC-10 | ARC-10 | `documents` | Quality and non-functional requirements populate quality scenarios in ARC-10 |

### Traceability Rules

1. Every **requirement usage** (concrete project requirement) MUST have `@RequirementMeta` with all four fields populated (source, priority, verificationMethod, rationale). `requirement def` templates do not carry `@RequirementMeta` — they carry no project-specific data.
2. Every requirement usage with `priority = "mandatory"` or `"high"` MUST be traceable to a named stakeholder in SM-PRD-08 via `@RequirementMeta.source`.
3. Every requirement usage with `verificationMethod = "test"` MUST have at least one corresponding test case in SM-PRD-16 linked via `verify`.
4. Every design element in SM-PRD-20 that implements a requirement MUST include an explicit `satisfy <requirementUsageName>` relationship — **targeting the usage, not the `requirement def` template**.
5. Non-functional requirement usages MUST have measurable, quantitative acceptance criteria in their `doc` string and (where possible) a bound `targetValue` attribute (e.g., `attribute :>> targetValue = 200`).
6. Every cross-package subsystem requirement usage MUST include `subject redefines sys = parent.subsystemPart` to explicitly bind the subject to the correct subsystem part definition.

---

## §5 Modeling Procedure

1. **Map stakeholder concerns to requirement seeds.** For each entry in `SM-PRD-08.StakeholderMeta.concern[]`, draft one or more requirement statements in natural language. Ensure every concern has at least one corresponding requirement — no concern may be left without a requirement seed.
2. **Apply the EARS pattern.** Write each requirement using the Easy Approach to Requirements Syntax: "[While/When/If/Where] <condition>, the system shall <action/property> [within/to/at least <quantitative criterion>]." This ensures every requirement is verifiable and unambiguous.
3. **Classify requirements by type prefix.** Assign each requirement a type prefix: REQ_FN (functional), REQ_PF (performance), REQ_SF (safety), REQ_IF (interface), REQ_CN (constraint), REQ_SC (security). This drives the package structure and determines the arc42 section mapping.
4. **Create the `RequirementMeta` metadata definition.** Define `metadata def RequirementMeta` once at the top of the main requirements package. Reuse it across all sub-packages to ensure consistent traceability attributes.
5. **Model the requirement hierarchy.** Create **category template** `requirement def` entries (FunctionalReq, PerformanceReq, SafetyReq, InterfaceReq) in a dedicated templates file. Then create concrete **requirement usages** typed by these templates for each specific project requirement. Decompose complex requirements into nested `requirement` usages inside a group `requirement def`. Each leaf-level requirement usage must be independently verifiable against a single acceptance criterion.
6. **Add risk-driven requirements.** Review SM-PRD-09 (Risks) for any critical or major risks not yet addressed by stakeholder-derived requirements. Create new **requirement usages** in the safety or constraint category group, referencing the risk ID in `@RequirementMeta.source`.
7. **Link interface requirements to the system context model.** For each REQ_IF_xxx, verify it corresponds to a `connect` statement or `port def` in System Context (SM-PRD-11). If an interface requirement implies a missing external connection, update the context model before finalizing requirements.
8. **Define acceptance criteria for all measurable requirements.** Ensure every performance, safety, and interface requirement includes a quantitative acceptance criterion in its `doc` string. Requirements with vague language ("shall be fast", "shall be reliable") must be rejected and replaced with measurable statements.
9. **Populate ARC-01 and ARC-10.** Transfer the requirements overview table to ARC-01, and map non-functional requirements to quality scenarios in ARC-10 using the arc42 quality tree structure (quality attribute → quality scenario → acceptance criterion).
10. **Establish `verify` links to test cases.** After SM-PRD-16 (Test Cases) is created, establish `verify` relationships from each test case to the requirements it verifies. Validate 100% coverage of all mandatory and high-priority requirements before proceeding to design activities.
