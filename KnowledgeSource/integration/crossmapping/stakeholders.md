---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Stakeholders
description: Full SysML v2 and arc42 mapping for SYSMOD product Stakeholders (SM-PRD-08).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Stakeholders (SM-PRD-08)

Stakeholders are all persons, organizations, or groups that have an interest in the system or are affected by it. Identifying stakeholders early in the Analysis process ensures that their concerns, expectations, and acceptance criteria drive requirements elicitation. Each stakeholder is modeled as a `part def` annotated with `@StakeholderMeta` capturing role, concerns, priority, and contact information, and they populate the mandatory stakeholder table in arc42 ARC-01.

## §1 SysMod Definition

**Product ID:** SM-PRD-08
**SYSMOD §:** 5.8
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.8 Identify Stakeholders](../../sysmod/methods/identify-stakeholders.md) (SM-MTH-08)
**Responsible Role:** [Requirements Engineer](../../sysmod/roles/requirements-engineer.md)

### Purpose

The Stakeholders product documents who has a stake in the system under development — their roles, primary concerns, influence level, and contact details. This product serves as the authoritative reference for requirements elicitation (SM-PRD-10) and use case identification (SM-PRD-12), ensuring that all relevant concerns are captured and no stakeholder group is overlooked during analysis.

### Role in Process

In the Analysis process (SM-PRC-1), the Stakeholders product is created after the Problem Statement (SM-PRD-04) establishes the problem context. It feeds directly into Requirements (SM-PRD-10) — each requirement must be traceable to at least one stakeholder concern — and into System Use Cases (SM-PRD-12) — each use case must have at least one identified actor drawn from the stakeholder list.

### Inputs

| # | Input Product | ID | Description |
|---|---------------|----|-------------|
| 1 | Problem Statement | SM-PRD-04 | Identifies the problem domain and the parties affected by the problem |

### Outputs / Dependent Artifacts

| # | Dependent Product | ID | Relationship |
|---|-------------------|----|--------------|
| 1 | Requirements | SM-PRD-10 | Each requirement must trace to at least one stakeholder concern |
| 2 | System Use Cases | SM-PRD-12 | Actors in use cases are drawn from the stakeholder list |

### Dependencies

The Stakeholders product depends only on SM-PRD-04 (Problem Statement), which provides the problem context needed to identify who is affected. No other analysis products are prerequisites for initial stakeholder identification, though the list is refined iteratively as SM-PRD-05 (System Idea) and SM-PRD-06 (System Objectives) are elaborated.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Stakeholder (human actor) | `part def <StakeholderName>` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Stakeholders modeled as typed actors; enables reuse in System Context (SM-PRD-11) |
| Stakeholder organization | `part def <OrgName>` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Organizational stakeholders as `part def` with `@StakeholderMeta` annotation |
| Stakeholder metadata (role, concern, priority, contact) | `metadata def StakeholderMeta { ... }` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Structured metadata captures all stakeholder properties without polluting the SysML type system |
| Stakeholder concern (multi-valued) | `attribute concern : String[1..*]` in `StakeholderMeta` | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | Concerns as multi-valued string attributes; refined later into typed requirement concerns |
| Stakeholder priority / influence | `attribute priority : String` in `StakeholderMeta` | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | Captures high/medium/low influence for requirements prioritization |
| Stakeholder-to-requirement trace | Requirements Diagram | [SML-DGM-ReqDiag](../../sysml2/diagrams/requirements-diagram.md) | Visualizes traceability from `StakeholderMeta.concern[]` to `requirement def` entries |
| SYSMOD «extendedStakeholder» stereotype | `metadata def StakeholderMeta` annotation | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | SYSMOD's `«extendedStakeholder»` stereotype realized as a metadata annotation in SysML v2 |

### Modeling Pattern

```sysml
package VehicleSystem_Stakeholders {

  metadata def StakeholderMeta {
    attribute role     : String;
    attribute concern  : String[1..*];
    attribute priority : String;   // high | medium | low
    attribute contact  : String;
  }

  // Human user stakeholder
  part def VehicleDriver {
    @StakeholderMeta {
      role     = "Primary User";
      concern  = ["ease of use", "safety", "response time < 200 ms", "haptic feedback quality"];
      priority = "high";
      contact  = "UX Research Team";
    }
  }

  // Regulatory / external authority
  part def SafetyAuthority {
    @StakeholderMeta {
      role     = "Regulatory Body";
      concern  = ["ISO 26262 ASIL-D compliance", "fail-safe behavior", "full audit traceability"];
      priority = "high";
      contact  = "safety-authority@certbody.org";
    }
  }

  // Internal organizational stakeholder
  part def ProductManagement {
    @StakeholderMeta {
      role     = "Business Owner";
      concern  = ["time to market", "cost targets", "feature completeness"];
      priority = "medium";
      contact  = "PM Team";
    }
  }

  // External integration partner
  part def SupplierECUTeam {
    @StakeholderMeta {
      role     = "External Supplier";
      concern  = ["interface stability", "message format compliance", "bus load budget"];
      priority = "medium";
      contact  = "supplier-integration@partner.com";
    }
  }

  // Operations and maintenance stakeholder
  part def MaintenanceTechnician {
    @StakeholderMeta {
      role     = "Maintainer";
      concern  = ["diagnostic accessibility", "fault code clarity", "spare parts availability"];
      priority = "low";
      contact  = "Service Engineering";
    }
  }
}
```

### Recommended Package Structure

```
<System>_Analysis/
└── stakeholders/
    └── <System>_Stakeholders.sysml   # Contains part defs annotated with @StakeholderMeta
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory? | Content Mapped from SM-PRD-08 |
|---|---|---|---|
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) — Stakeholders | ARC-01 | **Mandatory** | Stakeholder table: Role/Name, Contact, Expectations — one row per `part def` in the stakeholders package |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | Recommended | Quality-related concerns from `StakeholderMeta.concern[]` become quality scenarios in the Quality Tree |
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | Optional | Constraints imposed directly by regulatory stakeholders (e.g., SafetyAuthority requiring ASIL-D) generate ARC-02 entries |

**ARC-01 Stakeholder Table format:**

| Role / Name | Contact | Expectations |
|---|---|---|
| Vehicle Driver | UX Research Team | Ease of use; response time < 200 ms; reliable haptic feedback |
| Safety Authority | safety-authority@certbody.org | ISO 26262 ASIL-D compliance; fail-safe behavior; full audit trail |
| Product Management | PM Team | On-time delivery; within cost target; complete required feature set |
| Supplier ECU Team | supplier-integration@partner.com | Stable CAN FD interface; agreed message formats; bus load within budget |
| Maintenance Technician | Service Engineering | Clear fault codes; accessible diagnostic interface; documented spare parts |

---

## §4 Traceability

### Incoming Links

| Source Product | ID | Link Type | Description |
|---|---|---|---|
| Problem Statement | SM-PRD-04 | `depends_on` | Problem domain identifies who is affected and which parties have a stake in the outcome |

### Outgoing Links

| Target Product | ID | Link Type | Description |
|---|---|---|---|
| Requirements | SM-PRD-10 | `refines` | Every requirement must trace to at least one `StakeholderMeta.concern` entry |
| System Use Cases | SM-PRD-12 | `refines` | Every actor in a use case must correspond to a `part def` in the stakeholders package |
| arc42 ARC-01 | ARC-01 | `documents` | Stakeholder list populates the mandatory ARC-01 Stakeholders table |
| arc42 ARC-10 | ARC-10 | `documents` | Stakeholder quality concerns contribute to quality scenarios in ARC-10 |

### Traceability Rules

1. Every `part def` in the stakeholders package MUST appear in the ARC-01 Stakeholder table with role, contact, and expectations columns filled.
2. Every requirement in SM-PRD-10 MUST reference at least one stakeholder from this product via `@RequirementMeta.source`.
3. Every actor (`part def`) appearing in a use case (SM-PRD-12) MUST be defined in or imported from this stakeholders package.
4. Stakeholders with `priority = "high"` concerns MUST be addressed by at least one requirement with `priority = "mandatory"` or `"high"` in SM-PRD-10.
5. Regulatory stakeholder concerns that impose compliance requirements (e.g., ISO 26262) MUST generate corresponding entries in ARC-02.

---

## §5 Modeling Procedure

1. **Review the Problem Statement (SM-PRD-04).** Extract all parties mentioned as affected, responsible, or interested in the problem description. Use this as the initial seed list of potential stakeholders.
2. **Conduct a stakeholder identification workshop.** Apply brainstorming with the project team and review organizational charts, supplier lists, and regulatory inventories to expand the seed list. Apply SYSMOD actor categories: primary users, external systems (organizations), regulatory bodies, suppliers, internal departments, and maintainers.
3. **Classify each stakeholder by category and priority.** For each identified stakeholder, determine their role category and assign an initial `priority` value (high/medium/low) based on their influence over acceptance criteria and their exposure to system risk.
4. **Create a `part def` for each stakeholder.** In the `<System>_Stakeholders.sysml` package, define one `part def` per stakeholder, annotated with `@StakeholderMeta` containing role, concerns array, priority, and contact.
5. **Elicit concerns for each stakeholder.** Conduct interviews or workshops to enumerate 3–7 specific concerns per stakeholder. Record these as string entries in the `concern` array of `@StakeholderMeta`. Keep concerns outcome-oriented ("what they need"), not solution-oriented.
6. **Validate completeness against ISO/IEC 15288.** Review the stakeholder list with the project sponsor and System Architect to ensure no significant party is omitted. Cross-check against ISO/IEC 15288 lifecycle stakeholder categories (acquirer, supplier, operator, user, maintainer, disposal agent, developer).
7. **Populate ARC-01 Stakeholder table.** Transfer each `part def` to the arc42 Introduction and Goals section as a row in the stakeholders table, mapping `StakeholderMeta.concern[]` to the Expectations column.
8. **Map quality concerns to ARC-10.** For each concern that is quality-related (performance, reliability, safety, security, maintainability), create a corresponding quality scenario entry in ARC-10 using the arc42 quality tree structure.
9. **Establish concern-to-requirement traceability.** Before starting SM-PRD-10, create a concern traceability matrix mapping each `StakeholderMeta.concern` entry to a placeholder requirement ID, ensuring full coverage in the requirements model.
10. **Maintain the stakeholder list iteratively.** Review and update SM-PRD-08 at each project phase gate — new stakeholders may emerge as the System Context (SM-PRD-11) and Use Cases (SM-PRD-12) reveal previously unknown external interfaces and affected parties.
