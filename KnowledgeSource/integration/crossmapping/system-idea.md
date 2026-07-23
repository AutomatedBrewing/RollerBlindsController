---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Idea
description: Full SysML v2 and arc42 mapping for SYSMOD product System Idea (SM-PRD-05).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Idea (SM-PRD-05)

The System Idea is the project's elevator pitch for the proposed system. It translates the identified problem (SM-PRD-04) into a high-level solution vision: what the system is, what value it delivers, to whom, and what differentiates it. The System Idea is deliberately concise and non-prescriptive — it establishes shared direction without locking in design decisions. In SysML v2 it is modeled as a top-level `requirement def` with vision-board attributes, optionally framed by a `viewpoint def` for elevator-pitch stakeholder communication. In arc42 it is the narrative heart of the ARC-01 Introduction section and seeds the ARC-04 Solution Strategy.

## §1 SysMod Definition

**Product ID:** SM-PRD-05
**SYSMOD §:** 5.5
**Process:** [Analysis](../../sysmod/processes/analysis-process.md) (SM-PRC-1)
**Creating Method:** [4.6 Describe the System Idea and System Objectives](../../sysmod/methods/describe-system-idea-objectives.md) (SM-MTH-06)
**Responsible Role:** [Project Manager](../../sysmod/roles/project-manager.md)

### Purpose

The System Idea creates shared understanding of the proposed solution vision across all stakeholders — technical and non-technical — before any detailed requirements or architecture work begins. It answers three questions: (1) What is the system? (2) What value does it deliver (value proposition)? (3) What makes it different from existing solutions (uniqueness)? A well-crafted System Idea prevents premature convergence on design details, aligns diverse stakeholders around a common vision, and provides a communication tool for the project throughout its lifecycle.

### Role in Process

SM-PRD-05 is produced in the Analysis process (SM-PRC-1), immediately after the Problem Statement (SM-PRD-04) is approved. It depends on SM-PRD-04 because the system idea must be a credible solution to the stated problem gap. It feeds directly into System Objectives (SM-PRD-06) — objectives are the measurable instantiation of the idea — and into System Use Cases (SM-PRD-12) — use cases describe how the idea is realized in operational context.

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Problem Statement | SM-PRD-04 | Defines the problem gap that the system idea must credibly address |
| Stakeholder Vision Input | Stakeholders / Product Owner | Qualitative needs, desired capabilities, and priority features from key stakeholders |
| Market / Technology Survey | Domain Experts | Information on what existing solutions exist and where the proposed system can differentiate |
| Organizational Strategy | Management | Strategic direction that the system must align with (e.g., platform strategy, make-vs-buy policy) |

### Outputs / Dependent Artifacts

| Output / Dependent Artifact | ID | Relationship |
|-----------------------------|----|--------------|
| System Objectives | SM-PRD-06 | `refines` — Objectives are the measurable version of the idea's value proposition |
| Requirements | SM-PRD-10 | `refines` — Stakeholder requirements are derived from the features and value proposition |
| System Use Cases | SM-PRD-12 | `refines` — Use cases operationalize the idea by describing how the system delivers its value |

### Dependencies

| Dependency | ID | Link Type |
|------------|----|-----------|
| Problem Statement | SM-PRD-04 | `depends_on` — The system idea must solve the stated problem |

---

## §2 SysML v2 Mapping

The System Idea is a stakeholder-facing, vision-level artifact. In SysML v2 it is best expressed as a `requirement def` at the top of the stakeholder requirements hierarchy, carrying structured vision-board attributes. A `viewpoint def` can frame how the elevator-pitch view is rendered for non-technical audiences.

### Mapping Table

| SYSMOD Element | SysML v2 Element | Element ID | Rationale |
|----------------|------------------|------------|-----------|
| System Idea artifact | `requirement def SystemIdea` | [SML-DEF-ReqDef](../../sysml2/concepts/requirement-definition.md) | Places the system vision at the top of the stakeholder requirements hierarchy where it can be traced to all downstream requirements |
| Value proposition | `attribute valueProposition : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Captures the core benefit the system delivers to its primary users in one or two sentences |
| Main features | `attribute mainFeatures : String[0..*]` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Lists the headline capabilities without prescribing implementation |
| Uniqueness / differentiator | `attribute uniqueness : String` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Articulates what makes this solution different from existing alternatives |
| Target users | `attribute targetUsers : String[1..*]` | [SML-DEF-AttrDef](../../sysml2/concepts/attribute-definition.md) | Identifies the primary beneficiaries, cross-referencing affectedUsers from SM-PRD-04 |
| Stakeholder communication view | `viewpoint def ElevatorPitchViewpoint` | [SML-DEF-VpointDef](../../sysml2/concepts/viewpoint-definition.md) | Specifies a management / stakeholder view exposing only the SystemIdea requirement and its attributes |
| Vision metadata | `metadata def VisionBoard` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Annotates the Analysis package with version, author, and approval status of the system idea |

### Modeling Pattern

```sysml
package Analysis {

    requirement def SystemIdea {
        doc /* Brief elevator pitch for the proposed system.
               Captures the value proposition, headline features, and differentiators
               without prescribing design or implementation details. */

        attribute systemName       : String;
        // The short name used to refer to the proposed system.

        attribute valueProposition : String;
        // One- or two-sentence statement of the core benefit delivered to primary users.

        attribute mainFeatures     : String[0..*];
        // Headline capabilities the system provides.

        attribute uniqueness       : String;
        // What differentiates this system from existing alternatives.

        attribute targetUsers      : String[1..*];
        // Primary user groups who benefit from the system.

        attribute approvalStatus   : String = "draft";
        // "draft" | "under-review" | "approved" | "baselined"
    }

    // Example instantiation
    requirement fieldMonitoringIdea : SystemIdea {
        doc /* The Field Equipment Monitor provides real-time equipment status
               to control center operators and field engineers,
               eliminating manual log-based reporting. */

        attribute systemName       = "Field Equipment Monitor (FEM)";
        attribute valueProposition = "Delivers real-time equipment health data from the field to the control center, enabling proactive maintenance and reducing unplanned downtime by 30%.";
        attribute mainFeatures     = (
            "Real-time telemetry from field sensors to control center dashboard",
            "Automated fault detection and alert escalation",
            "Mobile interface for field engineers to view and acknowledge alerts",
            "Audit trail of equipment status and maintenance actions"
        );
        attribute uniqueness       = "Edge-processing on the field gateway eliminates cloud dependency; works in low-bandwidth environments.";
        attribute targetUsers      = ("Field Engineers", "Control Center Operators", "Maintenance Planners");
    }

    viewpoint def ElevatorPitchViewpoint {
        doc /* Management and stakeholder view: shows only SystemIdea requirements
               with their valueProposition and mainFeatures attributes visible. */
        expose : requirement def { subsets SystemIdea; };
    }

    metadata def VisionBoard {
        attribute ideaVersion  : String;   // e.g. "1.2"
        attribute authoredBy   : String;
        attribute approvedBy   : String;
        attribute approvalDate : String;   // ISO 8601
        attribute linkedProblem: String;   // e.g. "SM-PRD-04"
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
      system_idea.sysml           ← SystemIdea requirement def + instance
      vision_viewpoints.sysml     ← ElevatorPitchViewpoint def
      vision_metadata.sysml       ← VisionBoard annotation
    SystemObjectives/             ← SM-PRD-06
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory / Recommended | What to Document |
|---------------|----|------------------------|-----------------|
| [Introduction and Goals](../../arc42/sections/introduction-and-goals.md) | ARC-01 | **Mandatory** | The system idea narrative is the primary content of the arc42 "Purpose and Goals" or "Business Context" subsection: write the elevator pitch in one paragraph, list the top 3–5 main features as a bullet list, state the value proposition, and reference the SysML v2 model |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | **Recommended** | The system idea seeds the solution strategy: the uniqueness and main features give the first indication of the strategic technical and organizational choices the architecture will embody |

**ARC-01 guidance:** The arc42 Introduction section should contain the System Idea as the opening narrative. Use the `valueProposition` attribute text as the opening sentence. List `mainFeatures` as a concise bullet list. Add a sentence on `uniqueness` to differentiate from alternatives. Keep this section to one page maximum — it must be readable by non-technical stakeholders.

**ARC-04 guidance:** When writing the Solution Strategy, reference the System Idea as the originating vision. The architectural approaches chosen should be traceable to one or more `mainFeatures` or `uniqueness` properties. For example, if "works in low-bandwidth environments" is a uniqueness attribute, the solution strategy should identify edge processing as a key architectural principle.

---

## §4 Traceability

### Incoming Links

| Source ID | Source Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-04 | Problem Statement | `depends_on` | The system idea must address the problem gap; its `valueProposition` is validated against the `problemGap` attribute |

### Outgoing Links

| Target ID | Target Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-06 | System Objectives | `refines` | Objectives are the measurable realization of the value proposition and headline features stated in the system idea |
| SM-PRD-10 | Requirements | `refines` | Stakeholder requirements must trace to the system idea's main features and value proposition |
| SM-PRD-12 | System Use Cases | `refines` | Each use case operationalizes one or more of the main features listed in the system idea |

### Traceability Rules

1. **Idea-problem alignment rule:** The `valueProposition` and `mainFeatures` of the System Idea must demonstrably address the `problemGap` defined in SM-PRD-04. A formal reviewable test: for each main feature, can reviewers identify the problem-gap element it resolves?
2. **Feature-to-use-case rule:** Every entry in `mainFeatures` must be traceable to at least one System Use Case (SM-PRD-12). Features with no corresponding use case indicate scope that is stated but not analyzed.
3. **Idea-to-objective rule:** Every entry in `mainFeatures` and the `valueProposition` must be traceable to at least one measurable System Objective (SM-PRD-06).
4. **Change propagation rule:** A change to the system idea's `valueProposition`, `mainFeatures`, or `targetUsers` triggers a mandatory review of SM-PRD-06, SM-PRD-10, and SM-PRD-12 for alignment.

---

## §5 Modeling Procedure

1. **Review the approved Problem Statement.** Read SM-PRD-04 carefully. Identify the core `problemGap`, the `affectedUsers`, and the `impactIfNotSolved`. The system idea must be a credible, high-level solution to the stated gap — not a generic vision statement.

2. **Facilitate a system idea workshop.** Run a structured workshop with the Project Manager, key stakeholders, and domain experts. Use a vision-board template: Who are the target users? What problem are we solving? What is the core value the system delivers? What are the top 5 features? What differentiates us from alternatives?

3. **Draft the System Idea attributes.** From workshop outputs, draft the five core attributes: `systemName`, `valueProposition`, `mainFeatures` (list), `uniqueness`, and `targetUsers`. Keep the `valueProposition` to two sentences. Keep `mainFeatures` to 5–8 items at most.

4. **Create the SysML v2 System Idea model.** In the SME, create the `Analysis/SystemVision/` package. Define the `SystemIdea requirement def` with all attributes. Instantiate the project-specific requirement with the drafted attribute values.

5. **Validate against the Problem Statement.** For each `mainFeature`, verify it addresses at least one element of the `problemGap` from SM-PRD-04. Document this traceability explicitly. Remove or revise features that cannot be traced to the problem.

6. **Define the ElevatorPitchViewpoint.** Create the `ElevatorPitchViewpoint def` in the `vision_viewpoints.sysml` file. Configure the viewpoint to expose only the SystemIdea requirement and its `valueProposition` and `mainFeatures` attributes. Use this viewpoint to generate stakeholder-facing presentations or arc42 ARC-01 content.

7. **Document in arc42.** Write the Introduction and Goals section of ARC-01 using the system idea content as the primary input. Add a preliminary note to ARC-04 pointing to the system idea as the origin of the solution strategy.

8. **Review and baseline.** Present the System Idea to all key stakeholders for review. Ensure the elevator pitch resonates with non-technical stakeholders and that the features align with technical stakeholder expectations. After resolving all comments, set `approvalStatus` to "baselined" and proceed to SM-PRD-06 (System Objectives).

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Product Box](../../sysmod/tools/product-box.md) | Tool 11.8 | **During step 2 (workshop)** — use a physical product-box canvas to elicit system name, customer objectives, and top features from stakeholders before formal attribute drafting; outputs map directly to `systemName`, `mainFeatures`, and `valueProposition` |
