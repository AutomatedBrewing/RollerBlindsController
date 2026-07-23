---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Physical Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product Physical Architecture (SM-PRD-19).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Physical Architecture (SM-PRD-19)

Physical Architecture is an **abstract** umbrella concept in SYSMOD that encompasses all architecture kinds dealing with physical and software elements. The SEBoK defines Physical Architecture as "an arrangement of physical elements which provides the design solution." This node has no creating method of its own — it is realized exclusively through its concrete children: Base Architecture (SM-PRD-07), Logical Architecture (SM-PRD-20), Product Architecture (SM-PRD-21), and Test Architecture (SM-PRD-24).

## §1 SysMod Definition

**Product ID:** SM-PRD-19  
**SYSMOD §:** 5.19  
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)  
**Creating Method:** N/A — ABSTRACT concept (no direct creating method; see concrete children)  
**Responsible Role:** N/A — ABSTRACT (concrete children assign specific roles)

### Purpose

Physical Architecture is the taxonomic root for all structurally oriented architecture products in SYSMOD. It provides a shared abstraction layer for the transition from functional decomposition (SM-PRD-18 Functional Architecture) to concrete physical design (SM-PRD-21 Product Architecture). By defining Physical Architecture as an abstract concept, SYSMOD separates the *what* (physical element arrangement) from the *how* (specific realization level: logical, product, or test). No artifact is ever directly labelled "Physical Architecture" in project deliverables — the concrete children carry the project-specific content.

### Role in Process

Within the Architecture process (SM-PRC-2), Physical Architecture serves as the organizing umbrella under which all structural architecture products are classified. The process flow runs: Base Architecture (SM-PRD-07) → Logical Architecture (SM-PRD-20) → Product Architecture (SM-PRD-21), with Test Architecture (SM-PRD-24) branching off for verification. Physical Architecture itself is never directly created or updated during a project iteration — it is a stable structural concept whose concrete children evolve.

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Functional Architecture | SM-PRD-18 | Primary allocation source — functional elements drive physical element definition |
| 2 | System Context | SM-PRD-11 | Defines external physical interfaces that architecture must accommodate |
| 3 | Requirements | SM-PRD-10 | Technical and physical constraints bound the permissible architectures |
| 4 | Base Architecture | SM-PRD-07 | Foundational architectural concepts that all physical children may specialize |

### Outputs / Dependent Artifacts (table)

| # | Output Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Logical Architecture | SM-PRD-20 | Concrete child — high-level logical technical concepts |
| 2 | Product Architecture | SM-PRD-21 | Concrete child — final physical design of the system |
| 3 | Test Architecture | SM-PRD-24 | Concrete child — physical setup for test execution |
| 4 | Scenarios | SM-PRD-22 | Instances of physical architecture parts traced through use case activities |
| 5 | System States | SM-PRD-23 | Behavioral complement exhibited by physical architecture parts |

### Dependencies

- **SM-PRD-07 (Base Architecture):** The Base Architecture is the entry-level concrete physical architecture and the supertype foundation for Logical and Product Architectures. It is both a peer (concrete child) and the generalization root that other children specialize.
- **SM-PRD-17 (System Architecture [abstract]):** Physical Architecture is the physical sub-category of System Architecture; the full system architecture comprises both Functional (SM-PRD-18) and Physical (SM-PRD-19) aspects.
- **SM-PRD-18 (Functional Architecture):** The functional model is the primary allocation source. Every physical element must trace back to at least one functional element via `allocation def`.

---

## §2 SysML v2 Mapping

### Mapping Table

| SYSMOD Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Physical Architecture (abstract) | `abstract part def PhysicalArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Abstract supertype — never instantiated, common root for all physical containers |
| Logical Architecture (concrete child) | `part def LogicalSystem :> PhysicalArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Specializes abstract root; contains logical technical components |
| Product Architecture (concrete child) | `part def ProductSystem :> PhysicalArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Specializes abstract root; contains concrete physical/software components |
| Test Architecture (concrete child) | `part def TestContext :> PhysicalArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) | Specializes abstract root; contains SUT and test equipment |
| Functional-to-physical allocation | `allocation def` | [SML-DEF-AllocDef](../../sysml2/concepts/allocation-definition.md) | Links functional elements (SM-PRD-18) to physical architecture parts |
| Architecture namespace | `package` | [SML-DEF-Package](../../sysml2/concepts/package.md) | Groups all physical architecture levels under a single namespace |
| Architecture-level metadata tag | `metadata def PhysicalLevel` | [SML-DEF-MetaDef](../../sysml2/concepts/metadata-definition.md) | Annotates parts with their architecture level (logical / product / test) |

### Modeling Pattern

```sysml
package System_PhysicalArchitecture {

  // Abstract root — never instantiated directly in a model
  abstract part def PhysicalArchitecture {
    doc /* Abstract supertype for all physical architecture kinds in this system.
         Concrete subtypes: LogicalSystem (SM-PRD-20), ProductSystem (SM-PRD-21),
         TestContext (SM-PRD-24). Do NOT use part usages of this type directly. */
  }

  // Metadata annotation for traceability
  metadata def PhysicalLevel {
    attribute level : String; // "logical" | "product" | "test"
  }

  // Concrete children declare their level; full definitions live in child packages
  abstract part def LogicalSystem :> PhysicalArchitecture {
    @PhysicalLevel { level = "logical"; }
    doc /* See package <System>_Architecture/logical/ — SM-PRD-20 */
  }

  abstract part def ProductSystem :> PhysicalArchitecture {
    @PhysicalLevel { level = "product"; }
    doc /* See package <System>_Architecture/product/ — SM-PRD-21 */
  }

  abstract part def TestContext :> PhysicalArchitecture {
    @PhysicalLevel { level = "test"; }
    doc /* See package <System>_Verification/test_architecture/ — SM-PRD-24 */
  }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  physical/                            ← SM-PRD-19 namespace root (abstract supertypes only)
    <System>_PhysicalArchitecture.sysml
  logical/                             ← SM-PRD-20 — see logical-architecture.md
    <System>_LogicalArchitecture.sysml
  product/                             ← SM-PRD-21 — see product-architecture.md
    <System>_ProductArchitecture.sysml
<System>_Verification/
  test_architecture/                   ← SM-PRD-24 — see test-architecture.md
    <System>_TestArchitecture.sysml
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed by Physical Architecture |
|---|---|---|---|
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | **Mandatory** | Taxonomy of physical levels; hierarchy from abstract concept to concrete children; cross-level specialization decisions |
| [Deployment View](../../arc42/sections/deployment-view.md) | ARC-07 | **Mandatory** | Physical deployment perspective inherited from Product Architecture and Test Architecture children |
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Recommended | Strategic decision to adopt a multi-level physical architecture (logical → product); coupling strategy choice |
| [Architecture Decisions](../../arc42/sections/architecture-decisions.md) | ARC-09 | Recommended | Key decision: strong coupling (specialization) vs. loose coupling (allocation) between architecture levels |
| [Glossary](../../arc42/sections/glossary.md) | ARC-12 | Optional | Define "Logical Architecture", "Product Architecture", "Test Architecture" and their relationships |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-17 | System Architecture [abstract] | `refines` | Physical Architecture is the physical-structural sub-concept of System Architecture |
| SM-PRD-18 | Functional Architecture | `depends_on` | Physical elements are allocated from functional elements |
| SM-PRD-07 | Base Architecture | `refines` | Base Architecture is the first concrete realization of Physical Architecture |
| SM-PRD-10 | Requirements | `depends_on` | Technical requirements constrain the permissible physical architectures |
| SM-PRD-11 | System Context | `depends_on` | External interface definitions shape the physical architecture boundary |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-20 | Logical Architecture | `refines` | Concrete child — logical realization of Physical Architecture |
| SM-PRD-21 | Product Architecture | `refines` | Concrete child — product-level realization of Physical Architecture |
| SM-PRD-24 | Test Architecture | `refines` | Concrete child — test-context realization of Physical Architecture |
| SM-PRD-22 | Scenarios | `implements` | Scenarios are executed on physical architecture part instances |
| SM-PRD-23 | System States | `implements` | System States are exhibited by physical architecture parts |
| ARC-05 | Building Block View | `documents` | arc42 ARC-05 documents the physical architecture hierarchy |
| ARC-07 | Deployment View | `documents` | arc42 ARC-07 documents the physical deployment topology |

### Traceability Rules

1. Every `part def` in any concrete physical architecture MUST transitively specialize `PhysicalArchitecture`.
2. Every functional element defined in SM-PRD-18 MUST have at least one `allocation def` mapping it to a physical element in one of the concrete children.
3. No `part` usage (instance) may directly reference the abstract `PhysicalArchitecture` type — only its concrete subtypes may be instantiated.
4. Every `part def` in a physical architecture MUST carry a `@PhysicalLevel` metadata annotation identifying its architecture level.
5. Every physical architecture `part def` MUST be referenced by at least one arc42 section (ARC-05 or ARC-07).

---

## §5 Modeling Procedure

> **ABSTRACT UMBRELLA — you do not deliver a file called "Physical Architecture".** The following steps are concrete setup actions performed **once** before any physical architecture product is modeled.

1. **Create the physical architecture namespace package.** Add `package <System>_PhysicalArchitecture` to the model repository and define `abstract part def PhysicalArchitecture` inside it. **Every logical, product, and test architecture package must `import <System>_PhysicalArchitecture::*` at its top** so that the `:>` specialization chain resolves correctly.

2. **Define the `PhysicalLevel` metadata.** Add `metadata def PhysicalLevel { attribute level : String; }` to annotate all physical elements with their architecture level. This enables automated traceability queries across levels.

3. **Determine the required architecture levels.** Based on project scope, decide which concrete children are needed (e.g., Logical only for early-phase; Logical + Product for detailed design; all four for a verification-focused project). Document this decision in ARC-04 (Solution Strategy).

4. **Choose coupling strategies per level transition.** For each transition (Base→Logical, Logical→Product), decide between strong coupling (`part def Child :> Parent`) and loose coupling (`allocation def`). See [Coupling of System Architectures](../../sysmod/tools/coupling-system-architectures.md) (Tool 11.7). Record the decision and rationale in ARC-09 (Architecture Decisions).

5. **Establish the functional allocation baseline.** Confirm that SM-PRD-18 (Functional Architecture) is sufficiently stable. Extract the list of functional elements that must be allocated to physical elements — this list drives the completeness check in step 7.

6. **Set up the arc42 building block hierarchy.** In ARC-05, create Level 1 entries for each planned concrete child (Logical, Product, Test). These placeholders are filled as each concrete architecture is modeled.

7. **Validate cross-level completeness.** After all concrete children are populated: (a) every functional element has at least one physical allocation, (b) every physical element traces to at least one requirement, (c) every arc42 placeholder from step 6 is filled.
