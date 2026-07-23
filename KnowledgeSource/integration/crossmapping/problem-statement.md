---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Problem Statement
description: Full SysML v2 and arc42 mapping for SYSMOD product Problem Statement (SM-PRD-04).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Problem Statement (SM-PRD-04)

The Problem Statement is the first engineering artifact of the Analysis process and the root of the entire SYSMOD product dependency tree. It provides a structured, agreed description of the current situation (the problem), the desired situation (the goal), the gap between them, and the stakeholders affected. It is produced before any solution thinking begins. In SysML v2 it is modeled as a `requirement def` with structured documentation attributes, optionally strengthened by a `constraint def` for the formal gap expression. In arc42 it anchors the Requirements Overview subsection of ARC-01 and seeds the domain terminology in ARC-12.

## §1 SysMod Definition

**Product ID:** SM-PRD-04
**SYSMOD §:** 5.4
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.5 Analyze the Problem](../../sysmod/methods/analyze-problem.md) (SM-MTH-05)
**Responsible Role:** [Project Manager](../../sysmod/roles/project-manager.md)

### Purpose

The Problem Statement forces the project to articulate the problem before proposing solutions. It documents: (1) the current state and its pain points, (2) the desired future state, (3) the gap that the new system must close, (4) the users and stakeholders affected, and (5) the impact of not solving the problem. An agreed Problem Statement prevents scope creep, aligns stakeholder expectations, and provides the logical foundation from which System Idea (SM-PRD-05) and System Objectives (SM-PRD-06) are derived.

### Role in Process

SM-PRD-04 is the first artifact in the Analysis process (SM-PRC-1). It has no SYSMOD product prerequisites and is created from stakeholder interviews, domain knowledge, and project initiation documents. All downstream analysis artifacts — System Idea, System Objectives, Stakeholders, Risks, Requirements — are traceable back to the Problem Statement. A change to the Problem Statement may invalidate or require revision of any of these downstream products.

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Project Charter / Initiation Document | Project Manager | High-level statement of project motivation and business case |
| Stakeholder Interviews | Project Manager, System Engineers | Primary source of problem understanding from affected parties |
| Domain Expert Input | Domain Knowledge (SM-PRD-15) | Context about current processes, systems, and pain points |
| Market / Competitive Analysis | Product Owner / Marketing | External context on why the current situation is unsatisfactory |
| Regulatory / Mission Requirements | Compliance Officer | Obligations that define part of the "desired state" |

### Outputs / Dependent Artifacts

| Output / Dependent Artifact | ID | Relationship |
|-----------------------------|----|--------------|
| System Idea | SM-PRD-05 | `refines` — The System Idea proposes a solution to the stated problem |
| System Objectives | SM-PRD-06 | `refines` — Objectives are measurable goals for closing the identified gap |
| Stakeholders | SM-PRD-08 | `refines` — The affected-users field seeds the stakeholder identification |
| Requirements | SM-PRD-10 | `refines` — Requirements must be traceable to the problem gap |

### Dependencies

SM-PRD-04 has **no upstream SYSMOD product dependencies**. It is the first artifact of the Analysis process and is created from external stakeholder inputs and project initiation documents.

---

## §2 SysML v2 Mapping

The Problem Statement is a stakeholder-facing artifact best modeled as a `requirement def` carrying structured documentary attributes. A `constraint def` can formalize the gap when a measurable or logical expression of the current-vs-desired state is possible.

### Mapping Table

| SYSMOD Element | SysML v2 Element | Element ID | Rationale |
|----------------|------------------|------------|-----------|
| Problem Statement artifact | `requirement def ProblemStatement` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Anchors the problem in the requirements hierarchy as a top-level stakeholder requirement before any system requirement is derived |
| Current situation description | `attribute currentState : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Structures the narrative of the current state for machine-readable traceability |
| Desired situation description | `attribute desiredState : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Structures the narrative of the target state |
| Gap description | `attribute problemGap : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Makes the gap explicit and auditable |
| Affected users / stakeholders | `attribute affectedUsers : String[1..*]` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Seeds the stakeholder list (SM-PRD-08) with the primary affected parties |
| Impact of non-resolution | `attribute impactIfNotSolved : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Business-case attribute quantifying the cost or risk of inaction |
| Formal gap constraint | `constraint def ProblemGap` | [SML-DEF-ConstrDef](../../sysml2/concepts/constraint-definition.md) | Optional formal expression of the gap when the current and desired states can be quantified |
| Problem domain metadata | `metadata def ProblemContext` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Annotates the Analysis package with domain, project phase, and approval status |

### Modeling Pattern

```sysml
package Analysis {

    requirement def ProblemStatement {
        doc /* Structured articulation of the problem before any solution is considered.
               Captures current state, desired state, gap, and affected stakeholders. */

        attribute currentState      : String;
        // Description of the existing situation and its pain points.

        attribute desiredState      : String;
        // Description of the future situation after the problem is solved.

        attribute problemGap        : String;
        // The specific gap between currentState and desiredState that the system must close.

        attribute affectedUsers     : String[1..*];
        // Primary stakeholders and user groups impacted by the current situation.

        attribute impactIfNotSolved : String;
        // Business, mission, or safety impact of leaving the problem unaddressed.

        attribute approvalStatus    : String = "draft";
        // "draft" | "under-review" | "approved" | "baselined"
    }

    // Example instantiation for a fictitious project
    requirement projectProblem : ProblemStatement {
        doc /* Engineers in the field cannot communicate equipment status
               to the control center in real time, causing unplanned downtime. */

        attribute currentState      = "Field engineers use paper-based logs; data reaches control center with 24-hour delay.";
        attribute desiredState      = "Real-time equipment status is visible to the control center; downtime is reduced by 30%.";
        attribute problemGap        = "No digital, real-time communication channel exists between field devices and the control center.";
        attribute affectedUsers     = ("Field Engineers", "Control Center Operators", "Maintenance Planners");
        attribute impactIfNotSolved = "Estimated €2M/year in unplanned downtime costs; safety risk from undetected equipment faults.";
    }

    constraint def ProblemGap {
        doc /* Formal constraint: the current mean time to detect a fault must exceed
               the desired detection time for the gap to remain open. */
        attribute currentDetectionTimeHrs  : Real;
        attribute desiredDetectionTimeHrs  : Real;
        constraint gapExists { currentDetectionTimeHrs > desiredDetectionTimeHrs }
    }

    metadata def ProblemContext {
        attribute projectName  : String;
        attribute domain       : String;   // e.g. "Industrial IoT", "Aerospace", "Automotive"
        attribute approvedBy   : String;
        attribute approvalDate : String;   // ISO 8601
    }
}
```

### Recommended Package Structure

```
<ProjectRoot>/
  Analysis/
    ProblemSpace/
      problem_statement.sysml    ← ProblemStatement requirement def + instance
      problem_constraints.sysml  ← ProblemGap constraint def (if formal gap exists)
      problem_context.sysml      ← ProblemContext metadata annotation
    StakeholderNeeds/             ← SM-PRD-05, SM-PRD-06, SM-PRD-08
    SystemContext/                ← SM-PRD-11
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory / Recommended | What to Document |
|---------------|----|------------------------|-----------------|
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | **Mandatory** | Requirements Overview subsection: summarize the problem statement narrative (current state, desired state, gap), the business motivation, and reference the full Problem Statement model artifact |
| [Glossary](../../arc42/sections/glossary.md) | ARC-12 | **Recommended** | Key domain terms introduced in the Problem Statement that are used consistently across all downstream artifacts (e.g., the names of the affected user groups, the domain-specific term for the "gap") |

**ARC-01 guidance:** The Requirements Overview in arc42 is the primary arc42 location for the Problem Statement. Include a prose summary of the three core fields (currentState, desiredState, problemGap) in 3–5 sentences. Add a link or reference to the full `ProblemStatement` requirement in the SysML v2 model. Avoid repeating the full model content — keep the arc42 section as a human-readable summary.

**ARC-12 guidance:** For every term that is defined in `affectedUsers` or that appears prominently in the `currentState` / `desiredState` descriptions, add a glossary entry with a one-line definition and domain context.

---

## §4 Traceability

### Incoming Links

| Source ID | Source Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| — | — | — | SM-PRD-04 has no upstream SYSMOD product predecessors |

### Outgoing Links

| Target ID | Target Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-05 | System Idea | `refines` | The System Idea proposes a solution concept that directly addresses the stated problem gap |
| SM-PRD-06 | System Objectives | `refines` | Each objective is a measurable criterion for closing the gap identified in the Problem Statement |
| SM-PRD-08 | Stakeholders | `refines` | The `affectedUsers` attribute seeds the initial stakeholder identification |
| SM-PRD-10 | Requirements | `refines` | All requirements must be traceable to the problem gap; requirements that cannot be traced indicate gold-plating |

### Traceability Rules

1. **Problem-first rule:** No Analysis product (SM-PRD-05 through SM-PRD-16) may be baselined unless the Problem Statement is approved. Engineering work on requirements or architecture before an agreed Problem Statement is prohibited.
2. **Gap traceability rule:** Every system requirement (SM-PRD-10) must carry a `satisfy` or derivation link that traces back, directly or indirectly, to the problem gap described in SM-PRD-04.
3. **Change impact rule:** Any change to the `problemGap`, `currentState`, or `desiredState` attributes triggers a mandatory impact review on SM-PRD-05, SM-PRD-06, SM-PRD-08, and SM-PRD-10.
4. **Approved-before-architecture rule:** SM-PRD-04 must be approved (not merely drafted) before any Architecture process work (SM-PRD-17 onwards) begins.

---

## §5 Modeling Procedure

1. **Conduct stakeholder problem interviews.** Schedule structured interviews or workshops with representatives of each affected user group. Use a standard problem-analysis template covering: What is the current situation? What pain points does it cause? What would a better situation look like? What is the cost/risk of not fixing it?

2. **Draft the Problem Statement attributes.** From interview notes and project initiation documents, draft the five core attributes: `currentState`, `desiredState`, `problemGap`, `affectedUsers`, and `impactIfNotSolved`. Use precise, stakeholder-validated language for each.

3. **Create the SysML v2 Problem Statement model.** In the SME, create the `Analysis/ProblemSpace/` package. Define the `ProblemStatement requirement def` with all attributes. Create the project-specific requirement instance and populate all attribute values with the drafted content.

4. **Optionally formalize the gap as a constraint.** If the current-state and desired-state can be expressed in measurable terms (e.g., detection time, throughput, error rate), define a `ProblemGap constraint def` and link it to the Problem Statement requirement. This formal gap expression later becomes the acceptance criterion for the system.

5. **Annotate with ProblemContext metadata.** Apply the `#ProblemContext` annotation to the `ProblemSpace` package with the project name, domain, and approval status.

6. **Conduct a stakeholder review.** Present the drafted Problem Statement to all identified affected user groups and project sponsors for review and approval. Resolve conflicting views on the problem gap by facilitating a structured discussion. Update the model based on agreed feedback.

7. **Document in arc42.** Write the Requirements Overview subsection of ARC-01 as a prose summary of the Problem Statement, referencing the SysML v2 model. Add domain terms to ARC-12.

8. **Formally approve and baseline.** Obtain written approval of SM-PRD-04 from the Project Manager and key stakeholder representatives. Set `approvalStatus` to "baselined" in the model. This baseline is the formal prerequisite for starting SM-PRD-05 (System Idea) and SM-PRD-08 (Stakeholders).

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [6M Method](../../sysmod/tools/6m-method.md) | Tool 11.11 | **During step 1 (stakeholder interviews)** — run a 6M workshop to systematically explore causes across Manpower, Machinery, Materials, Methods, Measurement, and Mother-nature categories before drafting the problem gap |
| [Five Whys Method](../../sysmod/tools/five-whys-method.md) | Tool 11.12 | **During step 1** — use Five Whys root-cause analysis on each candidate problem to ensure the Problem Statement targets the root cause, not a symptom; document the why-chain in the model `doc` body |
