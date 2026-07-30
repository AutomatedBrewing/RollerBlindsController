---
type: Software Architecture Artifact
title: Software Deployment View
description: Mapping of firmware building blocks onto the MCU's execution context — memory layout, flash/RAM budget allocation, and task/interrupt placement.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-05. The Software Deployment View continues arc42's Deployment
View (ARC-07) below the hardware-topology level already covered by the
Product Architecture (SM-PRD-21) — it shows where, within the single MCU,
each firmware building block's code and data actually reside and execute.

# Purpose

The Product Architecture's Deployment View content answers "which hardware
node hosts which firmware component" (e.g. "`ControlMCU` hosts all 7
firmware `part`s"). Because this project has only one MCU, that mapping is
mostly trivial. The Software Deployment View instead answers the more
useful question at this scale: "does the aggregate flash/RAM footprint of
all firmware building blocks fit within the MCU's actual budget, and how is
that budget allocated?"

# Description

Concretely, this artifact:

- **Validates the resource budget.** Sums each firmware `part def`'s
  `estimatedFlashBytes`/`estimatedRamBytes` attributes (already present on
  every component in `ProductComponents.sysml`) and checks the total
  against `ControlMCU`'s `flashSizeKB`/`internalRamBytes` attributes, with
  an explicit safety margin.
- **Allocates execution context**, when the Software Solution Strategy
  (SWA-02) chose anything beyond a single superloop — e.g. which module's
  logic runs in which interrupt service routine vs. the main loop, and
  what stack depth each context requires.
- **Documents non-volatile memory layout**, when relevant — e.g. which
  EEPROM byte ranges `MemoryManagerSoftware` uses for the timing profile
  (ADR-003) vs. any other persisted configuration.

# Relationships

**Responsibility:** Software Architect (project role).

**Primary Inputs:**
- [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) — `ControlMCU`'s hardware budget attributes and each firmware component's resource-estimate attributes.
- [Software Solution Strategy](solution-strategy.md) (SWA-02) — execution model determines whether interrupt/task placement needs to be documented at all.
- [Software Architecture Constraints](architecture-constraints.md) (SWA-01) — the hard resource ceiling this view validates against.

**Outputs consumed by:**
- [Software Architecture Decisions](architecture-decisions.md) (SWA-07) — a budget overrun or a tight margin is typically recorded as a decision/risk.
- [Risks](../../sysmod/products/risks.md) (SM-PRD-09) — resource-margin risk (e.g. "less than 10% flash headroom") should be traceable to the risk register.

**Representation:** `attribute` roll-up (sum) expressed as a `constraint usage`/`requirement` check against the MCU's budget attributes, following the same style as the project's existing `L0_Constraints` requirement pattern — no new SysML v2 concepts. Optionally a `doc` table listing per-component flash/RAM figures for direct arc42 rendering.

**Cross-mapping:** [crossmapping/deployment-view.md](../crossmapping/deployment-view.md)

# Citations

- arc42 Architecture Documentation Framework, Section 7 (Deployment View).
