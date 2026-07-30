---
type: Software Architecture Artifact
title: Software Building Block View
description: Deeper whitebox decomposition (Level 4+) of individual firmware part def components already identified in Product Architecture — internal modules, algorithms, and data structures.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-03. The Software Building Block View continues arc42's
Building Block View (ARC-05) below the level where the Product Architecture
(SM-PRD-21) stops — each firmware `part def` component becomes a whitebox
container whose internal structure (sub-modules, algorithms, data) is opened
up here.

# Purpose

The Product Architecture treats each firmware component (e.g.
`MovementSupervisorSoftware`) as an opaque blackbox with ports, flows, and
resource-estimate attributes. The Software Building Block View opens that
blackbox: what internal functions/algorithms does it contain, what internal
data does it hold, and how do its internal parts collaborate to realize the
ports already defined at the Product Architecture level?

# Description

This is a direct continuation of arc42's iterative Building Block View
pattern (Whitebox Level 1 → Level 2 → Level 3 → …), applied one level deeper
than SYSMOD's Product Architecture (which corresponds to arc42 ARC-05 Level
3). Concretely, for each firmware `part def` that is "complex enough to
warrant further decomposition" (arc42's own criterion), this artifact adds:

- Nested `part def`/`part` usages representing internal sub-modules.
- `action def`/`perform action` for internal algorithms (e.g. the
  first-wins arbitration logic, the debounce filter, the EEPROM
  wear-leveling routine).
- `attribute` usages for internal data structures (e.g. a ring buffer, a
  small state table) that are not visible as ports.
- `exhibit state` bindings, when a firmware module is the concrete host of
  a state machine already defined in System States (SM-PRD-23) — this is
  the resolution point for the current model gap where
  `ControllerLifecycleState` is exhibited only on a Logical-layer
  specialization (`RollerShutterControllerWithLifecycle`), not yet on any
  Product-layer firmware `part def`.

Not every firmware component needs this level of detail — apply it only
where internal complexity, safety criticality, or reuse potential justifies
it (same selectivity principle arc42 uses for whitebox depth).

# Relationships

**Responsibility:** Software Architect (project role).

**Primary Inputs:**
- [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) — the firmware `part def` components being decomposed.
- [Software Solution Strategy](solution-strategy.md) (SWA-02) — decomposition rationale and state-machine binding strategy.
- [System States](../../sysmod/products/system-states.md) (SM-PRD-23) — state machines to be exhibited on firmware parts.
- [Use Case Activities](../../sysmod/products/use-case-activities.md) (SM-PRD-14) — `action def` bodies already defined at the functional level may be refined here.

**Outputs consumed by:**
- [Software Runtime View](runtime-view.md) (SWA-04) — internal actions/parts appear as participants in runtime scenarios.
- [Software Deployment View](deployment-view.md) (SWA-05) — internal data structures contribute to the RAM budget.
- [Test Cases](../../sysmod/products/test-cases.md) (SM-PRD-16) — internal algorithms may need unit-level verification cases.

**Representation:** Nested `part def`, `action def`, `attribute usage`, `exhibit state` inside a NEW `part def` that specializes (`:>`) the existing firmware `part def` — SysML v2 has no partial-class/reopening mechanism, so the whitebox detail is added via subclassification (e.g. `part def MovementSupervisorSoftwareInternal :> MovementSupervisorSoftware { ... }`), never by re-declaring the original component's name — no new SysML v2 concepts beyond what L0–L3 already use.

**Cross-mapping:** [crossmapping/building-block-view.md](../crossmapping/building-block-view.md)

# Citations

- arc42 Architecture Documentation Framework, Section 5 (Building Block View) — iterative whitebox/blackbox pattern this artifact continues.
- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.21 (Product Architecture — states the next level of detail is out of scope for SYSMOD).
