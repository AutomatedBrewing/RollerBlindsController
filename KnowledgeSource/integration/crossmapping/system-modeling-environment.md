---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Modeling Environment (SME)
description: Full SysML v2 and arc42 mapping for SYSMOD product System Modeling Environment (SM-PRD-02).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Modeling Environment (SM-PRD-02)

The System Modeling Environment (SME) product encompasses the fully configured modeling toolchain used throughout the project: tool selection, SysML v2 profile installation, model library setup, repository configuration, and inter-tool integration. It is established during the MBSE Adoption process, directly following the MBSE Methodology (SM-PRD-01), and acts as the enabling infrastructure for every subsequent engineering model artifact. In SysML v2 the SME structure is described via `part def` and `connection def` constructs; in arc42 it is documented as a cross-cutting tooling concept (ARC-08) and the subject of tool-selection architecture decisions (ARC-09).

## §1 SysMod Definition

**Product ID:** SM-PRD-02
**SYSMOD §:** 5.2
**Process:** [MBSE Adoption](../../sysmod/processes/mbse-adoption-process.md) (SM-PRC-4)
**Creating Method:** [4.2 Set up and Maintain the SME](../../sysmod/methods/set-up-maintain-sme.md) (SM-MTH-02)
**Responsible Role:** [SME Administrator](../../sysmod/roles/sme-administrator.md)

### Purpose

The SME provides the technical infrastructure within which all SysML v2 models are created, validated, reviewed, and maintained. It covers: (1) the primary modeling tool and its SysML v2 kernel/profile, (2) model library imports, (3) model repository with version control, (4) integration adapters to requirements management, PLM, and other project tools, and (5) environment-level modeling conventions (naming schemes, folder templates, diagram templates).

### Role in Process

SM-PRD-02 is the second artifact in the MBSE Adoption process. It depends on SM-PRD-01 (MBSE Methodology) because the tool configuration must align with the selected processes, notations, and model structure defined there. Once baselined, the SME enables all engineering modeling across Analysis (SM-PRC-1) and Architecture (SM-PRC-2) processes. It is maintained throughout the project as tool versions and integrations evolve.

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| MBSE Methodology | SM-PRD-01 | Defines required notations, mandatory model structure, and the SysML v2 profile baseline |
| IT Infrastructure Plan | IT / DevOps | Available servers, cloud platforms, authentication systems, and repository hosting |
| Tool Evaluation Results | SME Administrator | Comparative assessment of candidate SysML v2 tools against project criteria |
| Standard Model Libraries | OMG / Tool Vendor | SysML v2 standard library packages (`ScalarValues`, `ISQBase`, etc.) |
| Integration Requirements | Project Manager | Requirements for tool connectivity (e.g., must integrate with Jira, DOORS, or TeamCenter) |

### Outputs / Dependent Artifacts

| Output / Dependent Artifact | ID | Relationship |
|-----------------------------|----|--------------|
| MBSE Training | SM-PRD-03 | `enables` — Training must be conducted in the configured SME |
| Problem Statement model | SM-PRD-04 | `enables` — First engineering modeling uses the SME |
| All subsequent engineering products | SM-PRD-05…24 | `enables` — Every model artifact is created within the SME |

### Dependencies

| Dependency | ID | Link Type |
|------------|----|-----------|
| MBSE Methodology | SM-PRD-01 | `depends_on` — Tool selection and configuration are constrained by the methodology |

---

## §2 SysML v2 Mapping

The SME itself is represented as a system-of-tools model. Each tool is a `part def`, tool-to-tool connections are `connection def` instances, and configuration properties are `metadata def` annotations.

### Mapping Table

| SYSMOD Element | SysML v2 Element | Element ID | Rationale |
|----------------|------------------|------------|-----------|
| Modeling tool component | `part def ModelingTool` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Represents each physical or virtual tool in the SME as a structural definition |
| Tool configuration record | `metadata def ToolConfiguration` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Captures vendor, version, installed profile, and license details as model annotations |
| SME namespace | `package SME_Configuration` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all SME-level definitions in a dedicated, version-controlled package |
| Tool-to-tool integration | `connection def ToolIntegration` | [SML-DEF-ConnDef](../../sysml2/concepts/connection-definition.md) | Describes data-flow interfaces between tools (e.g., requirements import from DOORS) |
| Tool interface port | `port def ToolPort` | [SML-DEF-PortDef](../../sysml2/concepts/port-definition.md) | Typed port capturing the protocol/format of each inter-tool data exchange |
| SME structure instance | `part modelingEnvironment : SME` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Top-level usage instantiating the configured SME for the project |

### Modeling Pattern

```sysml
package SME_Configuration {

    metadata def ToolConfiguration {
        attribute vendor        : String;
        attribute productName   : String;
        attribute version       : String;
        attribute installedProfile : String;  // e.g. "SysML v2 Pilot Implementation"
        attribute licenseType   : String;     // "floating" | "node-locked" | "cloud"
        attribute repositoryUrl : String;
    }

    port def ImportPort {
        attribute format   : String;  // e.g. "ReqIF", "CSV", "OSLC"
        attribute protocol : String;  // e.g. "REST", "file-sync"
    }

    port def ExportPort {
        attribute format   : String;
        attribute protocol : String;
    }

    part def ModelingTool {
        attribute #ToolConfiguration;
        port importInterface : ImportPort;
        port exportInterface : ExportPort;
    }

    part def RequirementsManagementTool {
        attribute #ToolConfiguration;
        port reqExport : ExportPort { attribute format = "ReqIF"; }
    }

    part def VersionControlSystem {
        attribute #ToolConfiguration;
        port modelRepository : ImportPort { attribute format = "Git/textual-SysML"; }
    }

    connection def ToolIntegration {
        end source : ModelingTool;
        end target : RequirementsManagementTool;
    }

    part def SME {
        part primaryTool      : ModelingTool;
        part reqsTool         : RequirementsManagementTool;
        part vcs              : VersionControlSystem;
        connection reqImport  : ToolIntegration
            connect source = primaryTool
            connect target = reqsTool;
    }

    part modelingEnvironment : SME {
        part primaryTool : ModelingTool {
            attribute vendor         = "Eclipse Foundation";
            attribute productName    = "SysIDE";
            attribute version        = "2025.x";
            attribute installedProfile = "SysML v2 Pilot";
        }
    }
}
```

### Recommended Package Structure

```
<ProjectRoot>/
  SME_Configuration/
    tool_definitions.sysml    ← ModelingTool, RequirementsManagementTool, VCS part defs
    tool_integrations.sysml   ← ToolIntegration connection defs
    sme_instance.sysml        ← modelingEnvironment part usage with actual config values
    libraries/
      ISQBase/                ← OMG standard library imports
      ScalarValues/
  MBSE_Methodology/           ← SM-PRD-01
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Mandatory / Recommended | What to Document |
|---------------|----|------------------------|-----------------|
| [Cross-cutting Concepts](../../arc42/sections/cross-cutting-concepts.md) | ARC-08 | **Mandatory** | Document the complete SME landscape: primary modeling tool, version, profile, repository type, integration topology, and model lifecycle conventions (branching, merging, baselining) |
| [Architecture Constraints](../../arc42/sections/architecture-constraints.md) | ARC-02 | **Mandatory** | SME-imposed constraints on model structure: maximum file/package size, forbidden constructs, profile compliance rules, mandatory library imports |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | **Recommended** | ADR for primary tool selection: alternatives evaluated (other SysML v2 tools), selection criteria (team familiarity, API access, textual syntax support), chosen tool, consequences |

**ARC-08 guidance:** The SME cross-cutting concept entry should include a tool topology diagram (even an informal one), the model repository URL and branching strategy, naming conventions for model elements, and the process for onboarding new team members to the SME.

**ARC-02 guidance:** Constraints include: model must be stored as textual SysML v2 (`.sysml` files) in Git; all changes require peer review before merge to `main`; standard library packages must not be modified locally.

---

## §4 Traceability

### Incoming Links

| Source ID | Source Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-01 | MBSE Methodology | `depends_on` | The methodology defines required notations, model structure, and profiles that the SME must implement |

### Outgoing Links

| Target ID | Target Name | Link Type | Description |
|-----------|-------------|-----------|-------------|
| SM-PRD-03 | MBSE Training | `enables` | All hands-on training exercises are conducted within the configured SME |
| SM-PRD-04 | Problem Statement | `enables` | First engineering modeling sessions require a functional SME |
| SM-PRD-05…24 | All subsequent engineering products | `enables` | Every model artifact requires the SME infrastructure to be operational |

### Traceability Rules

1. **SME-before-engineering rule:** SM-PRD-02 must be baselined (tool installed, profile loaded, repository created) before engineering modeling of SM-PRD-04 begins.
2. **Methodology alignment rule:** Any change to SM-PRD-01 (e.g., adding a new mandatory notation) triggers a corresponding SME update ticket.
3. **Version freeze rule:** The SME configuration (tool version + profile version) must be frozen at the start of each project phase baseline; upgrades require a change request.
4. **Integration test rule:** All tool integrations (e.g., DOORS import adapter) must be smoke-tested and the result documented in the SME configuration record before being marked "operational".

---

## §5 Modeling Procedure

1. **Derive SME requirements from SM-PRD-01.** Extract the notation requirements, mandatory library imports, required integrations, and model structure conventions from the baselined MBSE Methodology. Translate these into a set of SME configuration requirements.

2. **Evaluate and select the primary SysML v2 modeling tool.** Assess candidate tools against the configuration requirements (textual SysML v2 support, API access, team size licensing, Git integration). Document the decision as an ARC-09 ADR.

3. **Install and configure the modeling tool.** Install the selected tool in the project environment. Load the SysML v2 kernel and any project-specific profile. Configure the connection to the version control system (Git repository). Verify the installation by creating a test package and running the SysML v2 standard library imports.

4. **Create the SME_Configuration package.** Model the SME structure in SysML v2 using the `part def ModelingTool`, `connection def ToolIntegration`, and `metadata def ToolConfiguration` patterns. Populate configuration attributes for each tool (vendor, version, profile, repository URL).

5. **Establish and test tool integrations.** Configure and test each inter-tool adapter (requirements management, PLM, CI pipeline). For each integration, record the data format, protocol, sync frequency, and responsible owner in the `ToolIntegration` connection definition.

6. **Define and distribute SME conventions.** Document naming conventions, package structure templates, diagram templates, and the model branching/merging strategy. Publish these as the SME Usage Guide and reference it from the ARC-08 section.

7. **Document in arc42.** Write the ARC-08 Cross-cutting Concept entry for the SME. Write the ARC-02 constraint entries for SME-imposed modeling rules. Record the tool selection ADR in ARC-09.

8. **Conduct SME acceptance review and baseline.** Demonstrate the configured SME to the MBSE Methodologist and key System Engineers. Verify that all integration tests pass and all conventions are documented. Baseline SM-PRD-02 as a formal prerequisite for starting engineering work.
