---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — System Architecture
description: Full SysML v2 and arc42 mapping for SYSMOD product System Architecture (SM-PRD-17).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — System Architecture (SM-PRD-17) [ABSTRACT]

> **⚠ ABSTRACT CONCEPT** — System Architecture is a taxonomy node, not an instantiable artifact. No engineering team creates a deliverable named "System Architecture." Instead, the concrete specialized architecture types (Functional, Logical, Product, Physical, Test, Base) are created and delivered. This file documents the shared abstract pattern, the common SysML supertype, and directs readers to the concrete child files.

System Architecture is the SYSMOD umbrella concept encompassing all structural and behavioral descriptions of the system that go beyond requirements analysis. It provides a common vocabulary and a common abstract SysML supertype (`abstract part def SystemArchitecture`) from which each concrete architecture specializes, ensuring consistent cross-architecture allocation relationships.

## §1 SysMod Definition

**Product ID:** SM-PRD-17
**SYSMOD §:** 5.17
**Process:** [Architecture](../../sysmod/processes/architecture-process.md) (SM-PRC-2)
**Creating Method:** N/A — abstract concept; no single creating method
**Responsible Role:** N/A — abstract concept; see concrete children for responsible roles

### Purpose
System Architecture (abstract) provides the taxonomic foundation for all architecture products. It ensures consistent vocabulary, shared traceability rules, and common SysML patterns across Functional, Logical, Product, Physical, Test, and Base architectures. It is referenced when defining cross-architecture relationships such as allocation from Functional to Logical, or from Logical to Physical.

### Role in Process
In the Architecture process (SM-PRC-2), the abstract System Architecture concept frames the overall architectural approach. Engineers do not produce a "System Architecture" artifact; instead they produce one or more of its concrete specializations in a defined sequence: Base Architecture → Functional Architecture → Logical Architecture → Product / Physical Architecture → Test Architecture.

### Inputs

| # | Artifact | ID | Description |
|---|----------|----|-------------|
| 1 | Analysis Products | SM-PRD-12/14/15 | Use cases, activities, and domain knowledge feed all architecture types |
| 2 | Requirements | SM-PRD-10 | Requirements drive architectural decisions across all architecture layers |

### Outputs / Dependent Artifacts — Concrete Children

| # | Concrete Architecture | ID | Creating Method | Responsible Role |
|---|----------------------|----|-----------------|-----------------|
| 1 | Base Architecture | SM-PRD-07 | — | System Architect |
| 2 | Functional Architecture | SM-PRD-18 | 4.17 Model the Functional Architecture | System Architect |
| 3 | Logical Architecture | SM-PRD-20 | 4.18 Model the Logical Architecture | System Architect |
| 4 | Product Architecture | SM-PRD-21 | 4.19 Model the Product Architecture | System Architect |
| 5 | Physical Architecture | SM-PRD-19 | — | System Architect |
| 6 | Test Architecture | SM-PRD-24 | — | System Tester |

### Dependencies
None — this is an abstract concept. Each concrete architecture carries its own dependency list.

---

## §2 SysML v2 Mapping

### Mapping Table (Abstract Taxonomy)

| Architecture Type | SysML v2 Definition | Specialization Syntax | Node ID |
|-------------------|--------------------|-----------------------|---------|
| System Architecture (abstract root) | `abstract part def SystemArchitecture` | Never instantiated | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |
| Functional Architecture | `part def FunctionalArchitecture` | `:> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |
| Logical Architecture | `part def LogicalArchitecture` | `:> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |
| Product Architecture | `part def ProductArchitecture` | `:> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |
| Physical Architecture | `part def PhysicalArchitecture` | `:> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |
| Test Architecture | `part def TestArchitecture` | `:> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |
| Base Architecture | `part def BaseArchitecture` | `:> SystemArchitecture` | [SML-DEF-PartDef](../../sysml2/concepts/part-definition.md) |

### Modeling Pattern (Abstract Supertype + Taxonomy)

```sysml
package SystemArchitecture_Taxonomy {

  // ── Abstract root — NEVER instantiated directly ──────────────────────────
  abstract part def SystemArchitecture {
    doc /* Abstract root for all SYSMOD architecture products (SM-PRD-17).
          Concrete subtypes: FunctionalArchitecture (SM-PRD-18),
          LogicalArchitecture (SM-PRD-20), ProductArchitecture (SM-PRD-21),
          PhysicalArchitecture (SM-PRD-19), TestArchitecture (SM-PRD-24),
          BaseArchitecture (SM-PRD-07). */
  }

  // ── Concrete specializations (headers; bodies in their own packages) ─────
  abstract part def BaseArchitecture :> SystemArchitecture {
    doc /* Fundamental system decomposition; refined by all other architectures (SM-PRD-07) */
  }

  abstract part def FunctionalArchitecture :> SystemArchitecture {
    doc /* Technology-independent functional decomposition derived via FAS (SM-PRD-18) */
  }

  abstract part def LogicalArchitecture :> SystemArchitecture {
    doc /* Technology-independent logical component structure (SM-PRD-20) */
  }

  abstract part def ProductArchitecture :> SystemArchitecture {
    doc /* Technology-specific HW/SW component allocation (SM-PRD-21) */
  }

  abstract part def PhysicalArchitecture :> SystemArchitecture {
    doc /* Physical deployment and hardware topology (SM-PRD-19) */
  }

  abstract part def TestArchitecture :> SystemArchitecture {
    doc /* Test suite organization and test infrastructure (SM-PRD-24) */
  }

  // ── Cross-architecture allocation relationship type ───────────────────────
  allocation def ArchitectureAllocation {
    doc /* Typed allocation between architecture layers (e.g., Functional → Logical) */
  }
}
```

### Recommended Package Structure

```
<System>_Architecture/
  <System>_ArchitectureTaxonomy.sysml    ← Abstract supertype + specialization headers
  functional/                             → See SM-PRD-18 (functional-architecture.md)
  logical/                                → See SM-PRD-20
  product/                                → See SM-PRD-21
  physical/                               → See SM-PRD-19
  test/                                   → See SM-PRD-24
```

---

## §3 arc42 Mapping

| arc42 Section | Node ID | Usage | Mandatory? |
|---------------|---------|-------|-----------|
| [Solution Strategy](../../arc42/sections/solution-strategy.md) | ARC-04 | Abstract architectural approach: which architecture layers are applied, their purpose, and recommended ordering | Optional |
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | Architecture taxonomy overview as context for all Level 1 building blocks across all layers | Optional |

**Note:** Since this is an abstract concept, there are no mandatory arc42 sections. The concrete children carry the mandatory arc42 mappings (Functional → ARC-04 MANDATORY, Logical → ARC-05 MANDATORY, etc.). This file is referenced as the parent context in the Solution Strategy (ARC-04) introduction.

---

## §4 Traceability

### Incoming Links

| From Node | ID | Relationship | Description |
|-----------|----|--------------|-------------|
| Requirements | SM-PRD-10 | `depends_on` | All architecture layers are collectively driven by requirements |
| System Use Cases | SM-PRD-12 | `depends_on` | Analysis artifacts are inputs to all concrete architecture children |
| Use Case Activities | SM-PRD-14 | `depends_on` | Detailed analysis is the foundation for all architecture derivation |
| Domain Knowledge | SM-PRD-15 | `depends_on` | Data vocabulary shared across all architecture layers |

### Outgoing Links — to Concrete Children

| To Node | ID | Relationship | Description |
|---------|----|--------------|-------------|
| Base Architecture | SM-PRD-07 | `refines` | Concrete specialization of the abstract supertype |
| Functional Architecture | SM-PRD-18 | `refines` | Concrete specialization — see [functional-architecture.md](functional-architecture.md) |
| Logical Architecture | SM-PRD-20 | `refines` | Concrete specialization |
| Product Architecture | SM-PRD-21 | `refines` | Concrete specialization |
| Physical Architecture | SM-PRD-19 | `refines` | Concrete specialization |
| Test Architecture | SM-PRD-24 | `refines` | Concrete specialization |

### Traceability Rules

1. The abstract `part def SystemArchitecture` MUST never be directly instantiated in any system model.
2. Every concrete architecture type MUST include `:> SystemArchitecture` in its `part def` declaration.
3. Cross-architecture allocation relationships (e.g., Functional → Logical) MUST use `allocation` typed by `ArchitectureAllocation` or a subtype thereof.
4. The taxonomy package (`<System>_ArchitectureTaxonomy.sysml`) MUST be imported by all concrete architecture packages.
5. No concrete architecture package may re-define the abstract root; it must import and specialize it.

---

## §5 Modeling Procedure

> **This is an abstract taxonomy concept — you do not deliver a file called "System Architecture".** Instead, perform the following concrete setup steps, then follow the concrete child files in order.

1. **Understand the taxonomy first** — read this file to understand which architecture type serves which engineering purpose before starting any concrete architecture work.
2. **Create the taxonomy package** — create `<System>_ArchitectureTaxonomy.sysml` with the `abstract part def SystemArchitecture` root and the six specialization headers shown in the modeling pattern above. **Every subsequent architecture package must `import <System>_ArchitectureTaxonomy::*` at its top.** Without this import, the specialization chain (`:>`) will produce unresolved-type errors.
3. **Commit the taxonomy as a baseline** — this package must not change after architecture work begins; all concrete children depend on its definitions. Record the commit in ARC-09 (Architecture Decisions) as "System Architecture Taxonomy established."
4. **Start with Base Architecture (SM-PRD-07)** — defines the system root `part def` from which all concrete architectures inherit; see [base-architecture.md](base-architecture.md).
5. **Proceed to Functional Architecture (SM-PRD-18)** — technology-independent functional decomposition; see [functional-architecture.md](functional-architecture.md).
6. **Proceed to Logical Architecture (SM-PRD-20)** — technology-principle logical components with typed interfaces; see [logical-architecture.md](logical-architecture.md).
7. **Proceed to Product Architecture (SM-PRD-21)** — concrete hardware/software components; see [product-architecture.md](product-architecture.md).
8. **Create Test Architecture (SM-PRD-24)** — test infrastructure; see [test-architecture.md](test-architecture.md).

---

*See also:* [OKF Ontology](../okf-ontology.md) · [Functional Architecture cross-mapping](functional-architecture.md) (SM-PRD-18) · [Architecture process](../../sysmod/processes/architecture-process.md) (SM-PRC-2)
