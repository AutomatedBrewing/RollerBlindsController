---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — MBSE Training
description: Full SysML v2 and arc42 mapping for SYSMOD product MBSE Training (SM-PRD-03).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — MBSE Training (SM-PRD-03)

The MBSE Training product is the structured training and coaching program that equips all project team members with the skills needed to apply the project MBSE methodology using SysML v2. It is the third and final artifact in the MBSE Adoption process, completing the infrastructure setup before engineering modeling begins. MBSE Training has minimal direct SysML v2 model representation — it is primarily documented as structured text — but is partially captured via `part def` for training module structure and `metadata def` for competency tracking. In arc42 it appears as a team competency entry in ARC-08 and contributes MBSE terminology to the ARC-12 Glossary.

## §1 SysMod Definition

**Product ID:** SM-PRD-03
**SYSMOD §:** 5.3
**Process:** [MBSE Adoption](../../sysmod/processes/mbse-adoption-process.md) (SM-PRC-4)
**Creating Method:** [4.4 Provide MBSE Training and Coaching](../../sysmod/methods/provide-mbse-training-coaching.md) (SM-MTH-04)
**Responsible Role:** [MBSE Methodologist](../../sysmod/roles/mbse-methodologist.md)

### Purpose

MBSE Training ensures that every team member who creates, reviews, or consumes system models has the competencies to do so correctly and consistently. It covers the SYSMOD methodology concepts, SysML v2 syntax and semantics, the project SME toolchain, and the project-specific modeling conventions. Without adequate training, models will diverge in quality and meaning, undermining the primary MBSE benefit of a single authoritative system model.

### Role in Process

SM-PRD-03 is the last infrastructure artifact in the MBSE Adoption process (SM-PRC-4). It depends on SM-PRD-01 (MBSE Methodology) for training content and on SM-PRD-02 (SME) for the hands-on lab environment. Once delivered, it enables all engineering team members to begin productive modeling work on the Analysis process (SM-PRC-1) and Architecture process (SM-PRC-2) products.

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| MBSE Methodology | SM-PRD-01 | Defines which SYSMOD methods, products, and notations team members must learn |
| System Modeling Environment | SM-PRD-02 | Provides the hands-on practice environment and tool-specific training content |
| Team Skills Assessment | Project Manager | Current skill levels and backgrounds of project team members |
| Training Needs Analysis | MBSE Methodologist | Gap analysis between current competencies and required competencies |
| SYSMOD Reference Material | External (Tim Weilkiens, 3rd ed.) | Source content for SYSMOD-specific training modules |

### Outputs / Dependent Artifacts

| Output / Dependent Artifact | ID | Relationship |
|-----------------------------|----|--------------|
| Problem Statement (and all subsequent products) | SM-PRD-04…24 | `enables` — Trained team members can produce and review engineering model artifacts |
| Team Competency Records | (project-internal) | `documents` — Records of individual training completion and assessed competency levels |

### Dependencies

| Dependency | ID | Link Type |
|------------|----|-----------|
| MBSE Methodology | SM-PRD-01 | `depends_on` — Training content is derived from the tailored methodology |
| System Modeling Environment | SM-PRD-02 | `depends_on` — Hands-on exercises require a functional SME |

---

## §2 SysML v2 Mapping

MBSE Training has no direct system model artifact in SysML v2 — it is an organizational process product. However, the training program structure and competency records can be lightly cataloged using metadata and part definitions for project tracking purposes.

### Mapping Table

| SYSMOD Element | SysML v2 Element | Element ID | Rationale |
|----------------|------------------|------------|-----------|
| Training module | `part def TrainingModule` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Represents each curriculum module as a structured component with attributes for topic, duration, and format |
| Training catalog | `metadata def TrainingCatalog` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Annotates the MBSE_Methodology package with a summary of training modules delivered |
| Competency level | `attribute def CompetencyLevel` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Typed attribute capturing the assessed proficiency of a role on a module (novice / practitioner / expert) |
| Team member record | `part def TeamMemberProfile` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Optional: catalogs each team member's role, assigned modules, and achieved competency levels |
| Training program | `part def TrainingProgram` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Aggregates all TrainingModule instances for the project into a single top-level definition |

### Modeling Pattern

```sysml
package MBSE_Training {

    attribute def CompetencyLevel {
        enum CompetencyEnum {
            novice;
            practitioner;
            expert;
        }
    }

    part def TrainingModule {
        attribute moduleId    : String;   // e.g. "TM-03" — SysML v2 Syntax Fundamentals
        attribute topic       : String;
        attribute durationHrs : Real;
        attribute format      : String;   // "instructor-led" | "self-paced" | "workshop"
        attribute targetRoles : String[1..*];
    }

    part def TrainingProgram {
        attribute programName  : String = "Project MBSE Training";
        attribute targetTool   : String;  // primary SME tool name
        part modules : TrainingModule[1..*];
    }

    metadata def TrainingCatalog {
        attribute deliveredBy   : String;  // name/org of the trainer or MBSE Methodologist
        attribute deliveryDate  : String;  // ISO 8601
        attribute participantCount : Integer;
        attribute coverageScope : String;  // brief description of what was covered
    }

    // Example program instantiation
    part projectTraining : TrainingProgram {
        attribute programName = "SYSMOD + SysML v2 Project Training";
        attribute targetTool  = "SysIDE / Eclipse SysML v2 Pilot";

        part tm01 : TrainingModule {
            attribute moduleId    = "TM-01";
            attribute topic       = "SYSMOD Methodology Overview";
            attribute durationHrs = 4.0;
            attribute format      = "instructor-led";
            attribute targetRoles = ("System Engineer", "Project Manager");
        }
        part tm02 : TrainingModule {
            attribute moduleId    = "TM-02";
            attribute topic       = "SysML v2 Language Fundamentals";
            attribute durationHrs = 8.0;
            attribute format      = "instructor-led";
            attribute targetRoles = ("System Engineer", "System Architect");
        }
        part tm03 : TrainingModule {
            attribute moduleId    = "TM-03";
            attribute topic       = "SME Tool Hands-On Workshop";
            attribute durationHrs = 4.0;
            attribute format      = "workshop";
            attribute targetRoles = ("System Engineer", "System Architect", "Tester");
        }
    }
}
```

### Recommended Package Structure

```
<ProjectRoot>/
  MBSE_Methodology/
    MBSE_Training/             ← SM-PRD-03: TrainingProgram and module definitions
      training_program.sysml
      competency_records.sysml  ← optional: team member competency annotations
  SME_Configuration/           ← SM-PRD-02
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory / Recommended | What to Document |
|---------------|----|------------------------|-----------------|
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | **Mandatory** | Team MBSE competency levels as a cross-cutting concern: which training was delivered, achieved competency levels per role, ongoing coaching arrangements, and the impact on model quality conventions |
| [Glossary](../../arc42/sections/glossary.md) | ARC-12 | **Recommended** | MBSE and SysML v2 terminology introduced during training that the whole team uses in documentation and model review discussions |
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | **Recommended** | Competency constraints: if certain roles have not completed mandatory training, they are not authorized to baseline model artifacts |

**ARC-08 guidance:** The competency cross-cutting concept entry should identify required competency levels per role (e.g., System Architect must reach "practitioner" in SysML v2 before beginning logical architecture work), record training delivery dates, and describe the ongoing coaching arrangement.

**ARC-12 guidance:** Add entries for: MBSE, system model, SysML v2, SYSMOD, use case, requirement, part definition, viewpoint, and any project-specific modeling terms introduced during training.

---

## §4 Traceability

### Incoming Links

| Source ID | Source Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-01 | MBSE Methodology | `depends_on` | Training content is scoped to the methods, products, and notations defined in the methodology |
| SM-PRD-02 | System Modeling Environment | `depends_on` | Hands-on exercises use the configured SME; training cannot proceed without an operational tool environment |

### Outgoing Links

| Target ID | Target Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-04…24 | All engineering products | `enables` | Trained team members are authorized and capable of producing and reviewing engineering model artifacts |

### Traceability Rules

1. **Training-before-modeling rule:** No team member may create or baseline an engineering model artifact (SM-PRD-04 onwards) until their mandatory training modules are recorded as completed.
2. **Curriculum alignment rule:** The training program content (TrainingModule topics) must cover every SYSMOD method and SysML v2 notation that is listed as mandatory in SM-PRD-01.
3. **Competency gate rule:** Role-specific competency thresholds (e.g., System Architect must achieve "practitioner" in SysML v2) must be verified before the role holder is assigned modeling responsibilities on critical products.
4. **Coaching continuity rule:** Ongoing coaching sessions are part of SM-PRD-03 and must be planned for the full project duration, not just the initial training event.

---

## §5 Modeling Procedure

1. **Conduct a training needs analysis.** Compare the current team skill inventory (roles, prior modeling experience, tool familiarity) against the competency requirements derived from SM-PRD-01. Identify gaps for each role and each mandatory training topic.

2. **Design the training curriculum.** For each identified gap, define a `TrainingModule` with topic, duration, format (instructor-led, workshop, self-paced), and target roles. Ensure the curriculum covers: SYSMOD methodology overview, SysML v2 language fundamentals, project SME tool hands-on, and project-specific modeling conventions.

3. **Instantiate the training program in SysML v2.** Create the `MBSE_Training` package. Define the `TrainingProgram` part and compose all `TrainingModule` instances. Populate attributes (moduleId, topic, durationHrs, format, targetRoles) for each module.

4. **Schedule and deliver training.** Coordinate with the Project Manager to schedule training sessions in alignment with project milestones. Deliver the training using the configured SME (SM-PRD-02) for all hands-on exercises. Capture attendance and completion records.

5. **Assess competency levels.** After each module, assess participants against the `CompetencyLevel` scale. Record results in `competency_records.sysml` using `TeamMemberProfile` annotations. Flag any roles that have not reached the required threshold.

6. **Provide targeted follow-up coaching.** For team members who did not reach the required competency threshold, schedule individual coaching sessions using the SME. Update competency records after each coaching session.

7. **Document in arc42.** Write the ARC-08 Cross-cutting Concept entry for team MBSE competency, covering required levels per role and actual achievement dates. Add MBSE and SysML v2 terminology to ARC-12. Add any competency-based authorization constraints to ARC-02.

8. **Plan ongoing coaching.** Define the ongoing coaching arrangement for the full project duration: frequency of group model review sessions, availability of the MBSE Methodologist for ad-hoc coaching, and criteria for escalating model quality issues.
