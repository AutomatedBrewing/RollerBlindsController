---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Objectives
description: Full SysML v2 and arc42 mapping for SYSMOD product System Objectives (SM-PRD-06).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Objectives (SM-PRD-06)

System Objectives are the measurable business and system goals that define what "success" means for the project. They translate the qualitative vision of the System Idea (SM-PRD-05) and the gap identified in the Problem Statement (SM-PRD-04) into quantifiable, verifiable targets. Each objective specifies a metric, a target value, a measurement method, a priority, and a time horizon. In SysML v2, objectives are modeled as a specialized `requirement def` sub-hierarchy with `attribute def` definitions for measurability. In arc42, the top-priority objectives become the Quality Goals table in ARC-01 and are elaborated as measurable quality scenarios in ARC-10.

## §1 SysMod Definition

**Product ID:** SM-PRD-06
**SYSMOD §:** 5.6
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.6 Describe the System Idea and System Objectives](../../sysmod/methods/describe-system-idea-objectives.md) (SM-MTH-06)
**Responsible Role:** [Project Manager](../../sysmod/roles/project-manager.md)

### Purpose

System Objectives provide the measurable definition of project success. They are the bridge between stakeholder needs (expressed in the Problem Statement and System Idea) and verifiable system requirements. Without explicit objectives, projects drift: requirements grow without bound, and stakeholders disagree on whether the delivered system is acceptable. Each objective must be SMART: Specific, Measurable, Achievable, Relevant, and Time-bound. The SYSMOD «objective» stereotype is mapped to a dedicated `requirement def` sub-type in SysML v2 to maintain the distinction between objectives (goal-level) and requirements (design-level constraints).

### Role in Process

SM-PRD-06 is produced in the Analysis process (SM-PRC-1), immediately following the System Idea (SM-PRD-05). Both SM-PRD-04 and SM-PRD-05 are prerequisites. System Objectives feed directly into Risk identification (SM-PRD-09) — risks are assessed relative to the ability to achieve objectives — and into Requirements (SM-PRD-10) — requirements are the system-level constraints that ensure objectives can be met.

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Problem Statement | SM-PRD-04 | Provides the gap and impact quantification that informs objective metrics and target values |
| System Idea | SM-PRD-05 | Provides the value proposition and main features that objectives must make measurable |
| Stakeholder Priorities | Stakeholders / Product Owner | Input on which objectives are highest priority and which trade-offs are acceptable |
| Existing KPIs / Business Metrics | Management / Product Owner | Existing performance indicators that can be adopted as objective metrics |
| Domain Standards | Compliance Officer | Any standards-mandated performance, safety, or quality levels that become mandatory objectives |

### Outputs / Dependent Artifacts

| Output / Dependent Artifact | ID | Relationship |
|-----------------------------|----|--------------|
| Risks | SM-PRD-09 | `refines` — Risks are assessed in terms of their threat to achieving the stated objectives |
| Requirements | SM-PRD-10 | `refines` — System requirements are derived as the technical constraints needed to achieve each objective |

### Dependencies

| Dependency | ID | Link Type |
|------------|----|-----------|
| Problem Statement | SM-PRD-04 | `depends_on` — Objectives must address the identified problem gap |
| System Idea | SM-PRD-05 | `depends_on` — Objectives must make the system idea's value proposition measurable |

---

## §2 SysML v2 Mapping

The SYSMOD «objective» stereotype is represented in SysML v2 as a specialized `requirement def` sub-type carrying measurability attributes. The `metadata def ObjectiveCategory` handles the SYSMOD distinction between business objectives and system objectives.

### Mapping Table

| SYSMOD Element | SysML v2 Element | Element ID | Rationale |
|----------------|------------------|------------|-----------|
| System Objective (abstract type) | `requirement def SystemObjective` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Top-level objective type — all project objectives are instances or sub-requirements of this def |
| Business Objective sub-type | `requirement def BusinessObjective` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Sub-type specializing SystemObjective for business/organizational goals |
| System Performance Objective sub-type | `requirement def PerformanceObjective` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Sub-type specializing SystemObjective for technical performance targets |
| Metric attribute | `attribute def Metric` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Typed attribute defining the name and unit of the measurement |
| Target value | `attribute targetValue : Real` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | The numerical threshold the system must reach or exceed |
| Measurement method | `attribute measurementMethod : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | How the metric will be measured in practice (test method, KPI dashboard, etc.) |
| Priority | `attribute priority : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | "critical" | "high" | "medium" | "low" — importance relative to other objectives |
| Time horizon | `attribute timeHorizon : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | When the objective must be achieved (e.g., "at system acceptance", "within 12 months of deployment") |
| SYSMOD «objective» stereotype | `metadata def ObjectiveCategory` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Captures the SYSMOD objective category annotation (business vs. system) and approval status |
| Objective-to-requirement satisfy link | `satisfy` | [SML-USG-Satisfy](../../sysml2/concepts/satisfy.md) | Relates system requirements to the objectives they serve, providing vertical traceability |

### Modeling Pattern

```sysml
package Analysis {

    requirement def SystemObjective {
        doc /* Top-level objective type. All project objectives sub-type or instantiate this def.
               Each objective must be measurable via a specified metric and target value. */

        attribute metric            : String;
        // Name of the measured quantity and its unit (e.g., "Unplanned Downtime [hours/month]").

        attribute targetValue       : Real;
        // Numerical goal (the objective is met when measured value satisfies this threshold).

        attribute targetDirection   : String;
        // "≤" (less-than-or-equal) | "≥" (greater-than-or-equal) | "=" (exact)

        attribute measurementMethod : String;
        // How the metric will be collected and verified.

        attribute priority          : String = "high";
        // "critical" | "high" | "medium" | "low"

        attribute timeHorizon       : String;
        // When the objective must be achieved.

        attribute approvalStatus    : String = "draft";
    }

    requirement def BusinessObjective :> SystemObjective {
        doc /* Objective framed in business or organizational terms.
               Typically owned by management or the product owner. */
        attribute businessOwner : String;
    }

    requirement def PerformanceObjective :> SystemObjective {
        doc /* Objective framed as a technical system performance target.
               Typically owned by the system architect or chief engineer. */
        attribute relatedSystemFunction : String;
        // The system function or quality attribute this objective targets.
    }

    metadata def ObjectiveCategory {
        attribute category     : String;   // "business" | "system-performance" | "safety" | "regulatory"
        attribute approvedBy   : String;
        attribute approvalDate : String;   // ISO 8601
    }

    // Example business objective
    requirement obj01 : BusinessObjective {
        doc /* Reduce unplanned field equipment downtime. */
        attribute metric            = "Unplanned Downtime [hours/month per site]";
        attribute targetValue       = 4.0;
        attribute targetDirection   = "≤";
        attribute measurementMethod = "Aggregate maintenance log analysis; KPI dashboard report T+30 days post-deployment.";
        attribute priority          = "critical";
        attribute timeHorizon       = "Within 6 months of system acceptance";
        attribute businessOwner     = "Operations Director";
    }

    // Example performance objective
    requirement obj02 : PerformanceObjective {
        doc /* System must deliver fault alerts to the control center within 30 seconds. */
        attribute metric                = "Fault-to-Alert Latency [seconds]";
        attribute targetValue           = 30.0;
        attribute targetDirection       = "≤";
        attribute measurementMethod     = "Measured end-to-end in system integration test with simulated fault injection.";
        attribute priority              = "critical";
        attribute timeHorizon           = "At system acceptance test";
        attribute relatedSystemFunction = "Real-time fault detection and alerting";
    }

    requirement obj03 : BusinessObjective {
        doc /* System must be operable with minimal training by field engineers. */
        attribute metric            = "Time-to-proficiency [hours of training to independent operation]";
        attribute targetValue       = 4.0;
        attribute targetDirection   = "≤";
        attribute measurementMethod = "Usability study with representative field engineers; measured during acceptance trial.";
        attribute priority          = "high";
        attribute timeHorizon       = "At system acceptance";
        attribute businessOwner     = "Field Operations Manager";
    }
}
```

### Recommended Package Structure

```
<ProjectRoot>/
  Analysis/
    ProblemSpace/
      problem_statement.sysml     ← SM-PRD-04
    SystemVision/
      system_idea.sysml           ← SM-PRD-05
    SystemObjectives/
      objective_types.sysml       ← SystemObjective, BusinessObjective, PerformanceObjective defs
      objective_instances.sysml   ← obj01, obj02, obj03 … requirement instances
      objective_metadata.sysml    ← ObjectiveCategory metadata annotations
    Requirements/                 ← SM-PRD-10: system requirements + satisfy links
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory / Recommended | What to Document |
|---------------|----|------------------------|-----------------|
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | **Mandatory** | Quality Goals table: list the top 3–5 highest-priority objectives as the quality goals that drive all major architectural decisions. Each row: Quality Goal name, Motivation (one sentence from the objective's `doc`), and Priority |
| [Quality Requirements](../../arc42/sections/quality-requirements.md) | ARC-10 | **Mandatory** | Quality scenarios elaborating each objective: for each objective, define a quality scenario with stimulus, response, and measurable response measure. The response measure is the `metric` + `targetValue` + `targetDirection` from the SysML v2 objective |
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | **Recommended** | Any objective with "critical" priority that constrains architectural choices (e.g., a latency objective may forbid certain cloud-only architectures) |

**ARC-01 Quality Goals guidance:** Select the 3–5 objectives with `priority = "critical"` or `priority = "high"`. Present them as a table with columns: Priority, Quality Goal, Motivation. These goals become the top-level drivers for architecture decision-making throughout the project.

**ARC-10 guidance:** For each objective in SM-PRD-06, write a quality scenario following the arc42 / ISO 25010 scenario pattern:
- **Source:** the stakeholder or system event that triggers the measurement
- **Stimulus:** the specific action or condition
- **Environment:** operational context (normal / stress / degraded mode)
- **Response:** the system's behavior
- **Response measure:** the `metric` target (e.g., "Fault-to-Alert Latency ≤ 30 seconds")

---

## §4 Traceability

### Incoming Links

| Source ID | Source Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-04 | Problem Statement | `depends_on` | Objectives must address the `problemGap` and quantify the `impactIfNotSolved` |
| SM-PRD-05 | System Idea | `depends_on` | Objectives must make each entry in `mainFeatures` and the `valueProposition` measurable |

### Outgoing Links

| Target ID | Target Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-09 | Risks | `refines` | Risks are evaluated in terms of the probability and impact of failing to achieve each objective |
| SM-PRD-10 | Requirements | `refines` | System requirements carry `satisfy` links to the objectives they enable |

### Traceability Rules

1. **Complete coverage rule:** Every entry in the System Idea's `mainFeatures` list must be addressed by at least one `SystemObjective` instance. An unmeasured feature is a scoping gap.
2. **SMART validation rule:** Every `SystemObjective` instance must have a non-empty `metric`, a numeric `targetValue`, a `measurementMethod`, and a `timeHorizon` before it can be approved. Objectives that cannot be made SMART must be escalated to the Project Manager for scope clarification.
3. **Objective-to-requirement traceability rule:** Every system requirement (SM-PRD-10) must carry a `satisfy` link to at least one `SystemObjective`. Requirements that cannot be traced to any objective are candidates for removal.
4. **ARC-01 Quality Goals alignment rule:** The top-priority objectives in the SysML v2 model must match the Quality Goals table in ARC-01 exactly. Any change to high/critical objectives triggers an ARC-01 update.
5. **Change propagation rule:** A change to an objective's `targetValue` or `metric` triggers re-evaluation of all requirements that satisfy it and all quality scenarios in ARC-10 that reference it.

---

## §5 Modeling Procedure

1. **Derive initial objective candidates.** From SM-PRD-04 (problemGap, impactIfNotSolved) and SM-PRD-05 (valueProposition, mainFeatures), identify candidate measurable goals. For each main feature in the System Idea, ask: "How would we know this feature is successfully delivered?" The answer is a candidate objective.

2. **Categorize objectives.** Classify each candidate as a BusinessObjective (organizational/operational outcome) or PerformanceObjective (technical system behavior). Apply the `ObjectiveCategory` metadata. This classification is important because the two sub-types are owned by different stakeholders.

3. **Make each objective SMART.** For each candidate, specify: `metric` (what is measured and in what unit), `targetValue` (the numerical threshold), `targetDirection` (≤, ≥, or =), `measurementMethod` (how it will be tested), `priority`, and `timeHorizon`. Reject or escalate any candidate that cannot be made fully SMART.

4. **Create the SysML v2 objectives model.** In the SME, create the `Analysis/SystemObjectives/` package. Define the `SystemObjective`, `BusinessObjective`, and `PerformanceObjective` requirement def hierarchy in `objective_types.sysml`. Create individual requirement instances for each objective in `objective_instances.sysml`.

5. **Validate objectives against SM-PRD-04 and SM-PRD-05.** For each objective, trace it back to the `problemGap` (SM-PRD-04) and to at least one `mainFeature` (SM-PRD-05). Document the cross-references in the model. Remove or revise objectives that cannot be traced to either.

6. **Prioritize the objective set.** Work with the Project Manager and product owner to assign `priority` values. Ensure the set of "critical" objectives is small enough to be achievable within project constraints. If too many objectives are "critical", facilitate a stakeholder trade-off discussion to rationalize priorities.

7. **Document in arc42.** Populate the Quality Goals table in ARC-01 with the top 3–5 critical/high-priority objectives. Write quality scenarios in ARC-10 for each objective. Flag any critical latency or throughput objectives that constrain architecture choices in ARC-02.

8. **Review and baseline.** Present the full objective set to stakeholders and the Project Manager for approval. Verify that all objectives are SMART and that the complete set covers all main features. Set `approvalStatus` to "baselined" for each approved objective. This baseline is a prerequisite for starting SM-PRD-09 (Risks) and SM-PRD-10 (Requirements).

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Product Vision Board](../../sysmod/tools/product-vision-board.md) | Tool 11.9 | **During step 1–2 (derivation and categorization)** — use Pichler's canvas to organize vision across target groups, needs, product features, and business goals; the "Business Goals" column maps directly to `BusinessObjective` instances and the "Needs" column provides the SMART metric candidates |
