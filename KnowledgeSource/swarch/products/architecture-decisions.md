---
type: Software Architecture Artifact
title: Software Architecture Decisions
description: ADRs specific to the software level (execution model choice, task vs. superloop, module boundaries) extending the existing ADR_NNN pattern established in Base/Product Architecture.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-07. Software Architecture Decisions record the significant,
hard-to-reverse choices made while designing the firmware internals — the
software-discipline continuation of arc42's Architecture Decisions (ARC-09),
using the exact same `package ADR_NNN { @ArchDecisionMeta {...} }` pattern
already established for Base and Product Architecture decisions in this
project.

# Purpose

Just as `ADR_003_TimeBased`, `ADR_006_ProductRealizationStrategy`,
`ADR_007_ProductCoupling`, and `ADR_008_BuzzerFeedback` record why the
Base/Product Architecture look the way they do, Software Architecture
Decisions record why the firmware internals (execution model,
task/interrupt split, module boundaries below the Product Architecture
level) look the way they do — so future maintainers do not need to
reverse-engineer the reasoning.

# Description

Expected decisions for this project, sourced from the Software Solution
Strategy (SWA-02) phase:

- **Execution model** — bare-metal superloop vs. cooperative scheduler vs.
  RTOS, justified against the 1 KB RAM / 16 KB flash budget (SWA-01) and
  the absence of any hard real-time requirement beyond debounce/timeout
  timing.
- **State-machine hosting** — which firmware `part def` component
  `exhibit state`s the `ControllerLifecycleState` machine (SM-PRD-23),
  resolving the current model gap where it is only exhibited on a
  Logical-layer specialization (`RollerShutterControllerWithLifecycle`).
- **Internal decomposition depth** — which firmware components warrant a
  Software Building Block View (SWA-03) whitebox decomposition and which
  remain blackbox (documented rationale, not just an implicit omission).

Each decision uses the **same** `ArchDecisionMeta` metadata definition
already declared once in `Project/Model/Architecture/base/ADR_Common.sysml`
— no new metadata definition is introduced for the software level.

# Relationships

**Responsibility:** Software Architect (project role).

**Primary Inputs:**
- [Software Solution Strategy](solution-strategy.md) (SWA-02) — the strategic choices this artifact documents in detail.
- [Software Architecture Constraints](architecture-constraints.md) (SWA-01) — the constraint context each decision must respect.

**Outputs consumed by:**
- [Software Cross-cutting Concepts](cross-cutting-concepts.md) (SWA-06) — cross-cutting concepts often originate directly from a decision recorded here.
- All other SWA artifacts — every non-trivial choice made while producing SWA-02 through SWA-06 should be traceable to an ADR here.

**Representation:** `package ADR_NNN { @ArchDecisionMeta {...} }`, reusing `ADR_Common::ArchDecisionMeta` — identical pattern to existing Base/Product Architecture ADRs, continuing the same numbering sequence.

**Cross-mapping:** [crossmapping/architecture-decisions.md](../crossmapping/architecture-decisions.md)

# Citations

- arc42 Architecture Documentation Framework, Section 9 (Architecture Decisions).
- Project file: `Project/Model/Architecture/base/ADR_Common.sysml` (shared `ArchDecisionMeta` definition, reused unchanged).
