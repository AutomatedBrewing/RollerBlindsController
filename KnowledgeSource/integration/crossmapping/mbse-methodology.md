---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — MBSE Methodology
description: Full SysML v2 and arc42 mapping for SYSMOD product MBSE Methodology (SM-PRD-01).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — MBSE Methodology (SM-PRD-01)

The MBSE Methodology product is the project-specific tailoring of the SYSMOD framework that defines which processes, methods, products, roles, and notations are applied on the project. It is the foundational artifact of the MBSE Adoption process and must be baselined before any engineering modeling begins. In SysML v2 it is represented through `metadata def` and `viewpoint def` constructs that annotate the model root package; in arc42 it appears as a cross-cutting methodology constraint (ARC-08) and a key architecture decision (ARC-09).

## §1 SysMod Definition

**Product ID:** SM-PRD-01
**SYSMOD §:** 5.1
**Process:** [MBSE Adoption](../../sysmod/processes/mbse-adoption-process.md) (SM-PRC-4)
**Creating Method:** [4.1 Tailor the MBSE Methodology](../../sysmod/methods/tailor-mbse-methodology.md) (SM-MTH-01)
**Responsible Role:** [MBSE Methodologist](../../sysmod/roles/mbse-methodologist.md)

### Purpose

The MBSE Methodology defines the project-specific MBSE approach: which SYSMOD processes and methods are applied, which products are mandatory, which roles are assigned, and which notations are used. It provides a shared reference for the whole project team and constrains how models are built, reviewed, and maintained throughout the project lifecycle.

### Role in Process

SM-PRD-01 is the first artifact produced in the MBSE Adoption process (SM-PRC-4). It is a hard prerequisite for configuring the System Modeling Environment (SM-PRD-02) and for designing MBSE Training (SM-PRD-03). All subsequent Analysis and Architecture products are produced within the process boundaries defined here.

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| SYSMOD Reference Framework | External (Tim Weilkiens, 3rd ed.) | Full set of SYSMOD processes, methods, products, roles, and tools |
| Project Management Plan | Project Manager | Project type, size, lifecycle model, and governance constraints |
| Organizational MBSE Guidelines | Organization / Quality Management | Existing corporate MBSE standards or framework preferences |
| Tool Landscape Survey | SME Administrator | Available modeling tools and integration options that constrain methodology choices |
| Regulatory / Domain Standards | Compliance Officer | Standards (e.g., ISO 26262, DO-178C) that impose process or notation requirements |

### Outputs / Dependent Artifacts

| Output / Dependent Artifact | ID | Relationship |
|-----------------------------|----|--------------|
| System Modeling Environment | SM-PRD-02 | `enables` — SME is configured to support the toolchain and profiles required by the methodology |
| MBSE Training | SM-PRD-03 | `enables` — Training content is derived from the tailored method and product list |
| All engineering products | SM-PRD-04…24 | `constrains` — Every engineering product is produced within the mandatory process and notation constraints |

### Dependencies

SM-PRD-01 has **no upstream SYSMOD product dependencies**. It is the first artifact in the MBSE Adoption process and is created solely from external inputs (SYSMOD reference, project plan, organizational guidelines).

---

## §2 SysML v2 Mapping

The MBSE Methodology is process infrastructure, not a system model element. In SysML v2 it is represented via metadata and viewpoint definitions that annotate the model namespace rather than via structural or behavioral model elements.

### Mapping Table

| SYSMOD Element | SysML v2 Element | Element ID | Rationale |
|----------------|------------------|------------|-----------|
| Methodology catalog entry | `metadata def MBSEMethodology` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Captures framework name, version, tailoring decisions as structured model annotations |
| Methodology namespace | `package MBSE_Methodology` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Provides an isolated namespace for all methodology-level definitions |
| Role-specific view specification | `viewpoint def` | [SML-DEF-VpointDef](../../sysml2/concepts/viewpoint-definition.md) | Defines what each project role needs to see in the model (system engineer, architect, tester) |
| Product catalog entry | `metadata def MBSEProduct` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Catalogs each applicable SYSMOD product with ID, mandatory flag, status, and responsible role |
| Method catalog entry | `metadata def MBSEMethod` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Catalogs each applied SYSMOD method with ID, phase, inputs, and outputs |
| Methodological constraint | `constraint def ModelingConvention` | [SML-DEF-ConstrDef](../../sysml2/concepts/constraint-definition.md) | Formalizes mandatory modeling rules (e.g., all requirements must carry a `satisfy` link) |

### Modeling Pattern

```sysml
package MBSE_Methodology {

    metadata def MBSEMethodology {
        attribute frameworkName    : String  = "SYSMOD";
        attribute frameworkVersion : String  = "3rd Edition";
        attribute notationSet      : String  = "SysML v2";
        attribute projectTailoring : String;        // narrative description of tailoring decisions
        attribute processScope     : String[1..*];  // list of applied SM-PRC-N IDs
        attribute mandatoryProducts: String[1..*];  // list of applied SM-PRD-NN IDs
    }

    metadata def MBSEProduct {
        attribute productId       : String;   // e.g. "SM-PRD-04"
        attribute productName     : String;
        attribute mandatory       : Boolean;
        attribute responsibleRole : String;
        attribute status          : String;   // "planned" | "in-progress" | "baselined"
    }

    metadata def MBSEMethod {
        attribute methodId       : String;   // e.g. "SM-MTH-05"
        attribute methodName     : String;
        attribute appliedInPhase : String;
    }

    viewpoint def SystemEngineerViewpoint {
        doc /* Shows requirements, use cases, and system context for system engineers */
        expose : requirement def, use case def, part def;
    }

    viewpoint def ArchitectViewpoint {
        doc /* Shows logical and physical architecture, interfaces, and allocations */
        expose : part def, connection def, port def, allocation def;
    }

    viewpoint def TesterViewpoint {
        doc /* Shows requirements, verification cases, and test architecture */
        expose : requirement def, verification case def;
    }

    constraint def MandatoryRequirementLink {
        doc /* Every requirement usage must have at least one satisfy link */
    }
}

// Annotate the project root package with methodology metadata
#MBSE_Methodology::MBSEMethodology {
    frameworkName    = "SYSMOD";
    frameworkVersion = "3rd Edition";
    notationSet      = "SysML v2";
    projectTailoring = "Full process scope; all 24 products applicable; ISO 15288 alignment.";
}
```

### Recommended Package Structure

```
<ProjectRoot>/
  MBSE_Methodology/           ← SM-PRD-01: metadata defs, viewpoint defs, constraint defs
  System_Modeling_Environment/ ← SM-PRD-02: tool config, profile imports
  Analysis/                   ← SM-PRC-1 products (SM-PRD-04 … SM-PRD-16)
  Architecture/               ← SM-PRC-2 products (SM-PRD-17 … SM-PRD-24)
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory / Recommended | What to Document |
|---------------|----|------------------------|-----------------|
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | **Mandatory** | MBSE methodology as a cross-cutting constraint: notation standard (SysML v2), modeling tool policy, model ownership and versioning rules, mandatory review gates, baseline criteria |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | **Mandatory** | ADR for the choice of MBSE methodology and SYSMOD tailoring: context, alternatives considered (e.g., INCOSE SE Handbook, custom approach), decision rationale, consequences |
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | **Recommended** | Methodological constraints that restrict design freedom: mandatory products, required notation compliance, organizational modeling standards |

**ARC-08 guidance:** The methodology cross-cutting concept entry should include: (1) notation standard and SysML v2 tool profile, (2) model structure conventions, (3) naming and ID conventions for model elements, (4) review and approval gates, (5) baseline and change control rules.

**ARC-09 guidance:** The ADR should follow a standard template: Context → Decision → Alternatives Considered → Rationale → Consequences. Attach or link the tailored SYSMOD product checklist as an appendix.

---

## §4 Traceability

### Incoming Links

| Source ID | Source Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| — | — | — | SM-PRD-01 has no upstream SYSMOD product predecessors |

### Outgoing Links

| Target ID | Target Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-02 | System Modeling Environment | `enables` | Methodology defines required tools, profiles, and structural conventions that the SME must implement |
| SM-PRD-03 | MBSE Training | `enables` | Training content is derived from the tailored method and notation set |
| SM-PRD-04…24 | All Engineering Products | `constrains` | Every engineering product must be produced using the mandatory methods and notations specified here |

### Traceability Rules

1. **Methodology-first rule:** SM-PRD-01 must be baselined before SM-PRD-02 or SM-PRD-03 are started.
2. **Root annotation rule:** The SysML v2 model root package must carry a `#MBSEMethodology` annotation before any engineering sub-packages are created.
3. **ADR linkage rule:** The ARC-09 ADR must reference the tailored SYSMOD product checklist by SM-PRD-NN identifier for each mandatory product.
4. **Change propagation rule:** Any change to SM-PRD-01 (adding or removing a mandatory product, changing notation) triggers an impact review on SM-PRD-02 (tool configuration) and SM-PRD-03 (training content).

---

## §5 Modeling Procedure

1. **Collect inputs.** Gather the SYSMOD 3rd ed. reference, the project management plan (lifecycle, size, regulatory context), any organizational MBSE guidelines, and the tool landscape survey from the SME Administrator.

2. **Tailor the SYSMOD product list.** For each of the 24 SYSMOD products, decide: mandatory, recommended, or not applicable. Document the tailoring decision and its rationale for each product. Consider project type (new development vs. evolution), lifecycle phase, and regulatory domain.

3. **Define the notation and tool policy.** Confirm SysML v2 as the primary modeling notation. Document any supplementary notations (e.g., BPMN for operational process analysis). Specify which modeling tool and which SysML v2 profile will be used.

4. **Create the SysML v2 methodology package.** In the modeling tool, create the `MBSE_Methodology` package. Define the `MBSEMethodology`, `MBSEProduct`, and `MBSEMethod` metadata definitions. Populate the product and method catalogs for all applicable SM-PRD-NN artifacts.

5. **Define role-specific viewpoints.** For each project role (System Engineer, System Architect, Tester, Project Manager), create a `viewpoint def` specifying which model element types are relevant and exposed.

6. **Annotate the root package.** Apply the `#MBSEMethodology` annotation to the project root package with the framework name, version, and a brief tailoring summary string.

7. **Document in arc42.** Write the ARC-09 Architecture Decision Record for the methodology choice. Write the ARC-08 Cross-cutting Concept entry covering modeling conventions, naming rules, and baseline criteria. Add methodological constraints to ARC-02 where they restrict design freedom.

8. **Review and baseline.** Conduct a formal review with the Project Manager, SME Administrator, and representative System Engineers. Address all comments. Formally baseline SM-PRD-01. This baseline is a documented prerequisite gate before starting SM-PRD-02 and SM-PRD-03.

---

### Relevant SYSMOD Tools

| Tool | ID | When to Apply |
|------|----|---------------|
| [Model Purpose Model](../../sysmod/tools/model-purpose-model.md) | Tool 11.3 | **During step 1 (purpose definition)** — use the three-level model (Communication / Traceability / Specification) to anchor the methodology's scope; the selected level determines which SYSMOD products are mandatory vs. optional and directly informs the `frameworkName` and tailoring summary in the `#MBSEMethodology` annotation |
