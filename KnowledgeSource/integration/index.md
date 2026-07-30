---
okf_version: "0.1"
type: OKF Integration Bundle
title: OKF Integration Knowledge Bundle — SYSMOD × SysML v2 × arc42
description: Root index for the cross-domain integration knowledge base connecting SYSMOD methodology, SysML v2 modeling language, and arc42 architecture documentation.
timestamp: 2026-07-01T00:00:00Z
---

# OKF Integration Knowledge Bundle — SYSMOD × SysML v2 × arc42

This bundle provides a unified, actionable knowledge base enabling engineers to answer:

> *"I need to create artifact X — how do I define it (SYSMOD), model it (SysML v2), document it (arc42), and trace it?"*

It is a companion to four existing OKF bundles:

| Source Bundle | Location | Role |
|--------------|----------|------|
| SYSMOD | [`../sysmod/`](../sysmod/) | **WHAT** to model — methodology, products, processes, methods |
| SysML v2 | [`../sysml2/`](../sysml2/) | **HOW** to model — language elements, syntax, diagrams |
| arc42 | [`../arc42/`](../arc42/) | **PUBLICATION FORMAT** — target view specification for generated architecture documentation |
| Software Architecture (`swarch`) | [`../swarch/`](../swarch/) | **WHAT/HOW below Product Architecture** — SYSMOD stops at Product Architecture (SM-PRD-21); `swarch` covers the software/firmware internals below it (execution model, whitebox decomposition, runtime scenarios, resource budget), organised per SW-relevant arc42 artifact instead of per SYSMOD product |

> **arc42 role in an MBSE project:** arc42 is **not** a parallel hand-authored document. It is the **target publication format** generated from the SysML v2 model via `view def` + `render`. Each arc42 section defines *what* a stakeholder audience needs to see and *how* it is structured — the SysML v2 model is the single source of truth. The arc42 OKF is retained in the knowledge source because:
> 1. It defines the `viewpoint def` contracts that `view def` elements must satisfy
> 2. It provides the structural vocabulary engineers use to reason about architecture documentation
> 3. It bridges the gap for engineers from documentation-first backgrounds during MBSE adoption
> 4. Today's tooling does not yet fully automate arc42 generation — until it does, the arc42 section definitions guide what `doc` blocks and `metadata def` annotations must contain in the model
>
> **Architecture Decision model pattern** (replaces manual ARC-09 authoring):
> ```sysml
> metadata def ArchDecisionMeta {
>   attribute status       : String;  // proposed | accepted | superseded
>   attribute alternatives : String;  // rejected options
>   attribute rationale    : String;  // why this option was chosen
>   attribute consequences : String;  // accepted trade-offs
> }
> package ADR_001_ProxyPortsOnly {
>   doc /* Decision: Use proxy ports exclusively. */
>   @ArchDecisionMeta { status = "accepted"; rationale = "..."; }
> }
> ```

### arc42 Section → Model Source Mapping

| arc42 Section | Model Source of Truth | SysML v2 Element | Software-Level Continuation (below SM-PRD-21) |
|--------------|----------------------|-----------------|------------------------------------------------|
| ARC-01 Introduction & Goals | Quality goals, stakeholder concerns | `requirement usage`, stakeholder `part def`, `viewpoint def` | — |
| ARC-02 Architecture Constraints | Non-negotiable constraints | `constraint def` + `@ConstraintMeta` (SM-PRD-07) | [SWA-01 Software Architecture Constraints](../swarch/products/architecture-constraints.md) |
| ARC-03 Context & Scope | System boundary and interfaces | `part def`, `port def`, `connection def` (SM-PRD-11) | — |
| ARC-04 Solution Strategy | Architecture rationale | `doc` on architecture packages + `@ArchDecisionMeta` | [SWA-02 Software Solution Strategy](../swarch/products/solution-strategy.md) |
| ARC-05 Building Block View | Part hierarchies per level | `part def` in SM-PRD-18/20/21 (L1/L2/L3) | [SWA-03 Software Building Block View](../swarch/products/building-block-view.md) (Level 4+) |
| ARC-06 Runtime View | Behavior and scenarios | `action def`, sequence diagrams (SM-PRD-13/14/22) | [SWA-04 Software Runtime View](../swarch/products/runtime-view.md) |
| ARC-07 Deployment View | Physical deployment topology | `part def` + `allocation def` (SM-PRD-21/24) | [SWA-05 Software Deployment View](../swarch/products/deployment-view.md) |
| ARC-08 Cross-cutting Concepts | System-wide principles | `doc` on cross-cutting packages + `metadata def` annotations | [SWA-06 Software Cross-cutting Concepts](../swarch/products/cross-cutting-concepts.md) |
| ARC-09 Architecture Decisions | Decision records | `package ADR_NNN { @ArchDecisionMeta { ... } }` | [SWA-07 Software Architecture Decisions](../swarch/products/architecture-decisions.md) |
| ARC-10 Quality Requirements | Quality scenarios | Performance/safety `requirement usage` with `targetValue` | — |
| ARC-11 Risks | Risk register | Risk `requirement usage` + `@RiskMeta` (SM-PRD-09) | — |
| ARC-12 Glossary | Domain vocabulary | `item def` + `attribute def` with `doc` bodies (SM-PRD-15) | — |

> **Implication for §5 procedures:** When a crossmapping procedure step says "populate ARC-XX", the actionable intent is: ensure the corresponding model element has a complete `doc` body and `@metadata` annotation. The arc42 section is the **rendered output** of those model elements — not a separately authored document. Until your SysML v2 toolchain supports arc42 rendering, the crossmapping §3 tables define what each rendered section must contain.
>
> **Below Product Architecture (SM-PRD-21):** SYSMOD explicitly stops at the Product Architecture — "the next level of detail... is out of scope for the system model" ([SYSMOD Product Architecture](../sysmod/products/product-architecture.md)). The **Software-Level Continuation** column above points to the [`swarch`](../swarch/index.md) bundle, which fills that gap using the same SysML v2 language, organised per SW-relevant arc42 artifact (SWA-01…07) instead of per SYSMOD product.

---

## Bundle Contents

### [OKF: Unified Ontology](okf-ontology.md)

The single authoritative integration reference. Contains:
- Complete node catalogue: 24 SYSMOD products, 31 SysML v2 elements, 12 arc42 sections
- 9 typed edge definitions (`implements`, `documents`, `depends_on`, `refines`, `maps_to`, `traced_by`, `describes`, `realizes`, `validates`)
- Full 24-row adjacency mapping table
- Product dependency graph (L0–L4)
- Global traceability system: ID schema, link naming conventions, mandatory-link rules
- Recommended project folder structure
- System decomposition strategy (Context → Logical → Physical → Component)

### [OKF: Cross-Mapping](crossmapping/index.md)

24 per-artifact files, each providing:
- §1 SysMod Definition (purpose, inputs/outputs, dependencies)
- §2 SysML v2 Mapping (table + code pattern + package structure)
- §3 arc42 Mapping (table with mandatory/optional per section)
- §4 Traceability (incoming/outgoing link tables + mandatory rules)
- §5 Modeling Procedure (step-by-step: Define → Model → Document → Link → Verify)

### [Software Architecture Bundle](../swarch/index.md)

Continues the same integration philosophy **below** SM-PRD-21 (Product
Architecture), where SYSMOD itself has no further product/method pair.
7 artifacts (SWA-01…07), organised per SW-relevant arc42 artifact instead of
per SYSMOD product, each with a matching
[`swarch/crossmapping/`](../swarch/crossmapping/index.md) file following the
identical §1–§5 structure. See [okf-ontology.md §7](okf-ontology.md) for how
this extends the L0–L4 decomposition table with an L5 "Software Architecture"
row, itself broken down into SWA-01…07 sub-levels (L5.1–L5.7).

---

## Quick Lookup Table

> **arc42 Level notation:** `ARC-05 L1` = arc42 Building Block View Level 1 (top-level functional decomposition); `ARC-05 L2` = Level 2 (logical components); `ARC-05 L3` = Level 3 (concrete product components). See [okf-ontology.md §7](okf-ontology.md) for full decomposition strategy.

| SM-ID | Product | SysML v2 Primary | arc42 Primary | Cross-Mapping |
|-------|---------|-----------------|---------------|---------------|
| SM-PRD-01 | MBSE Methodology | `package`, `metadata def` | ARC-04, ARC-08 | [→](crossmapping/mbse-methodology.md) |
| SM-PRD-02 | System Modeling Environment | `package` | ARC-04, ARC-08 | [→](crossmapping/system-modeling-environment.md) |
| SM-PRD-03 | MBSE Training | — | ARC-04 | [→](crossmapping/mbse-training.md) |
| SM-PRD-04 | Problem Statement | `requirement def` | ARC-01 | [→](crossmapping/problem-statement.md) |
| SM-PRD-05 | System Idea | `requirement def`, `viewpoint def` | ARC-01 | [→](crossmapping/system-idea.md) |
| SM-PRD-06 | System Objectives | `requirement def`, `attribute def` | ARC-01, ARC-10 | [→](crossmapping/system-objectives.md) |
| SM-PRD-07 | Base Architecture | `part def`, `constraint usage` | ARC-02, ARC-09 | [→](crossmapping/base-architecture.md) |
| SM-PRD-08 | Stakeholders | `part def`, `metadata def` | ARC-01 | [→](crossmapping/stakeholders.md) |
| SM-PRD-09 | Risks | `requirement def`, `metadata def` | ARC-11 | [→](crossmapping/risks.md) |
| SM-PRD-10 | Requirements | `requirement def`, `requirement usage` | ARC-01, ARC-10 | [→](crossmapping/requirements.md) |
| SM-PRD-11 | System Context | `part def`, `port def`, `connection def` | ARC-03 | [→](crossmapping/system-context.md) |
| SM-PRD-12 | System Use Cases | `use case def`, `use case usage` | ARC-01, ARC-03 | [→](crossmapping/system-use-cases.md) |
| SM-PRD-13 | System Processes | `action def`, `succession` | ARC-06 | [→](crossmapping/system-processes.md) |
| SM-PRD-14 | Use Case Activities | `action def`, `action usage`, `item flow` | ARC-06 | [→](crossmapping/use-case-activities.md) |
| SM-PRD-15 | Domain Knowledge | `item def`, `attribute def`, `part def` | ARC-12, ARC-08 | [→](crossmapping/domain-knowledge.md) |
| SM-PRD-16 | Test Cases | `verification case def`, `satisfy` | ARC-10 | [→](crossmapping/test-cases.md) |
| SM-PRD-17 | System Architecture [abstract] | `part def` (abstract) | ARC-05 | [→](crossmapping/system-architecture.md) |
| SM-PRD-18 | Functional Architecture | `part def`, `action def`, `flow def` | ARC-04, ARC-05 L1 | [→](crossmapping/functional-architecture.md) |
| SM-PRD-19 | Physical Architecture [abstract] | `part def` (abstract) | ARC-05 | [→](crossmapping/physical-architecture.md) |
| SM-PRD-20 | Logical Architecture | `part def`, `port def`, `allocation def` | ARC-04, ARC-05 L2 | [→](crossmapping/logical-architecture.md) |
| SM-PRD-21 | Product Architecture | `part def` (concrete), `attribute def` | ARC-05 L3, ARC-07 | [→](crossmapping/product-architecture.md) |
| SM-PRD-22 | Scenarios | sequence diagram, `part usage` | ARC-06 | [→](crossmapping/scenarios.md) |
| SM-PRD-23 | System States | `state def`, `state usage`, `transition` | ARC-06, ARC-08 | [→](crossmapping/system-states.md) |
| SM-PRD-24 | Test Architecture | `part def` (test), `verification case def` | ARC-07, ARC-05 | [→](crossmapping/test-architecture.md) |

---

## Software Architecture Quick Lookup Table (below SM-PRD-21)

These artifacts are **not** SYSMOD products (no `SM-PRD-*` ID) — see
[Section 7 of okf-ontology.md](okf-ontology.md) for their place in the
decomposition strategy (L5).

| SWA-ID | Artifact | SysML v2 Primary | arc42 Primary | Cross-Mapping |
|--------|----------|-------------------|----------------|----------------|
| SWA-01 | Software Architecture Constraints | `requirement`, `require constraint` | ARC-02 | [→](../swarch/crossmapping/architecture-constraints.md) |
| SWA-02 | Software Solution Strategy | `doc`, `package ADR_NNN` | ARC-04, ARC-09 | [→](../swarch/crossmapping/solution-strategy.md) |
| SWA-03 | Software Building Block View | nested `part def`, `action def`, `exhibit state` | ARC-05 (L4+) | [→](../swarch/crossmapping/building-block-view.md) |
| SWA-04 | Software Runtime View | `part` lifelines, `perform action` | ARC-06 | [→](../swarch/crossmapping/runtime-view.md) |
| SWA-05 | Software Deployment View | `requirement` (budget check), `metadata def` | ARC-07 | [→](../swarch/crossmapping/deployment-view.md) |
| SWA-06 | Software Cross-cutting Concepts | `doc`, `metadata def` | ARC-08 | [→](../swarch/crossmapping/cross-cutting-concepts.md) |
| SWA-07 | Software Architecture Decisions | `package ADR_NNN { @ArchDecisionMeta }` | ARC-09 | [→](../swarch/crossmapping/architecture-decisions.md) |

---

## Source Bundle Entry Points

Direct navigation to the indexed catalogues in each source bundle. Use these when an integration crossmapping refers you to a source bundle for full language or methodology details.

| Bundle | Index | Contents |
|--------|-------|----------|
| SysML v2 Concepts | [→](../sysml2/concepts/index.md) | All language concept files (definitions, usages, control nodes, relationships) |
| SysML v2 Rules | [→](../sysml2/rules/index.md) | Normative language rules (specialization, typing, name resolution, flow typing, keywords) |
| SYSMOD Products | [→](../sysmod/products/index.md) | All 24 SYSMOD product definitions |
| SYSMOD Tools | [→](../sysmod/tools/index.md) | Workshop tools and modeling patterns (SAMS, FAS, Zigzag, Proxy Port, Variant Modeling, etc.) |
| arc42 Sections | [→](../arc42/sections/index.md) | All 12 arc42 documentation sections |
| Software Architecture Products | [→](../swarch/products/index.md) | All 7 SWA-* artifact definitions (below Product Architecture) |
| Software Architecture Cross-Mapping | [→](../swarch/crossmapping/index.md) | All 7 SWA-* cross-mapping files |

