---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Risks
description: Full SysML v2 and arc42 mapping for SYSMOD product Risks (SM-PRD-09).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Risks (SM-PRD-09)

Risks are identified threats to achieving the system objectives or delivering a safe and correct system. The Risks product is a structured risk register modeled in SysML v2 as annotated `requirement def` elements — treating risks as "conditions the system must avoid or handle" — enabling `satisfy` links from mitigation measures. Each risk is characterized by probability, impact, severity, and mitigation strategy, and the register populates the mandatory arc42 ARC-11 section.

## §1 SysMod Definition

**Product ID:** SM-PRD-09
**SYSMOD §:** 5.9
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.9 Model Risks](../../sysmod/methods/model-risks.md) (SM-MTH-09)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose

The Risks product captures and structures all identified threats that could prevent the system from meeting its objectives, satisfying safety requirements, or being delivered on time and within budget. By modeling risks formally in SysML v2, engineers can link risks to the specific model elements they affect, enabling impact analysis when design decisions change and providing a formal basis for deriving risk-driven requirements in SM-PRD-10.

### Role in Process

In the Analysis process (SM-PRC-1), risks are identified after the System Objectives (SM-PRD-06) are defined, since risks must be assessed against the goals they threaten. The Risks product informs Requirements (SM-PRD-10) by generating risk-driven requirements (e.g., safety requirements to mitigate critical risks), and informs Logical Architecture (SM-PRD-20) by highlighting which design decisions require mitigation measures.

### Inputs

| # | Input Product | ID | Description |
|---|---------------|----|-------------|
| 1 | System Idea | SM-PRD-05 | Defines the envisioned solution, introducing technology-specific risks |
| 2 | System Objectives | SM-PRD-06 | Provides the goals against which risk impact is measured and calibrated |

### Outputs / Dependent Artifacts

| # | Dependent Product | ID | Relationship |
|---|-------------------|----|--------------|
| 1 | Requirements | SM-PRD-10 | Critical and major risks generate risk-driven requirements (safety, fault tolerance) |
| 2 | Logical Architecture | SM-PRD-20 | Architectural decisions must demonstrably address risks with `severity = "critical"` |

### Dependencies

The Risks product depends on SM-PRD-05 (System Idea) for technology-specific risk identification and SM-PRD-06 (System Objectives) for impact calibration. It does not depend on SM-PRD-07 through SM-PRD-08 directly, though stakeholder concerns (SM-PRD-08) can be reviewed as a secondary input for identifying business and compliance risks.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Risk item | `requirement def Risk_<Name> { doc /.../ }` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Risk modeled as a requirement — "the system must avoid or mitigate X" — enabling formal `satisfy` links from mitigation measures |
| Risk attributes (probability, impact, severity, etc.) | `metadata def RiskMeta { ... }` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Structured metadata captures all risk assessment fields without extending the SysML type system |
| Risk-to-model-element link | `satisfy` (or documentation note reference) | [SML-USG-Satisfy](../../sysml2/concepts/satisfy.md) | Links the risk `requirement def` to the design element it affects; supports impact analysis |
| Risk register visualization | Requirements Diagram | [SML-DGM-ReqDiag](../../sysml2/diagrams/requirements-diagram.md) | Displays risk `requirement def` hierarchy with `@RiskMeta` annotations and mitigation links |
| Risk category grouping | `package <Category>Risks { ... }` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups risks by category (technical, schedule, safety, integration) for management and filtering |
| Mitigation measure as derived requirement | `requirement def Mitigation_<Name>` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Mitigation measures formally expressed as derived requirements in SM-PRD-10; linked via `satisfy` |

### Modeling Pattern

```sysml
package VehicleSystem_Risks {

  metadata def RiskMeta {
    attribute probability : String;  // high | medium | low
    attribute impact      : String;  // high | medium | low
    attribute severity    : String;  // critical | major | minor
    attribute mitigation  : String;
    attribute status      : String;  // open | mitigated | closed
    attribute riskOwner   : String;
  }

  package TechnicalRisks {

    requirement def Risk_CommunicationBusLatency {
      doc /* CAN FD latency may exceed real-time constraints under high bus load,
             causing delayed braking commands with direct safety implications. */
      @RiskMeta {
        probability = "medium";
        impact      = "high";
        severity    = "critical";
        mitigation  = "Define bus load budget ≤ 60%; use time-triggered scheduling for safety messages";
        status      = "open";
        riskOwner   = "System Architect";
      }
    }

    requirement def Risk_ECUTemperatureExceedance {
      doc /* ECU operating temperature may exceed 85°C in high-ambient desert conditions,
             causing computational errors or protective shutdown. */
      @RiskMeta {
        probability = "low";
        impact      = "high";
        severity    = "major";
        mitigation  = "Add thermal derating model; specify cooling requirements in Product Architecture";
        status      = "open";
        riskOwner   = "Hardware Engineer";
      }
    }
  }

  package ScheduleRisks {

    requirement def Risk_SupplierDeliveryDelay {
      doc /* ECU hardware prototype delivery from supplier may be delayed by 4–8 weeks,
             impacting integration testing schedule and product launch date. */
      @RiskMeta {
        probability = "medium";
        impact      = "medium";
        severity    = "major";
        mitigation  = "Arrange hardware-in-the-loop simulation environment as integration test fallback";
        status      = "open";
        riskOwner   = "Project Manager";
      }
    }
  }

  package SafetyRisks {

    requirement def Risk_SinglePointFaultUndetected {
      doc /* A single-point hardware fault in the braking ECU may go undetected beyond the
             10 ms fault detection window, violating ASIL-D requirements. */
      @RiskMeta {
        probability = "low";
        impact      = "high";
        severity    = "critical";
        mitigation  = "Implement dual-channel fault detection with cross-comparison; validate via FMEA";
        status      = "open";
        riskOwner   = "Safety Engineer";
      }
    }
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
└── risks/
    ├── <System>_Risks.sysml            # Top-level risk package with RiskMeta def
    ├── <System>_TechnicalRisks.sysml   # Technical risk sub-package
    ├── <System>_ScheduleRisks.sysml    # Schedule/project risk sub-package
    └── <System>_SafetyRisks.sysml      # Safety risk sub-package
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory? | Content Mapped from SM-PRD-09 |
|---|---|---|---|
| [Risks and Technical Debts](../../arc42/sections/risks-and-technical-debts.md) | ARC-11 | **Mandatory** | Complete risk register table: Risk ID, description, probability, impact, severity, mitigation, status, owner |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Risks with `severity = "critical"` that drove architectural decisions are referenced in ADRs |
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | Optional | Critical risks summary may be noted in the quality goals section as known constraints |

**ARC-11 Risk Register Table format:**

| Risk ID | Description | Probability | Impact | Severity | Mitigation | Status | Owner |
|---|---|---|---|---|---|---|---|
| RISK-T-01 | CAN FD latency exceeds real-time constraints | medium | high | critical | Bus load ≤ 60%; time-triggered scheduling | open | System Architect |
| RISK-T-02 | ECU temperature exceedance in high-ambient environment | low | high | major | Thermal derating; cooling spec in PA | open | HW Engineer |
| RISK-S-01 | Supplier hardware delivery delay | medium | medium | major | HIL simulation fallback environment | open | Project Manager |
| RISK-S-02 | Single-point fault undetected beyond 10 ms window | low | high | critical | Dual-channel detection; FMEA validation | open | Safety Engineer |

---

## §4 Traceability

### Incoming Links

| Source Product | ID | Link Type | Description |
|---|---|---|---|
| System Idea | SM-PRD-05 | `depends_on` | Technology choices in the system idea introduce technology-specific and integration risks |
| System Objectives | SM-PRD-06 | `depends_on` | Objectives define the impact scale against which risk severity is calibrated |

### Outgoing Links

| Target Product | ID | Link Type | Description |
|---|---|---|---|
| Requirements | SM-PRD-10 | `refines` | Critical and major risks generate risk-driven requirements (safety, fault tolerance, performance) |
| Logical Architecture | SM-PRD-20 | `refines` | Architectural decisions must demonstrably address every risk with `severity = "critical"` |
| arc42 ARC-11 | ARC-11 | `documents` | Risk register populates the Risks and Technical Debts section |
| arc42 ARC-09 | ARC-09 | `documents` | Architecture decisions driven by critical risks are recorded as ADRs referencing risk IDs |

### Traceability Rules

1. Every `requirement def` in the risks package MUST have `@RiskMeta` with all fields populated (probability, impact, severity, mitigation, status, riskOwner).
2. Every risk with `severity = "critical"` MUST have at least one corresponding requirement in SM-PRD-10 addressing its mitigation (derived requirement pattern).
3. Every risk with `severity = "critical"` that drove an architectural decision MUST have a corresponding ADR in ARC-09 referencing the risk ID.
4. Every risk entry in the SysML model MUST appear as a row in the ARC-11 risk register table with identical IDs.
5. Risk `status` field MUST be kept current; mitigated risks MUST reference the specific requirement or design element (`satisfy` link target) that provides the mitigation.

---

## §5 Modeling Procedure

1. **Seed the risk list from objectives and system idea.** Review SM-PRD-06 (objectives) to identify which goals are at risk, and SM-PRD-05 (system idea) to identify technology-specific risks. Consult historical risk databases and lessons-learned from analogous projects.
2. **Define the `RiskMeta` metadata definition.** Establish `metadata def RiskMeta` with fields for probability, impact, severity, mitigation, status, and riskOwner in the top-level risks package. This ensures consistent structure across all risk entries.
3. **Create risk sub-packages by category.** Organize risks into sub-packages: TechnicalRisks, ScheduleRisks, SafetyRisks, IntegrationRisks. This supports filtering, prioritization, and role-based review.
4. **Model each risk as a `requirement def`.** For each identified risk, create a `requirement def Risk_<Name>` with a `doc` string describing the threat in the format: "[Cause] may result in [effect], leading to [consequence for system objectives]."
5. **Annotate each risk with `@RiskMeta`.** Fill in all fields: probability (high/medium/low), impact (high/medium/low), severity (critical/major/minor — derived from probability × impact matrix), mitigation strategy, status (open), and riskOwner.
6. **Assess severity using a risk matrix.** Apply a standard risk matrix: high probability + high impact = critical; low probability + high impact = major; other combinations yield major or minor. Document the rationale for the severity assignment explicitly in the `@RiskMeta.mitigation` field context.
7. **Link risks to affected model elements.** Using `satisfy` relationships or documentation notes, link each risk `requirement def` to the `part def`, `requirement def`, or interface element it threatens. This enables downstream impact analysis when design decisions change.
8. **Derive risk-driven requirements.** For every risk with `severity = "critical"` or `"major"`, derive at least one requirement in SM-PRD-10 that specifies what the system must do to prevent or mitigate the risk. Cross-reference the risk ID in `@RequirementMeta.source`.
9. **Populate ARC-11.** Transfer all risk entries to the arc42 Risks and Technical Debts section (ARC-11) in the standard risk register table format. Risk IDs must match between the SysML model and the arc42 document.
10. **Write ADRs for architecture decisions driven by critical risks (ARC-09).** For each critical risk that caused a specific architectural design decision (e.g., choosing time-triggered scheduling to mitigate bus latency), write a corresponding ADR in ARC-09 referencing the risk ID and explaining how the decision reduces probability, impact, or severity.
