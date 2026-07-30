---
type: Software Architecture Artifact
title: Software Solution Strategy
description: The high-level technology and decomposition strategy for the firmware — execution model, concurrency approach, module decomposition rationale — bridging Product Architecture components to their internal software design.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-02. The Software Solution Strategy summarises the fundamental
decisions that shape how the firmware realizes the software `part def`
components already identified in the Product Architecture (SM-PRD-21),
within the bounds set by the Software Architecture Constraints (SWA-01).

# Purpose

The Software Solution Strategy answers, at an executive-summary level: "how
does the firmware achieve its behavioural and resource goals within the
fixed hardware envelope?" It bridges the "what" already fixed by the Product
Architecture (which firmware modules exist, their ports and flows) and the
"how" elaborated in the Software Building Block View (SWA-03) and Software
Runtime View (SWA-04).

# Description

Typical content for an embedded/firmware context:

- **Execution model** — e.g. bare-metal superloop vs. cooperative
  scheduler vs. RTOS; justified against the Software Architecture
  Constraints (SWA-01) resource budget.
- **Concurrency approach** — how interrupts, timers, and the main loop
  interact; whether shared state requires critical sections.
- **Decomposition rationale** — why the firmware `part def` boundaries
  chosen in the Product Architecture are the right internal seams (this
  is normally already implied by the strong/loose coupling decisions in
  `ADR_006`/`ADR_007`, and this artifact makes the *internal* rationale
  explicit).
- **State-machine binding strategy** — which firmware module(s) `exhibit
  state` the system-level state machines already defined in System States
  (SM-PRD-23), and why.

# Relationships

**Responsibility:** Software Architect (project role).

**Primary Inputs:**
- [Software Architecture Constraints](architecture-constraints.md) (SWA-01) — bounds the strategy space.
- [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) — firmware `part def` components and their coupling decisions are the strategy's starting structure.
- [System States](../../sysmod/products/system-states.md) (SM-PRD-23) — existing state machines that must be bound somewhere in the software.

**Outputs consumed by:**
- [Software Building Block View](building-block-view.md) (SWA-03) — internal module decomposition follows the strategy.
- [Software Deployment View](deployment-view.md) (SWA-05) — resource-budget allocation follows the execution model choice.
- [Software Architecture Decisions](architecture-decisions.md) (SWA-07) — each strategic choice is recorded as one or more ADRs.

**Representation:** `doc` block on the top-level software architecture package + one or more `package ADR_NNN { @ArchDecisionMeta {...} }` blocks for each strategic decision, exactly mirroring the pattern already used for Base/Product Architecture decisions (`ADR_003_TimeBased.sysml`, `ADR_006_ProductRealizationStrategy.sysml`, `ADR_007_ProductCoupling.sysml`, `ADR_008_BuzzerFeedback.sysml`).

**Cross-mapping:** [crossmapping/solution-strategy.md](../crossmapping/solution-strategy.md)

# Citations

- arc42 Architecture Documentation Framework, Section 4 (Solution Strategy).
